## Metadata
Question Type : Single Choice

## Question
4. In Lab 3 you found the account `svc-backup` in `/etc/passwd` with UID 0, and it did not appear in the UID 1000+ listing you ran in Lab 1. Which statement best describes the risk it represented?

## Options
Option 1: It had no usable password, so it posed no real risk and removing it was only good housekeeping
Option 2: Linux authorises on the numeric UID rather than the account name, so despite its name the account had full root privileges, and the UID 1000+ filter used for human accounts would never have revealed it
Option 3: It could read files owned by root but could not modify them, because only the account literally named `root` may write to system files
Option 4: The risk came from its `/bin/bash` login shell; changing the shell to `/usr/sbin/nologin` would have fully removed the privilege

## Answers
Option 2 : 1

## Tags
Linux
Identity
Privilege Escalation

## Number of Retries
1
