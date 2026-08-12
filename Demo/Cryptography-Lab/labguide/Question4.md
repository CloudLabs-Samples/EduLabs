## Metadata
Question Type : Single Choice

## Question
4. In Lab 3 the command `openssl verify server.crt` reported `error 18 at 0 depth lookup: self-signed certificate`, but `openssl verify -CAfile server.crt server.crt` reported `OK` for the very same file. What changed between the two commands?

## Options
Option 1: The second command regenerated the certificate with a valid signature from a certificate authority
Option 2: The second command skipped signature checking entirely, so no cryptographic verification took place
Option 3: Nothing about the certificate changed — the second command supplied it as a trusted anchor, showing that trust is a decision about which authorities you accept rather than a property of the certificate file
Option 4: The second command extended the certificate's validity period so it was no longer expired

## Answers
Option 3 : 1

## Tags
Cryptography
Certificates
PKI

## Number of Retries
1
