# Module 2: Restore VM Access to Azure Storage Using Managed Identity

## Module Overview

Every night, the application server uploads the orders report to Azure Blob Storage. In the same change window, the storage account's **access keys were disabled** (CHG-4480) and its firewall was switched to **selected networks** (CHG-4481). The job was rewritten to authenticate with the VM's **managed identity**, so no key, connection string or SAS token is stored anywhere on the VM. It has failed ever since.

Both changes were the right call, and neither is to be reversed. Your job is to make the secure configuration work, not to make the job work by making the configuration less secure.

A VM needs three independent things before it can write to a locked-down storage account with a managed identity, and they are checked in this order:

1. **An identity to authenticate as.** The job asks the Instance Metadata Service (IMDS) at `169.254.169.254` for a token. IMDS can only issue one if the VM has a managed identity.
2. **A network path the storage firewall accepts.** The firewall rejects a request based on **where it came from**, before it looks at who is asking.
3. **A data-plane role that authorises the request.** Storage then checks whether the authenticated identity is **allowed to write blobs**. Control-plane roles such as Owner and Contributor manage the storage account resource; they do not grant access to the data inside it.

Each layer fails with a different message, and the storage layers fail with different **error codes** under the same HTTP 403. The job prints which step failed and why. Read it after every change.

## Module Objectives

* Task: Restore the report upload using the VM's managed identity

> **Note:** This module continues in the same jump host session as Module 1. If your SSH session has closed, reconnect and sign in again. Your SSH key to the application server is still in place. Shell variables you set do not survive a disconnect.

## Task: Restore the report upload using the VM's managed identity

**Situation:** Running `ssh azureuser@$APP_VM_IP /opt/app/sync-reports.sh` from the jump host fails at step 1 of 3. The job's configuration is in `/opt/app/app.env` on the application server. The storage account is <inject key="Storage Account Name" enableCopy="true"/> and the container is `reports`.

**Required outcome:**

**2a - Identity.** The application server has a **system-assigned** managed identity, and IMDS issues a token for it.

**2b - Storage firewall.** The storage firewall admits traffic from `app-subnet`, and from nothing else you have added:

- the firewall's **default action remains `Deny`**
- a **virtual network rule** for `app-subnet` is present on the storage account
- public network access is **not** disabled (the service-endpoint path depends on it)
- shared key access stays disabled - do not re-enable access keys

**2c - Authorisation.** The managed identity holds a **data-plane** role that permits writing blobs, scoped as narrowly as the job allows. The job writes to one container only; the expected least-privilege answer is **Storage Blob Data Contributor on the `reports` container**. A role at account scope is the widest that is accepted. A control-plane role does not satisfy this outcome, however broad.

**2d - End to end.** Run the report job. It must complete all three steps and finish with:

```
Sync complete - the managed identity can reach and write to storage.
```

The blob `reports/orders-report-latest.txt` must exist, because the validator reads it back with a **fresh** IMDS token from inside the application server. A configuration that is correct but has never been exercised by the job fails 2d.

**Pointers:** `az vm identity --help` covers enabling and reading a VM's identity; the identity's `principalId` is what you grant roles to. `az storage account show --query networkRuleSet` and `--query allowSharedKeyAccess` show the firewall and key settings. A storage firewall can only match on a subnet once that subnet has a **`Microsoft.Storage` service endpoint** - see `az network vnet subnet update --help` and `az storage account network-rule --help`. The resource ID of a single container is the storage account's ID followed by `/blobServices/default/containers/<name>`. When creating a role assignment for an identity created minutes ago, `--assignee-object-id` with `--assignee-principal-type ServicePrincipal` avoids a directory lookup that may not have replicated yet.

> **`AuthorizationFailure` and `AuthorizationPermissionMismatch` are different faults.** Both are HTTP 403. The first comes from the storage **firewall** and means the request was rejected for where it came from. The second means the firewall let it through and storage **authenticated** the identity, but the identity is not **authorised** for the operation. If you change the firewall and the error code changes, that is progress, not a failed fix.

> **Switching the firewall to "all networks" makes the 403 go away and fails the task**, because the validator requires the default action to stay `Deny`. Re-enabling access keys is equally wrong: the job does not use them, and it undoes a change the security team made on purpose. Allowing exactly one subnet is the least-privilege fix.

> **Azure RBAC is eventually consistent.** A new role assignment can take one to two minutes, occasionally longer, before storage honours it, and a network rule can take around 30 seconds. One or two `AuthorizationPermissionMismatch` results after a correct role assignment are normal. Retry before you conclude the fix is wrong.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="d2954a3e-d480-42af-ae6e-f3c1159a45e8" />

## Module Summary

The report job now authenticates with an identity Azure manages, reaches storage over a path the firewall can verify, and holds exactly the permission it needs - and the access keys and the firewall are still locked down. Click **Next** to continue with **Module 3: Knowledge Check**.
