# =====================================================================
# Lab 3 / Task 1 - Hunt down persistence and enable auditing
# Validation step: 3b71d5a8-9e42-4c60-b17f-5d8a0c36e924
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
  uid0_ok=false
  cron_ok=false
  script_ok=false
  auditd_ok=false
  rules_ok=false
  persist_ok=false

  # 1) exactly one UID 0 account remains, and it is root
  uid0_count=$(awk -F: '$3 == 0 {c++} END {print c+0}' /etc/passwd)
  uid0_names=$(awk -F: '$3 == 0 {printf "%s ", $1}' /etc/passwd)
  if [ "$uid0_count" = "1" ] && ! id svc-backup >/dev/null 2>&1; then
    uid0_ok=true
  fi

  # 2) the rogue cron job is gone
  [ ! -f /etc/cron.d/system-health ] && cron_ok=true

  # 3) the world-writable script it called is gone, or at minimum is no
  #    longer writable by everyone (removing it is what the lab teaches,
  #    but locking it down is a defensible alternative remediation)
  if [ ! -e /usr/local/bin/health-check.sh ]; then
    script_ok=true
  else
    hc_mode=$(stat -c '%a' /usr/local/bin/health-check.sh 2>/dev/null)
    case "$hc_mode" in
      *[2367]) script_ok=false ;;   # world-writable bit still set
      *)       script_ok=true  ;;
    esac
  fi

  # 4) auditd is installed, running and enabled at boot
  if systemctl is-active auditd >/dev/null 2>&1 && systemctl is-enabled auditd >/dev/null 2>&1; then
    auditd_ok=true
  fi

  # 5) the identity and privilege watches are loaded in the running kernel
  rules=$(auditctl -l 2>/dev/null)
  if echo "$rules" | grep -qE '^-w /etc/passwd .*-k identity' \
     && echo "$rules" | grep -qE '^-w /etc/shadow .*-k identity' \
     && echo "$rules" | grep -qE '^-w /etc/sudoers'; then
    rules_ok=true
  fi

  # 6) the rules are persistent - they live in /etc/audit/rules.d so that
  #    augenrules reloads them at every boot. A rule added only with
  #    auditctl would disappear on restart and is not a real control.
  if grep -rqE '^\s*-w\s+/etc/passwd\s+-p\s+wa\s+-k\s+identity' /etc/audit/rules.d/ 2>/dev/null; then
    persist_ok=true
  fi

  if $uid0_ok && $cron_ok && $script_ok && $auditd_ok && $rules_ok && $persist_ok; then
    found=true
    echo '{"Status":"Succeeded","Message":"The hidden UID 0 account and the rogue cron persistence have been removed, and auditd is running with persistent watches on the identity and privilege files."}'
    exit 0
  fi

  sleep 10
done

echo '{"Status":"Failed","Message":"Detection check failed after '"$count"' attempts (uid0_ok='"$uid0_ok"' accounts_with_uid_0=['"$uid0_names"'], cron_removed='"$cron_ok"', script_removed='"$script_ok"', auditd_service='"$auditd_ok"', rules_loaded='"$rules_ok"', persistent='"$persist_ok"'). Only root may hold UID 0 - remove any other account listed above with \"userdel -f <name>\" (the -f flag is required for a UID 0 account, because userdel otherwise reports it is in use by process 1), including the audittest account if you have not deleted it yet. Also delete /etc/cron.d/system-health and /usr/local/bin/health-check.sh, then install auditd, create /etc/audit/rules.d/99-identity.rules with watches on /etc/passwd, /etc/shadow and /etc/sudoers using -p wa -k, and run augenrules --load."}'
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
                Message = "The hidden root account and the rogue scheduled job have been removed, and the audit daemon is running with persistent rules watching the identity and privilege files."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "Validation failed. Ensure the svc-backup UID 0 account is deleted, /etc/cron.d/system-health and /usr/local/bin/health-check.sh are removed, and auditd is enabled with watches on /etc/passwd, /etc/shadow and /etc/sudoers loaded from /etc/audit/rules.d."
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
