#!/bin/bash
# =====================================================================
# QA / FACILITATOR TOOL - NOT learner content, do not ship in the guide.
#
# Performs every command the three lab guides instruct, so that the
# CloudLabs validators can be tested end to end without manually walking
# all ~45 steps. Run it on a freshly bootstrapped lab VM AS THE LEARNER
# ACCOUNT - not with sudo, because every file in this lab is owned by the
# learner and root-owned artefacts would not match a real run:
#
#   bash qa-complete-all-labs.sh
#
# Then hit Validate on all three tasks - every one should report Success.
#
# To test the FAILURE path instead, redeploy (or run with --partial) so
# that only Lab 1 is completed; Labs 2 and 3 should then report Failed.
#
# Commands below are copied verbatim from the lab guides. If a guide step
# changes, change it here too or this script stops being a valid test.
#
# LAB_DIR can be overridden to rehearse the logic outside a lab VM.
# =====================================================================
set -uo pipefail

LAB_DIR="${LAB_DIR:-$HOME/crypto-lab}"
LAB_PASS="Payroll-Key-2026"
EXPECTED_CN="payments.northwind.example"

PARTIAL=0
[ "${1:-}" = "--partial" ] && PARTIAL=1

log() { echo "[qa] $(date -u '+%H:%M:%S') $*"; }

if [ "$(id -u)" -eq 0 ]; then
  echo "[qa] ERROR: do NOT run this with sudo. The lab is performed as the" >&2
  echo "[qa]        learner account, and root-owned files would not match" >&2
  echo "[qa]        a real learner run." >&2
  exit 1
fi

if ! cd "$LAB_DIR" 2>/dev/null; then
  echo "[qa] ERROR: $LAB_DIR not found - did the bootstrap run?" >&2
  exit 1
fi
log "working in $LAB_DIR as $(id -un)"

# ---------------------------------------------------------------------
# LAB 1 - Hashing, Integrity, and Symmetric Encryption
# ---------------------------------------------------------------------
log "===== Lab 1: hashing, integrity, symmetric encryption ====="

sha256sum -c invoice.sha256 2>&1 | tee integrity-report.txt >/dev/null
if grep -Fqx 'invoice-resent.txt: FAILED' integrity-report.txt; then
  log "  integrity-report.txt records the forgery as FAILED"
else
  log "  ERROR: integrity-report.txt did not record a FAILED verdict"
fi

openssl enc -aes-256-cbc -pbkdf2 -salt -in payroll.csv -out payroll.csv.enc \
            -pass pass:"$LAB_PASS" 2>/dev/null
openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.csv.enc \
            -out payroll-decrypted.csv -pass pass:"$LAB_PASS" 2>/dev/null
if cmp -s payroll.csv payroll-decrypted.csv; then
  log "  payroll.csv encrypted with AES-256 and decrypted back identically"
else
  log "  ERROR: AES round trip did not reproduce payroll.csv"
fi

if [ "$PARTIAL" -eq 1 ]; then
  log "--partial requested: stopping after Lab 1"
  log "Expect: task 1 Success, tasks 2 and 3 Failed"
  exit 0
fi

# ---------------------------------------------------------------------
# LAB 2 - Public-Key Cryptography
# ---------------------------------------------------------------------
log "===== Lab 2: RSA and hybrid encryption ====="

# genpkey is run ONCE. Running it again would leave public_key.pem tied to
# a superseded private key, which is exactly the mistake the validator's
# modulus comparison is designed to catch.
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 \
                -out private_key.pem 2>/dev/null
openssl rsa -pubout -in private_key.pem -out public_key.pem 2>/dev/null
log "  2048-bit RSA key pair generated"

openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in message.txt \
                -out message.enc 2>/dev/null
openssl pkeyutl -decrypt -inkey private_key.pem -in message.enc \
                -out message-decrypted.txt 2>/dev/null
if cmp -s message.txt message-decrypted.txt; then
  log "  message.txt encrypted with the public key and recovered with the private key"
else
  log "  ERROR: RSA round trip did not reproduce message.txt"
fi

# The guide has the learner attempt this and see it fail. Reproduce the
# attempt so the QA run exercises the same path, and confirm it DOES fail -
# if it ever succeeds, payroll.csv has shrunk below the 245-byte RSA limit
# and Lab 2's central teaching step has silently stopped working.
if openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in payroll.csv \
                   -out /dev/null 2>/dev/null; then
  log "  ERROR: RSA encrypted payroll.csv - it is under the 245-byte limit,"
  log "         so the 'data too large for key size' step no longer fails"
else
  log "  confirmed RSA rejects payroll.csv as too large (expected)"
fi

openssl rand -base64 32 > aes.key
openssl enc -aes-256-cbc -pbkdf2 -salt -in payroll.csv \
            -out payroll.hybrid.enc -pass file:aes.key 2>/dev/null
openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in aes.key \
                -out aes.key.enc 2>/dev/null
openssl pkeyutl -decrypt -inkey private_key.pem -in aes.key.enc \
                -out aes.key.recovered 2>/dev/null
openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.hybrid.enc \
            -out payroll-hybrid.csv -pass file:aes.key.recovered 2>/dev/null
if cmp -s payroll.csv payroll-hybrid.csv; then
  log "  hybrid scheme recovered payroll.csv through the RSA-wrapped AES key"
else
  log "  ERROR: hybrid round trip did not reproduce payroll.csv"
fi

# ---------------------------------------------------------------------
# LAB 3 - Digital Signatures and Certificates
# ---------------------------------------------------------------------
log "===== Lab 3: signatures and certificates ====="

openssl dgst -sha256 -sign private_key.pem -out message.sig message.txt 2>/dev/null
if openssl dgst -sha256 -verify public_key.pem -signature message.sig \
                message.txt >/dev/null 2>&1; then
  log "  message.txt signed and the signature verifies"
else
  log "  ERROR: signature does not verify against message.txt"
fi

# Tamper with a COPY. message.txt and its signature stay valid, which is
# what lets both the positive and negative checks pass in the same run.
sed 's/CHG-10428/CHG-99999/' message.txt > forged-message.txt
if cmp -s message.txt forged-message.txt; then
  log "  ERROR: forged-message.txt is identical to message.txt - the sed"
  log "         pattern did not match, so the negative test is meaningless"
elif openssl dgst -sha256 -verify public_key.pem -signature message.sig \
                  forged-message.txt >/dev/null 2>&1; then
  log "  ERROR: the signature verified against the FORGED file"
else
  log "  forged-message.txt created and correctly fails verification"
fi

openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes \
  -keyout server.key -out server.crt \
  -subj "/C=DE/O=Northwind Components Ltd/CN=${EXPECTED_CN}" 2>/dev/null
if [ -f server.crt ] && [ -f server.key ]; then
  log "  self-signed certificate issued for ${EXPECTED_CN}"
else
  log "  ERROR: certificate generation failed"
fi

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
# The manifest hash is compared directly rather than by piping "sha256sum -c"
# into grep: that command exits non-zero here by design, because the forged
# invoice is SUPPOSED to fail, and "set -o pipefail" would then sink the
# pipeline no matter what grep matched. The validator does the same.
MANIFEST_HASH=$(awk '$2 == "invoice.txt" {print $1}' invoice.sha256 2>/dev/null)
GENUINE_ACTUAL=$(sha256sum invoice.txt 2>/dev/null | awk '{print $1}')
FORGED_ACTUAL=$(sha256sum invoice-resent.txt 2>/dev/null | awk '{print $1}')
chk "manifest matches genuine"  "yes" "$([ -n "$MANIFEST_HASH" ] && [ "$MANIFEST_HASH" = "$GENUINE_ACTUAL" ] && echo yes || echo no)"
chk "manifest rejects forgery"  "yes" "$([ -n "$MANIFEST_HASH" ] && [ -n "$FORGED_ACTUAL" ] && [ "$MANIFEST_HASH" != "$FORGED_ACTUAL" ] && echo yes || echo no)"
chk "report records OK"         "yes" "$(grep -Fqx 'invoice.txt: OK' integrity-report.txt 2>/dev/null && echo yes || echo no)"
chk "report records FAILED"     "yes" "$(grep -Fqx 'invoice-resent.txt: FAILED' integrity-report.txt 2>/dev/null && echo yes || echo no)"
chk "payroll.csv.enc opaque"    "yes" "$(grep -q 'employee_id' payroll.csv.enc 2>/dev/null && echo no || echo yes)"
chk "AES decrypts to original"  "yes" "$(t=$(mktemp); openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.csv.enc -out "$t" -pass pass:"$LAB_PASS" 2>/dev/null && cmp -s "$t" payroll.csv && echo yes || echo no; rm -f "$t")"
chk "decrypt round trip file"   "yes" "$(cmp -s payroll-decrypted.csv payroll.csv 2>/dev/null && echo yes || echo no)"

# Task 2
chk "keypair modulus matches"   "yes" "$(a=$(openssl rsa -in private_key.pem -noout -modulus 2>/dev/null); b=$(openssl rsa -pubin -in public_key.pem -noout -modulus 2>/dev/null); [ -n "$a" ] && [ "$a" = "$b" ] && echo yes || echo no)"
chk "key is >= 2048 bits"       "yes" "$(n=$(openssl rsa -in private_key.pem -noout -text 2>/dev/null | sed -n 's/.*Private-Key: (\([0-9]*\) bit.*/\1/p' | tr -cd '0-9'); [ -n "$n" ] && [ "$n" -ge 2048 ] && echo yes || echo no)"
chk "RSA decrypts to message"   "yes" "$(t=$(mktemp); openssl pkeyutl -decrypt -inkey private_key.pem -in message.enc -out "$t" 2>/dev/null && cmp -s "$t" message.txt && echo yes || echo no; rm -f "$t")"
chk "hybrid chain recovers csv"  "yes" "$(k=$(mktemp); p=$(mktemp); openssl pkeyutl -decrypt -inkey private_key.pem -in aes.key.enc -out "$k" 2>/dev/null && [ -s "$k" ] && openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.hybrid.enc -out "$p" -pass file:"$k" 2>/dev/null && cmp -s "$p" payroll.csv && echo yes || echo no; rm -f "$k" "$p")"

# Task 3
chk "signature verifies"        "yes" "$(openssl dgst -sha256 -verify public_key.pem -signature message.sig message.txt >/dev/null 2>&1 && echo yes || echo no)"
chk "forgery differs"           "yes" "$(cmp -s forged-message.txt message.txt 2>/dev/null && echo no || echo yes)"
chk "forgery is rejected"       "yes" "$(openssl dgst -sha256 -verify public_key.pem -signature message.sig forged-message.txt >/dev/null 2>&1 && echo no || echo yes)"
chk "cert is self-signed"       "yes" "$(s=$(openssl x509 -in server.crt -noout -subject 2>/dev/null | sed 's/^subject=//' | tr -d ' '); i=$(openssl x509 -in server.crt -noout -issuer 2>/dev/null | sed 's/^issuer=//' | tr -d ' '); [ -n "$s" ] && [ "$s" = "$i" ] && echo yes || echo no)"
chk "cert carries expected CN"  "yes" "$(openssl x509 -in server.crt -noout -subject 2>/dev/null | grep -Fq "$EXPECTED_CN" && echo yes || echo no)"
chk "cert matches server.key"   "yes" "$(a=$(openssl x509 -in server.crt -noout -modulus 2>/dev/null); b=$(openssl rsa -in server.key -noout -modulus 2>/dev/null); [ -n "$a" ] && [ "$a" = "$b" ] && echo yes || echo no)"

echo
if [ "$FAILED" -eq 0 ]; then
  log "PRE-FLIGHT PASSED - all three CloudLabs validators should now report Success"
else
  log "PRE-FLIGHT FAILED - $FAILED check(s) short; validators would report Failed"
fi
