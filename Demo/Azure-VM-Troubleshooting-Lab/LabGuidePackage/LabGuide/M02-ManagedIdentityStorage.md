# Lab 2: Restore VM Access to Azure Storage Using Managed Identity

**Lab Description:** Every night, **appvm-<inject key="DeploymentID" enableCopy="false"/>** uploads the orders report to the storage account **<inject key="Storage Account Name" enableCopy="false"/>**. As part of the change window, the storage account's **access keys were disabled** (CHG-4480) and its firewall was switched to **selected networks** (CHG-4481). The job was rewritten to authenticate with the VM's **managed identity**, which means no secret is stored anywhere on the VM. It has failed ever since. In this lab you will run the job, read exactly where and why it fails, and fix the three things a VM needs before it can reach storage with a managed identity: **an identity to authenticate as, a network path the storage firewall accepts, and a data-plane role that authorizes the request**.

**Estimated Duration:** **25 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Explain how a VM obtains a managed identity token from the Instance Metadata Service (IMDS) without storing any credential

- Enable a system-assigned managed identity on a VM and identify its principal ID

- Distinguish a storage **firewall** rejection (`AuthorizationFailure`) from an **RBAC** rejection (`AuthorizationPermissionMismatch`)

- Allow a subnet through a storage firewall using a service endpoint and a virtual network rule

- Grant least-privilege, data-plane access with a Storage Blob Data role scoped to a single container

## Task 1: Restore the report upload using the VM's managed identity

In this task, you will enable a system-assigned managed identity on the application server, allow its subnet through the storage firewall, and grant it a data-plane role on the `reports` container, running the report job after each change to see what it reports next.

>**Note:** Lab 2 continues in the same jump host session as Lab 1. If your SSH session has closed, reconnect and sign in again with the two `az login` / `az account set` commands from the start of Lab 1. Your SSH key to the application server is still in place.

### Reproduce the failure

1. Run the following command to view the report job's configuration on the application server.

    ```bash
    ssh azureuser@$APP_VM_IP 'cat /opt/app/app.env'
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">STORAGE_ACCOUNT=stapp&lt;DeploymentID&gt;
    STORAGE_CONTAINER=reports
    REPORT_BLOB=orders-report-latest.txt</div>

    >**Note:** The file contains a storage account name, a container, and a blob name, and **no key, connection string, or SAS token**. The job gets its credential at run time from the VM's managed identity.

1. Run the following command to run the report job.

    ```bash
    ssh azureuser@$APP_VM_IP /opt/app/sync-reports.sh
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">[1/3] Requesting an access token from the Instance Metadata Service (IMDS)
          FAILED - IMDS returned HTTP 400
          {"error":"invalid_request","error_description":"Identity not found"}</div>

    >**Note:** The job asks the **Instance Metadata Service** for a token. IMDS is a REST endpoint at the fixed, non-routable address **`169.254.169.254`**, available only from inside an Azure VM. When the VM has a managed identity, IMDS returns an OAuth access token for it, and Azure handles the underlying credential and rotates it for you. `Identity not found` means this VM has no managed identity at all, so there is nothing for IMDS to issue a token for.

### Fix 1: Enable a system-assigned managed identity

1. Run the following command to confirm that the VM has no identity.

    ```bash
    az vm identity show -g $RG -n $APP_VM
    ```

    >**Note:** The command returns nothing. An empty result here means no identity is configured.

1. Run the following command to enable a **system-assigned** managed identity on the application server.

    ```bash
    az vm identity assign -g $RG -n $APP_VM
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">{
      "systemAssignedIdentity": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "userAssignedIdentities": {}
    }</div>

    >**Note:** A **system-assigned** identity is created in Microsoft Entra ID and tied to the lifecycle of this one VM: when the VM is deleted, the identity is deleted with it. A **user-assigned** identity is a separate Azure resource that you create yourself, can attach to several VMs, and that survives when they are deleted.

1. Run the following command to save the identity's **principal ID** (its object ID in Entra ID) into a shell variable. You will use it to grant access later.

    ```bash
    PRINCIPAL_ID=$(az vm identity show -g $RG -n $APP_VM --query principalId -o tsv)
    echo $PRINCIPAL_ID
    ```

    >**Note:** Shell variables do not survive a disconnect. If your SSH session drops, run this command again before you continue.

1. Run the report job again.

    ```bash
    ssh azureuser@$APP_VM_IP /opt/app/sync-reports.sh
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">[1/3] Requesting an access token from the Instance Metadata Service (IMDS)
          OK - token issued to managed identity xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    [2/3] Uploading orders-report-latest.txt to https://stapp&lt;DeploymentID&gt;.blob.core.windows.net/reports/
          FAILED - Storage returned HTTP 403 (AuthorizationFailure)
          This request is not authorized to perform this operation.</div>

    >**Note:** Step 1 now succeeds, and the ID in the token matches the `PRINCIPAL_ID` you just printed. Step 2 fails with **`AuthorizationFailure`**. Learn to recognize this error code: it comes from the **storage firewall**, which rejects the request based on where it came from **before it even looks at who is asking**. If IMDS still returns `Identity not found`, wait 30 seconds and retry, because a new identity can take a moment to reach the host.

### Fix 2: Allow the application subnet through the storage firewall

1. Run the following command to inspect the storage account's network configuration.

    ```bash
    az storage account show -g $RG -n $STORAGE_ACCOUNT \
      --query "{PublicNetworkAccess:publicNetworkAccess, DefaultAction:networkRuleSet.defaultAction, VnetRules:length(networkRuleSet.virtualNetworkRules), IpRules:length(networkRuleSet.ipRules), SharedKey:allowSharedKeyAccess}" -o table
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">PublicNetworkAccess    DefaultAction    VnetRules    IpRules    SharedKey
    ---------------------  ---------------  -----------  ---------  -----------
    Enabled                Deny             0            0          False</div>

    >**Note:** Read this as: the public endpoint is **enabled from selected networks only** (`DefaultAction: Deny`), and the list of selected networks is **empty**, so no virtual network and no IP address is allowed in. `SharedKey: False` confirms that access keys are disabled, so Microsoft Entra ID (your managed identity) is the only way in.

1. Run the following command to check whether the application subnet has a service endpoint for Azure Storage.

    ```bash
    az network vnet subnet show -g $RG --vnet-name $VNET_NAME -n $APP_SUBNET --query "serviceEndpoints[].service" -o tsv
    ```

    >**Note:** No output means **no service endpoints**. Without a `Microsoft.Storage` service endpoint, traffic from the VM reaches storage from the VM's **public IP address**, and the storage firewall has no way of knowing that it came from your virtual network.

1. Run the following command to enable the `Microsoft.Storage` service endpoint on the application subnet.

    ```bash
    az network vnet subnet update -g $RG --vnet-name $VNET_NAME -n $APP_SUBNET --service-endpoints Microsoft.Storage \
      --query "serviceEndpoints[].{Service:service, State:provisioningState}" -o table
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">Service            State
    -----------------  ---------
    Microsoft.Storage  Succeeded</div>

    >**Note:** A service endpoint changes the **source identity** of the traffic. Requests from `app-subnet` to Azure Storage now travel over the Azure backbone and arrive tagged with the virtual network and subnet they came from, which is information the storage firewall can match on.

1. Run the following command to add a virtual network rule that allows `app-subnet` through the storage firewall.

    ```bash
    az storage account network-rule add -g $RG --account-name $STORAGE_ACCOUNT --vnet-name $VNET_NAME --subnet $APP_SUBNET --output none
    ```

    >**Note:** The two steps are needed **together**. The service endpoint makes the traffic identifiable, and the network rule tells the firewall to accept that subnet. If you add the rule before the endpoint exists, Azure rejects it, because the subnet has no `Microsoft.Storage` service endpoint.

1. Run the following command to confirm the firewall now allows one virtual network rule and still denies everything else.

    ```bash
    az storage account show -g $RG -n $STORAGE_ACCOUNT \
      --query "{PublicNetworkAccess:publicNetworkAccess, DefaultAction:networkRuleSet.defaultAction, VnetRules:length(networkRuleSet.virtualNetworkRules), IpRules:length(networkRuleSet.ipRules), SharedKey:allowSharedKeyAccess}" -o table
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">PublicNetworkAccess    DefaultAction    VnetRules    IpRules    SharedKey
    ---------------------  ---------------  -----------  ---------  -----------
    Enabled                Deny             1            0          False</div>

    >**Note:** `DefaultAction` is still **Deny**. The tempting "fix" of switching the firewall to **Enabled from all networks** would also make this error disappear, but it would undo CHG-4481 and expose the account to the whole internet. Allowing exactly one subnet is the least-privilege fix.

1. Wait about 30 seconds for the network rule to take effect, then run the report job again.

    ```bash
    ssh azureuser@$APP_VM_IP /opt/app/sync-reports.sh
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">[1/3] Requesting an access token from the Instance Metadata Service (IMDS)
          OK - token issued to managed identity xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    [2/3] Uploading orders-report-latest.txt to https://stapp&lt;DeploymentID&gt;.blob.core.windows.net/reports/
          FAILED - Storage returned HTTP 403 (AuthorizationPermissionMismatch)
          This request is not authorized to perform this operation using this permission.</div>

    >**Note:** Still a 403, but the error code has changed to **`AuthorizationPermissionMismatch`**. This means the firewall let the request through and storage **authenticated** the identity successfully, but the identity is not **authorized** to write blobs. If you still see `AuthorizationFailure`, the network rule has not propagated yet. Wait another 30 seconds and retry.

### Fix 3: Grant a data-plane role on the container

1. The new identity has **no role assignments at all**. Even if it had **Owner** or **Contributor** on the storage account, the upload would still fail. Those are **control-plane** roles: they allow managing the storage account resource (its settings, firewall, and tags), but they do **not** include permission to read or write the data inside it. Blob data access needs a **data-plane** role such as **Storage Blob Data Reader** or **Storage Blob Data Contributor**.

1. Run the following command to build the resource ID of the `reports` container. This is the narrowest scope at which you can grant blob access.

    ```bash
    CONTAINER_SCOPE="$(az storage account show -g $RG -n $STORAGE_ACCOUNT --query id -o tsv)/blobServices/default/containers/$STORAGE_CONTAINER"
    echo $CONTAINER_SCOPE
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">/subscriptions/&lt;subscription-id&gt;/resourceGroups/&lt;resource-group&gt;/providers/Microsoft.Storage/storageAccounts/stapp&lt;DeploymentID&gt;/blobServices/default/containers/reports</div>

1. Run the following command to grant the managed identity the **Storage Blob Data Contributor** role on the `reports` container only.

    ```bash
    az role assignment create --assignee-object-id $PRINCIPAL_ID --assignee-principal-type ServicePrincipal \
      --role "Storage Blob Data Contributor" --scope $CONTAINER_SCOPE --output none
    ```

    >**Note:** **Contributor** is the least role that works, because the job writes as well as reads. **Reader** would allow listing but not the upload. Scoping to the **container** rather than the storage account means the identity cannot touch any other container, even ones added later. `--assignee-principal-type ServicePrincipal` tells Azure what kind of principal this is, because a managed identity is a special kind of service principal. That lets the command skip a directory lookup that may not have replicated yet for an identity created seconds ago.

1. Run the following command to confirm the role assignment.

    ```bash
    az role assignment list --scope $CONTAINER_SCOPE --query "[?principalId=='$PRINCIPAL_ID'].{Role:roleDefinitionName, Principal:principalId}" -o table
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">Role                           Principal
    -----------------------------  ------------------------------------
    Storage Blob Data Contributor  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx</div>

1. Run the following command to run the report job, retrying every 30 seconds until the role assignment has propagated. It normally succeeds within two minutes.

    ```bash
    for i in 1 2 3 4 5 6 7 8; do
      ssh azureuser@$APP_VM_IP /opt/app/sync-reports.sh && break
      echo "--- role assignment still propagating, retrying in 30 seconds ($i/8) ---"; sleep 30
    done
    ```

    **Expected Output:**

    <div style="font-family: Consolas, 'Courier New', monospace; font-size: 13px; line-height: 1.45; background-color: #f4f4f4; border: 1px solid #d4d4d4; border-radius: 4px; padding: 10px 12px; white-space: pre-wrap; overflow-wrap: anywhere; user-select: none;">[1/3] Requesting an access token from the Instance Metadata Service (IMDS)
          OK - token issued to managed identity xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    [2/3] Uploading orders-report-latest.txt to https://stapp&lt;DeploymentID&gt;.blob.core.windows.net/reports/
          OK - HTTP 201 Created
    [3/3] Listing blobs in container 'reports'
          orders-report-latest.txt
    Sync complete - the managed identity can reach and write to storage.</div>

    >**Note:** Azure RBAC changes are **eventually consistent**. A new role assignment can take a minute or two, and occasionally longer, before storage honors it. One or two `AuthorizationPermissionMismatch` retries before the success is normal. The loop exists so you do not mistake propagation delay for a wrong fix.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="d2954a3e-d480-42af-ae6e-f3c1159a45e8" />

**Lab 2 Recap:** In this lab, you:

- Saw how a VM gets a token from IMDS at `169.254.169.254` without any stored secret, and enabled a **system-assigned managed identity** so that IMDS had an identity to issue one for.

- Recognized **`AuthorizationFailure`** as a storage **firewall** rejection, and fixed it with a `Microsoft.Storage` **service endpoint** on the subnet plus a **virtual network rule** on the account, keeping the default action at Deny.

- Recognized **`AuthorizationPermissionMismatch`** as an **RBAC** rejection of an authenticated identity, and learned why control-plane roles such as Owner and Contributor do not grant access to blob data.

- Granted **Storage Blob Data Contributor** scoped to a single container, and allowed for RBAC propagation delay before judging the fix.

## You have successfully completed Lab 2.

Now, click on **Next >>** from the lower right corner to move on to the Knowledge Check.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/next1.png)
