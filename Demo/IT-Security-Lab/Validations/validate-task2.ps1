# =====================================================================
# Lab 2 / Task 1 - Secure sensitive data and remove the SUID risk
# Validation step: 1f5b8e70-3a94-42d6-8c17-9b2e5d40a683
# =====================================================================
Import-Module Az.Compute
Import-Module Az.Accounts

# Variables provided by CloudLabs
$deployment_id     = $deployment_id
$resourceGroupName = $resourceGroupName
$sub_id            = $sub_id
$vmName            = "labvm-$deployment_id"

# Set subscription
Select-AzSubscription -SubscriptionId $sub_id

# Retry logic
$stopRetry = $false
[int]$retryCount = 0
$maxRetries = 3

do {
    try {

        # Script to run inside VM
        $script = @'
#!/bin/bash
set -uo pipefail

count=0
found=false

while [ $count -lt 3 ] && [ "$found" != "true" ]; do
  count=$((count + 1))
  records_ok=false
  keys_ok=false
  script_ok=false
  umask_ok=false
  suid_ok=false

  # 1) customer-records.csv is 0640 and group-owned by secops
  rec_mode=$(stat -c '%a' /opt/labdata/customer-records.csv 2>/dev/null)
  rec_grp=$(stat -c '%G'  /opt/labdata/customer-records.csv 2>/dev/null)
  if [ "$rec_mode" = "640" ] && [ "$rec_grp" = "secops" ]; then
    records_ok=true
  fi

  # 2) api-keys.txt is owner-only (0600)
  key_mode=$(stat -c '%a' /opt/labdata/api-keys.txt 2>/dev/null)
  [ "$key_mode" = "600" ] && keys_ok=true

  # 3) backup.sh is no longer group- or world-writable
  bak_mode=$(stat -c '%a' /opt/labdata/backup.sh 2>/dev/null)
  case "$bak_mode" in
    750|740|700|550|500) script_ok=true ;;
    *) script_ok=false ;;
  esac

  # 4) a restrictive default umask of 027 is configured system-wide
  if grep -rhqE '^\s*umask\s+0?027\s*$' /etc/profile.d/ 2>/dev/null \
     && grep -qE '^\s*UMASK\s+0?027\s*$' /etc/login.defs 2>/dev/null; then
    umask_ok=true
  fi

  # 5) the SUID bit has been cleared from the planted binary.
  #    Deleting the binary outright is also an acceptable remediation.
  if [ -e /opt/labdata/scanner ]; then
    [ ! -u /opt/labdata/scanner ] && suid_ok=true
  else
    suid_ok=true
  fi

  if $records_ok && $keys_ok && $script_ok && $umask_ok && $suid_ok; then
    found=true
    echo '{"Status":"Succeeded","Message":"Sensitive files in /opt/labdata are correctly restricted, a 027 default umask is configured, and the SUID bit has been removed from the unauthorised binary."}'
    exit 0
  fi

  sleep 10
done

echo '{"Status":"Failed","Message":"Permission check failed after '"$count"' attempts (records='"$records_ok"' mode='"$rec_mode"' group='"$rec_grp"', apikeys='"$keys_ok"' mode='"$key_mode"', backup='"$script_ok"' mode='"$bak_mode"', umask='"$umask_ok"', suid_removed='"$suid_ok"'). Ensure customer-records.csv is 0640 root:secops, api-keys.txt is 0600, backup.sh is 0750, umask 027 is set in both /etc/profile.d and /etc/login.defs, and chmod u-s was applied to /opt/labdata/scanner."}'
exit 0
'@

        # Execute inside VM
        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $resourceGroupName `
            -VMName $vmName `
            -CommandId "RunShellScript" `
            -ScriptString $script

        $vmOutput = ($result.Value[0].Message | Out-String).Trim()

        if ($vmOutput -match '"Status":"Succeeded"') {
            $message = @{
                Status  = "Succeeded"
                Message = "The sensitive files in /opt/labdata are correctly restricted, a 027 default umask is configured system-wide, and the unauthorised SUID bit has been removed."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "Validation failed. Ensure customer-records.csv is mode 0640 owned by root:secops, api-keys.txt is mode 0600, backup.sh is mode 0750, umask 027 is set in both /etc/profile.d and /etc/login.defs, and the SUID bit was cleared from /opt/labdata/scanner."
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
