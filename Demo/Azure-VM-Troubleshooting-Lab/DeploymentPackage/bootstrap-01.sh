#!/bin/bash
# =====================================================================
# Azure VM Troubleshooting Lab - Lab VM (jump host) bootstrap (labvm-<id>)
# Runs once, as root, via the ARM Custom Script Extension.
#
# Design rule: this script makes NO Azure control-plane or data-plane
# calls. Every fixture is a file written to local disk, so provisioning
# cannot fail on a transient credential problem. The learner is the first
# thing that talks to Azure, signing in as the lab service principal.
#
# Installs: Azure CLI, jq, curl, netcat-openbsd, dnsutils, openssh-client.
# Stages:   /opt/lab/lab-env.sh (SPN credentials + every resource name the
#           guide uses), /home/azureuser/LabFiles/scenario-brief.txt.
#
# The broken environment itself lives in deploy-01.json (NSG, route,
# identity, storage firewall, service endpoint) and bootstrap-02.sh (the
# nginx bind address on appvm). Nothing here is a fault.
#
# Invoked by the ARM CustomScript extension:
#   bash bootstrap-01.sh -d <id> -u <trainer> -p <trainerPass> -g <rg>
#        -b <subId> -t <tenantId> -a <appId> -k '<secret>' -s <storage>
#        -c <container> -v <vnet> -i <appVmIp>
# =====================================================================
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

LOG=/var/log/lab-bootstrap.log
exec > >(tee -a "$LOG") 2>&1
echo "[bootstrap] started $(date -u)"

DEPLOYMENT_ID=""
TRAINER_USER=""
TRAINER_PASS=""
RG_NAME=""
SUB_ID=""
TENANT_ID=""
APP_ID=""
APP_SECRET=""
STORAGE_ACCOUNT=""
STORAGE_CONTAINER="reports"
VNET_NAME=""
APP_VM_IP="10.0.2.10"

while getopts "d:u:p:g:b:t:a:k:s:c:v:i:" opt; do
  case "$opt" in
    d) DEPLOYMENT_ID="$OPTARG" ;;
    u) TRAINER_USER="$OPTARG" ;;
    p) TRAINER_PASS="$OPTARG" ;;
    g) RG_NAME="$OPTARG" ;;
    b) SUB_ID="$OPTARG" ;;
    t) TENANT_ID="$OPTARG" ;;
    a) APP_ID="$OPTARG" ;;
    k) APP_SECRET="$OPTARG" ;;
    s) STORAGE_ACCOUNT="$OPTARG" ;;
    c) STORAGE_CONTAINER="$OPTARG" ;;
    v) VNET_NAME="$OPTARG" ;;
    i) APP_VM_IP="$OPTARG" ;;
    *) echo "[bootstrap] unknown option: $opt" ;;
  esac
done

# Resource names are derived from the deployment ID exactly as
# deploy-01.json derives them. The validators use the same convention.
APP_VM="appvm-${DEPLOYMENT_ID}"
APP_NIC="${APP_VM}-nic"
APP_NSG="${APP_VM}-nsg"
ROUTE_TABLE="rt-app-${DEPLOYMENT_ID}"
[ -z "$VNET_NAME" ] && VNET_NAME="lab-vnet-${DEPLOYMENT_ID}"

echo "[bootstrap] deployment=$DEPLOYMENT_ID rg=$RG_NAME app_vm=$APP_VM ($APP_VM_IP) storage=$STORAGE_ACCOUNT"

# =====================================================================
# 0. Wait for apt to be free before touching it.
# =====================================================================
apt_busy() {
  pgrep -x unattended-upgr >/dev/null 2>&1 && return 0
  pgrep -x apt-get         >/dev/null 2>&1 && return 0
  pgrep -x apt             >/dev/null 2>&1 && return 0
  pgrep -x dpkg            >/dev/null 2>&1 && return 0
  if command -v fuser >/dev/null 2>&1; then
    fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 && return 0
    fuser /var/lib/dpkg/lock          >/dev/null 2>&1 && return 0
    fuser /var/lib/apt/lists/lock     >/dev/null 2>&1 && return 0
  fi
  return 1
}

wait_for_apt() {
  local waited=0
  while [ "$waited" -lt 300 ]; do
    apt_busy || { [ "$waited" -gt 0 ] && echo "[bootstrap] apt free after ${waited}s"; return 0; }
    [ "$waited" = "0" ] && echo "[bootstrap] apt is busy - waiting up to 300s"
    sleep 5
    waited=$((waited + 5))
  done
  echo "[bootstrap] WARN: apt still busy after 300s - proceeding anyway"
  return 1
}

apt_install() {
  local pkg="$1" attempt=0
  while [ "$attempt" -lt 3 ]; do
    attempt=$((attempt + 1))
    wait_for_apt
    apt-get install -y --no-install-recommends "$pkg" >/dev/null 2>&1 && return 0
    [ "$attempt" -lt 3 ] && { apt-get update -y >/dev/null 2>&1; sleep 10; }
  done
  return 1
}

systemctl stop unattended-upgrades >/dev/null 2>&1 || true
wait_for_apt

# =====================================================================
# 1. Base packages - one at a time, so one unavailable package cannot
#    silently take the rest of a batch transaction with it.
# =====================================================================
echo "[bootstrap] apt update"
apt-get update -y >/dev/null 2>&1 || echo "[bootstrap] WARN: apt update returned non-zero"

for p in curl ca-certificates gnupg lsb-release apt-transport-https jq netcat-openbsd dnsutils openssh-client; do
  if dpkg -s "$p" >/dev/null 2>&1; then
    echo "[bootstrap]   $p already present"
  elif apt_install "$p"; then
    echo "[bootstrap]   $p installed"
  else
    echo "[bootstrap] WARN: could not install $p after 3 attempts"
  fi
done

if ! command -v jq >/dev/null 2>&1; then
  echo "[bootstrap] jq still missing - fetching the static binary"
  curl -fsSL -o /usr/local/bin/jq https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64 \
    && chmod 755 /usr/local/bin/jq \
    || echo "[bootstrap] WARN: jq could not be installed"
fi

# =====================================================================
# 2. Azure CLI - every Azure action in the guide is an az command.
# =====================================================================
echo "[bootstrap] Azure CLI"
if ! command -v az >/dev/null 2>&1; then
  wait_for_apt
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash >/dev/null 2>&1 || echo "[bootstrap] WARN: Azure CLI install returned non-zero"
fi
if command -v az >/dev/null 2>&1; then
  echo "[bootstrap] az: $(az version --query '"azure-cli"' -o tsv 2>/dev/null || echo unknown)"
else
  echo "[bootstrap] CRITICAL: az not installed - no lab can be completed"
fi

# =====================================================================
# 3. The environment file. Sourced from .bashrc, so every name the guide
#    uses is already set in the learner's shell.
# =====================================================================
echo "[bootstrap] /opt/lab/lab-env.sh"
install -d -m 0755 /opt/lab
{
  echo "#!/bin/bash"
  echo "# Staged by bootstrap-01.sh - sourced automatically from ~/.bashrc."
  printf "export DEPLOYMENT_ID='%s'\n"      "$DEPLOYMENT_ID"
  printf "export AZ_RESOURCE_GROUP='%s'\n"  "$RG_NAME"
  printf "export RG='%s'\n"                 "$RG_NAME"
  printf "export AZ_SUBSCRIPTION_ID='%s'\n" "$SUB_ID"
  printf "export AZ_TENANT_ID='%s'\n"       "$TENANT_ID"
  printf "export AZ_CLIENT_ID='%s'\n"       "$APP_ID"
  printf "export AZ_CLIENT_SECRET='%s'\n"   "$APP_SECRET"
  printf "export APP_VM='%s'\n"             "$APP_VM"
  printf "export APP_VM_IP='%s'\n"          "$APP_VM_IP"
  printf "export APP_NIC='%s'\n"            "$APP_NIC"
  printf "export APP_NSG='%s'\n"            "$APP_NSG"
  printf "export ROUTE_TABLE='%s'\n"        "$ROUTE_TABLE"
  printf "export VNET_NAME='%s'\n"          "$VNET_NAME"
  echo   "export APP_SUBNET='app-subnet'"
  printf "export STORAGE_ACCOUNT='%s'\n"    "$STORAGE_ACCOUNT"
  printf "export STORAGE_CONTAINER='%s'\n"  "$STORAGE_CONTAINER"
} > /opt/lab/lab-env.sh
chown azureuser:azureuser /opt/lab/lab-env.sh
chmod 600 /opt/lab/lab-env.sh

if ! grep -q 'lab-env.sh' /home/azureuser/.bashrc 2>/dev/null; then
  echo '[ -f /opt/lab/lab-env.sh ] && source /opt/lab/lab-env.sh' >> /home/azureuser/.bashrc
fi

# =====================================================================
# 4. Scenario brief handed to the learner
# =====================================================================
echo "[bootstrap] scenario brief"
install -d -m 0755 /home/azureuser/LabFiles
cat > /home/azureuser/LabFiles/scenario-brief.txt <<EOF
Contoso Retail - Incident INC-20931 (Priority 2)
================================================
Deployment ID : ${DEPLOYMENT_ID}
Jump host     : $(hostname)  (10.0.1.10 - you are here)
App server    : ${APP_VM}  (${APP_VM_IP}, no inbound internet access)
Storage       : ${STORAGE_ACCOUNT} / container '${STORAGE_CONTAINER}'

SYMPTOMS
  1. Since last night's change window, the Orders API on ${APP_VM}
     cannot be reached from this jump host. Health checks against
     http://${APP_VM_IP}/health time out, and so does SSH.
  2. The nightly job on ${APP_VM} that uploads the orders report to
     Blob Storage (/opt/app/sync-reports.sh) has been failing too.

CHANGE LOG FOR THE WINDOW
  CHG-4471  Firewall appliance 10.0.254.4 decommissioned.
            "Routes to be cleaned up afterwards."
  CHG-4472  Hardening: block plain HTTP inbound on ${APP_VM}
            ahead of the WAF migration.
  CHG-4473  nginx configuration on ${APP_VM} refactored.
  CHG-4480  Storage account keys disabled. The report job must now
            authenticate with a managed identity - no secrets on disk.
  CHG-4481  Storage firewall switched to "selected networks".

YOUR ASSIGNMENT
  Lab 1 - restore connectivity from this host to the Orders API.
  Lab 2 - restore the report upload using ${APP_VM}'s managed identity.

Every resource name above is already exported in your shell - run
'env | grep -E "APP_|STORAGE_|ROUTE_|VNET_|^RG="' to see them.
EOF
chown -R azureuser:azureuser /home/azureuser/LabFiles
chmod 0644 /home/azureuser/LabFiles/scenario-brief.txt

# =====================================================================
# 5. Optional trainer account
# =====================================================================
if [ -n "$TRAINER_USER" ] && ! id "$TRAINER_USER" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$TRAINER_USER" 2>/dev/null || true
  [ -n "$TRAINER_PASS" ] && echo "${TRAINER_USER}:${TRAINER_PASS}" | chpasswd 2>/dev/null || true
  usermod -aG sudo "$TRAINER_USER" 2>/dev/null || true
  echo "[bootstrap] trainer account $TRAINER_USER created"
fi

# =====================================================================
# 6. Summary
# =====================================================================
echo "======================================================="
echo "[bootstrap] TOOLING"
for t in az jq curl nc ssh ssh-keygen ssh-copy-id; do
  printf "  %-12s %s\n" "$t" "$(command -v "$t" >/dev/null 2>&1 && echo present || echo MISSING)"
done

CRITICAL_MISSING=""
for t in az jq curl nc ssh-copy-id; do
  command -v "$t" >/dev/null 2>&1 || CRITICAL_MISSING="$CRITICAL_MISSING $t"
done
if [ -n "$CRITICAL_MISSING" ]; then
  echo "[bootstrap] CRITICAL: missing required tooling:$CRITICAL_MISSING"
else
  echo "[bootstrap] all critical tooling present (az, jq, curl, nc, ssh-copy-id)"
fi

for v in DEPLOYMENT_ID RG_NAME SUB_ID TENANT_ID APP_ID APP_SECRET STORAGE_ACCOUNT; do
  [ -n "${!v}" ] || echo "[bootstrap] CRITICAL: $v was not passed by the ARM template"
done

echo "[bootstrap] finished $(date -u)"
echo "======================================================="
exit 0
