#!/bin/bash
# =====================================================================
# CloudLabs CSE bootstrap - Introduction to IT Security (Linux)
#
# Seeds a deliberately weak baseline on Ubuntu 22.04 so the learner has
# something real to find and fix. Every seed below maps to a step in the
# lab guide - nothing is seeded that the labs do not use:
#
#   Seed                                    Remediated in
#   -------------------------------------   ----------------------------
#   olduser account, unlocked, no expiry     Lab 1 (offboarding)
#   /opt/labdata files at 0666 / 0644 / 0777 Lab 2 (permissions)
#   SUID root copy of find (scanner)         Lab 2 (privilege escalation)
#   svc-backup account with UID 0            Lab 3 (hidden root account)
#   root cron job on a 0777 script           Lab 3 (persistence)
#   auditd absent                            Lab 3 (auditing)
#
# Every seed is created by this script, so the lab is fully deterministic
# and does not depend on the age or patch level of the base image.
#
# NOTE: this script does not touch sshd_config or the firewall. The labs
# deliberately avoid changes that could cut off the learner's only route
# into the VM.
#
# The script logs every step and finishes with a SELF-CHECK block that
# verifies each seed actually landed. Read the result with:
#   sudo cat /var/log/cloudlabs-bootstrap.log
#
# Invoked by the ARM CustomScript extension:
#   bash bootstrap-01.sh -d <DeploymentID> -u <trainerUser> -p <trainerPass>
# Idempotent-ish: safe to re-run.
# =====================================================================
set -uo pipefail
exec > >(tee -a /var/log/cloudlabs-bootstrap.log) 2>&1

log() { echo "[bootstrap] $(date -u '+%Y-%m-%dT%H:%M:%SZ') $*"; }

log "===== starting ====="

DEPLOYMENT_ID=""
TRAINER_USER="instructor"
TRAINER_PASS=""
while getopts "d:u:p:" opt; do
  case "$opt" in
    d) DEPLOYMENT_ID="$OPTARG" ;;
    u) TRAINER_USER="$OPTARG" ;;
    p) TRAINER_PASS="$OPTARG" ;;
    *) ;;
  esac
done
log "deployment_id=${DEPLOYMENT_ID:-<unset>} trainer_user=${TRAINER_USER}"

export DEBIAN_FRONTEND=noninteractive

# Refresh the index so that Lab 3's "apt-get install auditd" works.
log "refreshing package index (apt output suppressed - it is very noisy)"
if apt-get update -y >/dev/null 2>&1; then
  log "  package index refreshed"
else
  log "  WARNING: apt-get update returned non-zero; Lab 3 install step may fail"
fi

LABFILES="/home/azureuser/LabFiles"
mkdir -p "$LABFILES" /opt/labdata
log "created $LABFILES and /opt/labdata"

# ---------------------------------------------------------------------
# 1) Stale account belonging to a departed contractor  -> Lab 1
# ---------------------------------------------------------------------
log "seeding olduser account (Lab 1)"
if id olduser >/dev/null 2>&1; then
  log "  olduser already exists - reusing"
else
  useradd -m -s /bin/bash -c "Former contractor - offboarded" olduser
  echo 'olduser:Contractor@2019' | chpasswd
  log "  olduser created with a usable password"
fi
# Ensure it starts UNLOCKED and non-expiring so the learner has work to do.
usermod -U olduser 2>/dev/null || true
chage -E -1 -M 99999 olduser 2>/dev/null || true
log "  olduser reset to unlocked / non-expiring"

# ---------------------------------------------------------------------
# 2) Sensitive data with insecure permissions  -> Lab 2
# ---------------------------------------------------------------------
log "seeding /opt/labdata with insecure permissions (Lab 2)"
cat > /opt/labdata/customer-records.csv <<'CSVEOF'
customer_id,full_name,email,region,account_balance
1001,Amara Okafor,amara.okafor@example.com,EMEA,18450.22
1002,Diego Marchetti,diego.marchetti@example.com,EMEA,9120.00
1003,Priya Raghunathan,priya.r@example.com,APAC,33875.90
1004,Kwame Boateng,kwame.boateng@example.com,EMEA,412.75
1005,Sofia Lindqvist,sofia.lindqvist@example.com,EMEA,27600.10
CSVEOF

cat > /opt/labdata/api-keys.txt <<'KEYEOF'
# Service credentials - MUST NOT be world readable
BILLING_API_KEY=sk_live_4f9a2c7e18b30d6519ae
REPORTING_API_KEY=sk_live_c03d81b5fa27e94610cd
KEYEOF

cat > /opt/labdata/backup.sh <<'SHEOF'
#!/bin/bash
# Nightly backup job executed by cron as root.
tar -czf /var/backups/labdata-$(date +%F).tar.gz /opt/labdata
SHEOF

# Deliberately wrong modes - these are the findings the learner remediates.
chown root:root /opt/labdata/customer-records.csv /opt/labdata/api-keys.txt /opt/labdata/backup.sh
chmod 0666 /opt/labdata/customer-records.csv
chmod 0644 /opt/labdata/api-keys.txt
chmod 0777 /opt/labdata/backup.sh
log "  customer-records.csv=0666  api-keys.txt=0644  backup.sh=0777"

# ---------------------------------------------------------------------
# 3) Unnecessary SUID root binary  -> Lab 2
#    A renamed copy of GNU find with the SUID bit set. Because find has
#    an -exec option, any user could obtain a root shell with it.
# ---------------------------------------------------------------------
log "seeding SUID root binary /opt/labdata/scanner (Lab 2)"
if [ -x /usr/bin/find ]; then
  cp -f /usr/bin/find /opt/labdata/scanner
  chown root:root /opt/labdata/scanner
  chmod 4755 /opt/labdata/scanner
  log "  scanner created from /usr/bin/find at mode 4755"
else
  log "  WARNING: /usr/bin/find not present - scanner NOT seeded, Lab 2 SUID step will fail"
fi

# ---------------------------------------------------------------------
# 4) Hidden second root account  -> Lab 3
#    UID 0 under a service-sounding name. Linux authorises on the UID,
#    not the name, so this account IS root. It is created with no usable
#    password (useradd defaults the hash to "!"), so it cannot actually
#    be logged into - the finding is the UID, not the credential.
#    Home is /nonexistent so that an accidental "userdel -r" is harmless.
# ---------------------------------------------------------------------
log "seeding hidden UID 0 account svc-backup (Lab 3)"
if id svc-backup >/dev/null 2>&1; then
  log "  svc-backup already exists - reusing"
else
  useradd -M -d /nonexistent -o -u 0 -g 0 -s /bin/bash \
          -c "Backup service account" svc-backup
  log "  svc-backup created with UID 0 and no usable password"
fi

# ---------------------------------------------------------------------
# 5) Persistence: a root cron job running a world-writable script -> Lab 3
#    Any user can rewrite the script; cron then executes it as root.
# ---------------------------------------------------------------------
log "seeding rogue cron persistence (Lab 3)"
cat > /usr/local/bin/health-check.sh <<'HCEOF'
#!/bin/bash
# Host health reporter - added by contractor, no change record.
echo "$(date -u) $(uptime)" >> /var/log/health-check.log
HCEOF
chown root:root /usr/local/bin/health-check.sh
chmod 0777 /usr/local/bin/health-check.sh

cat > /etc/cron.d/system-health <<'CRONEOF'
# Host health reporter - runs every 5 minutes as root.
*/5 * * * * root /usr/local/bin/health-check.sh
CRONEOF
chown root:root /etc/cron.d/system-health
chmod 0644 /etc/cron.d/system-health
log "  /etc/cron.d/system-health runs /usr/local/bin/health-check.sh (0777) as root"

# ---------------------------------------------------------------------
# 6) Auditing absent  -> Lab 3
#    Remove auditd if the image ships it, so the learner installs it.
# ---------------------------------------------------------------------
log "ensuring auditd is absent (Lab 3)"
apt-get purge -y auditd >/dev/null 2>&1 || true
log "  auditd purge attempted (a no-op on images that never had it)"

# ---------------------------------------------------------------------
# 7) Scenario brief handed to the learner
# ---------------------------------------------------------------------
log "writing scenario brief"
cat > "$LABFILES/scenario-brief.txt" <<EOF
Introduction to IT Security - Scenario Brief
Deployment ID : ${DEPLOYMENT_ID}
Host          : $(hostname)

You have inherited this Ubuntu server from a contractor who has left the
company. It has never been security reviewed. Known concerns:

  * Accounts were created ad hoc; at least one belongs to someone who no
    longer works here, and there is no password ageing policy.
  * /opt/labdata holds customer records and live API keys. Nobody has
    checked who can read them.
  * An unexplained SUID root binary sits in /opt/labdata.
  * The contractor left behind scheduled jobs and service accounts that
    nobody has reviewed or approved.
  * Nothing is auditing changes to the identity and privilege files.

Work through Labs 1-3 to bring the host to a defensible baseline.
EOF

chown -R azureuser:azureuser "$LABFILES" 2>/dev/null || true
chmod 0644 "$LABFILES/scenario-brief.txt" 2>/dev/null || true
log "  scenario brief written to $LABFILES/scenario-brief.txt"

# ---------------------------------------------------------------------
# SELF-CHECK - verify every seed actually landed.
# This is what makes the log worth reading: a clean run ends with
# "self-check PASSED", and any missing seed is named explicitly.
# ---------------------------------------------------------------------
log "===== self-check ====="
FAILED=0

chk() { # chk <description> <expected> <actual>
  if [ "$2" = "$3" ]; then
    log "  PASS  $1 [$3]"
  else
    log "  FAIL  $1 - expected [$2] got [$3]"
    FAILED=$((FAILED + 1))
  fi
}

chk "olduser exists"             "yes"     "$(id -u olduser >/dev/null 2>&1 && echo yes || echo no)"
chk "olduser password unlocked"  "P"       "$(passwd -S olduser 2>/dev/null | awk '{print $2}')"
chk "olduser has no expiry"      "never"   "$(chage -l olduser 2>/dev/null | awk -F': *' '/Account expires/{print $2}')"
chk "customer-records.csv mode"  "666"     "$(stat -c '%a' /opt/labdata/customer-records.csv 2>/dev/null)"
chk "api-keys.txt mode"          "644"     "$(stat -c '%a' /opt/labdata/api-keys.txt 2>/dev/null)"
chk "backup.sh mode"             "777"     "$(stat -c '%a' /opt/labdata/backup.sh 2>/dev/null)"
chk "scanner SUID mode"          "4755"    "$(stat -c '%a' /opt/labdata/scanner 2>/dev/null)"
chk "svc-backup has UID 0"       "0"       "$(id -u svc-backup 2>/dev/null)"
chk "two UID 0 accounts exist"   "2"       "$(awk -F: '$3 == 0 {c++} END {print c+0}' /etc/passwd)"
chk "rogue cron job present"     "yes"     "$([ -f /etc/cron.d/system-health ] && echo yes || echo no)"
chk "cron script world-writable" "777"     "$(stat -c '%a' /usr/local/bin/health-check.sh 2>/dev/null)"
chk "secops group not yet made"  "absent"  "$(getent group secops >/dev/null 2>&1 && echo present || echo absent)"
chk "auditd not yet installed"   "absent"  "$(command -v auditctl >/dev/null 2>&1 && echo present || echo absent)"
chk "scenario brief readable"    "yes"     "$([ -s "$LABFILES/scenario-brief.txt" ] && echo yes || echo no)"

if [ "$FAILED" -eq 0 ]; then
  log "self-check PASSED - all seeds in place"
else
  log "self-check FAILED - $FAILED seed(s) incorrect, lab will not work as written"
fi

log "===== complete ====="
