#!/usr/bin/env bash
# CloudLabs POC - "RSA Public-Key Encryption & Digital Signatures" lab
# Provisioning script: run once on a fresh Linux VM (Ubuntu 20.04/22.04/24.04, any size >= 1 vCPU / 1GB RAM).
# No package installs required -- openssl ships with the base OS image on every mainstream distro.
set -euo pipefail

LAB_DIR="$HOME/rsa-lab"
STUDENT_MSG="This message proves the CloudLabs RSA lab environment is ready."

echo "== CloudLabs RSA Lab: environment setup =="

if ! command -v openssl >/dev/null 2>&1; then
  echo "openssl not found -- installing (this should not normally be needed)..."
  sudo apt-get update -y && sudo apt-get install -y openssl
fi
echo "openssl version: $(openssl version)"

mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Seed the starting message the student will encrypt/sign.
echo "$STUDENT_MSG" > message.txt

# Store a hash of the pristine message so validate.py can tell "tampered" from "original"
# even after the student intentionally edits message.txt in Task 4.
sha256sum message.txt | awk '{print $1}' > .original_message.sha256

cat > README.txt << 'EOF'
CloudLabs RSA Lab - working directory
--------------------------------------
message.txt   Starting plaintext (Task 4 asks you to edit this file -- that's expected).
Everything else (keys, ciphertext, signature) is created by you during the lab.

Run ~/rsa-lab/../validate.py (or `python3 validate.py` from this directory)
at any time to self-check your progress.
EOF

chmod 600 message.txt .original_message.sha256
echo "Lab directory ready at: $LAB_DIR"
echo "Next: open the Lab Guide and start Task 1."