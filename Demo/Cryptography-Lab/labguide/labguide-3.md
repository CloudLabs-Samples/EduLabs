# Lab 3: Digital Signatures and Certificates

**Lab Description:** In Lab 1 a hash proved that an invoice had been altered, but it could not tell you who altered it,  and an attacker who edits a file can simply publish a new hash to match. In Lab 2 you could encrypt to anyone holding a published public key, but nothing proved who a message came from. Both gaps are closed by the same mechanism: a **digital signature**, which is what you get when you use a private key backwards. In this lab you will sign the release approval, prove that a forged copy fails verification, then issue an X.509 certificate and discover why certificate authorities exist at all.

**Estimated Duration:** **20 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Create and verify a digital signature with `openssl dgst`

- Explain why signing uses the private key while verification uses the public key

- Demonstrate that any modification to a signed file invalidates its signature

- Generate a self-signed X.509 certificate and inspect its subject, issuer, and validity

- Explain what a certificate authority provides that a self-signed certificate cannot

> **Note:** This lab uses the RSA key pair you created in Lab 2. If `private_key.pem` and `public_key.pem` are not in `~/crypto-lab`, return to Lab 2 and generate them before continuing.

## Task: Sign a release approval and issue a certificate

In this task, you will sign the release approval, watch verification fail against a forged copy, and then issue and inspect a self-signed certificate.

1. Run the following commands to return to your working directory and confirm your keys are present.

    ```bash
    cd ~/crypto-lab
    ```

    ```bash
    ls -l private_key.pem public_key.pem
    ```

    **Expected Output:**

    ```output
    -rw------- 1 azureuser azureuser 1704 Aug 11 09:28 private_key.pem
    -rw-rw-r-- 1 azureuser azureuser  451 Aug 11 09:28 public_key.pem
    ```

    >**Note:** Notice the permissions OpenSSL chose. The private key is `-rw-------`, readable by nobody but you, while the public key was left at the default the system would give any new file. OpenSSL applies that restriction to private keys deliberately, it does not rely on you remembering to do it. The distinction is the whole point: one of these files is a secret and the other is meant to be handed out.

### **Sign the release approval**

1. Run the following command to review the statement you are about to sign.

    ```bash
    cat message.txt
    ```

    **Expected Output:**

    ```output
    Release 4.2.0 of the Northwind payment gateway is approved for production.
    Approved by: Security Engineering
    Change reference: CHG-10428
    ```

1. Run the following command to sign the file with your **private** key.

    ```bash
    openssl dgst -sha256 -sign private_key.pem -out message.sig message.txt
    ```

    >**Note:** This is a two-stage operation. OpenSSL first hashes `message.txt` with SHA-256, then encrypts that 32-byte hash with your private key. Signing the hash rather than the file is what lets you sign a file of any size with a single fixed-cost operation, the same reason the 245-byte RSA limit from Lab 2 never gets in the way here.

1. Run the following command to inspect the signature you produced.

    ```bash
    ls -l message.sig
    ```

    **Expected Output:**

    ```output
    -rw-rw-r-- 1 azureuser azureuser 256 Aug 11 09:45 message.sig
    ```

    >**Note:** 256 bytes again, one RSA key width, exactly as in Lab 2. The signature is a **detached** file: `message.txt` itself is untouched and still perfectly readable. You publish the two together, which is precisely how signed software releases are distributed.

1. Run the following command to verify the signature using the **public** key.

    ```bash
    openssl dgst -sha256 -verify public_key.pem -signature message.sig message.txt
    ```

    **Expected Output:**

    ```output
    Verified OK
    ```

    >**Note:** Note the reversal against Lab 2. There you encrypted with the **public** key so that only the private key could read it. Here you signed with the **private** key so that anyone with the public key can check it. Confidentiality and authenticity use the same key pair in opposite directions.

### **Prove the signature detects tampering**

1. Run the following command to create a forged copy with an altered change reference, exactly as an attacker would.

    ```bash
    sed 's/CHG-10428/CHG-99999/' message.txt > forged-message.txt
    ```

    >**Note:** You are editing a **copy**. `message.txt` and its valid signature stay intact, so nothing you do here can strand you with a broken signature.

1. Run the following command to confirm what changed.

    ```bash
    diff message.txt forged-message.txt
    ```

    **Expected Output:**

    ```output
    3c3
    < Change reference: CHG-10428
    ---
    > Change reference: CHG-99999
    ```

1. Run the following command to verify the **original** signature against the **forged** file.

    ```bash
    openssl dgst -sha256 -verify public_key.pem -signature message.sig forged-message.txt
    ```

    **Expected Output:**

    ```output
    Verification failure
    804B5F5276700000:error:02000068:rsa routines:ossl_rsa_verify:bad signature:../crypto/rsa/rsa_sign.c:430:
    804B5F5276700000:error:1C880004:Provider routines:rsa_verify:RSA lib:../providers/implementations/signature/rsa_sig.c:774:
    ```

    >**Note:** The hexadecimal prefixes, file paths, and line numbers will differ on your run, and some OpenSSL versions print `Verification failure` after the error detail rather than before it. The verdict is what matters: the signature no longer matches. Compare this with the single clean `Verified OK` from the previous step, there is no ambiguous middle ground, and no way to make a signature "partially" valid.
    >
    > This is the guarantee that a plain hash could not give you in Lab 1. An attacker who edits a file can recompute its hash and publish that too, and you would be none the wiser. They cannot recompute the **signature**, because doing so requires the private key. That is why publishing a checksum only helps if the checksum itself arrives over a channel you already trust, and why signatures are the stronger control.

1. Run the following command to confirm the original file still verifies.

    ```bash
    openssl dgst -sha256 -verify public_key.pem -signature message.sig message.txt
    ```

    **Expected Output:**

    ```output
    Verified OK
    ```

### **Issue an X.509 certificate**

1. Run the following command to generate a self-signed certificate together with a fresh private key for it.

    ```bash
    openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes \
      -keyout server.key -out server.crt \
      -subj "/C=DE/O=Northwind Components Ltd/CN=payments.northwind.example"
    ```

    >**Note:** You can use **CTRL + SHIFT + V** to paste the command to avoid copy paste issues. 

    **Expected Output:**

    ```output
    ...+..+.+++++++++++++++++++++++++++++++++++++++*....+++++++++++++++++++++++++++++++++++++++*...+...+..+....+..++++++
    -----
    ```

    >**Note:** The progress dots appear again because this command generates a brand-new key pair before signing the certificate. `-nodes` means "no DES" and leaves the key unencrypted so a web server can start without a passphrase prompt. `-subj` supplies the identity fields on the command line; omit it and OpenSSL asks for each one interactively.

1. Run the following command to inspect the identity the certificate asserts.

    ```bash
    openssl x509 -in server.crt -noout -subject -issuer -dates
    ```

    **Expected Output:**

    ```output
    subject=C = DE, O = Northwind Components Ltd, CN = payments.northwind.example
    issuer=C = DE, O = Northwind Components Ltd, CN = payments.northwind.example
    notBefore=Aug 11 09:52:14 2026 GMT
    notAfter=Aug 11 09:52:14 2027 GMT
    ```

    >**Note:** Your dates will reflect today, and some OpenSSL versions print the name without spaces around the `=`. The important detail is that **`subject` and `issuer` are identical**, this certificate vouches for itself. That is the definition of self-signed, and it is why your browser rejects them: anyone can generate a certificate claiming to be `payments.northwind.example`, including an attacker.

1. Run the following commands to confirm the certificate carries the public half of `server.key`.

    ```bash
    openssl x509 -in server.crt -noout -modulus | sha256sum
    ```

    ```bash
    openssl rsa -in server.key -noout -modulus | sha256sum
    ```

    **Expected Output:**

    ```output
    63be28740b01f1ce2ae01639a99671626cdc4d73d9d47812f9ab5b0b94604a8e  -
    63be28740b01f1ce2ae01639a99671626cdc4d73d9d47812f9ab5b0b94604a8e  -
    ```

    >**Note:** Your hashes will differ from these but **must match each other**. This is the same modulus comparison you used in Lab 2, and it is the first thing to run when a web server refuses to start with a `key values mismatch` error, it tells you immediately whether the certificate and key belong together.

1. Run the following command to ask OpenSSL whether it trusts the certificate.

    ```bash
    openssl verify server.crt
    ```

    **Expected Output:**

    ```output
    C = DE, O = Northwind Components Ltd, CN = payments.northwind.example
    error 18 at 0 depth lookup: self-signed certificate
    error server.crt: verification failed
    ```

    >**Note:** This failure is expected. OpenSSL checked the certificate against the system trust store, the set of certificate authorities Ubuntu ships in `/etc/ssl/certs`, and found nothing vouching for it. The certificate is cryptographically valid and completely untrusted, and those are two different things.

1. Run the following command to verify it again, this time telling OpenSSL to trust the certificate as its own authority.

    ```bash
    openssl verify -CAfile server.crt server.crt
    ```

    **Expected Output:**

    ```output
    server.crt: OK
    ```

    >**Note:** Nothing about the certificate changed between these two commands, only what you told OpenSSL to trust. **Trust is a decision, not a property of the file.** A public certificate authority performs the check you just skipped: it confirms you actually control `payments.northwind.example` before signing, and browsers ship its certificate so that its signature means something. Adding a certificate to a trust store, as you effectively did here, is the same act that makes corporate TLS inspection possible, and the same act an attacker needs to intercept your traffic.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="a2771a87-4733-4013-bc08-6db26bd7fc73" />

**Lab 3 Recap:** In this lab, you:

- Signed the release approval with your private key and verified it with your public key.

- Created a forged copy and watched verification fail, proving a signature detects what a bare hash cannot.

- Issued a self-signed X.509 certificate and read its subject, issuer, and validity window.

- Confirmed the certificate and its private key match by comparing their modulus hashes.

- Saw a certificate go from `verification failed` to `OK` purely by changing which trust anchor OpenSSL was given.

## You have successfully completed Lab 3.

Now, click on **Next >>** from the lower right corner to move on to the next page

   ![](./Image/nxt.png)
