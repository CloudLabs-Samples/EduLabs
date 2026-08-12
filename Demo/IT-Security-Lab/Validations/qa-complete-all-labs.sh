#!/bin/bash
# =====================================================================
# QA / FACILITATOR TOOL - NOT learner content, do not ship in the guide.
#
# Performs every remediation the three lab guides instruct, so that the
# CloudLabs validators can be tested end to end without manually walking
# all ~50 steps. Run it on a freshly bootstrapped lab VM:
#
#   sudo bash qa-complete-all-labs.sh
#
# Then hit Validate on all three tasks - every one should report Success.
#
# To test the FAILURE path instead, redeploy (or run with --partial) so
# that only Lab 1 is completed; Labs 2 and 3 should then report Failed.
#
# Commands below are copied verbatim from the lab guides. If a guide step
# changes, change it here too or this script stops being a valid test.
# =====================================================================
set -uo pipefail

PARTIAL=0
[ "${1:-}" = "--partial" ] && PARTIAL=1

log() { echo "[qa] $(date -u '+%H:%M:%S') $*"; }

if [ "$(id -u)" -ne 0 ]; then
  echo "[qa] ERROR: run this with sudo" >&2
  exit 1
fi

# ---------------------------------------------------------------------
# LAB 1 - Users, Groups, and Least Privilege
# ---------------------------------------------------------------------
log "===== Lab 1: users, groups, least privilege ====="

getent group secops >/dev/null 2>&1 || groupadd secops
id analyst1 >/dev/null 2>&1 || useradd -m -s /bin/bash -c "Security Analyst 1" analyst1
id analyst2 >/dev/null 2>&1 || useradd -m -s /bin/bash -c "Security Analyst 2" analyst2
echo 'analyst1:Analyst@Lab#2024' | chpasswd
echo 'analyst2:Analyst@Lab#2024' | chpasswd
usermod -aG secops analyst1
usermod -aG secops analyst2
log "  secops group + analyst1/analyst2 created and enrolled"

chage -M 90 -m 1 -W 7 analyst1
chage -M 90 -m 1 -W 7 analyst2
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t90/' /etc/login.defs
log "  90-day password ageing applied"

usermod -L olduser
chage -E 0 olduser
usermod -s /usr/sbin/nologin olduser
log "  olduser locked, expired and shell removed"

tee /etc/sudoers.d/secops > /dev/null <<'EOF'
# Least-privilege administration for the secops group.
# Members may inspect services and read logs, and nothing more.
%secops ALL=(root) /usr/bin/systemctl status *, /usr/bin/journalctl *
EOF
chmod 0440 /etc/sudoers.d/secops
if visudo -c >/dev/null 2>&1; then
  log "  sudoers drop-in written at 0440 and parses OK"
else
  log "  ERROR: sudoers drop-in FAILED to parse - removing it to protect sudo"
  rm -f /etc/sudoers.d/secops
fi

if [ "$PARTIAL" -eq 1 ]; then
  log "--partial requested: stopping after Lab 1"
  log "Expect: task 1 Success, tasks 2 and 3 Failed"
  exit 0
fi

# ---------------------------------------------------------------------
# LAB 2 - File Permissions and Sensitive Data
# ---------------------------------------------------------------------
log "===== Lab 2: file permissions and sensitive data ====="

chown root:secops /opt/labdata/customer-records.csv
chmod 0640 /opt/labdata/customer-records.csv
chmod 0600 /opt/labdata/api-keys.txt
chmod 0750 /opt/labdata/backup.sh
log "  customer-records=0640 root:secops  api-keys=0600  backup.sh=0750"

echo 'umask 027' > /etc/profile.d/99-secure-umask.sh
sed -i 's/^UMASK.*/UMASK\t\t027/' /etc/login.defs
log "  umask 027 set in /etc/profile.d and /etc/login.defs"

chmod u-s /opt/labdata/scanner
log "  SUID bit cleared from /opt/labdata/scanner"

# ---------------------------------------------------------------------
# LAB 3 - Auditing and Detecting Unauthorised Changes
# ---------------------------------------------------------------------
log "===== Lab 3: detection and auditing ====="

if id svc-backup >/dev/null 2>&1; then
  # -f is required: userdel attributes running processes by UID, and because
  # svc-backup shares UID 0 with root, PID 1 looks like it belongs to this
  # account. Note that -f still PRINTS "currently used by process 1" - it
  # just downgrades it from a fatal error to a warning and deletes anyway,
  # which is why the removal is confirmed with id() below rather than by
  # trusting the exit status or the absence of output.
  userdel -f svc-backup
  if id svc-backup >/dev/null 2>&1; then
    log "  ERROR: svc-backup STILL PRESENT after userdel -f"
  else
    log "  svc-backup (UID 0) removed"
  fi
else
  log "  svc-backup already absent"
fi

rm -f /etc/cron.d/system-health /usr/local/bin/health-check.sh
log "  rogue cron job and world-writable script removed"

export DEBIAN_FRONTEND=noninteractive
if apt-get install -y auditd >/dev/null 2>&1; then
  log "  auditd installed"
else
  log "  ERROR: auditd install failed - check network/apt index"
fi

tee /etc/audit/rules.d/99-identity.rules > /dev/null <<'EOF'
## Watch the files that define WHO can log in.
-w /etc/passwd  -p wa -k identity
-w /etc/shadow  -p wa -k identity
-w /etc/group   -p wa -k identity

## Watch the files that define WHAT users are allowed to do.
-w /etc/sudoers   -p wa -k privilege
-w /etc/sudoers.d -p wa -k privilege

## Watch where the rogue job was planted.
-w /etc/cron.d -p wa -k persistence
EOF
augenrules --load >/dev/null 2>&1
log "  audit rules written and loaded"

# The guide creates and then deletes a test account. Do the same so the
# end state matches: exactly one UID 0 account, no leftover audittest.
useradd -m -s /bin/bash audittest >/dev/null 2>&1 || true
sleep 1
userdel -r audittest >/dev/null 2>&1 || true
log "  audit rule exercised with a temporary account, then cleaned up"

# ---------------------------------------------------------------------
# PRE-FLIGHT - mirror what the three validators assert
# ---------------------------------------------------------------------
log "===== pre-flight (mirrors the validator checks) ====="
FAILED=0
chk() {
  if [ "$2" = "$3" ]; then
    log "  PASS  $1 [$3]"
  else
    log "  FAIL  $1 - expected [$2] got [$3]"
    FAILED=$((FAILED + 1))
  fi
}

# Task 1
chk "secops has analyst1"       "yes"    "$(id -nG analyst1 2>/dev/null | tr ' ' '\n' | grep -qx secops && echo yes || echo no)"
chk "secops has analyst2"       "yes"    "$(id -nG analyst2 2>/dev/null | tr ' ' '\n' | grep -qx secops && echo yes || echo no)"
chk "analyst1 max age"          "90"     "$(chage -l analyst1 2>/dev/null | awk -F': *' '/Maximum number/{print $2}')"
chk "olduser locked"            "L"      "$(passwd -S olduser 2>/dev/null | awk '{print $2}')"
chk "olduser expired"           "yes"    "$(exp=$(chage -l olduser 2>/dev/null | awk -F': *' '/Account expires/{print $2}'); [ -n "$exp" ] && [ "$exp" != "never" ] && echo yes || echo no)"
chk "sudoers mode"              "440"    "$(stat -c '%a' /etc/sudoers.d/secops 2>/dev/null)"
chk "sudoers parses"            "yes"    "$(visudo -c >/dev/null 2>&1 && echo yes || echo no)"

# Task 2
chk "customer-records mode"     "640"    "$(stat -c '%a' /opt/labdata/customer-records.csv 2>/dev/null)"
chk "customer-records group"    "secops" "$(stat -c '%G' /opt/labdata/customer-records.csv 2>/dev/null)"
chk "api-keys mode"             "600"    "$(stat -c '%a' /opt/labdata/api-keys.txt 2>/dev/null)"
chk "backup.sh mode"            "750"    "$(stat -c '%a' /opt/labdata/backup.sh 2>/dev/null)"
chk "umask in profile.d"        "yes"    "$(grep -rhqE '^\s*umask\s+0?027\s*$' /etc/profile.d/ 2>/dev/null && echo yes || echo no)"
chk "umask in login.defs"       "yes"    "$(grep -qE '^\s*UMASK\s+0?027\s*$' /etc/login.defs 2>/dev/null && echo yes || echo no)"
chk "scanner SUID cleared"      "yes"    "$([ -e /opt/labdata/scanner ] && { [ ! -u /opt/labdata/scanner ] && echo yes || echo no; } || echo yes)"

# Task 3
chk "only one UID 0 account"    "1"      "$(awk -F: '$3 == 0 {c++} END {print c+0}' /etc/passwd)"
chk "svc-backup gone"           "yes"    "$(id svc-backup >/dev/null 2>&1 && echo no || echo yes)"
chk "rogue cron gone"           "yes"    "$([ -f /etc/cron.d/system-health ] && echo no || echo yes)"
chk "cron script gone"          "yes"    "$([ -e /usr/local/bin/health-check.sh ] && echo no || echo yes)"
chk "auditd active"             "yes"    "$(systemctl is-active auditd >/dev/null 2>&1 && echo yes || echo no)"
chk "auditd enabled"            "yes"    "$(systemctl is-enabled auditd >/dev/null 2>&1 && echo yes || echo no)"
chk "passwd watch loaded"       "yes"    "$(auditctl -l 2>/dev/null | grep -qE '^-w /etc/passwd .*-k identity' && echo yes || echo no)"
chk "rules persistent"          "yes"    "$(grep -rqE '^\s*-w\s+/etc/passwd\s+-p\s+wa\s+-k\s+identity' /etc/audit/rules.d/ 2>/dev/null && echo yes || echo no)"

echo
if [ "$FAILED" -eq 0 ]; then
  log "PRE-FLIGHT PASSED - all three CloudLabs validators should now report Success"
else
  log "PRE-FLIGHT FAILED - $FAILED check(s) short; validators would report Failed"
fi
