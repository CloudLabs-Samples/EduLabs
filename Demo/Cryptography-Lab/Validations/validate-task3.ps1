# =====================================================================
# Lab 3 / Task 1 - Sign a release approval and issue a certificate
# Validation step: 8d5c026b-4713-49af-9e2c-3b71a8f05d6e
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
EXPECTED_CN="payments.northwind.example"

count=0
found=false

while [ $count -lt 3 ] && [ "$found" != "true" ]; do
  count=$((count + 1))
  signature_ok=false
  forgery_ok=false
  cert_ok=false
  certkey_ok=false

  cd "$LAB_DIR" 2>/dev/null || { sleep 10; continue; }

  # 1) the signature verifies against the original message with the public key
  if [ -f message.sig ] && [ -s message.txt ] && [ -f public_key.pem ]; then
    if openssl dgst -sha256 -verify public_key.pem -signature message.sig \
                    message.txt >/dev/null 2>&1; then
      signature_ok=true
    fi
  fi

  # 2) the forged copy exists, genuinely differs from the original, and the
  #    signature does NOT verify against it. Checking that verification
  #    FAILS is what proves the learner produced a real forgery rather than
  #    a copy of the original under a different name.
  if [ -f forged-message.txt ] && [ -s message.txt ] \
     && ! cmp -s forged-message.txt message.txt; then
    if ! openssl dgst -sha256 -verify public_key.pem -signature message.sig \
                      forged-message.txt >/dev/null 2>&1; then
      forgery_ok=true
    fi
  fi

  # 3) a self-signed X.509 certificate exists carrying the expected CN, and
  #    its subject and issuer are identical - that is what self-signed means
  if [ -f server.crt ]; then
    subj=$(openssl x509 -in server.crt -noout -subject 2>/dev/null)
    issr=$(openssl x509 -in server.crt -noout -issuer 2>/dev/null)
    # Strip the leading "subject="/"issuer=" labels before comparing, and
    # ignore spacing around "=" so the check works across OpenSSL versions.
    subj_norm=$(printf '%s' "$subj" | sed 's/^subject=//' | tr -d ' ')
    issr_norm=$(printf '%s' "$issr" | sed 's/^issuer=//'  | tr -d ' ')
    if [ -n "$subj_norm" ] && [ "$subj_norm" = "$issr_norm" ] \
       && printf '%s' "$subj_norm" | grep -Fq "$EXPECTED_CN"; then
      cert_ok=true
    fi
  fi

  # 4) the certificate carries the public half of server.key. Comparing the
  #    modulus is the standard way to prove a certificate and key belong
  #    together, and it is the same technique used in Lab 2.
  if [ -f server.crt ] && [ -f server.key ]; then
    crt_mod=$(openssl x509 -in server.crt -noout -modulus 2>/dev/null)
    key_mod=$(openssl rsa -in server.key -noout -modulus 2>/dev/null)
    if [ -n "$crt_mod" ] && [ "$crt_mod" = "$key_mod" ]; then
      certkey_ok=true
    fi
  fi

  if $signature_ok && $forgery_ok && $cert_ok && $certkey_ok; then
    found=true
    echo '{"Status":"Succeeded","Message":"The release approval is signed and verifies against the public key, the forged copy correctly fails verification, and a self-signed X.509 certificate is in place whose public key matches its private key."}'
    exit 0
  fi

  sleep 10
done

echo '{"Status":"Failed","Message":"Signature and certificate check failed after '"$count"' attempts (signature_verifies='"$signature_ok"', forgery_rejected='"$forgery_ok"', self_signed_cert='"$cert_ok"', cert_matches_key='"$certkey_ok"'). In ~/crypto-lab sign with \"openssl dgst -sha256 -sign private_key.pem -out message.sig message.txt\". Create the forgery as a COPY so the original stays valid: \"sed s/CHG-10428/CHG-99999/ message.txt > forged-message.txt\" - if forged-message.txt is identical to message.txt this check cannot pass. Then issue the certificate with \"openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes -keyout server.key -out server.crt -subj /C=DE/O=Northwind Components Ltd/CN=payments.northwind.example\", keeping the CN exactly as written and keeping server.key from the same command that produced server.crt."}'
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
                Message = "The release approval is signed and verifies correctly, the tampered copy is rejected by the same signature, and a self-signed X.509 certificate is in place whose public key matches its private key."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "Validation failed. Ensure message.sig verifies against message.txt with public_key.pem, that forged-message.txt differs from message.txt and fails that same verification, and that server.crt is a self-signed certificate for payments.northwind.example matching server.key."
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
