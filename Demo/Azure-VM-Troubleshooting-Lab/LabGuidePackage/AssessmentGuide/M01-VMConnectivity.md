# Module 1: Troubleshoot Azure VM Connectivity

## Module Overview

When a service stops answering, the temptation is to change several things at once until it works. That gets the service back and leaves nobody able to say what was wrong, which means the same fault comes back in the next change window.

The disciplined approach follows the packet. Traffic from the jump host to the Orders API meets the layers in a fixed order, and each layer fails in a recognisable way:

- **Is the VM running?** A stopped VM looks exactly like a network fault and takes five seconds to rule out.
- **Can the reply get back?** Routing applies to return traffic too. A route that sends replies somewhere they cannot arrive produces a **timeout** even when every inbound rule is correct.
- **Is the packet allowed in?** NSG rules are evaluated in priority order and processing stops at the first match. A correct rule can be shadowed by an earlier one.
- **Is anything listening?** Once the network is open, a packet that reaches a VM with nothing listening on the right address comes back as **connection refused** - in milliseconds, not seconds.

The single most useful diagnostic clue in this module is the difference between a **timeout** and a **refusal**. A timeout means a packet was silently dropped somewhere in the path. A refusal means the packet arrived and the operating system answered. Watch how the symptom changes after every fix; it tells you which layer to look at next.

Three changes went into the window that broke this service. Each broke it at a different layer.

## Module Objectives

* Task: Restore connectivity from the jump host to the Orders API

> **Note:** SSH to the Lab VM and sign in to Azure as the service principal first. Read `~/LabFiles/scenario-brief.txt` before you change anything - the change log tells you which network appliance was decommissioned and which hardening change must survive your fix.

## Task: Restore connectivity from the jump host to the Orders API

**Situation:** From the jump host, both `curl -m 5 http://$APP_VM_IP/health` and an SSH connection to the application server **time out**. The application server is in `app-subnet` (`10.0.2.0/24`); the jump host is in `lab-subnet` (`10.0.1.0/24`). The application server's NIC is associated with an NSG and its subnet with a route table, both in your resource group.

**Required outcome:**

**1a - Routing.** Return traffic from the application server to `lab-subnet` must be delivered. No user-defined route may send traffic for `10.0.1.0/24` to a virtual appliance that no longer exists. Make the **smallest** change that achieves this - remove what is wrong, not what is around it.

**1b - Network security.** HTTP (TCP/80) from the jump host (`10.0.1.10`) to the application server must be **allowed** by the first NSG rule that matches it. At the same time:

- the intent of the HTTP hardening change must survive - HTTP from any other source must remain blocked
- **no** inbound Allow rule for port 80 may have a source of `*`, `Any`, `Internet` or `0.0.0.0/0`

**1c - The guest operating system.** The Orders API must accept connections on the application server's private address, not only from the server itself. Validate any web server configuration change before you restart the service, so that a syntax error never takes the running service down.

**1d - End to end.** From the jump host:

```
curl -sS -m 5 -w 'HTTP %{http_code}\n' http://$APP_VM_IP/health
```

must return:

```
orders-api: healthy
HTTP 200
```

**Pointers:** `az vm get-instance-view` tells you whether the VM is running. `az network nic show-effective-route-table` shows the routes actually programmed onto a NIC, including where they came from (`Default` or `User`) - it takes about 30 seconds to return. `az network route-table route --help` and `az network nsg rule --help` list everything you need to inspect and change routes and rules; use a JMESPath `sort_by(@, &priority)` query to read NSG rules in the order Azure evaluates them. Inside the VM, `ss -tlnp` shows which address and port each process is listening on. To work on the application server from the jump host, create an SSH key with `ssh-keygen` and install it with `ssh-copy-id`, then run remote commands as `ssh azureuser@$APP_VM_IP '<command>'` - you will need this access again in Module 2.

> **Opening port 80 to `*` or `Internet` gets you HTTP 200 and fails the task.** The validator's exposure check rejects any internet-facing Allow rule for port 80, however the rest of the configuration looks. Deleting the HTTP deny rule, or removing the route table rather than the one stale route, is not a fix either: both throw away a deliberate change to clear a fault that only needed one rule reordered and one route removed. An engineer reviewing your change would reject it.

> **Read the symptom after every change.** If SSH works but HTTP still times out, the remaining fault is one that affects port 80 and not port 22. If HTTP changes from a timeout to a refusal, the network is no longer your problem.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="c01064cb-4a5f-4407-916d-1afaf293b658" />

## Module Summary

You restored the Orders API layer by layer - routing, network security and the guest OS - and you did it without undoing the hardening that came with the change window. Click **Next** to continue with **Module 2: Restore VM Access to Azure Storage Using Managed Identity**.
