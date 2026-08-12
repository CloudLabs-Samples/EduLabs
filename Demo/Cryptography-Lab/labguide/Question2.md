## Metadata
Question Type : Multiple Choice

## Question
2. On your lab server labvm-<inject key="DeploymentID" enableCopy="false"/> you built a hybrid encryption scheme in Lab 2: `payroll.csv` was encrypted with a random AES key, and that AES key was then encrypted with RSA. Which TWO of the following are reasons real systems use this design instead of encrypting the file with RSA directly?

## Options
Option 1: RSA cannot encrypt data larger than its key size, and `payroll.csv` exceeded the 245-byte limit of a 2048-bit key
Option 2: RSA is far slower than AES, so encrypting bulk data with it would be impractical even where it fits
Option 3: AES cannot be decrypted once the session key is discarded, which guarantees the data is destroyed
Option 4: Wrapping the AES key with RSA makes the resulting ciphertext smaller than the original file

## Answers
Option 1 : 1
Option 2 : 1

## Tags
Cryptography
Hybrid Encryption
RSA

## Number of Retries
1
