# Challenge 1: Resolving a Windows Domain Account Lockout

## Objective

Diagnose and resolve a domain user account lockout and validate successful authentication by signing in to the Client VM using the affected domain user.

## Scenario

**HELPDESK TICKET #HD-2847 | Priority: HIGH | Status: ASSIGNED TO YOU**

---
**From:** enduser1 (enduser1@contoso.local)
**Subject:** URGENT - Cannot access my computer before client presentation
**Time Reported:** Monday, 8:15 AM
---

**Issue Description:**

"I can't log into my computer this morning! I've tried entering my password several times, but now it won't even let me attempt to sign in anymore. I keep getting an error message about my account.

This is urgent - I have a critical client presentation at 10:00 AM and all my presentation files are on my work computer. I haven't had any issues before, and I'm certain I'm using the correct password. Please help me get back into my system as soon as possible!"

**Your Mission:**

As the on-call helpdesk technician at Contoso Corporation, you have less than 2 hours to resolve this issue. You must:

- Investigate why CONTOSO\enduser1 (enduser1) cannot authenticate
- Diagnose the root cause using the Technician VM
- Restore access to her account following proper security protocols
- Validate that she can successfully sign in without further issues

**Important:** enduser1 is a sales manager who needs immediate access to prepare for a high-stakes client meeting. Time is critical, but security protocols must still be followed.

 ![](images/enduser1lock.png)

## Lab Environment

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

- Login to Client VM and identify why CONTOSO\enduser1 is unable to authenticate

- Verify the current status of the user account in Active Directory

- Confirm that the issue is related to an account lockout

## Task 2: Remediate the Issue

If the account is confirmed to be locked:

- Restore access using appropriate domain administrative actions

- Ensure the account remains enabled

- Do not reset or change the user’s password

## Task 3: Validate User Sign-In

From the Technician VM:

- Sign out of the current session or switch user

- Attempt to sign in as CONTOSO\enduser1

- Confirm successful authentication without lockout errors

## User Credentials (For Validation)

Use the following credentials only for validation after remediation:

User Name: CONTOSO\enduser1

Password: Summer!2025

## Success Criteria

The challenge is considered successfully completed when:

- CONTOSO\enduser1 is no longer locked out

- The account remains enabled

- Successful RDP sign-in to the Client VM as CONTOSO\enduser1 is confirmed

- No password reset was performed

**Congratulations on completing the Challenge!** Now, it's time to validate it. Here are the steps:

Hit the Validate button for the corresponding Challenge. If you receive a success message, you can proceed to the next Challenge.
If not, carefully read the error message and retry the step, following the instructions in the lab guide.

## Validation 1: Resolving a Windows Domain Account Lockout

<validation step="7392ee95-d1a9-44f3-8313-59715a3b172c" />

Now, click Next to continue to Challenge 02.
