# =====================================================================
# Lab 2 / Task 1 - Generate an RSA key pair and build hybrid encryption
# Validation step: 6a92f38d-1c47-40be-b53a-8f0d27e6c914
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

count=0
found=false

while [ $count -lt 3 ] && [ "$found" != "true" ]; do
  count=$((count + 1))
  keypair_ok=false
  keysize_ok=false
  rsa_roundtrip_ok=false
  hybrid_ok=false

  cd "$LAB_DIR" 2>/dev/null || { sleep 10; continue; }

  # 1) a private key and a matching public key exist. Comparing the modulus
  #    is what proves they are two halves of ONE pair - a learner who ran
  #    genpkey twice would have two valid keys that do not match.
  priv_mod=$(openssl rsa -in private_key.pem -noout -modulus 2>/dev/null)
  pub_mod=$(openssl rsa -pubin -in public_key.pem -noout -modulus 2>/dev/null)
  if [ -n "$priv_mod" ] && [ "$priv_mod" = "$pub_mod" ]; then
    keypair_ok=true
  fi

  # 2) the key is at least 2048 bits. Anything smaller is not a usable
  #    control, so accept larger but never smaller.
  bits=$(openssl rsa -in private_key.pem -noout -text 2>/dev/null \
         | sed -n 's/.*Private-Key: (\([0-9]*\) bit.*/\1/p')
  bits=$(printf '%s' "${bits:-0}" | tr -cd '0-9')
  if [ -n "$bits" ] && [ "$bits" -ge 2048 ] 2>/dev/null; then
    keysize_ok=true
  fi

  # 3) message.enc decrypts with the private key back to message.txt
  if [ -f message.enc ] && [ -s message.txt ]; then
    tmp_msg=$(mktemp)
    if openssl pkeyutl -decrypt -inkey private_key.pem -in message.enc \
                       -out "$tmp_msg" 2>/dev/null \
       && cmp -s "$tmp_msg" message.txt; then
      rsa_roundtrip_ok=true
    fi
    rm -f "$tmp_msg"
  fi

  # 4) the full hybrid chain works: unwrap the AES session key with RSA,
  #    then use it to decrypt the payload back to the original payroll file.
  #    This is verified end to end rather than by checking the files exist,
  #    because only decrypting proves the two artefacts actually belong
  #    together.
  if [ -f aes.key.enc ] && [ -f payroll.hybrid.enc ] && [ -s payroll.csv ]; then
    tmp_key=$(mktemp)
    tmp_pay=$(mktemp)
    if openssl pkeyutl -decrypt -inkey private_key.pem -in aes.key.enc \
                       -out "$tmp_key" 2>/dev/null \
       && [ -s "$tmp_key" ] \
       && openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.hybrid.enc \
                      -out "$tmp_pay" -pass file:"$tmp_key" 2>/dev/null \
       && cmp -s "$tmp_pay" payroll.csv; then
      hybrid_ok=true
    fi
    rm -f "$tmp_key" "$tmp_pay"
  fi

  if $keypair_ok && $keysize_ok && $rsa_roundtrip_ok && $hybrid_ok; then
    found=true
    echo '{"Status":"Succeeded","Message":"A matching 2048-bit RSA key pair is in place, the message encrypted with the public key decrypts with the private key, and the hybrid scheme recovers the payroll file through both the RSA-wrapped session key and the AES payload."}'
    exit 0
  fi

  sleep 10
done

echo '{"Status":"Failed","Message":"Public-key check failed after '"$count"' attempts (matching_keypair='"$keypair_ok"', key_bits='"$bits"', rsa_roundtrip='"$rsa_roundtrip_ok"', hybrid_chain='"$hybrid_ok"'). In ~/crypto-lab generate the pair with \"openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private_key.pem\" then \"openssl rsa -pubout -in private_key.pem -out public_key.pem\" - do not run genpkey a second time, or the public key will no longer match. Encrypt message.txt to message.enc with pkeyutl -encrypt, then build the hybrid scheme: \"openssl rand -base64 32 > aes.key\", encrypt payroll.csv to payroll.hybrid.enc with -pass file:aes.key, and wrap aes.key into aes.key.enc with pkeyutl -encrypt. Do not edit payroll.csv or message.txt after encrypting them."}'
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
                Message = "A matching RSA key pair of at least 2048 bits is in place, public-key encryption round-trips correctly, and the hybrid scheme recovers the payroll file through the RSA-wrapped AES session key."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "Validation failed. Ensure ~/crypto-lab holds private_key.pem and a public_key.pem derived from it, that message.enc decrypts back to message.txt, and that aes.key.enc and payroll.hybrid.enc together decrypt back to payroll.csv."
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
