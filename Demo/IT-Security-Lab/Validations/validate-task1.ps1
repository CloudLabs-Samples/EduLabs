# =====================================================================
# Lab 1 / Task 1 - Establish managed accounts and least-privilege access
# Validation step: a7c31e94-2b6d-4f18-9e05-1c8a4d7b0f31
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
  accounts_ok=false
  ageing_ok=false
  locked_ok=false
  sudoers_ok=false

  # 1) secops group exists and both analysts are members with home dirs
  a1_home=$(getent passwd analyst1 2>/dev/null | cut -d: -f6)
  a2_home=$(getent passwd analyst2 2>/dev/null | cut -d: -f6)
  if getent group secops >/dev/null 2>&1 \
     && [ -n "$a1_home" ] && [ -d "$a1_home" ] \
     && [ -n "$a2_home" ] && [ -d "$a2_home" ] \
     && id -nG analyst1 2>/dev/null | tr ' ' '\n' | grep -qx 'secops' \
     && id -nG analyst2 2>/dev/null | tr ' ' '\n' | grep -qx 'secops'; then
    accounts_ok=true
  fi

  # 2) analyst1 has a 90-day maximum password age
  max_days=$(chage -l analyst1 2>/dev/null | grep -i 'Maximum number of days' | awk -F: '{gsub(/ /,"",$2); print $2}')
  [ "$max_days" = "90" ] && ageing_ok=true

  # 3) olduser is locked (password status L) AND the account is expired
  pw_status=$(passwd -S olduser 2>/dev/null | awk '{print $2}')
  acct_exp=$(chage -l olduser 2>/dev/null | grep -i 'Account expires' | awk -F: '{gsub(/^ +| +$/,"",$2); print $2}')
  if [ "$pw_status" = "L" ] && [ -n "$acct_exp" ] && [ "$acct_exp" != "never" ]; then
    locked_ok=true
  fi

  # 4) a sudoers drop-in grants secops a SCOPED command list (not blanket ALL),
  #    is mode 0440, and the whole sudoers configuration parses cleanly
  if [ -f /etc/sudoers.d/secops ]; then
    mode=$(stat -c '%a' /etc/sudoers.d/secops 2>/dev/null)
    if grep -qE '^\s*%secops\s+ALL=' /etc/sudoers.d/secops \
       && ! grep -qE '^\s*%secops\s+ALL=\(\s*ALL(\s*:\s*ALL)?\s*\)\s*(NOPASSWD:\s*)?ALL\s*$' /etc/sudoers.d/secops \
       && [ "$mode" = "440" ] \
       && visudo -c >/dev/null 2>&1; then
      sudoers_ok=true
    fi
  fi

  if $accounts_ok && $ageing_ok && $locked_ok && $sudoers_ok; then
    found=true
    echo '{"Status":"Succeeded","Message":"The secops group and both analyst accounts exist, password ageing is set to 90 days, olduser is locked and expired, and a validated least-privilege sudoers drop-in is in place."}'
    exit 0
  fi

  sleep 10
done

echo '{"Status":"Failed","Message":"Identity check failed after '"$count"' attempts (accounts='"$accounts_ok"', ageing='"$ageing_ok"', olduser_disabled='"$locked_ok"', sudoers='"$sudoers_ok"'). Ensure the secops group exists with analyst1 and analyst2 as members, chage -M 90 was applied to analyst1, olduser was locked with usermod -L and expired with chage -E 0, and /etc/sudoers.d/secops grants %secops a specific command list at mode 0440 that passes visudo -c."}'
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
                Message = "Managed accounts and group membership are in place, password ageing is enforced, the departed contractor account is disabled, and least-privilege sudo is configured."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "Validation failed. Ensure the secops group exists with analyst1 and analyst2 as members, analyst1 has a 90-day maximum password age, olduser is both locked and expired, and /etc/sudoers.d/secops grants %secops a scoped command list at mode 0440."
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
