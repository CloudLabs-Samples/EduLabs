## Metadata
Question Type : Multiple Choice

## Question
2. On your lab server labvm-<inject key="DeploymentID" enableCopy="false"/> you offboarded the departed contractor `olduser` in Lab 1. Which TWO of the following statements about that process are TRUE?

## Options
Option 1: Locking the password with `usermod -L` is not sufficient on its own, because an SSH key left in `authorized_keys` would still allow login
Option 2: Disabling the account rather than deleting it preserves file ownership and the audit trail
Option 3: Deleting the account with `userdel` is always preferred, because it immediately removes every trace of the user from the system
Option 4: Setting the login shell to `/usr/sbin/nologin` encrypts the user's home directory

## Answers
Option 1 : 1
Option 2 : 1

## Tags
Linux
Identity
Account Management

## Number of Retries
1
