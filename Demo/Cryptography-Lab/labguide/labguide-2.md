# Lab 2: Public-Key Cryptography

**Lab Description:** Lab 1 ended with a problem: symmetric encryption uses the same key to lock and unlock, so before a partner can send you an encrypted file you must somehow get that key to them safely, and any channel safe enough for the key was already safe enough for the file. **Public-key cryptography** breaks that circle by using two different keys. In this lab you will generate an RSA key pair, publish one half of it, encrypt and decrypt with it, then run head-first into the limitation that stops RSA being used for bulk data, and build the hybrid scheme that every real system uses to work around it.

**Estimated Duration:** **30 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Generate an RSA key pair and explain the role of each half

- Derive a public key from a private key, and prove the two are mathematically linked

- Encrypt with a public key and decrypt with the matching private key

- Explain why RSA cannot encrypt data larger than its key size

- Build a hybrid encryption scheme, the design used by TLS, PGP, and every file-encryption product

## Task 1: Generate an RSA key pair and build hybrid encryption

In this task, you will create a 2048-bit RSA key pair, use it to protect a short message, discover the size limit first-hand, and then combine RSA with AES to protect a file of any size.

1. Run the following command to return to your working directory.

    ```bash
    cd ~/crypto-lab
    ```

### **Generate the key pair**

1. Run the following command to generate a 2048-bit RSA private key.

    ```bash
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private_key.pem
    ```

    **Expected Output:**

    ```output
    ..+.......+..+.+++++++++++++++++++++++++++++++++++++++*.....+.....+++++++++++++++++++++++++++++++++++++++*.....+...+....+..+.......+...+..++++++
    ...+..+....+++++++++++++++++++++++++++++++++++++++*......+..+....+++++++++++++++++++++++++++++++++++++++*......+.....+....+..+...+....++++++
    ```

    >**Note:** The dots and plus signs are a progress indicator, and the exact pattern will be different every time, OpenSSL is searching for large random prime numbers, and the display shows candidates being tested and rejected. This is why key generation takes a few seconds rather than being instant. **Your key is unique to you**; nobody else running this lab will produce the same one.

1. Run the following command to derive the matching public key from the private key.

    ```bash
    openssl rsa -pubout -in private_key.pem -out public_key.pem
    ```

    **Expected Output:**

    ```output
    writing RSA key
    ```

    >**Note:** Notice the direction. The public key is **extracted from** the private key, the private key contains everything, and the public key is a subset of it. There is no command to do the reverse, which is precisely why a leaked private key is a catastrophe and a published public key is harmless. Both files are PEM format: base64 text wrapped in `BEGIN`/`END` markers, which is why keys can be pasted into config files and emails. **`public_key.pem` is safe to publish anywhere. `private_key.pem` never leaves this machine.**

1. Run the following command to confirm the key size.

    ```bash
    openssl rsa -in private_key.pem -noout -text | head -1
    ```

    **Expected Output:**

    ```output
    Private-Key: (2048 bit, 2 primes)
    ```

    >**Note:** 2048 bits is the current practical minimum for RSA; anything at or below 1024 bits is considered broken. The "2 primes" is the heart of RSA, the key was built from two large secret primes, and its security rests on the fact that multiplying them together is easy while factoring the result back apart is not.

1. Run the following commands to prove the two files really are two halves of one key pair.

    ```bash
    openssl rsa -in private_key.pem -noout -modulus | sha256sum
    ```

    ```bash
    openssl rsa -pubin -in public_key.pem -noout -modulus | sha256sum
    ```

    **Expected Output:**

    ```output
    665742549d3c91b6f5dcf011acf786574ce4217472ba478339dbbfb935c5021d  -
    665742549d3c91b6f5dcf011acf786574ce4217472ba478339dbbfb935c5021d  -
    ```

    >**Note:** Your two hashes will be different from the ones shown, because your key is unique, but **they must match each other**. The modulus is the shared public number both halves are built around, so hashing it is the standard way to check that a key and a certificate belong together. You will use exactly this technique again in Lab 3.

### **Encrypt and decrypt with the key pair**

1. Run the following command to encrypt the release approval using the **public** key.

    ```bash
    openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in message.txt -out message.enc
    ```

1. Run the following command to confirm what was produced.

    ```bash
    ls -l message.txt message.enc
    ```

    **Expected Output:**

    ```output
    -rw-rw-r-- 1 azureuser azureuser 256 Aug 11 09:31 message.enc
    -rw-r--r-- 1 azureuser azureuser 137 Aug 11 09:12 message.txt
    ```

    >**Note:** The 137-byte input became exactly **256 bytes**, which is 2048 bits, the size of the key. RSA output is always exactly one key-width, whatever the input size. Keep that number in mind for the next section.

1. Run the following command to decrypt it using the **private** key.

    ```bash
    openssl pkeyutl -decrypt -inkey private_key.pem -in message.enc -out message-decrypted.txt
    ```

1. Run the following command to confirm the round trip was lossless.

    ```bash
    diff message.txt message-decrypted.txt && echo "IDENTICAL"
    ```

    **Expected Output:**

    ```output
    IDENTICAL
    ```

    >**Note:** This is the asymmetry that solves Lab 1's problem. Anyone holding your public key can encrypt a message to you, but **only** your private key can open it, so you can publish the public key on a website and never need a secure channel to bootstrap the conversation.

### **Discover the size limit**

1. Run the following command to try the same thing with the payroll file.

    ```bash
    openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in payroll.csv -out payroll.rsa.enc
    ```

    **Expected Output:**

    ```output
    Public Key operation error
    800B762557770000:error:0200006E:rsa routines:ossl_rsa_padding_add_PKCS1_type_2_ex:data too large for key size:../crypto/rsa/rsa_pk1.c:133:
    ```

    >**Note:** This failure is expected, it is the lesson. The hexadecimal prefix and file path will differ on your run; the phrase that matters is **`data too large for key size`**. RSA is not a general-purpose cipher: it can only encrypt a number smaller than its modulus. With a 2048-bit key and PKCS#1 v1.5 padding, the ceiling is **245 bytes** (256 bytes of key width, minus 11 bytes of mandatory padding). `message.txt` was 137 bytes and fit comfortably; `payroll.csv` is 407 bytes and does not.

    >**Note:** Even if RSA had no size limit it would still be the wrong tool here, because it is roughly a thousand times slower than AES. Encrypting a large file with RSA directly would be unusably slow even where it was possible.

### **Build hybrid encryption**

1. Run the following command to generate a random 256-bit key for AES, encoded as base64 text.

    ```bash
    openssl rand -base64 32 > aes.key
    ```

    ```bash
    cat aes.key
    ```

    **Expected Output:**

    ```output
    AS+7pvHZuSABjQzohEYq2OkG2BS+3oCyEMRnhUVnTWc=
    ```

    >**Note:** Yours will be different, that is the point of `rand`. This is a **session key**: generated fresh, used once, and thrown away. 32 bytes of random data become 44 base64 characters, which is comfortably under the 245-byte RSA ceiling. That fact is what makes the next two steps work.

1. Run the following command to encrypt the bulk data with AES, using that random key.

    ```bash
    openssl enc -aes-256-cbc -pbkdf2 -salt -in payroll.csv -out payroll.hybrid.enc -pass file:aes.key
    ```

    >**Note:** `-pass file:aes.key` reads the first line of the file instead of taking the password from the command line, so the key is never visible in `ps` output or your shell history. This is the production pattern you were warned about in Lab 1.

1. Run the following command to encrypt the AES key itself with RSA.

    ```bash
    openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in aes.key -out aes.key.enc
    ```

    >**Note:** This is the whole trick. RSA cannot carry the file, but it can easily carry the 44-byte key that unlocks the file. You now have two artefacts, and both are safe to send over an untrusted channel.

1. Run the following command to see what you would actually transmit.

    ```bash
    ls -l payroll.hybrid.enc aes.key.enc
    ```

    **Expected Output:**

    ```output
    -rw-rw-r-- 1 azureuser azureuser  256 Aug 11 09:38 aes.key.enc
    -rw-rw-r-- 1 azureuser azureuser  432 Aug 11 09:38 payroll.hybrid.enc
    ```

    >**Note:** The wrapped key is 256 bytes regardless of the file size, and the encrypted payload grows with the data. Send both to the recipient. Only the holder of the private key can unwrap the session key, and without the session key the payload is useless.

1. Run the following commands to perform the recipient's side: unwrap the key with RSA, then decrypt the payload with AES.

    ```bash
    openssl pkeyutl -decrypt -inkey private_key.pem -in aes.key.enc -out aes.key.recovered
    ```

    ```bash
    openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.hybrid.enc -out payroll-hybrid.csv -pass file:aes.key.recovered
    ```

1. Run the following command to confirm the file survived both layers intact.

    ```bash
    diff payroll.csv payroll-hybrid.csv && echo "HYBRID ROUND TRIP OK"
    ```

    **Expected Output:**

    ```output
    HYBRID ROUND TRIP OK
    ```

    >**Note:** You have just rebuilt, by hand, the design used by TLS, PGP, S/MIME, and effectively every encrypted messaging product: **use slow public-key cryptography once to agree a fast symmetric key, then use that symmetric key for the actual data.** When your browser opens an HTTPS connection it performs this same negotiation before a single byte of the page is transferred.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="82466211-3f08-497f-9523-a303a53fc1df" />

**Lab 2 Recap:** In this lab, you:

- Generated a 2048-bit RSA private key and derived the matching public key from it.

- Proved the two halves belong together by comparing the hash of their shared modulus.

- Encrypted a message with the public key and decrypted it with the private key, solving Lab 1's key distribution problem.

- Hit the `data too large for key size` limit for real, and learned why it exists.

- Built a hybrid scheme that wraps a random AES session key with RSA, and recovered the original file through both layers.

> **Note:** Keep `private_key.pem` and `public_key.pem` — Lab 3 uses the same key pair to sign the release approval. You have now covered integrity and confidentiality. The one guarantee still missing is **authenticity**: nothing so far proves who a message came from, because anyone can encrypt with a public key that is published to the world.

## You have successfully completed Lab 2.

Now, click on **Next >>** from the lower right corner to move on to the next page

   ![](./Image/nxt.png)
