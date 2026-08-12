# =====================================================================
# Lab 1 / Task 1 - Prove integrity with hashing and protect data with AES
# Validation step: c4e17a92-8d3b-4f65-a018-2e7c9b5d40f1
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

LAB_DIR="/home/azureuser/crypto-lab"
LAB_PASS="Payroll-Key-2026"

count=0
found=false

while [ $count -lt 3 ] && [ "$found" != "true" ]; do
  count=$((count + 1))
  report_ok=false
  encrypted_ok=false
  roundtrip_ok=false
  seeds_ok=false

  cd "$LAB_DIR" 2>/dev/null || { sleep 10; continue; }

  # 0) the seeded invoices must still be intact, otherwise the integrity
  #    report below would be meaningless. The published hash is compared
  #    directly rather than by piping "sha256sum -c" into grep, because
  #    "sha256sum -c" exits non-zero by design here (the forged invoice is
  #    SUPPOSED to fail) and under "set -o pipefail" that non-zero status
  #    would sink the whole pipeline regardless of what grep matched.
  manifest_hash=$(awk '$2 == "invoice.txt" {print $1}' invoice.sha256 2>/dev/null)
  genuine_hash=$(sha256sum invoice.txt 2>/dev/null | awk '{print $1}')
  forged_hash=$(sha256sum invoice-resent.txt 2>/dev/null | awk '{print $1}')
  if [ -n "$manifest_hash" ] && [ "$manifest_hash" = "$genuine_hash" ] \
     && [ -n "$forged_hash" ] && [ "$manifest_hash" != "$forged_hash" ]; then
    seeds_ok=true
  fi

  # 1) the learner captured the integrity check, and it records BOTH
  #    verdicts - the genuine invoice passing and the forgery failing
  if [ -f integrity-report.txt ] \
     && grep -Fqx 'invoice.txt: OK' integrity-report.txt \
     && grep -Fqx 'invoice-resent.txt: FAILED' integrity-report.txt; then
    report_ok=true
  fi

  # 2) payroll.csv.enc exists, is genuinely encrypted rather than a copy,
  #    and decrypts with the documented lab password back to the original.
  #    Decrypting is the only honest test - comparing bytes would fail
  #    because the random salt makes every ciphertext different.
  if [ -f payroll.csv.enc ] && [ -s payroll.csv ]; then
    if ! grep -q 'employee_id' payroll.csv.enc 2>/dev/null; then
      tmp_dec=$(mktemp)
      if openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.csv.enc \
                     -out "$tmp_dec" -pass pass:"$LAB_PASS" 2>/dev/null \
         && cmp -s "$tmp_dec" payroll.csv; then
        encrypted_ok=true
      fi
      rm -f "$tmp_dec"
    fi
  fi

  # 3) the learner completed the round trip to a file of their own
  if [ -f payroll-decrypted.csv ] && cmp -s payroll-decrypted.csv payroll.csv; then
    roundtrip_ok=true
  fi

  if $seeds_ok && $report_ok && $encrypted_ok && $roundtrip_ok; then
    found=true
    echo '{"Status":"Succeeded","Message":"The forged invoice was identified against the published checksum manifest, and the payroll extract was encrypted with AES-256 and decrypted back to its original content."}'
    exit 0
  fi

  sleep 10
done

echo '{"Status":"Failed","Message":"Cryptography check failed after '"$count"' attempts (seed_files_intact='"$seeds_ok"', integrity_report='"$report_ok"', aes_encrypted='"$encrypted_ok"', decrypt_roundtrip='"$roundtrip_ok"'). In ~/crypto-lab run \"sha256sum -c invoice.sha256 2>&1 | tee integrity-report.txt\" so the report records invoice.txt as OK and invoice-resent.txt as FAILED. Then encrypt with \"openssl enc -aes-256-cbc -pbkdf2 -salt -in payroll.csv -out payroll.csv.enc -pass pass:Payroll-Key-2026\" and decrypt with \"openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.csv.enc -out payroll-decrypted.csv -pass pass:Payroll-Key-2026\". Use the password exactly as printed in the guide, and do not edit payroll.csv or either invoice."}'
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
                Message = "The forged invoice was detected using the vendor's published SHA-256 manifest, and the payroll extract was encrypted with AES-256 and successfully decrypted back to its original content."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "Validation failed. Ensure ~/crypto-lab/integrity-report.txt records invoice.txt as OK and invoice-resent.txt as FAILED, and that payroll.csv.enc and payroll-decrypted.csv were produced with the lab password Payroll-Key-2026."
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
