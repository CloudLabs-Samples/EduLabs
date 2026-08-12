#!/bin/bash
# =====================================================================
# CloudLabs CSE bootstrap - IT Security Fundamentals: Cryptography
#
# Seeds the working files the learner operates on. Every seed below maps
# to a step in the lab guide - nothing is seeded that the labs do not use:
#
#   Seed                                    Used in
#   -------------------------------------   ----------------------------
#   invoice.txt (genuine supplier invoice)   Lab 1 (integrity)
#   invoice-resent.txt (forged IBAN)         Lab 1 (tamper detection)
#   invoice.sha256 (published manifest)      Lab 1 (sha256sum -c)
#   payroll.csv (407 bytes of sensitive data) Lab 1 (AES), Lab 2 (hybrid)
#   message.txt (release approval)           Lab 2 (RSA), Lab 3 (signing)
#
# The learner generates every key, ciphertext, signature and certificate
# themselves - this script deliberately creates NO cryptographic material,
# because producing it is the entire point of the lab.
#
# payroll.csv is intentionally larger than 245 bytes. That is the maximum
# a 2048-bit RSA key can encrypt with PKCS#1 v1.5 padding, so Lab 2's
# "RSA cannot encrypt bulk data" step fails for real rather than being
# asserted. Do not shrink this file.
#
# NOTE: this script does not touch sshd_config, the firewall, or any
# account. The labs run entirely inside the learner's own home directory
# and never require sudo, so there is no way for a learner to lose access
# to the VM.
#
# The script logs every step and finishes with a SELF-CHECK block that
# verifies each seed actually landed. Read the result with:
#   sudo cat /var/log/cloudlabs-bootstrap.log
#
# Invoked by the ARM CustomScript extension:
#   bash bootstrap-01.sh -d <DeploymentID> -u <trainerUser> -p <trainerPass>
# Idempotent: safe to re-run.
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

LAB_USER="azureuser"
LAB_DIR="/home/${LAB_USER}/crypto-lab"
LABFILES="/home/${LAB_USER}/LabFiles"

# ---------------------------------------------------------------------
# 0) OpenSSL must be present. It ships with Ubuntu Server, so this is a
#    safety net rather than an expected code path.
# ---------------------------------------------------------------------
if command -v openssl >/dev/null 2>&1; then
  log "openssl present: $(openssl version)"
else
  log "WARNING: openssl not found - installing"
  apt-get update -y >/dev/null 2>&1
  if apt-get install -y openssl >/dev/null 2>&1; then
    log "  openssl installed: $(openssl version)"
  else
    log "  ERROR: openssl install FAILED - the entire lab will not work"
  fi
fi

mkdir -p "$LAB_DIR" "$LABFILES"
log "created $LAB_DIR and $LABFILES"

# ---------------------------------------------------------------------
# 1) The genuine supplier invoice  -> Lab 1
# ---------------------------------------------------------------------
log "seeding invoice.txt (Lab 1)"
cat > "$LAB_DIR/invoice.txt" <<'INVEOF'
INVOICE 2026-0417
Vendor        : Northwind Components Ltd
Amount Due    : 48,250.00 EUR
Payment Terms : Net 30
Bank          : Handelsbank AG
IBAN          : DE44 5001 0517 5407 3249 31
Reference     : PO-88213
INVEOF

# ---------------------------------------------------------------------
# 2) The forged copy  -> Lab 1
#    Byte-for-byte identical to the genuine invoice EXCEPT the IBAN, so
#    that "diff" points straight at the fraud. This is a payment-redirect
#    attack, which is the most common invoice fraud in the real world.
# ---------------------------------------------------------------------
log "seeding invoice-resent.txt with a substituted IBAN (Lab 1)"
sed 's/DE44 5001 0517 5407 3249 31/DE89 3704 0044 0532 0130 00/' \
    "$LAB_DIR/invoice.txt" > "$LAB_DIR/invoice-resent.txt"

# ---------------------------------------------------------------------
# 3) The checksum manifest the vendor published  -> Lab 1
#    BOTH lines carry the hash of the GENUINE invoice, because that is
#    what the vendor published. The learner has two files claiming to be
#    that invoice; "sha256sum -c" says which one actually is.
# ---------------------------------------------------------------------
log "seeding invoice.sha256 published manifest (Lab 1)"
GENUINE_HASH=$(sha256sum "$LAB_DIR/invoice.txt" | awk '{print $1}')
printf '%s  invoice.txt\n%s  invoice-resent.txt\n' \
       "$GENUINE_HASH" "$GENUINE_HASH" > "$LAB_DIR/invoice.sha256"
log "  published hash = ${GENUINE_HASH}"

# ---------------------------------------------------------------------
# 4) Sensitive bulk data  -> Lab 1 (AES) and Lab 2 (hybrid encryption)
#    MUST stay above 245 bytes - see the header note.
# ---------------------------------------------------------------------
log "seeding payroll.csv (Lab 1 and Lab 2)"
cat > "$LAB_DIR/payroll.csv" <<'CSVEOF'
employee_id,full_name,department,annual_salary
2001,Amara Okafor,Engineering,92000
2002,Diego Marchetti,Finance,78500
2003,Priya Raghunathan,Engineering,105000
2004,Kwame Boateng,Operations,64000
2005,Sofia Lindqvist,Legal,88750
2006,Hiroshi Tanaka,Engineering,98500
2007,Fatima Al-Rashid,Finance,81200
2008,Lucas Oliveira,Operations,59900
2009,Ingrid Johansson,Legal,93400
2010,Chen Wei,Engineering,101750
CSVEOF

# ---------------------------------------------------------------------
# 5) The statement the learner encrypts and later signs  -> Labs 2 and 3
#    Comfortably under 245 bytes so RSA CAN encrypt it directly, which is
#    the contrast that makes payroll.csv's failure meaningful.
# ---------------------------------------------------------------------
log "seeding message.txt (Lab 2 and Lab 3)"
cat > "$LAB_DIR/message.txt" <<'MSGEOF'
Release 4.2.0 of the Northwind payment gateway is approved for production.
Approved by: Security Engineering
Change reference: CHG-10428
MSGEOF

# ---------------------------------------------------------------------
# 6) Scenario brief handed to the learner
# ---------------------------------------------------------------------
log "writing scenario brief"
cat > "$LABFILES/scenario-brief.txt" <<EOF
IT Security Fundamentals: Cryptography - Scenario Brief
Deployment ID : ${DEPLOYMENT_ID}
Host          : $(hostname)

You are the security engineer at Northwind Components. Four things are
on your desk this morning:

  1. Accounts Payable received an invoice by email, then received a
     second copy of "the same" invoice from a different address. One of
     them is a forgery with a substituted bank account. The vendor
     publishes a checksum for every invoice they send.

  2. A payroll extract is sitting unencrypted in your working directory
     and has to be protected before it is archived.

  3. A partner needs to send you confidential files, but you have no
     safe way to agree a shared password with them first.

  4. A release approval has to be published in a way that anyone can
     confirm came from you and has not been altered in transit.

Everything you need is in ~/crypto-lab. Work through Labs 1-3.
EOF

# ---------------------------------------------------------------------
# 7) Hand the whole working directory to the learner.
#    Nothing here needs root, which is why no lab step uses sudo.
# ---------------------------------------------------------------------
chown -R "${LAB_USER}:${LAB_USER}" "$LAB_DIR" "$LABFILES" 2>/dev/null || true
chmod 0755 "$LAB_DIR"
chmod 0644 "$LAB_DIR"/* "$LABFILES/scenario-brief.txt" 2>/dev/null || true
log "  $LAB_DIR handed to ${LAB_USER}"

# ---------------------------------------------------------------------
# SELF-CHECK - verify every seed actually landed.
# A clean run ends with "self-check PASSED"; any missing seed is named.
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

chk "openssl available"          "yes"  "$(command -v openssl >/dev/null 2>&1 && echo yes || echo no)"
chk "lab dir owned by learner"   "$LAB_USER" "$(stat -c '%U' "$LAB_DIR" 2>/dev/null)"
chk "invoice.txt present"        "yes"  "$([ -s "$LAB_DIR/invoice.txt" ] && echo yes || echo no)"
chk "invoice-resent.txt present" "yes"  "$([ -s "$LAB_DIR/invoice-resent.txt" ] && echo yes || echo no)"
chk "the two invoices differ"    "yes"  "$(cmp -s "$LAB_DIR/invoice.txt" "$LAB_DIR/invoice-resent.txt" && echo no || echo yes)"
chk "manifest has 2 entries"     "2"    "$(wc -l < "$LAB_DIR/invoice.sha256" 2>/dev/null | tr -d ' ')"
# The published hash is compared directly rather than by piping
# "sha256sum -c" into grep. "sha256sum -c" exits non-zero here by design,
# because invoice-resent.txt is SUPPOSED to fail, and under the
# "set -o pipefail" in force at the top of this script that non-zero status
# sinks the entire pipeline no matter what grep matched.
MANIFEST_HASH=$(awk '$2 == "invoice.txt" {print $1}' "$LAB_DIR/invoice.sha256" 2>/dev/null)
GENUINE_ACTUAL=$(sha256sum "$LAB_DIR/invoice.txt" 2>/dev/null | awk '{print $1}')
FORGED_ACTUAL=$(sha256sum "$LAB_DIR/invoice-resent.txt" 2>/dev/null | awk '{print $1}')
chk "manifest matches genuine"   "yes"  "$([ -n "$MANIFEST_HASH" ] && [ "$MANIFEST_HASH" = "$GENUINE_ACTUAL" ] && echo yes || echo no)"
chk "manifest rejects forgery"   "yes"  "$([ -n "$MANIFEST_HASH" ] && [ -n "$FORGED_ACTUAL" ] && [ "$MANIFEST_HASH" != "$FORGED_ACTUAL" ] && echo yes || echo no)"
chk "payroll.csv over 245 bytes" "yes"  "$([ "$(wc -c < "$LAB_DIR/payroll.csv" 2>/dev/null)" -gt 245 ] && echo yes || echo no)"
chk "message.txt under 245 bytes" "yes" "$([ "$(wc -c < "$LAB_DIR/message.txt" 2>/dev/null)" -lt 245 ] && echo yes || echo no)"
chk "no keys pre-created"        "0"    "$(ls "$LAB_DIR"/*.pem 2>/dev/null | wc -l | tr -d ' ')"
chk "scenario brief readable"    "yes"  "$([ -s "$LABFILES/scenario-brief.txt" ] && echo yes || echo no)"

if [ "$FAILED" -eq 0 ]; then
  log "self-check PASSED - all seeds in place"
else
  log "self-check FAILED - $FAILED seed(s) incorrect, lab will not work as written"
fi

log "===== complete ====="
