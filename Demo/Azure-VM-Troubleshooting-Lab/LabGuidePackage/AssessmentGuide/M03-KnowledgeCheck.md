# Module 3: Knowledge Check

## Module Overview

You have restored the Orders platform layer by layer. A validator can confirm that the platform works; it cannot confirm that you know **why** it works, and that is what decides whether you fix the next incident in ten minutes or two hours.

This module checks the reasoning behind the work you did in Modules 1 and 2:

- what a **timeout** and a **connection refused** each tell you about where traffic stopped
- how NSG rules are evaluated, and how a user-defined route can black-hole **return** traffic
- which tools show a network interface's **effective** configuration rather than its declared one
- how a VM obtains a managed identity token without storing a credential, and how a system-assigned identity's lifecycle works
- how to tell a storage **firewall** rejection from an **RBAC** rejection, and how to choose a least-privilege data-plane role

Every question refers to the faults in your own environment. Where a question describes a specific fix - for example a particular NSG priority - read it as the reference fix; the reasoning it tests is the same whichever valid fix you applied.

> **This module is assessed by questions, not by a task.** Each question allows **one retry**. The earlier module pages remain available - click **<< Previous** to review them before answering.

## Question & Answers

Please answer all ten questions before moving on:

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-01.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-02.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-03.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-04.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-05.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-06.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-07.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-08.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-09.md" />

<question source="https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-10.md" />

## Module Summary

You explained each fix in terms of the layer it belonged to and the symptom that pointed to it: a timeout that became a refusal, an `AuthorizationFailure` that became an `AuthorizationPermissionMismatch`. Changing one thing, re-testing, and reading how the symptom moves is the method that transfers to every incident after this one.

### Congratulations! You have successfully completed the Troubleshooting Azure VM Connectivity and Managed Identity Access assessment.

### Please click End Lab to complete the assessment.
