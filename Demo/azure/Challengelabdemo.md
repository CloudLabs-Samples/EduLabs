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
 
   - Note: CONTOSO\enduser1 is a standard domain user associated with the Client VM.
For this challenge, authentication is intentionally validated by signing in as the user from the Technician VM to demonstrate identity troubleshooting capabilities.
 
## Challenge Workflow

Learners must complete the following tasks using the CloudLabs environment.
No commands or step-by-step instructions are provided.

## Task 1: Investigate the Account Lockout

Using the Technician VM:

Identify why CONTOSO\enduser1 is unable to authenticate

Verify the current status of the user account in Active Directory

Confirm that the issue is related to an account lockout

## Task 2: Remediate the Issue

If the account is confirmed to be locked:

Restore access using appropriate domain administrative actions

Ensure the account remains enabled

Do not reset or change the user’s password

## Task 3: Validate User Sign-In

From the Technician VM:

Sign out of the current session or switch user

Attempt to sign in as CONTOSO\enduser1

Confirm successful authentication without lockout errors

## User Credentials (For Validation)

Use the following credentials only for validation after remediation:

User Name: CONTOSO\enduser1

Password: Summer!2025

## Success Criteria

The challenge is considered successfully completed when:

- CONTOSO\enduser1 is no longer locked out

- The account remains enabled

- Successful sign-in as CONTOSO\enduser1 is confirmed on the Technician VM

- No password reset was performed
