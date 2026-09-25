#!/bin/bash
# =====================================================================
# Facilitator dry-run - Azure VM Troubleshooting Lab
#
# QA / FACILITATOR TOOL - NOT learner content, do not ship in the guide.
#
# Performs every fix the two lab guides instruct, so the validators can
# be tested end to end in a few minutes instead of walking both labs.
# Run it on a freshly provisioned jump host:
#
#   sudo bash run-solution.sh             # Lab 1 and Lab 2
#   sudo bash run-solution.sh --partial   # Lab 1 only
#
# Then hit Validate on both tasks, or run run-validators.sh.
# With --partial, expect task 1 Success and task 2 Failed.
#
# The guide changes appvm's nginx over SSH as azureuser. This script
# runs as root and uses 'az vm run-command invoke' for the same edit,
# so it does not depend on the learner's SSH key. The Azure commands
# are copied from the guides. If a guide step changes, change it here
# too or this script stops being a valid test.
#
# Idempotent: every step is a no-op when already applied.
# =====================================================================
set -uo pipefail

PARTIAL=0
[ "${1:-}" = "--partial" ] && PARTIAL=1

DONE=0
BROKE=0
FAILED=""
step() { echo; echo "--- $1 ---"; }
good() { echo "    OK: $1"; DONE=$((DONE+1)); }
oops() { echo "    FAILED: $1"; BROKE=$((BROKE+1)); FAILED="${FAILED}    - $1
"; }

if [ "$(id -u)" != "0" ]; then
  echo "Run as root (sudo bash run-solution.sh) - lab-env.sh is mode 600."
  exit 1
fi

exec > >(tee /var/log/run-solution.log) 2>&1
echo "Azure VM Troubleshooting Lab - facilitator dry-run, $(date -u)"

# shellcheck disable=SC1091
source /opt/lab/lab-env.sh

step "SIGN IN as the service principal"
if az login --service-principal -u "$AZ_CLIENT_ID" -p "$AZ_CLIENT_SECRET" --tenant "$AZ_TENANT_ID" --output none >/dev/null 2>&1 \
   && az account set --subscription "$AZ_SUBSCRIPTION_ID" >/dev/null 2>&1; then
  good "signed in, subscription set"
else
  oops "service principal sign-in failed - nothing below will work"
fi

# =====================================================================
# LAB 1 - VM connectivity
# =====================================================================
step "LAB 1: delete the black-hole route"
if az network route-table route show -g "$RG" --route-table-name "$ROUTE_TABLE" -n to-lab-subnet-via-nva >/dev/null 2>&1; then
  az network route-table route delete -g "$RG" --route-table-name "$ROUTE_TABLE" -n to-lab-subnet-via-nva \
    && good "route to-lab-subnet-via-nva deleted" || oops "route delete failed"
else
  good "route already absent"
fi

step "LAB 1: move Allow-HTTP-From-LabSubnet ahead of the deny"
az network nsg rule update -g "$RG" --nsg-name "$APP_NSG" -n Allow-HTTP-From-LabSubnet --priority 150 --output none \
  && good "Allow-HTTP-From-LabSubnet is priority 150" || oops "NSG rule update failed"

step "LAB 1: bind nginx to all addresses (via Run command)"
out=$(az vm run-command invoke -g "$RG" -n "$APP_VM" --command-id RunShellScript --scripts \
  "sed -i 's/listen 127.0.0.1:80;/listen 80;/' /etc/nginx/sites-available/orders-api && nginx -t && systemctl restart nginx && ss -tln | grep -q '0.0.0.0:80 ' && echo NGINX_OK" \
  --query "value[0].message" -o tsv 2>&1)
echo "$out" | grep -q NGINX_OK && good "nginx listening on 0.0.0.0:80" || { oops "nginx fix failed"; echo "$out" | sed 's/^/      /'; }

step "LAB 1: end-to-end check from the jump host"
ok1=false
for i in 1 2 3 4 5 6; do
  if [ "$(curl -s -m 5 "http://$APP_VM_IP/health")" = "orders-api: healthy" ]; then ok1=true; break; fi
  sleep 10
done
$ok1 && good "http://$APP_VM_IP/health returns orders-api: healthy" || oops "health endpoint still not answering"

if [ "$PARTIAL" -eq 1 ]; then
  step "--partial requested: stopping after Lab 1"
  echo "    Expect: task 1 Success, task 2 Failed"
  exit 0
fi

# =====================================================================
# LAB 2 - managed identity to storage
# =====================================================================
step "LAB 2: enable the system-assigned managed identity"
az vm identity assign -g "$RG" -n "$APP_VM" --output none \
  && good "identity assigned" || oops "identity assign failed"
PRINCIPAL_ID=$(az vm identity show -g "$RG" -n "$APP_VM" --query principalId -o tsv 2>/dev/null)
[ -n "$PRINCIPAL_ID" ] && good "principal ID $PRINCIPAL_ID" || oops "no principal ID returned"

step "LAB 2: service endpoint + storage network rule"
az network vnet subnet update -g "$RG" --vnet-name "$VNET_NAME" -n "$APP_SUBNET" --service-endpoints Microsoft.Storage --output none \
  && good "Microsoft.Storage service endpoint on $APP_SUBNET" || oops "subnet update failed"
az storage account network-rule add -g "$RG" --account-name "$STORAGE_ACCOUNT" --vnet-name "$VNET_NAME" --subnet "$APP_SUBNET" --output none \
  && good "network rule for $APP_SUBNET on $STORAGE_ACCOUNT" || oops "network-rule add failed"

step "LAB 2: Storage Blob Data Contributor on the container"
CONTAINER_SCOPE="$(az storage account show -g "$RG" -n "$STORAGE_ACCOUNT" --query id -o tsv)/blobServices/default/containers/$STORAGE_CONTAINER"
n=$(az role assignment list --scope "$CONTAINER_SCOPE" --query "[?principalId=='$PRINCIPAL_ID' && roleDefinitionName=='Storage Blob Data Contributor'] | length(@)" -o tsv 2>/dev/null)
if [ "${n:-0}" -ge 1 ] 2>/dev/null; then
  good "role assignment already present"
else
  az role assignment create --assignee-object-id "$PRINCIPAL_ID" --assignee-principal-type ServicePrincipal \
    --role "Storage Blob Data Contributor" --scope "$CONTAINER_SCOPE" --output none \
    && good "role assigned at $CONTAINER_SCOPE" || oops "role assignment create failed"
fi

step "LAB 2: run the report job until RBAC propagates (up to 5 minutes)"
ok2=false
for i in $(seq 1 10); do
  out=$(az vm run-command invoke -g "$RG" -n "$APP_VM" --command-id RunShellScript \
          --scripts "/opt/app/sync-reports.sh" --query "value[0].message" -o tsv 2>&1)
  if echo "$out" | grep -q 'Sync complete'; then ok2=true; break; fi
  echo "    attempt $i: $(echo "$out" | grep -E 'FAILED' | head -n 1 | sed 's/^ *//')"
  sleep 30
done
$ok2 && good "report job completed - orders-report-latest.txt uploaded" || oops "report job never succeeded"

# =====================================================================
echo
echo "======================================================="
echo " RESULT: $DONE steps OK, $BROKE failed"
echo "======================================================="
[ -n "$FAILED" ] && printf 'Failed steps:\n%s' "$FAILED"
[ "$BROKE" -eq 0 ] && echo " Now hit Validate on both tasks, or run: sudo bash run-validators.sh"
exit 0
