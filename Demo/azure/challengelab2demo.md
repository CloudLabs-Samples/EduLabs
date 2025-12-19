# Challenge 2: Resolving a Network Resource Access Error

## Objective

Diagnose and resolve a network connectivity issue preventing access to an internal web application and validate successful access from the Client VM.

## Scenario

A user reports that they are unable to access the internal application hosted at:

https://app.contoso.local

The issue occurs when accessing the application from their workstation (Client VM).
As a helpdesk technician, you must investigate the problem using the Technician VM, remediate the issue, and confirm that access to the application is successfully restored.

## Lab Environment

When the lab is launched, CloudLabs automatically provisions the following resources:

Technician VM

Domain-joined to CONTOSO

Logged in using a helpdesk-level account

Used only for investigation and remediation

Client VM

Domain-joined end-user workstation

Used only to validate application access

Application Server (APP01)

Hosts the internal web application

Domain-joined to CONTOSO

Accessible only through internal network connectivity

Internal Application

URL: https://app.contoso.local

Uses HTTPS for secure access

## Challenge Workflow

Learners must complete the following tasks using the CloudLabs environment.
No commands, scripts, or step-by-step instructions are provided.

## Task 1: Reproduce and Analyze the Issue

Using the Client VM:

Attempt to access the internal application

Use appropriate diagnostic tools to determine:

Whether name resolution is working

Whether basic network connectivity exists

Whether the issue is related to a specific service or port

## Task 2: Investigate the Application Server

Using the Technician VM:

Access the application server (APP01) using approved administrative methods

Review relevant system and network configurations

Identify any security controls or rules that may be blocking access to the application

## Task 3: Remediate the Connectivity Issue

On the application server:

Correct the configuration preventing access to the application

Ensure the change restores secure HTTPS connectivity

Avoid making unnecessary or unrelated configuration changes

## Task 4: Validate Application Access

Using the Client VM:

Reattempt access to https://app.contoso.local

Confirm that the application loads successfully

Validate that access is restored without connectivity errors

## Success Criteria

The challenge is considered successfully completed when:

The internal application at https://app.contoso.local is reachable

HTTPS connectivity is successfully established

The application loads correctly from the Client VM

No access or connectivity errors are observed

**Congratulations on completing this challenge!**
