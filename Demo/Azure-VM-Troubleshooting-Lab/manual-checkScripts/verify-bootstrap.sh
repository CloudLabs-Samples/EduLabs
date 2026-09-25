#!/bin/bash
# =====================================================================
# Bootstrap verifier - Azure VM Troubleshooting Lab
#
# Confirms that both Custom Script Extensions finished, that the tooling
# and environment file are in place on the jump host, and - just as
# important - that every planted FAULT is still present at hand-over.
# A lab whose route is already deleted or whose VM already has an
# identity would validate before the learner has done anything, so a
# missing fault is a FAIL, not a warning.
#
# Read-only: it changes nothing and is safe to run at any point before
# the learner starts. (After the learner starts, section 5 will
# correctly report the faults as fixed.)
#
# Run on labvm-<id> as root:  sudo bash verify-bootstrap.sh
# or through Azure Run command against labvm-<id>.
# =====================================================================
set -uo pipefail

PASS=0
FAIL=0
WARN=0
PROBLEMS=""

ok()   { echo "  PASS  $1"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL  $1"; FAIL=$((FAIL+1)); PROBLEMS="${PROBLEMS}  FAIL  $1
"; }
warn() { echo "  WARN  $1"; WARN=$((WARN+1)); PROBLEMS="${PROBLEMS}  WARN  $1
"; }
sec()  { echo; echo "--- $1 ---"; }

if [ "$(id -u)" != "0" ]; then
  echo "Run as root (sudo bash verify-bootstrap.sh) - lab-env.sh is mode 600."
  exit 1
fi

exec > >(tee /var/log/verify-bootstrap.log) 2>&1
echo "Azure VM Troubleshooting Lab - bootstrap verification, $(date -u)"
echo "Full transcript: /var/log/verify-bootstrap.log"

# =====================================================================
sec "1. Jump host Custom Script Extension"
CSE_DIR=$(ls -1d /var/lib/waagent/custom-script/download/* 2>/dev/null | tail -n 1)
if [ -n "$CSE_DIR" ] && [ -s "$CSE_DIR/bootstrap-01.sh" ]; then
  ok "bootstrap-01.sh was downloaded ($(stat -c %s "$CSE_DIR/bootstrap-01.sh") bytes)"
else
  bad "bootstrap-01.sh was not downloaded - check labScriptUrl in deploy-01.json"
fi

if [ -s /var/log/lab-bootstrap.log ]; then
  grep -q '\[bootstrap\] finished' /var/log/lab-bootstrap.log \
    && ok "bootstrap-01 reached its finish line" \
    || bad "bootstrap-01 log has no finish line - it died partway through"
  while IFS= read -r l; do bad "bootstrap-01: ${l#*CRITICAL: }"; done < <(grep 'CRITICAL' /var/log/lab-bootstrap.log | head -6)
  while IFS= read -r l; do warn "bootstrap-01: ${l#*WARN: }"; done < <(grep 'WARN:' /var/log/lab-bootstrap.log | head -6)
else
  bad "no /var/log/lab-bootstrap.log - bootstrap-01 never started"
fi

# =====================================================================
sec "2. Tooling on the jump host"
for t in az jq curl nc ssh ssh-keygen ssh-copy-id; do
  command -v "$t" >/dev/null 2>&1 && ok "$t present" || bad "$t MISSING - a lab step cannot be completed"
done

# =====================================================================
sec "3. Environment file"
if [ -f /opt/lab/lab-env.sh ]; then
  MODE=$(stat -c %a /opt/lab/lab-env.sh)
  OWNER=$(stat -c %U /opt/lab/lab-env.sh)
  [ "$MODE" = "600" ] && ok "lab-env.sh is mode 600" || bad "lab-env.sh is mode $MODE - the SPN secret is exposed"
  [ "$OWNER" = "azureuser" ] && ok "lab-env.sh is owned by azureuser" || bad "lab-env.sh is owned by $OWNER - the learner cannot source it"
  # shellcheck disable=SC1091
  source /opt/lab/lab-env.sh
  for v in DEPLOYMENT_ID RG AZ_SUBSCRIPTION_ID AZ_TENANT_ID AZ_CLIENT_ID AZ_CLIENT_SECRET \
           APP_VM APP_VM_IP APP_NIC APP_NSG ROUTE_TABLE VNET_NAME APP_SUBNET \
           STORAGE_ACCOUNT STORAGE_CONTAINER; do
    [ -n "${!v:-}" ] && ok "$v is set" || bad "$v is NOT set in lab-env.sh"
  done
  grep -q 'lab-env.sh' /home/azureuser/.bashrc 2>/dev/null \
    && ok "azureuser's .bashrc sources lab-env.sh" \
    || bad ".bashrc does not source lab-env.sh - every guide command would lack its variables"
else
  bad "/opt/lab/lab-env.sh is missing - nothing in the lab can run"
fi
[ -s /home/azureuser/LabFiles/scenario-brief.txt ] && ok "scenario brief present" || warn "scenario brief missing"

: "${RG:=}" "${APP_VM:=}" "${APP_VM_IP:=10.0.2.10}" "${APP_NSG:=}" "${ROUTE_TABLE:=}"
: "${VNET_NAME:=}" "${APP_SUBNET:=app-subnet}" "${STORAGE_ACCOUNT:=}" "${STORAGE_CONTAINER:=reports}"

# =====================================================================
sec "4. Service principal sign-in"
AZ_OK=false
if az login --service-principal -u "${AZ_CLIENT_ID:-}" -p "${AZ_CLIENT_SECRET:-}" --tenant "${AZ_TENANT_ID:-}" --output none >/dev/null 2>&1 \
   && az account set --subscription "${AZ_SUBSCRIPTION_ID:-}" >/dev/null 2>&1; then
  ok "service principal signed in"
  AZ_OK=true
else
  bad "service principal sign-in FAILED - the learner cannot start Lab 1"
fi

# =====================================================================
sec "5. Planted faults - every one must still be present"
if $AZ_OK; then
  n=$(az network route-table route list -g "$RG" --route-table-name "$ROUTE_TABLE" \
        --query "[?name=='to-lab-subnet-via-nva' && nextHopIpAddress=='10.0.254.4'] | length(@)" -o tsv 2>/dev/null)
  [ "$n" = "1" ] && ok "Lab 1 fault: black-hole route to 10.0.254.4 present" \
                 || bad "Lab 1 fault missing: route to-lab-subnet-via-nva not found (got '${n:-error}')"

  pa=$(az network nsg rule show -g "$RG" --nsg-name "$APP_NSG" -n Allow-HTTP-From-LabSubnet --query priority -o tsv 2>/dev/null)
  pd=$(az network nsg rule show -g "$RG" --nsg-name "$APP_NSG" -n Deny-HTTP-Inbound --query priority -o tsv 2>/dev/null)
  if [ "$pa" = "300" ] && [ "$pd" = "200" ]; then
    ok "Lab 1 fault: Allow-HTTP-From-LabSubnet (300) is shadowed by Deny-HTTP-Inbound (200)"
  else
    bad "Lab 1 fault missing: NSG priorities are allow=${pa:-missing} deny=${pd:-missing}, expected 300 and 200"
  fi

  ps=$(az vm get-instance-view -g "$RG" -n "$APP_VM" --query "instanceView.statuses[?starts_with(code,'PowerState')].displayStatus | [0]" -o tsv 2>/dev/null)
  [ "$ps" = "VM running" ] && ok "$APP_VM is running" || bad "$APP_VM power state is '${ps:-unknown}'"

  it=$(az vm show -g "$RG" -n "$APP_VM" --query "identity.type" -o tsv 2>/dev/null)
  [ -z "$it" ] && ok "Lab 2 fault: $APP_VM has no managed identity" \
               || bad "Lab 2 fault missing: $APP_VM already has identity type '$it'"

  se=$(az network vnet subnet show -g "$RG" --vnet-name "$VNET_NAME" -n "$APP_SUBNET" --query "length(serviceEndpoints || \`[]\`)" -o tsv 2>/dev/null)
  [ "$se" = "0" ] && ok "Lab 2 fault: $APP_SUBNET has no service endpoints" \
                  || bad "Lab 2 fault missing: $APP_SUBNET has ${se:-unknown} service endpoint(s)"

  acl=$(az storage account show -g "$RG" -n "$STORAGE_ACCOUNT" \
          --query "[networkRuleSet.defaultAction, length(networkRuleSet.virtualNetworkRules), length(networkRuleSet.ipRules), allowSharedKeyAccess]" -o tsv 2>/dev/null | tr '\n\t' '  ' | xargs | tr "A-Z" "a-z")
  [ "$acl" = "deny 0 0 false" ] && ok "Lab 2 fault: storage firewall is Deny with no rules, shared key disabled" \
                                || bad "Lab 2 fault missing: storage firewall/key state is '${acl:-unreadable}', expected 'deny 0 0 false'"

  cs=$(az rest --method get --url "https://management.azure.com/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$RG/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT/blobServices/default/containers/$STORAGE_CONTAINER?api-version=2023-01-01" --query name -o tsv 2>/dev/null)
  [ "$cs" = "$STORAGE_CONTAINER" ] && ok "container '$STORAGE_CONTAINER' exists" || bad "container '$STORAGE_CONTAINER' not found"
else
  warn "skipped - no Azure sign-in"
fi

# =====================================================================
sec "6. App VM guest state (via Run command)"
if $AZ_OK; then
  out=$(az vm run-command invoke -g "$RG" -n "$APP_VM" --command-id RunShellScript --scripts '
    grep -q "self-check PASSED" /var/log/app-bootstrap.log 2>/dev/null && echo SELFCHECK=pass || echo SELFCHECK=fail
    grep -q "\[bootstrap\] finished" /var/log/app-bootstrap.log 2>/dev/null && echo FINISHED=yes || echo FINISHED=no
    ss -tln | grep -q "127.0.0.1:80 " && echo LOOPBACK=yes || echo LOOPBACK=no
    [ -x /opt/app/sync-reports.sh ] && echo SYNC=yes || echo SYNC=no
  ' --query "value[0].message" -o tsv 2>/dev/null)
  echo "$out" | grep -q 'FINISHED=yes'  && ok "bootstrap-02 reached its finish line"        || bad "bootstrap-02 did not finish on $APP_VM"
  echo "$out" | grep -q 'SELFCHECK=pass' && ok "bootstrap-02 self-check PASSED"            || bad "bootstrap-02 self-check did not pass - read /var/log/app-bootstrap.log on $APP_VM"
  echo "$out" | grep -q 'LOOPBACK=yes'  && ok "Lab 1 fault: nginx bound to 127.0.0.1:80"    || bad "Lab 1 fault missing: nginx is not bound to loopback only"
  echo "$out" | grep -q 'SYNC=yes'      && ok "report job /opt/app/sync-reports.sh present" || bad "report job missing on $APP_VM"
else
  warn "skipped - no Azure sign-in"
fi

# =====================================================================
sec "7. Symptom check - the learner's starting point"
if curl -s -m 5 "http://$APP_VM_IP/health" >/dev/null 2>&1; then
  bad "http://$APP_VM_IP/health already answers - Lab 1 has nothing to fix"
else
  ok "http://$APP_VM_IP/health does not answer from the jump host (expected at hand-over)"
fi

# =====================================================================
echo
echo "======================================================="
echo " RESULT: $PASS passed, $FAIL failed, $WARN warnings"
echo "======================================================="
if [ -n "$PROBLEMS" ]; then
  printf '%s' "$PROBLEMS"
fi
if [ "$FAIL" -eq 0 ]; then
  echo " Environment is ready for hand-over."
else
  echo " Do NOT release this environment until the failures above are resolved."
fi
az logout >/dev/null 2>&1 || true
exit 0
