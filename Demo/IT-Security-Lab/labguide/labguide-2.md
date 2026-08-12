# Lab 2: File Permissions and Sensitive Data

**Lab Description:** The directory **`/opt/labdata`** on this server holds customer records and live API keys, and nobody has ever checked who is able to read them. There is also an unexplained SUID root binary sitting alongside that data. In this lab, you will read and interpret Linux permission modes, lock the sensitive files down to the accounts that genuinely need them, tighten the system-wide default `umask`, and remove a SUID bit that offers any user on the server a trivial path to a root shell.

**Estimated Duration:** **30 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Read and interpret Linux permission strings and their octal equivalents

- Apply appropriate ownership and permissions to sensitive data with `chown` and `chmod`

- Verify that an unauthorised access attempt is actually denied

- Explain what the `umask` does and set a more restrictive system-wide default

- Locate SUID binaries and explain why an unnecessary SUID root binary is a privilege escalation risk

## Task: Secure sensitive data and remove the privilege escalation risk

In this task, you will audit the permissions on `/opt/labdata`, restrict the customer records and API keys, tighten the default `umask`, and clear the SUID bit from an unauthorised binary.

1. Run the following command to list the contents of `/opt/labdata` with full permission details.

    ```bash
    ls -l /opt/labdata
    ```

    **Expected Output:**

    ```output
    total 1044
    -rw-r--r-- 1 root root     143 Aug  7 09:12 api-keys.txt
    -rwxrwxrwx 1 root root     118 Aug  7 09:12 backup.sh
    -rw-rw-rw- 1 root root     341 Aug  7 09:12 customer-records.csv
    -rwsr-xr-x 1 root root 1055344 Aug  7 09:12 scanner
    ```

    >**Note:** Read the first column carefully, because it describes the entire security posture of each file. The leading character is the file type (`-` for a regular file, `d` for a directory). The remaining nine characters are three groups of `rwx` covering the **owner**, the **group**, and **everyone else**.

1. Study the four findings visible in that output before you change anything:

    | File | Mode | Why it is a problem |
    |------|------|---------------------|
    | `customer-records.csv` | `-rw-rw-rw-` (0666) | Every account on the server can read **and modify** customer data. |
    | `api-keys.txt` | `-rw-r--r--` (0644) | Every account can read live production API keys. |
    | `backup.sh` | `-rwxrwxrwx` (0777) | Every account can rewrite a script that **runs as root** from cron. |
    | `scanner` | `-rwsr-xr-x` (4755) | The `s` where the owner's `x` should be is the **SUID bit**. |

    >**Note:** `backup.sh` is the most dangerous of the first three. A file that any user can edit and that root later executes is a direct, reliable path to full system compromise — an attacker with any low-privileged account simply appends a command and waits for cron to run it as root.

1. Run the following command to see the permissions as octal numbers, which is how you will set them.

    ```bash
    stat -c '%a %U:%G %n' /opt/labdata/*
    ```

    **Expected Output:**

    ```output
    644 root:root /opt/labdata/api-keys.txt
    777 root:root /opt/labdata/backup.sh
    666 root:root /opt/labdata/customer-records.csv
    4755 root:root /opt/labdata/scanner
    ```

    >**Note:** Each octal digit is the sum of read (**4**), write (**2**), and execute (**1**) for one class of user. So `640` means owner read+write (4+2), group read (4), and nothing at all for everyone else (0).

### **Restrict the sensitive files**

1. Run the following command to give the customer records to the `secops` group you created in Lab 1.

    ```bash
    sudo chown root:secops /opt/labdata/customer-records.csv
    ```

    >**Note:** Ownership and permissions work together. Setting a group-read permission is meaningless until the correct group owns the file. The API keys are deliberately left owned by `root:root` — no group needs to read them, so no group is given ownership.

1. Run the following command to restrict the customer records to **owner read/write, group read, nothing for anyone else**.

    ```bash
    sudo chmod 0640 /opt/labdata/customer-records.csv
    ```

1. Run the following command to restrict the API keys further, to **owner read/write only**.

    ```bash
    sudo chmod 0600 /opt/labdata/api-keys.txt
    ```

    >**Note:** Credentials get tighter treatment than data. Only root needs to read the API keys, so not even the `secops` group is granted access. Grant the narrowest permission that still allows the work to happen.

1. Run the following command to remove group and world write access from the root-executed backup script.

    ```bash
    sudo chmod 0750 /opt/labdata/backup.sh
    ```

1. Run the following command to confirm all three files are now correctly secured.

    ```bash
    stat -c '%a %U:%G %n' /opt/labdata/api-keys.txt /opt/labdata/backup.sh /opt/labdata/customer-records.csv
    ```

    **Expected Output:**

    ```output
    600 root:root /opt/labdata/api-keys.txt
    750 root:root /opt/labdata/backup.sh
    640 root:secops /opt/labdata/customer-records.csv
    ```

1. Run the following command to prove the control works, by reading the customer records as `analyst2` — who is in `secops` and should succeed.

    ```bash
    sudo -u analyst2 head -n 2 /opt/labdata/customer-records.csv
    ```

    **Expected Output:**

    ```output
    customer_id,full_name,email,region,account_balance
    1001,Amara Okafor,amara.okafor@example.com,EMEA,18450.22
    ```

1. Run the following command to attempt to read the API keys as `analyst2`, which should now be refused.

    ```bash
    sudo -u analyst2 cat /opt/labdata/api-keys.txt
    ```

    **Expected Output:**

    ```output
    cat: /opt/labdata/api-keys.txt: Permission denied
    ```

    >**Note:** A **Permission denied** error is the desired result here. Verifying that access is refused matters as much as verifying that authorised access works — a control you have not tested is a control you do not have.

### **Tighten the default umask**

1. Run the following command to check the current default `umask`.

    ```bash
    umask
    ```

    **Expected Output:**

    ```output
    0002
    ```

    >**Note:** The `umask` is a mask of permission bits **removed** from every newly created file. Ubuntu's default of `0002` subtracts only the world-write bit, so new files land at mode `644` — readable by every account on the system. For a host holding customer data that is too permissive.

1. Run the following commands to set a more restrictive system-wide default of **`027`**, which removes group-write and all world access from new files.

    ```bash
    echo 'umask 027' | sudo tee /etc/profile.d/99-secure-umask.sh > /dev/null
    ```

    ```bash
    sudo sed -i 's/^UMASK.*/UMASK\t\t027/' /etc/login.defs
    ```

1. Run the following commands to confirm both settings are in place.

    ```bash
    cat /etc/profile.d/99-secure-umask.sh
    ```

    ```bash
    grep -E '^UMASK' /etc/login.defs
    ```

    **Expected Output:**

    ```output
    umask 027
    UMASK		027
    ```

    >**Note:** With a `027` umask, a new file is created at mode `640` and a new directory at `750`. Your current shell keeps the old value until you log out and back in, which is expected.

### **Find and remove the SUID risk**

1. Run the following command to find every SUID root binary on the filesystem. This is a standard step in any Linux security audit.

    ```bash
    sudo find / -xdev -type f -perm -4000 -exec ls -l {} \; 2>/dev/null
    ```

    **Expected Output:**

    ```output
    -rwsr-xr-x 1 root root   68208 Nov 24  2022 /usr/bin/passwd
    -rwsr-xr-x 1 root root   72072 Nov 24  2022 /usr/bin/gpasswd
    -rwsr-xr-x 1 root root 1055344 Aug  7 09:12 /opt/labdata/scanner
    ...
    ```

    >**Note:** `-perm -4000` matches the SUID bit and `-xdev` keeps the search on the local filesystem. A SUID binary runs with the privileges of its **owner** rather than whoever launched it, so a SUID root binary always executes as root. A handful of system binaries such as `passwd` legitimately need this, because changing your own password requires writing to `/etc/shadow`.

1. Run the following command to look more closely at the suspicious binary.

    ```bash
    ls -l /opt/labdata/scanner && /opt/labdata/scanner --version | head -n 1
    ```

    **Expected Output:**

    ```output
    -rwsr-xr-x 1 root root 1055344 Aug  7 09:12 /opt/labdata/scanner
    find (GNU findutils) 4.8.0
    ```

    >**Note:** This is a renamed copy of GNU `find` with the SUID root bit set. Because `find` has an `-exec` option, **any** user on the system could run `/opt/labdata/scanner . -exec /bin/sh \;` and receive a **root shell**. This is one of the best known privilege escalation techniques on Linux and it is exactly what an attacker looks for first.

1. Run the following command to remove the SUID bit.

    ```bash
    sudo chmod u-s /opt/labdata/scanner
    ```

    >**Note:** You can also write this as `sudo chmod 0755 /opt/labdata/scanner`. An explicit four-digit mode with a leading `0` clears the SUID, SGID, and sticky bits in one operation.

1. Run the following command to confirm the SUID bit is gone.

    ```bash
    stat -c '%a %A %n' /opt/labdata/scanner
    ```

    **Expected Output:**

    ```output
    755 -rwxr-xr-x /opt/labdata/scanner
    ```

    >**Note:** The `s` in the owner block has returned to a normal `x`, and the octal mode no longer carries a leading `4`. In a real engagement you would also ask **why** the binary was placed there, and treat its presence as a potential indicator of compromise.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="3ece02a1-4ea8-4bf5-9616-1783715150c1" />

**Lab 2 Recap:** In this lab, you:

- Read and interpreted Linux permission strings and their octal equivalents, and identified four real findings in `/opt/labdata`.

- Secured customer records at mode `640` owned by `root:secops`, restricted live API keys to `600`, and removed world-write from a root-executed backup script.

- Verified both sides of the control: an authorised read succeeded and an unauthorised read was denied.

- Tightened the system-wide default `umask` from `002` to `027` in both `/etc/profile.d` and `/etc/login.defs`.

- Located every SUID root binary and removed the SUID bit from a planted copy of `find` that offered a trivial path to a root shell.

## You have successfully completed Lab 2.

Now, click on **Next >>** from the lower right corner to move on to the next page

   ![](./Image/nxt.png)
