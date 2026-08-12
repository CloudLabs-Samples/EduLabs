# Lab 4: Knowledge Check

**Lab Description:** You have taken an unmanaged Ubuntu server and brought it to a defensible baseline across identity, permissions, and detection. This final page checks that you understood **why** each change mattered, not just which command produced it. Every question refers directly to work you performed on your own lab server.

**Estimated Duration:** **10 Minutes**

**Learning Objectives:** By the end of this knowledge check, you will have confirmed that you can:

- Explain why an unnecessary SUID root binary is a privilege escalation risk

- Justify disabling rather than deleting an account during offboarding, and identify what password locking alone leaves open

- Recall the restrictive default `umask` you applied and what it achieves

- Explain why an account with UID 0 holds full root privileges regardless of its name

- Identify the audit field that attributes a privileged action to a specific human

## Before you begin

> **Note:** Each question allows **one retry**. If you are unsure of an answer, the relevant lab page is still available — click **<< Previous** to review it before answering.

## Questions

<question source="Question1.md" />

<br>

<question source="Question2.md" />

<br>

<question source="Question3.md" />

<br>

<question source="Question4.md" />

<br>

<question source="Question5.md" />

<br>

---

## What you built in this lab

| Lab | Control type | What you established |
|-----|--------------|----------------------|
| Lab 1 | Identity and access | A group-based access model, a 90-day password ageing policy, a properly offboarded account, and least-privilege `sudo` |
| Lab 2 | Data protection | Customer records and API keys restricted to the accounts that need them, a `027` default `umask`, and no unnecessary SUID root binaries |
| Lab 3 | Detection and response | A hidden UID 0 account and a rogue root cron job found and removed, plus kernel-level auditing of identity, privilege, and `cron.d` changes |

> **Note:** The pattern underneath these three labs is the one that structures nearly every security framework you will meet, from the CIS Controls to ISO 27001: know who your users are, give them the least access that works, remove what should not be there, and record what happens so you can investigate. The commands change between operating systems; that sequence does not.

### Where to go next

- Keep the software patched. Apply security updates with `apt-get upgrade` and automate them with `unattended-upgrades`, which by default installs from the security repositories only.
- Harden the SSH daemon: disable direct root login, lower `MaxAuthTries`, and move from password authentication to SSH keys — the single highest-impact remote access control.
- Enable a host firewall such as UFW with a default-deny inbound policy, and add Fail2ban so repeated failed logins result in an automatic temporary ban.
- Forward the systemd journal and audit trail to a central collector, so evidence survives a compromise of the host itself.
- Measure your host against a published benchmark such as the **CIS Ubuntu Linux 22.04 LTS Benchmark**, which formalises most of what you configured here.

### Congratulations! You have successfully completed the Introduction to IT Security lab.

### Please click End Lab to complete the lab.
