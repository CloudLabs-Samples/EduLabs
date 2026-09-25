# =====================================================================
# Lab 1 / Task 1 - Restore connectivity from the jump host to the Orders API
# Validation step: 4eb65796-8985-4f91-9016-43ae28f7b8fc
#
# HYBRID validator:
#   1a CONTROL PLANE - the black-hole route to 10.0.254.4 is gone
#   1b CONTROL PLANE - HTTP from the jump host subnet is ALLOWED by the first
#                      matching NSG rule, and HTTP is not opened to the internet
#   1c IN-VM (labvm) - http://10.0.2.10/health returns 200 "orders-api: healthy"
#
# 1c is the real proof: it can only pass when the route, the NSG and the
# nginx bind address are all fixed. 1a and 1b exist so the failure message
# can name the layer that is still broken.
# =====================================================================
Import-Module Az.Accounts
Import-Module Az.Compute
Import-Module Az.Resources

# Variables provided by CloudLabs
$deployment_id     = $deployment_id
$resourceGroupName = $resourceGroupName
$sub_id            = $sub_id

$labVmName      = "labvm-$deployment_id"
$appNsgName     = "appvm-$deployment_id-nsg"
$routeTableName = "rt-app-$deployment_id"
$deadNvaIp      = "10.0.254.4"
$labSubnet      = "10.0.1.0/24"
$netApiVersion  = "2023-04-01"

# Sources that include the jump host (10.0.1.10) - used to decide which NSG
# rule is the first to match HTTP from the jump host.
$labSources   = @("*", "any", "virtualnetwork", "10.0.0.0/8", "10.0.0.0/16", "10.0.1.0/24", "10.0.1.10", "10.0.1.10/32")
# Sources that mean "the internet" - an allow from any of these on port 80
# undoes the hardening change and fails the task even if curl works.
$openSources  = @("*", "any", "internet", "0.0.0.0/0")

function Test-PortMatch($props, [int]$port) {
    $ranges = @()
    if ($props.destinationPortRange)  { $ranges += $props.destinationPortRange }
    if ($props.destinationPortRanges) { $ranges += $props.destinationPortRanges }
    foreach ($r in $ranges) {
        if ($r -eq "*") { return $true }
        if ($r -match '^(\d+)-(\d+)$') {
            if ($port -ge [int]$Matches[1] -and $port -le [int]$Matches[2]) { return $true }
        }
        elseif ($r -match '^\d+$' -and [int]$r -eq $port) { return $true }
    }
    return $false
}

function Test-SourceMatch($props, $allowed) {
    $srcs = @()
    if ($props.sourceAddressPrefix)   { $srcs += $props.sourceAddressPrefix }
    if ($props.sourceAddressPrefixes) { $srcs += $props.sourceAddressPrefixes }
    foreach ($s in $srcs) {
        if ($allowed -contains ([string]$s).ToLower()) { return $true }
    }
    return $false
}

# Set subscription
Select-AzSubscription -SubscriptionId $sub_id

# Retry logic
$stopRetry = $false
[int]$retryCount = 0
$maxRetries = 3

do {
    try {

        $reasons = @()

        # =============================================================
        # 1a - CONTROL PLANE: no route may still send the jump host
        #      subnet to the decommissioned appliance. Disassociating the
        #      route table from app-subnet is accepted as well.
        # =============================================================
        $routeOk = $false
        $rtPath  = "/subscriptions/$sub_id/resourceGroups/$resourceGroupName/providers/Microsoft.Network/routeTables/$routeTableName" + "?api-version=$netApiVersion"
        $rtResp  = Invoke-AzRestMethod -Path $rtPath -Method GET

        if ($rtResp.StatusCode -eq 200) {
            $rt        = $rtResp.Content | ConvertFrom-Json
            $routes    = @($rt.properties.routes | Where-Object { $_ })
            $subnets   = @($rt.properties.subnets | Where-Object { $_ })
            $deadRoutes = @($routes | Where-Object {
                $_.properties.nextHopType -eq "VirtualAppliance" -and (
                    $_.properties.nextHopIpAddress -eq $deadNvaIp -or $_.properties.addressPrefix -eq $labSubnet)
            })
            if ($deadRoutes.Count -eq 0 -or $subnets.Count -eq 0) {
                $routeOk = $true
            }
            else {
                $reasons += "route '$($deadRoutes[0].name)' in $routeTableName still sends $($deadRoutes[0].properties.addressPrefix) to the decommissioned appliance $($deadRoutes[0].properties.nextHopIpAddress) - delete it with 'az network route-table route delete'"
            }
        }
        elseif ($rtResp.StatusCode -eq 404) {
            $routeOk = $true
        }
        else {
            $reasons += "route table $routeTableName could not be read (HTTP $($rtResp.StatusCode))"
        }

        # =============================================================
        # 1b - CONTROL PLANE: the FIRST inbound NSG rule (by priority)
        #      that matches TCP/80 from the jump host must be Allow.
        #      No matching custom rule is also fine - the default
        #      AllowVnetInBound (65000) then admits it.
        # =============================================================
        $nsgOk   = $false
        $openOk  = $true
        $nsgPath = "/subscriptions/$sub_id/resourceGroups/$resourceGroupName/providers/Microsoft.Network/networkSecurityGroups/$appNsgName" + "?api-version=$netApiVersion"
        $nsgResp = Invoke-AzRestMethod -Path $nsgPath -Method GET

        if ($nsgResp.StatusCode -eq 200) {
            $nsg   = $nsgResp.Content | ConvertFrom-Json
            $rules = @($nsg.properties.securityRules | Where-Object { $_ -and $_.properties.direction -eq "Inbound" }) |
                     Sort-Object { [int]$_.properties.priority }

            $httpRules = @($rules | Where-Object {
                ($_.properties.protocol -eq "*" -or $_.properties.protocol -eq "Tcp") -and (Test-PortMatch $_.properties 80)
            })

            $first = $httpRules | Where-Object { Test-SourceMatch $_.properties $labSources } | Select-Object -First 1
            if ($null -eq $first -or $first.properties.access -eq "Allow") {
                $nsgOk = $true
            }
            else {
                $reasons += "HTTP from the jump host subnet first matches '$($first.name)' (priority $($first.properties.priority), $($first.properties.access)) - move Allow-HTTP-From-LabSubnet to a lower priority number than that rule, for example 150"
            }

            $wideOpen = $httpRules | Where-Object { $_.properties.access -eq "Allow" -and (Test-SourceMatch $_.properties $openSources) } | Select-Object -First 1
            if ($null -ne $wideOpen) {
                $openOk = $false
                $reasons += "rule '$($wideOpen.name)' allows HTTP from any source, which undoes the CHG-4472 hardening - restrict it to 10.0.1.0/24"
            }
        }
        else {
            $reasons += "NSG $appNsgName could not be read (HTTP $($nsgResp.StatusCode))"
        }

        # =============================================================
        # 1c - IN-VM (jump host): the health endpoint answers end to end.
        #      curl's exit code tells a timeout (network) from a refusal
        #      (nothing listening), so the message names the layer.
        # =============================================================
        $script = @'
#!/bin/bash
set -uo pipefail

APP_VM_IP=10.0.2.10
count=0
found=false
detail=""

while [ $count -lt 3 ] && [ "$found" != "true" ]; do
  count=$((count + 1))
  code=$(curl -s -m 5 -o /tmp/v1-health.txt -w '%{http_code}' "http://${APP_VM_IP}/health")
  rc=$?
  text=$(head -n 1 /tmp/v1-health.txt 2>/dev/null | tr -d '\r')

  if [ "$rc" = "0" ] && [ "$code" = "200" ] && [ "$text" = "orders-api: healthy" ]; then
    found=true
    rm -f /tmp/v1-health.txt
    echo '{"Status":"Succeeded","Message":"http://10.0.2.10/health returned HTTP 200 orders-api: healthy from the jump host."}'
    exit 0
  fi

  case "$rc" in
    28) detail="the request to http://10.0.2.10/health TIMED OUT - traffic is still being dropped in the network path (check the route table and the NSG rule order)" ;;
    7)  detail="the connection to 10.0.2.10:80 was REFUSED - the network path is open but nginx is not listening on the VM's private address (check the listen line in /etc/nginx/sites-available/orders-api)" ;;
    0)  detail="http://10.0.2.10/health answered HTTP ${code} with '${text}' instead of HTTP 200 orders-api: healthy" ;;
    *)  detail="curl to http://10.0.2.10/health failed with exit code ${rc}" ;;
  esac
  sleep 10
done

rm -f /tmp/v1-health.txt
echo '{"Status":"Failed","Message":"End-to-end check failed after '"$count"' attempts: '"$detail"'."}'
exit 0
'@

        # Execute inside VM
        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $resourceGroupName `
            -VMName $labVmName `
            -CommandId "RunShellScript" `
            -ScriptString $script

        $vmOutput = ($result.Value[0].Message | Out-String).Trim()
        $vmOk = ($vmOutput -match '"Status":"Succeeded"')

        if (-not $vmOk) {
            if ($vmOutput -match '"Message":"([^"]*)"') { $reasons += $Matches[1] }
            else { $reasons += "the end-to-end health check from the jump host did not succeed" }
        }

        if ($routeOk -and $nsgOk -and $openOk -and $vmOk) {
            $message = @{
                Status  = "Succeeded"
                Message = "Connectivity restored. The leftover route to the decommissioned appliance is gone, HTTP from the jump host subnet is allowed ahead of the hardening deny rule, nginx is listening on the VM's private address, and http://10.0.2.10/health returns HTTP 200 from the jump host."
            } | ConvertTo-Json
        }
        else {
            $detail = $reasons -join "; "
            $message = @{
                Status  = "Failed"
                Message = "Connectivity check failed - $detail. Work through Lab 1 in order: delete the route to-lab-subnet-via-nva, move Allow-HTTP-From-LabSubnet to priority 150, change nginx to 'listen 80;' and restart it, then confirm curl http://10.0.2.10/health returns HTTP 200."
            } | ConvertTo-Json
        }

        # Return JSON response
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [System.Net.HttpStatusCode]::OK
            Body       = $message
        })

        $stopRetry = $true
    }
    catch {

        if ($retryCount -ge $maxRetries) {

            $message = @{
                Status  = "Failed"
                Message = "Retry for validation process has been exhausted. Please try after sometime."
            } | ConvertTo-Json

            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [System.Net.HttpStatusCode]::OK
                Body       = $message
            })

            $stopRetry = $true
        }
        else {
            Write-Host "Validation failed. Retrying... ($($retryCount + 1)/$maxRetries)"
            Start-Sleep -Seconds 10
            $retryCount++
        }
    }

} while ($stopRetry -eq $false)
