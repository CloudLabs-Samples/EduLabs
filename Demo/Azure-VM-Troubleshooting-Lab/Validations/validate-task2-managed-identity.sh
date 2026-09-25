# =====================================================================
# Lab 2 / Task 1 - Restore VM access to Azure Storage using managed identity
# Validation step: 1514befa-558a-41b9-9400-bc0374c734e3
#
# HYBRID validator:
#   2a CONTROL PLANE - appvm has a system-assigned managed identity
#   2b CONTROL PLANE - storage firewall still defaults to Deny AND allows
#                      app-subnet through a virtual network rule
#   2c CONTROL PLANE - the identity holds Storage Blob Data Contributor (or
#                      Owner) on the reports container or the account
#   2d IN-VM (appvm) - a fresh IMDS token can read the blob the report job
#                      uploads, orders-report-latest.txt
#
# 2d is the real proof: it can only pass when identity, network and RBAC
# are all right AND the learner actually ran the job. 2a-2c exist so the
# failure message names the missing piece. 2b also fails a "fix" that
# opens the storage firewall to all networks.
# =====================================================================
Import-Module Az.Accounts
Import-Module Az.Compute
Import-Module Az.Resources

# Variables provided by CloudLabs
$deployment_id     = $deployment_id
$resourceGroupName = $resourceGroupName
$sub_id            = $sub_id

$appVmName     = "appvm-$deployment_id"
$storageName   = "stapp$deployment_id"
$containerName = "reports"
$vnetName      = "lab-vnet-$deployment_id"
$rgPath        = "/subscriptions/$sub_id/resourceGroups/$resourceGroupName"
$appSubnetId   = "$rgPath/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/app-subnet"
$accountScope  = "$rgPath/providers/Microsoft.Storage/storageAccounts/$storageName"
$containerScope = "$accountScope/blobServices/default/containers/$containerName"

# Built-in role definition IDs - identical in every tenant
$blobDataRoles = @{
    "ba92f5b4-2d11-453d-a403-e96b0029c9fe" = "Storage Blob Data Contributor"
    "b7e6dc6d-f1e8-4753-8033-0f276bb0955b" = "Storage Blob Data Owner"
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
        # 2a - CONTROL PLANE: system-assigned identity on appvm
        # =============================================================
        $identityOk  = $false
        $principalId = $null
        $vmResp = Invoke-AzRestMethod -Path ("$rgPath/providers/Microsoft.Compute/virtualMachines/$appVmName" + "?api-version=2023-03-01") -Method GET

        if ($vmResp.StatusCode -eq 200) {
            $identity = ($vmResp.Content | ConvertFrom-Json).identity
            if ($null -ne $identity -and ([string]$identity.type) -match "SystemAssigned" -and $identity.principalId) {
                $identityOk  = $true
                $principalId = $identity.principalId
            }
            else {
                $reasons += "$appVmName has no system-assigned managed identity - run 'az vm identity assign -g <rg> -n $appVmName'"
            }
        }
        else {
            $reasons += "$appVmName could not be read (HTTP $($vmResp.StatusCode))"
        }

        # =============================================================
        # 2b - CONTROL PLANE: storage firewall
        # =============================================================
        $firewallOk = $false
        $saResp = Invoke-AzRestMethod -Path ("$accountScope" + "?api-version=2023-01-01") -Method GET

        if ($saResp.StatusCode -eq 200) {
            $sa  = ($saResp.Content | ConvertFrom-Json).properties
            $acl = $sa.networkAcls
            $defaultDeny = ($acl.defaultAction -eq "Deny")
            $subnetRule  = @($acl.virtualNetworkRules | Where-Object { $_ -and ([string]$_.id).TrimEnd('/') -ieq $appSubnetId })
            $publicOff   = ($sa.publicNetworkAccess -eq "Disabled")

            if (-not $defaultDeny) {
                $reasons += "the storage firewall default action is '$($acl.defaultAction)' - it must stay 'Deny' (selected networks only); allow app-subnet with a virtual network rule instead of opening the account to all networks"
            }
            if ($subnetRule.Count -eq 0) {
                $reasons += "the storage firewall has no virtual network rule for app-subnet - add the Microsoft.Storage service endpoint to app-subnet, then 'az storage account network-rule add --vnet-name $vnetName --subnet app-subnet'"
            }
            if ($publicOff) {
                $reasons += "public network access on $storageName is Disabled, which also blocks service endpoint traffic - set it back to 'Enabled from selected networks'"
            }
            $firewallOk = ($defaultDeny -and $subnetRule.Count -gt 0 -and -not $publicOff)
        }
        else {
            $reasons += "$storageName could not be read (HTTP $($saResp.StatusCode))"
        }

        # =============================================================
        # 2c - CONTROL PLANE: data-plane role for the identity.
        #      Listing at resource-group scope with a principalId filter
        #      returns assignments at, above AND below the resource group,
        #      so a container-scoped assignment is found.
        # =============================================================
        $roleOk = $false
        if ($identityOk) {
            $raPath = "$rgPath/providers/Microsoft.Authorization/roleAssignments?api-version=2022-04-01&`$filter=principalId%20eq%20'$principalId'"
            $raResp = Invoke-AzRestMethod -Path $raPath -Method GET

            if ($raResp.StatusCode -eq 200) {
                $assignments = @(($raResp.Content | ConvertFrom-Json).value | Where-Object { $_ })
                $match = $assignments | Where-Object {
                    $roleGuid = ([string]$_.properties.roleDefinitionId).Split('/')[-1].ToLower()
                    $scope    = ([string]$_.properties.scope).TrimEnd('/')
                    $blobDataRoles.ContainsKey($roleGuid) -and ($scope -ieq $containerScope -or $scope -ieq $accountScope)
                } | Select-Object -First 1

                if ($null -ne $match) {
                    $roleOk = $true
                }
                else {
                    $held = @($assignments | ForEach-Object { ([string]$_.properties.scope).Split('/')[-1] }) -join ", "
                    if ($assignments.Count -eq 0) {
                        $reasons += "the managed identity has no role assignments - grant 'Storage Blob Data Contributor' on the reports container"
                    }
                    else {
                        $reasons += "the managed identity holds role assignment(s) at [$held] but none is Storage Blob Data Contributor on the reports container or the $storageName account - control-plane roles such as Reader, Contributor and Owner do not grant access to blob data"
                    }
                }
            }
            else {
                $reasons += "role assignments for the managed identity could not be read (HTTP $($raResp.StatusCode))"
            }
        }

        # =============================================================
        # 2d - IN-VM (appvm): end to end with the VM's own identity.
        #      A fresh token proves identity, a successful read proves
        #      network and RBAC, and the blob's content proves the report
        #      job itself was run.
        # =============================================================
        $script = @'
#!/bin/bash
set -uo pipefail

source /opt/app/app.env 2>/dev/null
SA="${STORAGE_ACCOUNT:-unknown}"
C="${STORAGE_CONTAINER:-reports}"
B="${REPORT_BLOB:-orders-report-latest.txt}"
IMDS="http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F"

count=0
found=false
detail=""

while [ $count -lt 3 ] && [ "$found" != "true" ]; do
  count=$((count + 1))

  tcode=$(curl -s --noproxy '*' -m 10 -H "Metadata: true" -o /tmp/v2-token.json -w '%{http_code}' "$IMDS")
  if [ "$tcode" != "200" ]; then
    detail="IMDS returned HTTP ${tcode} - the VM has no usable managed identity yet"
    sleep 10; continue
  fi
  token=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["access_token"])' /tmp/v2-token.json 2>/dev/null)

  bcode=$(curl -s -m 20 -D /tmp/v2-headers.txt -o /tmp/v2-blob.txt -w '%{http_code}' \
    -H "Authorization: Bearer ${token}" -H "x-ms-version: 2021-08-06" \
    "https://${SA}.blob.core.windows.net/${C}/${B}")
  err=$(grep -i '^x-ms-error-code:' /tmp/v2-headers.txt 2>/dev/null | cut -d: -f2 | tr -d ' \r')

  if [ "$bcode" = "200" ] && grep -q '^orders-report' /tmp/v2-blob.txt 2>/dev/null; then
    found=true
    rm -f /tmp/v2-token.json /tmp/v2-headers.txt /tmp/v2-blob.txt
    echo '{"Status":"Succeeded","Message":"The managed identity obtained a token from IMDS and read '"${C}/${B}"' from '"${SA}"'."}'
    exit 0
  fi

  case "$err" in
    AuthorizationFailure)              detail="storage rejected the request with AuthorizationFailure - the storage firewall is not yet admitting app-subnet" ;;
    AuthorizationPermissionMismatch)   detail="storage rejected the request with AuthorizationPermissionMismatch - the identity has no data-plane role yet, or the assignment has not propagated" ;;
    BlobNotFound)                      detail="access works but ${C}/${B} does not exist - run /opt/app/sync-reports.sh on appvm so the report is uploaded" ;;
    *)                                 detail="reading ${C}/${B} returned HTTP ${bcode} ${err}" ;;
  esac
  sleep 10
done

rm -f /tmp/v2-token.json /tmp/v2-headers.txt /tmp/v2-blob.txt
echo '{"Status":"Failed","Message":"End-to-end check from appvm failed after '"$count"' attempts: '"$detail"'."}'
exit 0
'@

        # Execute inside the APP VM - the identity under test belongs to it
        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $resourceGroupName `
            -VMName $appVmName `
            -CommandId "RunShellScript" `
            -ScriptString $script

        $vmOutput = ($result.Value[0].Message | Out-String).Trim()
        $vmOk = ($vmOutput -match '"Status":"Succeeded"')

        if (-not $vmOk) {
            if ($vmOutput -match '"Message":"([^"]*)"') { $reasons += $Matches[1] }
            else { $reasons += "the end-to-end storage check on $appVmName did not succeed" }
        }

        if ($identityOk -and $firewallOk -and $roleOk -and $vmOk) {
            $message = @{
                Status  = "Succeeded"
                Message = "Storage access restored with managed identity. $appVmName has a system-assigned identity, the storage firewall still denies by default but admits app-subnet through its service endpoint, the identity holds a Storage Blob Data role on the reports container, and the uploaded report can be read back with a fresh IMDS token."
            } | ConvertTo-Json
        }
        else {
            $detail = $reasons -join "; "
            $message = @{
                Status  = "Failed"
                Message = "Managed identity check failed - $detail. Work through Lab 2 in order: enable the system-assigned identity on $appVmName, add the Microsoft.Storage service endpoint to app-subnet and a network rule for it on $storageName, grant Storage Blob Data Contributor on the reports container, then run /opt/app/sync-reports.sh until it reports 'Sync complete'."
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
