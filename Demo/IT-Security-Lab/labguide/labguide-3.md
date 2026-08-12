# Lab 3: Auditing and Detecting Unauthorised Changes

**Lab Description:** Everything you configured in Labs 1 and 2 is a **preventive** control, it stops something bad from happening. No set of preventive controls is perfect, so security also depends on **detective** controls: the ability to notice what an attacker left behind, and to answer after the fact who did what and when. The contractor who left this server behind also left scheduled jobs and service accounts that nobody reviewed or approved. In this lab, you will hunt down two pieces of unauthorised persistence, remove them, and then install the Linux audit daemon with persistent rules so that the next change to an identity file cannot happen unseen.

**Estimated Duration:** **20 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Explain why Linux authorises on the numeric **UID** rather than the account name, and find hidden UID 0 accounts

- Review scheduled jobs for unauthorised persistence and explain why a world-writable script run by root is a privilege escalation path

- Install `auditd` and write persistent audit rules that survive a reboot

- Retrieve audit events with `ausearch` and interpret the `auid` field

## Task: Hunt down persistence and enable auditing

In this task, you will find and remove a hidden root account and a rogue cron job, then turn on kernel-level auditing of the files that control identity and privilege.

### **Find the hidden root account**

1. Run the following command to list every account that has **UID 0**.

    ```bash
    awk -F: '($3 == 0) {print $1, $3, $7}' /etc/passwd
    ```

    **Expected Output:**

    ```output
    root 0 /bin/bash
    svc-backup 0 /bin/bash
    ```

    >**Note:** There should only ever be **one** account with UID 0, and it should be `root`. Linux makes its authorisation decision on the numeric **UID**, not on the account name, so `svc-backup` is not "an account with elevated rights", it **is** root under a different name. Every file root can read, it can read; every command root can run, it can run.

1. Notice what this means about the check you ran in Lab 1.

    ```bash
    getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 {print $1, $3}'
    ```

    **Expected Output:**

    ```output
    azureuser 1000
    olduser 1001
    analyst1 1002
    analyst2 1003
    ```

    >**Note:** `svc-backup` does **not** appear. The Lab 1 filter deliberately looked at UID 1000 and above, which is where human accounts live — and that is exactly where this account is not. An attacker who wants to stay hidden puts their account somewhere your routine check does not look, which is why auditing UID 0 separately is a standard control.

1. Run the following command to inspect the account more closely before removing it.

    ```bash
    getent passwd svc-backup && sudo passwd -S svc-backup
    ```

    **Expected Output:**

    ```output
    svc-backup:x:0:0:Backup service account:/nonexistent:/bin/bash
    svc-backup L 08/07/2026 0 99999 7 -1
    ```

    >**Note:** The `L` confirms the account has no usable password, so nobody can log in as `svc-backup` directly today. That is **not** a reason to leave it: anything that can write to `/etc/shadow` could set a password later, and the plausible service-account name is designed to survive a casual review. In a real engagement you would also treat its presence as an indicator of compromise and investigate how it got there.

1. Run the following command to remove the unauthorised account.

    ```bash
    sudo userdel -f svc-backup
    ```

    **Expected Output:**

    ```output
    userdel: user svc-backup is currently used by process 1
    ```

    >**Note:** **This message is expected, and the account was still deleted.** You will confirm that in the next step. With `-f` the warning is printed but the removal proceeds; *without* `-f` the same message is a fatal error and nothing is deleted at all.

    >**Note:** The reason this happens is the whole lesson of the lab. `userdel` refuses to delete an account that has running processes, and it decides which processes belong to an account **by UID** — so because `svc-backup` shares UID 0 with root, every root-owned process on the box, including PID 1 (`systemd`), looks like it belongs to this account. Nothing is actually killed: only the `/etc/passwd` and `/etc/shadow` entries are removed, and root itself is untouched because `userdel` matches on the account **name**.

    >**Note:** Do **not** add `-r`. That flag deletes the account's home directory, and a hostile or careless entry could point its home at a directory you very much want to keep. Inspect the home path first, as you did in the previous step, and remove files deliberately rather than as a side effect.

1. Run the following command to confirm only `root` now holds UID 0.

    ```bash
    awk -F: '($3 == 0) {print $1, $3}' /etc/passwd
    ```

    **Expected Output:**

    ```output
    root 0
    ```

### **Find the rogue scheduled job**

1. Run the following command to list the scheduled jobs installed system-wide.

    ```bash
    ls -l /etc/cron.d/
    ```

    **Expected Output:**

    ```output
    total 12
    -rw-r--r-- 1 root root 201 Jan  8  2022 e2scrub_all
    -rw-r--r-- 1 root root 396 Feb  2  2021 sysstat
    -rw-r--r-- 1 root root 103 Aug 10 09:24 system-health
    ```

    >**Note:** `/etc/cron.d/` is a favourite location for persistence because a single dropped file runs code on a schedule, as any user you choose, without touching a user's own crontab. Look at the **dates**: `e2scrub_all` and `sysstat` ship with the distribution and carry old package build dates, while `system-health` is dated when this server was provisioned. A file whose timestamp does not match its neighbours is worth a second look.

1. Run the following command to read the suspicious job.

    ```bash
    cat /etc/cron.d/system-health
    ```

    **Expected Output:**

    ```output
    # Host health reporter - runs every 5 minutes as root.
    */5 * * * * root /usr/local/bin/health-check.sh
    ```

    >**Note:** The sixth field is the **user the job runs as** — here, `root`. So every five minutes, whatever is in `/usr/local/bin/health-check.sh` executes with full root privileges.

1. Run the following command to inspect the script that job executes.

    ```bash
    ls -l /usr/local/bin/health-check.sh && cat /usr/local/bin/health-check.sh
    ```

    **Expected Output:**

    ```output
    -rwxrwxrwx 1 root root 133 Aug 10 09:24 /usr/local/bin/health-check.sh
    #!/bin/bash
    # Host health reporter - added by contractor, no change record.
    echo "$(date -u) $(uptime)" >> /var/log/health-check.log
    ```

    >**Note:** This is the same finding you met on `backup.sh` in Lab 2, and it is the most reliable privilege escalation path on a Linux host. The script's **contents are harmless** — that is not the point. The mode is `-rwxrwxrwx`, so **any** account on the server can rewrite it, and root will execute whatever they put there within five minutes. An attacker with a low-privileged foothold simply appends one line and waits.

1. Run the following command to confirm the script really is writable by an unprivileged user.

    ```bash
    sudo -u analyst2 test -w /usr/local/bin/health-check.sh && echo "WRITABLE by analyst2 - this is the finding"
    ```

    **Expected Output:**

    ```output
    WRITABLE by analyst2 - this is the finding
    ```

    >**Note:** Proving the exposure rather than assuming it is what turns "this looks wrong" into a finding you can defend in a report.

1. Run the following command to remove both the scheduled job and the script it called.

    ```bash
    sudo rm /etc/cron.d/system-health /usr/local/bin/health-check.sh
    ```

    >**Note:** Remove the **job** as well as the script. Deleting only the script leaves cron firing every five minutes against a missing file, which fills the logs with errors and leaves the entry in place for someone to "helpfully" restore later.

1. Run the following command to sweep the other places persistence commonly hides.

    ```bash
    ls -l /etc/cron.d/ /etc/cron.daily/ && sudo crontab -l 2>/dev/null || echo "root has no personal crontab - good"
    ```

    **Expected Output:**

    ```output
    /etc/cron.d/:
    total 8
    -rw-r--r-- 1 root root 201 Jan  8  2022 e2scrub_all
    -rw-r--r-- 1 root root 396 Feb  2  2021 sysstat

    /etc/cron.daily/:
    total 24
    -rwxr-xr-x 1 root root  376 Jul 24  2023 apport
    -rwxr-xr-x 1 root root 1478 Apr  8  2022 apt-compat
    -rwxr-xr-x 1 root root  123 Dec  5  2021 dpkg
    -rwxr-xr-x 1 root root  377 Jan 24  2022 logrotate
    -rwxr-xr-x 1 root root 1330 Mar 17  2022 man-db
    -rwxr-xr-x 1 root root  518 Feb  2  2021 sysstat
    root has no personal crontab - good
    ```

    >**Note:** `system-health` is gone from `/etc/cron.d/`, and everything that remains ships with the distribution. Scheduled work lives in several places on a modern Linux host: `/etc/cron.d/`, the `/etc/cron.{hourly,daily,weekly,monthly}/` directories, each user's own crontab, and systemd timers (`systemctl list-timers`). A review that checks only one of them is not a review.

### **Enable auditing**

1. Run the following command to confirm that nothing is currently auditing the system.

    ```bash
    systemctl is-active auditd 2>/dev/null || echo "auditd is NOT installed or NOT running"
    ```

    **Expected Output:**

    ```output
    inactive
    auditd is NOT installed or NOT running
    ```

    >**Note:** Both lines are expected. `systemctl is-active` prints its verdict (`inactive`) on standard output and *also* returns a non-zero exit status, which is what triggers the `||` and prints the second line.

    >**Note:** You just removed two pieces of persistence, but nothing on this host recorded when they were added or by whom. That is the gap you are about to close.

1. Run the following command to install the audit daemon.

    ```bash
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y auditd
    ```

    **Expected Output:**

    ```output
    The following NEW packages will be installed:
      auditd libauparse0
    ...
    Setting up auditd (1:3.0.7-1build1) ...
    Created symlink /etc/systemd/system/multi-user.target.wants/auditd.service → /lib/systemd/system/auditd.service.
    ```

    >**Note:** That `Created symlink` line is worth noticing — it is the package enabling `auditd` at boot for you, so you do not need a separate `systemctl enable`. The service is also started immediately.

    >**Note:** `auditd` hooks directly into the Linux kernel's audit subsystem, which sits below the applications it observes. That is what makes it valuable: a process cannot avoid being audited by choosing not to log, the way an application writing its own log file can.

1. Run the following command to write a persistent rules file that watches the files controlling identity and privilege.

    ```bash
    sudo tee /etc/audit/rules.d/99-identity.rules > /dev/null <<'EOF'
    ## Watch the files that define WHO can log in.
    -w /etc/passwd  -p wa -k identity
    -w /etc/shadow  -p wa -k identity
    -w /etc/group   -p wa -k identity

    ## Watch the files that define WHAT users are allowed to do.
    -w /etc/sudoers   -p wa -k privilege
    -w /etc/sudoers.d -p wa -k privilege

    ## Watch where the rogue job was planted.
    -w /etc/cron.d -p wa -k persistence
    EOF
    ```

    >**Note:** Read one rule: `-w` names the **path to watch**, `-p wa` sets the **permissions that trigger** it (`w` for write, `a` for attribute change such as `chmod` or `chown`), and `-k` attaches a searchable **key**. Keys are what make an audit trail usable — without them you are grepping raw kernel records. The `persistence` watch means a second `system-health` file could not be dropped into `/etc/cron.d` unnoticed.

1. Run the following command to load the rules into the running kernel.

    ```bash
    sudo augenrules --load
    ```

    **Expected Output:**

    ```output
    No rules
    enabled 1
    failure 1
    pid 3958
    rate_limit 0
    backlog_limit 8192
    lost 0
    backlog 3
    backlog_wait_time 60000
    backlog_wait_time_actual 0
    ...
    ```

    >**Note:** This output looks alarming but is completely normal. **`No rules`** is `augenrules` reporting that it cleared the *previous* ruleset before loading yours — it is not saying your rules were rejected. It then prints the audit system status two or three times as it works. Ignore all of it and confirm the result with the next command instead.

1. Run the following command to list the rules the kernel is actually enforcing.

    ```bash
    sudo auditctl -l
    ```

    **Expected Output:**

    ```output
    -w /etc/passwd -p wa -k identity
    -w /etc/shadow -p wa -k identity
    -w /etc/group -p wa -k identity
    -w /etc/sudoers -p wa -k privilege
    -w /etc/sudoers.d -p wa -k privilege
    -w /etc/cron.d -p wa -k persistence
    ```

    >**Note:** This is the authoritative check — six rules loaded, matching the file you wrote. `augenrules` compiles every file in `/etc/audit/rules.d/` and loads the result, so the rules are reloaded automatically at every boot. A rule added ad hoc with `auditctl` would disappear on restart — and a rule that does not survive a reboot is not a control.

1. Run the following commands to make a change to `/etc/passwd`, and then find it in the audit trail.

    ```bash
    sudo useradd -m -s /bin/bash audittest
    ```

    ```bash
    sudo ausearch -k identity -i | tail -n 3
    ```

    **Expected Output:**

    ```output
    type=PATH msg=audit(08/10/26 10:01:03.424:104) : item=0 name=/etc/ inode=41 dev=08:01 mode=dir,755 ouid=root ogid=root ... nametype=PARENT ...
    type=CWD msg=audit(08/10/26 10:01:03.424:104) : cwd=/home/azureuser
    type=SYSCALL msg=audit(08/10/26 10:01:03.424:104) : arch=x86_64 syscall=rename success=yes exit=0 ... ppid=4068 pid=4069 auid=azureuser uid=root gid=root euid=root ... comm=useradd exe=/usr/sbin/useradd subj=unconfined key=identity
    ```

    >**Note:** Look closely at two fields on the `SYSCALL` line. **`uid=root`** is the identity the process was running as, while **`auid=azureuser`** is the *audit user ID* — the account that originally logged in. `auid` is set at login and the kernel does not allow it to be changed, even by root. That is what defeats the classic "log in, `sudo su -`, act anonymously as root" pattern.

    >**Note:** Notice `syscall=rename` rather than a write, and `name=/etc/` with `nametype=PARENT` rather than `/etc/passwd`. `useradd` does not edit `/etc/passwd` in place — it writes a complete temporary file and then **renames** it over the original, which is how it avoids leaving a half-written password database if it crashes. The watch still catches it, because renaming a file into `/etc/` modifies the watched path. This is exactly why you audit with a kernel-level tool instead of trying to guess which system call a program will use.

    >**Note:** The watch fires on **any** write to `/etc/passwd`, so creating `svc-backup` with UID 0 would have produced exactly this record. Had auditing been running when the contractor planted that account, you would know who did it and when, instead of finding it months later with no explanation.

1. Run the following command to remove the test account now that you have proved the rule fires.

    ```bash
    sudo userdel -r audittest
    ```

    **Expected Output:**

    ```output
    userdel: audittest mail spool (/var/mail/audittest) not found
    ```

    >**Note:** That warning is harmless and expected. `-r` tries to remove the account's mail spool as well as its home directory, and this server has no mail system installed, so there was no spool to delete. The account and its home directory were removed successfully.

    >**Note:** This deletion is itself written to `/etc/passwd` and generates another `identity` event. Being unable to erase your own tracks is precisely the point of a well-configured audit trail. Using `-r` is safe here because you created this account yourself a moment ago and know its home directory is `/home/audittest` — unlike `svc-backup`, whose home path you had not verified.

1. Run the following command to check the audit system's own status and event counters.

    ```bash
    sudo auditctl -s
    ```

    **Expected Output:**

    ```output
    enabled 1
    failure 1
    pid 3958
    rate_limit 0
    backlog_limit 8192
    lost 0
    backlog 0
    backlog_wait_time 60000
    backlog_wait_time_actual 0
    loginuid_immutable 0 unlocked
    ```

    >**Note:** Watch the **`lost`** counter in particular. A non-zero value means the kernel generated audit events faster than `auditd` could write them and records were dropped, which means gaps in your evidence. If it climbs in production, raise `backlog_limit` or reduce how noisy your rules are.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="b2a67968-b1e4-429e-a7c7-b6067deb921e" />

**Lab 3 Recap:** In this lab, you:

- Learned that Linux authorises on the numeric UID, found a hidden UID 0 account named `svc-backup`, and saw why the UID 1000+ filter from Lab 1 could never have caught it.

- Removed the unauthorised account with `userdel -f`, learning that the force flag was needed precisely *because* the account shared UID 0 with root, and deliberately avoiding `-r` so that a hostile home path could not cause collateral damage.

- Found a rogue `/etc/cron.d` job running a world-writable script as root, proved an unprivileged user could rewrite it, and removed both the job and the script.

- Swept the other locations where scheduled work hides: the `cron.*` directories, user crontabs, and systemd timers.

- Installed `auditd` and wrote persistent rules in `/etc/audit/rules.d/` watching the identity, privilege, and `cron.d` paths, loading them with `augenrules --load` so they survive a reboot.

- Proved the rules fire and interpreted the `auid` field that attributes a privileged action to a specific human.

## You have successfully completed Lab 3.

Now, click on **Next >>** from the lower right corner to move on to the Knowledge Check.

   ![](./Image/nxt.png)
