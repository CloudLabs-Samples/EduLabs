#!/bin/bash
# =====================================================================
# Facilitator validator runner - Azure VM Troubleshooting Lab
#
# GENERATED - do not hand-edit. The two in-VM blocks below are extracted
# verbatim from the validator scripts in Validations/, so what runs here
# is byte-identical to what the CloudLabs validator runs in the VMs.
# Regenerate after changing either validator.
#
# Both validators are HYBRID:
#   validator 1 - in-VM half runs on the JUMP HOST (here, locally)
#   validator 2 - in-VM half runs on the APP VM (here, via az vm run-command)
# Their control-plane halves are reproduced below as equivalent az
# commands. The NSG check here is a simplified equivalent (priority of
# the allow rule versus the deny rule); the real validator evaluates the
# first matching rule in full.
#
# Run on labvm-<id> as root:  sudo bash run-validators.sh
# =====================================================================
OKC=0
BADC=0
RESULTS=""

if [ "$(id -u)" != "0" ]; then
  echo "Run as root - lab-env.sh is mode 600."
  exit 1
fi

exec > >(tee /var/log/run-validators.log) 2>&1
echo "Azure VM Troubleshooting Lab - validator dry-run, $(date -u)"

# shellcheck disable=SC1091
source /opt/lab/lab-env.sh
WORK=$(mktemp -d)

az login --service-principal -u "$AZ_CLIENT_ID" -p "$AZ_CLIENT_SECRET" --tenant "$AZ_TENANT_ID" --output none >/dev/null 2>&1 \
  && az account set --subscription "$AZ_SUBSCRIPTION_ID" >/dev/null 2>&1 \
  || echo "WARNING: service principal sign-in failed - control-plane checks and validator 2 will not run"

record() { # record <n> <label> <pass:true|false>
  if [ "$3" = "true" ]; then
    echo "  --> VALIDATOR $1: PASS"; OKC=$((OKC+1)); RESULTS="${RESULTS}  PASS  validator $1 - $2
"
  else
    echo "  --> VALIDATOR $1: FAIL"; BADC=$((BADC+1)); RESULTS="${RESULTS}  FAIL  validator $1 - $2
"
  fi
}

# ---------------------------------------------------------------------
# validator 1 - in-VM block, extracted verbatim from
# Validations/validate-task1-vm-connectivity.sh
# ---------------------------------------------------------------------
cat > "$WORK/v1.sh" <<'__V1_EOF__'
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
__V1_EOF__

# ---------------------------------------------------------------------
# validator 2 - in-VM block, extracted verbatim from
# Validations/validate-task2-managed-identity.sh
# ---------------------------------------------------------------------
cat > "$WORK/v2.sh" <<'__V2_EOF__'
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
__V2_EOF__

echo
echo "======================================================================"
echo " VALIDATOR 1  |  Lab 1 - VM connectivity"
echo "======================================================================"
v1cp=true
n=$(az network route-table route list -g "$RG" --route-table-name "$ROUTE_TABLE" \
      --query "[?nextHopType=='VirtualAppliance' && (nextHopIpAddress=='10.0.254.4' || addressPrefix=='10.0.1.0/24')] | length(@)" -o tsv 2>/dev/null)
if [ "${n:-1}" = "0" ]; then echo "  control plane: black-hole route removed"; else echo "  control plane: black-hole route STILL PRESENT"; v1cp=false; fi
pa=$(az network nsg rule show -g "$RG" --nsg-name "$APP_NSG" -n Allow-HTTP-From-LabSubnet --query priority -o tsv 2>/dev/null)
pd=$(az network nsg rule show -g "$RG" --nsg-name "$APP_NSG" -n Deny-HTTP-Inbound --query priority -o tsv 2>/dev/null)
if [ -z "$pd" ] || { [ -n "$pa" ] && [ "$pa" -lt "$pd" ]; }; then
  echo "  control plane: Allow-HTTP-From-LabSubnet (${pa:-?}) is evaluated before Deny-HTTP-Inbound (${pd:-absent})"
else
  echo "  control plane: Allow-HTTP-From-LabSubnet (${pa:-missing}) is still shadowed by Deny-HTTP-Inbound (${pd})"; v1cp=false
fi
out=$(bash "$WORK/v1.sh" 2>&1); echo "  in-VM (jump host): $out"
if $v1cp && echo "$out" | grep -q '"Status":"Succeeded"'; then record 1 "Lab 1 - VM connectivity" true; else record 1 "Lab 1 - VM connectivity" false; fi

echo
echo "======================================================================"
echo " VALIDATOR 2  |  Lab 2 - managed identity to storage"
echo "======================================================================"
v2cp=true
PID=$(az vm show -g "$RG" -n "$APP_VM" --query "identity.principalId" -o tsv 2>/dev/null)
if [ -n "$PID" ]; then echo "  control plane: system-assigned identity $PID"; else echo "  control plane: NO managed identity on $APP_VM"; v2cp=false; fi
acl=$(az storage account show -g "$RG" -n "$STORAGE_ACCOUNT" \
        --query "[networkRuleSet.defaultAction, length(networkRuleSet.virtualNetworkRules[?ends_with(virtualNetworkResourceId, '/subnets/$APP_SUBNET')])]" -o tsv 2>/dev/null | tr '\n\t' '  ' | xargs)
if [ "$acl" = "Deny 1" ]; then echo "  control plane: storage firewall Deny + rule for $APP_SUBNET"; else echo "  control plane: storage firewall state '$acl' (want 'Deny 1')"; v2cp=false; fi
if [ -n "$PID" ]; then
  roles=$(az rest --method get \
    --url "https://management.azure.com/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$RG/providers/Microsoft.Authorization/roleAssignments?api-version=2022-04-01&\$filter=principalId%20eq%20'$PID'" \
    --query "value[?ends_with(properties.roleDefinitionId, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') || ends_with(properties.roleDefinitionId, 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b')].properties.scope" -o tsv 2>/dev/null)
  if echo "$roles" | grep -Eiq "/storageAccounts/$STORAGE_ACCOUNT(/blobServices/default/containers/$STORAGE_CONTAINER)?$"; then
    echo "  control plane: Storage Blob Data role at $(echo "$roles" | head -n 1)"
  else
    echo "  control plane: NO Storage Blob Data role on the container or account"; v2cp=false
  fi
fi
out=$(az vm run-command invoke -g "$RG" -n "$APP_VM" --command-id RunShellScript --scripts @"$WORK/v2.sh" --query "value[0].message" -o tsv 2>&1)
line=$(echo "$out" | grep -m1 '"Status"'); echo "  in-VM (app VM): ${line:-$out}"
if $v2cp && echo "$line" | grep -q '"Status":"Succeeded"'; then record 2 "Lab 2 - managed identity to storage" true; else record 2 "Lab 2 - managed identity to storage" false; fi

rm -rf "$WORK"
echo
echo "======================================================="
echo " RESULT: $OKC passed, $BADC failed"
echo "======================================================="
printf '%s' "$RESULTS"
exit 0
