# Lab 1: Hashing, Integrity, and Symmetric Encryption

**Lab Description:** Accounts Payable has two copies of invoice 2026-0417, received from two different email addresses, and the bank details do not match. Paying the wrong one sends 48,250 EUR to a criminal. In this lab you will use a **cryptographic hash** to prove which copy is genuine, then use **symmetric encryption** to protect a payroll extract that is currently sitting on disk in plain text. Along the way you will meet the limitation of symmetric encryption that the whole of Lab 2 exists to solve.

**Estimated Duration:** **30 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Explain what a cryptographic hash guarantees, and what it does not

- Verify files against a published checksum manifest with `sha256sum -c`

- Describe why password hashes are salted, and demonstrate the effect

- Encrypt and decrypt a file with AES-256 using `openssl enc`

- Explain the key distribution problem that symmetric encryption cannot solve

## Task 1: Prove integrity with hashing and protect data with AES

In this task, you will identify the forged invoice using the vendor's published checksum, then encrypt the payroll extract so it is unreadable without the key.

1. You are already connected to the **Lab VM** over SSH. If you encounter any issues connecting, you can also connect locally using the connection details available under the **Environment tab**.

    ![](./Image/EV.png)

1. Run the following commands to move into your working directory, see what you have been given, and confirm which version of OpenSSL you are working with.

    ```bash
    cd ~/crypto-lab
    ```

    ```bash
    ls -l
    ```

    ```bash
    openssl version
    ```

    **Expected Output:**

    ```output
    total 20
    -rw-r--r-- 1 azureuser azureuser 212 Aug 11 09:12 invoice-resent.txt
    -rw-r--r-- 1 azureuser azureuser 163 Aug 11 09:12 invoice.sha256
    -rw-r--r-- 1 azureuser azureuser 212 Aug 11 09:12 invoice.txt
    -rw-r--r-- 1 azureuser azureuser 137 Aug 11 09:12 message.txt
    -rw-r--r-- 1 azureuser azureuser 407 Aug 11 09:12 payroll.csv
    OpenSSL 3.0.2 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)
    ```

    >**Note:** Your timestamps and OpenSSL version may differ. The repeated `(Library: ...)` is normal, it reports the version of the OpenSSL library the command-line tool is linked against, which on this image is the same one. Notice that both invoices are exactly **212 bytes**, the forgery was built by substituting one bank account number for another of the same length, so file size tells you nothing. This is deliberate, and it is why you need a hash. OpenSSL is the reference implementation of TLS and the toolkit behind most of the encryption on the internet; every command in this lab uses it.

### **Understand what a hash is**

1. Run the following command to produce the SHA-256 fingerprint of the first invoice.

    ```bash
    sha256sum invoice.txt
    ```

    **Expected Output:**

    ```output
    373ab763e97ce0bccb319f20dfcc591db59ac482b70574d133cdd42aa4ea5352  invoice.txt
    ```

    >**Note:** A cryptographic hash is a one-way function: it turns any input into a fixed-length fingerprint, and there is no practical way to work backwards from the fingerprint to the input. Because your file is byte-for-byte identical to the one the vendor sent, your hash matches theirs exactly.

1. Run the following commands to see how sensitive that fingerprint is. The two strings differ by a single character.

    ```bash
    echo -n "Transfer 1000 EUR to IBAN DE44" | sha256sum
    ```

    ```bash
    echo -n "Transfer 1000 EUR to IBAN DE45" | sha256sum
    ```

    **Expected Output:**

    ```output
    2df73e9d5e79dd5f0b835eedee54aac8bb926d8980ae5a450707c6df486a4950  -
    85fe6083e608b04ea0e57589e8833d0f7da621bc74cd31442291d3446ab915cd  -
    ```

    >**Note:** Changing `4` to `5` produced a completely unrelated hash rather than a slightly different one. This is the **avalanche effect**, and it is what makes hashes useful for detecting tampering: there is no such thing as a "small" change. The `-` in the output means the input came from standard input rather than a file, and `echo -n` suppresses the trailing newline so you are hashing exactly those 30 characters.

### **Identify the forged invoice**

1. Run the following command to view the checksum manifest the vendor publishes on their website.

    ```bash
    cat invoice.sha256
    ```

    **Expected Output:**

    ```output
    373ab763e97ce0bccb319f20dfcc591db59ac482b70574d133cdd42aa4ea5352  invoice.txt
    373ab763e97ce0bccb319f20dfcc591db59ac482b70574d133cdd42aa4ea5352  invoice-resent.txt
    ```

    >**Note:** Both lines carry the **same** hash, because the vendor sent one invoice and published one fingerprint for it. You have two files each claiming to be that invoice. At most one of them can be genuine.

1. Run the following command to check both files against the manifest and save the result as evidence.

    ```bash
    sha256sum -c invoice.sha256 2>&1 | tee integrity-report.txt
    ```

    **Expected Output:**

    ```output
    invoice.txt: OK
    invoice-resent.txt: FAILED
    sha256sum: WARNING: 1 computed checksum did NOT match
    ```

    >**Note:** `sha256sum -c` recomputes the hash of every file named in the manifest and compares it to the recorded value. `invoice.txt` is the invoice the vendor actually sent; `invoice-resent.txt` is a forgery. The `2>&1` is needed because the WARNING line is written to standard error, and `tee` writes the combined output to `integrity-report.txt` while still showing it on screen.

1. Run the following command to see exactly what the attacker changed.

    ```bash
    diff invoice.txt invoice-resent.txt
    ```

    **Expected Output:**

    ```output
    6c6
    < IBAN          : DE44 5001 0517 5407 3249 31
    ---
    > IBAN          : DE89 3704 0044 0532 0130 00
    ```

    >**Note:** This is a **payment redirect attack**, and it is one of the most common frauds businesses face. Everything about the forged invoice is convincing except six words of bank detail. Note carefully what the hash did and did not do: it proved the file changed, but it could not tell you *who* changed it. Proving origin is authenticity, and that is Lab 3.

### **See why password hashes are salted**

1. Run the following command twice to hash the same password with the same salt.

    ```bash
    openssl passwd -6 -salt LabSalt01 'SamePassword123'
    ```

    ```bash
    openssl passwd -6 -salt LabSalt01 'SamePassword123'
    ```

    **Expected Output:**

    ```output
    $6$LabSalt01$orysB7nwROcFbcrScXoaDy9MDevGMHOivDpdUFRzEX728SmdNe5Ou5VVWi3ZMQHgPdWzzDBZo7FejGfF0WpN40
    $6$LabSalt01$orysB7nwROcFbcrScXoaDy9MDevGMHOivDpdUFRzEX728SmdNe5Ou5VVWi3ZMQHgPdWzzDBZo7FejGfF0WpN40
    ```

    >**Note:** Hashing is deterministic: identical inputs always produce identical outputs. That is exactly how a login check works, the system hashes what you typed and compares it to the stored value, without ever storing your actual password. The `-6` selects SHA-512 crypt, the scheme Linux uses in `/etc/shadow`.

1. Run the following command to hash the **same** password with a **different** salt.

    ```bash
    openssl passwd -6 -salt LabSalt02 'SamePassword123'
    ```

    **Expected Output:**

    ```output
    $6$LabSalt02$R29VGF88q4w9VbRf9OoW9D/nt0Xw305D6Euh8VeMsOviHiFxC6OTtyc9pCjCB16J5UnZvZGTwDSjRhGlGdtx8/
    ```

    >**Note:** Same password, unrelated hash. The salt is stored in plain sight between the second and third `$`, it is not a secret. Its job is to guarantee that two users who happen to choose the same password get different stored hashes, so an attacker cannot crack them both at once and cannot use a precomputed rainbow table. Real systems generate a random salt per account rather than fixing it as you did here.

### **Protect the payroll extract with AES-256**

1. Run the following command to encrypt the payroll extract, currently readable by anyone who opens it, with AES-256 in CBC mode.

    ```bash
    openssl enc -aes-256-cbc -pbkdf2 -salt -in payroll.csv -out payroll.csv.enc -pass pass:'Payroll-Key-2026'
    ```

    >**Note:** `-pbkdf2` is not optional in practice. Without it OpenSSL falls back to a legacy key derivation function based on a single MD5 pass, which is fast enough to brute-force. PBKDF2 deliberately makes deriving the key from your password slow. Passing a password with `pass:` also exposes it to anyone running `ps`; production scripts use `-pass file:` or `-pass env:` instead.

1. Run the following command to look at the first bytes of the ciphertext.

    ```bash
    head -c 32 payroll.csv.enc | od -c | head -3
    ```

    **Expected Output:**

    ```output
    0000000   S   a   l   t   e   d   _   _  \f 211   J 222 337 351   {   _
    0000020 204 264   &   C 224   z 337 224 316   R   ]   )   *   {   @   "
    0000040
    ```

    >**Note:** Your bytes after the header will differ every time, and that is the point. OpenSSL writes the literal string `Salted__` followed by the eight random salt bytes it generated, then the ciphertext. Because the salt is random, encrypting the same file twice with the same password produces completely different output, so an observer cannot tell that two ciphertexts hold identical data.

1. Run the following command to decrypt the file back with the same password.

    ```bash
    openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.csv.enc -out payroll-decrypted.csv -pass pass:'Payroll-Key-2026'
    ```

    >**Note:** You did not have to supply the salt. OpenSSL reads it back out of the `Salted__` header and uses it to derive the same key from your password.

1. Run the following command to prove the round trip was lossless.

    ```bash
    diff payroll.csv payroll-decrypted.csv && echo "IDENTICAL"
    ```

    **Expected Output:**

    ```output
    IDENTICAL
    ```

    >**Note:** `diff` prints nothing when two files match, so the `&& echo` gives you a visible confirmation instead of an ambiguous blank line.

1. Run the following command to see what happens with the wrong password.

    ```bash
    openssl enc -d -aes-256-cbc -pbkdf2 -in payroll.csv.enc -out /dev/null -pass pass:'Wrong-Key-2026'
    ```

    **Expected Output:**

    ```output
    bad decrypt
    80AB3209367B0000:error:1C800064:Provider routines:ossl_cipher_unpadblock:bad decrypt:../providers/implementations/ciphers/ciphercommon_block.c:124:
    ```

    >**Note:** The long hexadecimal prefix, the source file path, and the line number will differ on your run, only `bad decrypt` matters. AES itself did not detect the wrong key; it happily produced 407 bytes of garbage. What failed was the **padding check** at the end. This is why modern designs prefer authenticated modes such as AES-GCM, which verify the data cryptographically rather than inferring failure from malformed padding.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="560d7b09-aacf-4937-bc44-7399019ce3e9" />

**Lab 1 Recap:** In this lab, you:

- Produced SHA-256 fingerprints and saw the avalanche effect make any change, however small, unmistakable.

- Used the vendor's published manifest with `sha256sum -c` to prove which of two identical-looking invoices was forged, and used `diff` to expose the substituted bank account.

- Demonstrated why password hashes are salted, by hashing one password under two salts.

- Encrypted and decrypted the payroll extract with AES-256 and PBKDF2, and inspected the `Salted__` header that makes each ciphertext unique.

> **Note:** You have now solved integrity and confidentiality, but only for yourself. Notice that you used **the same password to encrypt and to decrypt**. If a partner needs to send you an encrypted file, you first have to get that password to them, and any channel safe enough to carry the password was already safe enough to carry the file. This is the **key distribution problem**, and it is what Lab 2 solves.

## You have successfully completed Lab 1.

Now, click on **Next >>** from the lower right corner to move on to the next page

   ![](./Image/nxt.png)
