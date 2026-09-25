#!/bin/bash
# =====================================================================
# Azure VM Troubleshooting Lab - App VM bootstrap (appvm-<id>)
# Runs once, as root, via the ARM Custom Script Extension.
#
# Seeds the OS-level half of the broken environment. The Azure-level
# faults (NSG ordering, black-hole route, no managed identity, storage
# firewall, missing service endpoint) are all in deploy-01.json.
#
#   Seed                                         Remediated in
#   -------------------------------------------  ----------------------
#   nginx "orders-api" bound to 127.0.0.1:80      Lab 1 (OS layer)
#   /opt/app/sync-reports.sh (managed identity)   Lab 2 (run until it works)
#
# Design rule: this script makes NO Azure control-plane or data-plane
# calls, so provisioning cannot fail on an identity or network problem -
# which matters here, because identity and network are exactly what is
# broken.
#
# Invoked by the ARM CustomScript extension:
#   bash bootstrap-02.sh -d <DeploymentID> -s <storageAccount> -c <container>
# =====================================================================
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

LOG=/var/log/app-bootstrap.log
exec > >(tee -a "$LOG") 2>&1
echo "[bootstrap] started $(date -u)"

DEPLOYMENT_ID=""
STORAGE_ACCOUNT=""
STORAGE_CONTAINER="reports"

while getopts "d:s:c:" opt; do
  case "$opt" in
    d) DEPLOYMENT_ID="$OPTARG" ;;
    s) STORAGE_ACCOUNT="$OPTARG" ;;
    c) STORAGE_CONTAINER="$OPTARG" ;;
    *) echo "[bootstrap] unknown option: $opt" ;;
  esac
done
echo "[bootstrap] deployment=$DEPLOYMENT_ID storage=$STORAGE_ACCOUNT container=$STORAGE_CONTAINER"

# =====================================================================
# 0. Wait for apt. unattended-upgrades holds the dpkg lock on first boot
#    and the CSE starts at the same moment.
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

echo "[bootstrap] apt update"
apt-get update -y >/dev/null 2>&1 || echo "[bootstrap] WARN: apt update returned non-zero"

for p in nginx curl python3; do
  if dpkg -s "$p" >/dev/null 2>&1; then
    echo "[bootstrap]   $p already present"
  elif apt_install "$p"; then
    echo "[bootstrap]   $p installed"
  else
    echo "[bootstrap] CRITICAL: could not install $p - Lab 1 or Lab 2 cannot be completed"
  fi
done

# =====================================================================
# 1. The orders API - deliberately bound to loopback only  -> Lab 1
#
#    127.0.0.1:80 means nginx answers requests that originate on this VM
#    and nothing else. From the jump host the symptom is "Connection
#    refused", which only becomes visible once the route and the NSG are
#    fixed - that progression is the point of Lab 1.
# =====================================================================
echo "[bootstrap] configuring the orders-api site (Lab 1 OS fault)"
install -d -m 0755 /var/www/orders-api
cat > /var/www/orders-api/index.html <<'HTML'
<!doctype html>
<html><head><title>Contoso Orders API</title></head>
<body><h1>Contoso Orders API</h1><p>Service is running. Health endpoint: /health</p></body>
</html>
HTML

cat > /etc/nginx/sites-available/orders-api <<'NGINX'
server {
    listen 127.0.0.1:80;
    server_name _;

    root /var/www/orders-api;
    index index.html;

    location = /health {
        default_type text/plain;
        return 200 'orders-api: healthy\n';
    }
}
NGINX

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/orders-api /etc/nginx/sites-enabled/orders-api

if nginx -t >/dev/null 2>&1; then
  systemctl enable nginx >/dev/null 2>&1 || true
  systemctl restart nginx
  echo "[bootstrap]   nginx restarted with listen 127.0.0.1:80"
else
  echo "[bootstrap] CRITICAL: nginx configuration test failed"
  nginx -t
fi

# =====================================================================
# 2. The report sync job - uses the VM's managed identity  -> Lab 2
#
#    Three stages, each of which fails in a different, recognisable way
#    until the matching fix is applied:
#      [1/3] IMDS token   - HTTP 400 "Identity not found"   (no identity)
#      [2/3] blob upload  - 403 AuthorizationFailure         (storage firewall)
#                         - 403 AuthorizationPermissionMismatch (no data role)
#      [3/3] blob listing - proves read access as well as write
# =====================================================================
echo "[bootstrap] staging /opt/app (Lab 2)"
install -d -m 0755 /opt/app

cat > /opt/app/app.env <<EOF
STORAGE_ACCOUNT=${STORAGE_ACCOUNT}
STORAGE_CONTAINER=${STORAGE_CONTAINER}
REPORT_BLOB=orders-report-latest.txt
EOF
chmod 0644 /opt/app/app.env

cat > /opt/app/sync-reports.sh <<'SYNC'
#!/bin/bash
# =====================================================================
# Contoso orders report sync
# Uploads the daily orders report to Blob Storage using this VM's
# MANAGED IDENTITY. There is no storage key or secret anywhere on this
# machine - the token comes from the Instance Metadata Service (IMDS).
# =====================================================================
set -uo pipefail
source /opt/app/app.env

API_VERSION="2021-08-06"
BASE_URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${STORAGE_CONTAINER}"
IMDS_URL="http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# ---- 1. token ---------------------------------------------------------
echo "[1/3] Requesting an access token from the Instance Metadata Service (IMDS)"
code=$(curl -s --noproxy '*' -m 10 -H "Metadata: true" -o "$TMP/token.json" -w '%{http_code}' "$IMDS_URL")
if [ "$code" != "200" ]; then
  echo "      FAILED - IMDS returned HTTP ${code}"
  echo "      $(cat "$TMP/token.json" 2>/dev/null)"
  exit 1
fi
TOKEN=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["access_token"])' "$TMP/token.json")
OID=$(python3 - "$TOKEN" <<'PY'
import base64, json, sys
p = sys.argv[1].split(".")[1]
p += "=" * (-len(p) % 4)
print(json.loads(base64.urlsafe_b64decode(p)).get("oid", "unknown"))
PY
)
echo "      OK - token issued to managed identity ${OID}"

# ---- 2. upload --------------------------------------------------------
echo "[2/3] Uploading ${REPORT_BLOB} to ${BASE_URL}/"
printf 'orders-report\nhost=%s\ngenerated_utc=%s\norders_processed=1482\nstatus=complete\n' \
  "$(hostname)" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" > "$TMP/report.txt"

code=$(curl -s -m 20 -X PUT -D "$TMP/headers.txt" -o "$TMP/body.xml" -w '%{http_code}' \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "x-ms-version: ${API_VERSION}" \
  -H "x-ms-blob-type: BlockBlob" \
  -H "Content-Type: text/plain" \
  --data-binary @"$TMP/report.txt" \
  "${BASE_URL}/${REPORT_BLOB}")
if [ "$code" != "201" ]; then
  err=$(grep -i '^x-ms-error-code:' "$TMP/headers.txt" 2>/dev/null | cut -d: -f2 | tr -d ' \r')
  msg=$(sed -n 's/.*<Message>\([^<]*\).*/\1/p' "$TMP/body.xml" 2>/dev/null | head -n 1)
  [ -z "$msg" ] && msg=$(tr -d '\r' < "$TMP/body.xml" 2>/dev/null | head -n 1)
  echo "      FAILED - Storage returned HTTP ${code} (${err:-no error code})"
  echo "      ${msg:-no response body - check DNS and outbound connectivity}"
  exit 1
fi
echo "      OK - HTTP 201 Created"

# ---- 3. list ----------------------------------------------------------
echo "[3/3] Listing blobs in container '${STORAGE_CONTAINER}'"
code=$(curl -s -m 20 -o "$TMP/list.xml" -w '%{http_code}' \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "x-ms-version: ${API_VERSION}" \
  "${BASE_URL}?restype=container&comp=list")
if [ "$code" != "200" ]; then
  echo "      FAILED - Storage returned HTTP ${code}"
  exit 1
fi
grep -o '<Name>[^<]*</Name>' "$TMP/list.xml" | sed 's/<[^>]*>//g; s/^/      /'

echo "Sync complete - the managed identity can reach and write to storage."
exit 0
SYNC
chmod 0755 /opt/app/sync-reports.sh
chown -R root:root /opt/app

cat > /opt/app/README.txt <<EOF
Contoso orders app server - $(hostname)
  Web service : nginx site /etc/nginx/sites-available/orders-api  (health: /health)
  Report job  : /opt/app/sync-reports.sh   (config: /opt/app/app.env)
  Storage     : ${STORAGE_ACCOUNT} / ${STORAGE_CONTAINER}  - managed identity only, keys disabled
EOF
chmod 0644 /opt/app/README.txt

# =====================================================================
# SELF-CHECK - every seed must be in place, or the lab will not behave
# as the guide describes. Read with: sudo cat /var/log/app-bootstrap.log
# =====================================================================
echo "[bootstrap] ===== self-check ====="
FAILED=0
chk() { # chk <description> <expected> <actual>
  if [ "$2" = "$3" ]; then
    echo "[bootstrap]   PASS  $1 [$3]"
  else
    echo "[bootstrap]   FAIL  $1 - expected [$2] got [$3]"
    FAILED=$((FAILED + 1))
  fi
}

chk "nginx active"                "active"  "$(systemctl is-active nginx 2>/dev/null)"
chk "nginx bound to loopback only" "yes"    "$(ss -tln 2>/dev/null | grep -q '127.0.0.1:80 ' && echo yes || echo no)"
chk "nginx NOT on all addresses"  "no"      "$(ss -tln 2>/dev/null | grep -Eq '(0\.0\.0\.0|\*):80 ' && echo yes || echo no)"
chk "health answers locally"      "orders-api: healthy" "$(curl -s -m 5 http://127.0.0.1/health 2>/dev/null)"
chk "sync script executable"      "yes"     "$([ -x /opt/app/sync-reports.sh ] && echo yes || echo no)"
chk "app.env names storage"       "yes"     "$(grep -q "^STORAGE_ACCOUNT=${STORAGE_ACCOUNT}\$" /opt/app/app.env && [ -n "$STORAGE_ACCOUNT" ] && echo yes || echo no)"
chk "python3 present"             "yes"     "$(command -v python3 >/dev/null 2>&1 && echo yes || echo no)"

if [ "$FAILED" -eq 0 ]; then
  echo "[bootstrap] self-check PASSED - all seeds in place"
else
  echo "[bootstrap] CRITICAL: self-check FAILED - $FAILED seed(s) incorrect, the lab will not work as written"
fi

echo "[bootstrap] finished $(date -u)"
exit 0
