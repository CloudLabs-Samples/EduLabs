# Lab 4: Knowledge Check

**Lab Description:** You have worked through the three guarantees cryptography provides — integrity, confidentiality, and authenticity — and hit the real limits of each along the way. This final page checks that you understood **why** each mechanism exists, not just which command produced it. Every question refers directly to work you performed on your own lab server.

**Estimated Duration:** **10 Minutes**

**Learning Objectives:** By the end of this knowledge check, you will have confirmed that you can:

- Explain what a digital signature proves that a published checksum cannot

- Justify the hybrid encryption design in terms of RSA's size limit and its performance cost

- Recall how `sha256sum -c` reports a file whose hash does not match

- Explain why a self-signed certificate can be cryptographically valid and still untrusted

- Name the value that makes two identical passwords produce different stored hashes

## Before you begin

> **Note:** Each question allows **one retry**. If you are unsure of an answer, the relevant lab page is still available — click **<< Previous** to review it before answering.

## Questions

<question source="Question1.md" />

<br>

<question source="Question2.md" />

<br>

<question source="Question3.md" />

<br>

<question source="Question4.md" />

<br>

<question source="Question5.md" />

<br>

---

## What you built in this lab

| Lab | Guarantee | What you established |
|-----|-----------|----------------------|
| Lab 1 | Integrity and confidentiality | A forged invoice identified against a published SHA-256 manifest, salting demonstrated on password hashes, and a payroll extract encrypted with AES-256 and PBKDF2 |
| Lab 2 | Confidentiality without a shared secret | A 2048-bit RSA key pair, the `data too large for key size` limit met first-hand, and a hybrid scheme wrapping a random AES session key with RSA |
| Lab 3 | Authenticity | A signed release approval, a forged copy that fails verification, and a self-signed X.509 certificate that is valid but untrusted |

> **Note:** Each lab in this sequence existed because the previous one left a gap. Hashing proved a file had changed but not who changed it. Symmetric encryption protected the data but required a shared key you had no safe way to deliver. Public-key cryptography delivered the key but could not carry the payload, and proved nothing about origin. Signatures closed the origin gap, and certificates exposed the last one: a key is only as trustworthy as your reason for believing whose it is. That final problem is not solved by mathematics at all — it is solved by certificate authorities, key pinning, and out-of-band verification, which is why PKI is mostly an operational discipline rather than a cryptographic one.

### Where to go next

- Prefer **authenticated encryption** over the CBC mode used here. AES-GCM and ChaCha20-Poly1305 detect tampering cryptographically instead of inferring failure from a padding error, as you saw in Lab 1.
- Look at **elliptic curve** cryptography. An ECDSA key at 256 bits gives security comparable to RSA at 3072 bits, with much smaller signatures — try `openssl ecparam -genkey -name prime256v1`.
- Explore a real certificate chain with `openssl s_client -connect <host>:443 -showcerts` and follow it from the leaf certificate up to the root in your system trust store.
- Read about **certificate transparency**, the public append-only logs that make mis-issued certificates detectable, and the reason a rogue CA can no longer sign for a domain unnoticed.
- Try **key management** rather than key generation: rotating keys, protecting them in a hardware security module or a cloud key vault, and revoking a certificate once its key is compromised. In practice this is where most cryptographic failures actually happen — not in the algorithms, but in how the keys are stored and retired.

### Congratulations! You have successfully completed the IT Security Fundamentals: Cryptography lab.

### Please click End Lab to complete the lab.
