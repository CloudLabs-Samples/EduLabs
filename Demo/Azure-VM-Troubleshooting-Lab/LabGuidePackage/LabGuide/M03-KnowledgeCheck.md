# Lab 3: Knowledge Check

**Lab Description:** You have restored the Orders platform layer by layer: routing, network security, the guest operating system, managed identity, the storage firewall, and data-plane RBAC. This final page checks that you understood **why** each fix worked, not just which command produced it. Every question refers directly to work you performed in your own environment.

**Estimated Duration:** **10 Minutes**

**Learning Objectives:** By the end of this knowledge check, you will have confirmed that you can:

- Interpret connection symptoms (timeout versus refused) to locate the failing layer

- Explain NSG priority evaluation and how a user-defined route can black-hole return traffic

- Identify the tools that show a network interface's effective configuration

- Explain how a VM obtains a managed identity token and how a system-assigned identity's lifecycle works

- Distinguish a storage firewall rejection from an RBAC rejection, and choose a least-privilege data-plane role

## Before you begin

> **Note:** Each question allows **one retry**. If you are unsure of an answer, the relevant lab page is still available. Click **<< Previous** to review it before answering.

## Questions

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-01.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-02.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-03.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-04.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-05.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-06.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-07.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-08.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-09.md" />

<br>

<question source="https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/Inline-Questions/question-10.md" />

<br>

---

## What you fixed in this lab

| Layer | Fault | Fix |
|-------|-------|-----|
| Routing | A leftover user-defined route sent replies for the jump host subnet to a decommissioned appliance | Deleted the route `to-lab-subnet-via-nva` |
| Network security | `Allow-HTTP-From-LabSubnet` (300) was shadowed by `Deny-HTTP-Inbound` (200) | Moved the allow rule to priority 150 and kept the deny |
| Guest OS | nginx listened on `127.0.0.1:80` only | Changed the bind to `listen 80;`, validated with `nginx -t` |
| Identity | appvm had no managed identity, so IMDS had no token to issue | Enabled a system-assigned managed identity |
| Storage firewall | Selected networks only, with an empty allow list (`AuthorizationFailure`) | Added a `Microsoft.Storage` service endpoint and a VNet rule for `app-subnet` |
| Authorization | The identity had no data-plane role (`AuthorizationPermissionMismatch`) | Granted Storage Blob Data Contributor on the `reports` container |

> **Note:** Both labs used the same method: change **one** thing, re-test, and read how the symptom changes. A timeout that becomes a refusal, or an `AuthorizationFailure` that becomes an `AuthorizationPermissionMismatch`, is not a failed fix. It is evidence that you have moved one layer closer to the application.

### Where to go next

- Replace the service endpoint with a **private endpoint** and a `privatelink.blob.core.windows.net` private DNS zone, so storage is reached on a private IP address and public network access can be disabled entirely.
- Use **Azure Network Watcher** (*IP flow verify*, *Next hop*, and *Connection troubleshoot*) to test NSG and routing decisions without needing a shell on either VM.
- Move from a system-assigned to a **user-assigned managed identity** when several VMs or a scale set need the same access, so that role assignments survive when VMs are rebuilt.
- Enable **storage diagnostic logs** to Log Analytics, where every rejected request is recorded with its error code and caller identity.

### Congratulations! You have successfully completed the Troubleshooting Azure VM Connectivity and Managed Identity Access lab.

### Please click End Lab to complete the lab.
