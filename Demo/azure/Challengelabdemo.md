# Challenge 1: Resolving a Windows Domain Account Lockout

## Objective

Diagnose and resolve a domain user account lockout and validate successful authentication from the Technician VM.

## Scenario

The user CONTOSO\enduser1 is locked out of the domain after multiple failed sign-in attempts.

As a helpdesk technician, you must investigate the issue, restore access to the account, and confirm that the user can successfully sign in using the CloudLabs-provisioned environment.

## Lab Environment (Provisioned by CloudLabs)

When the lab is launched, CloudLabs automatically provisions:

- Technician VM

- Domain-joined to CONTOSO

- Logged in using a helpdesk-level account

- Used for investigation, remediation, and validation

- Active Directory Domain Services

- Domain: CONTOSO

- Affected user: CONTOSO\enduser1 (pre-locked)

## Success Criteria

The challenge is considered successfully completed when:

- CONTOSO\enduser1 is no longer locked out

- The account remains enabled

- Successful sign-in as CONTOSO\enduser1 is confirmed on the Technician VM

- No password reset was performed
