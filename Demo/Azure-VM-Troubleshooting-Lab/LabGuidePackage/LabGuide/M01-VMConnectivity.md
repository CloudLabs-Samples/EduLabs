# Lab 1: Troubleshoot Azure VM Connectivity

**Lab Description:** The Orders API on **appvm-<inject key="DeploymentID" enableCopy="false"/>** has been unreachable from the operations jump host since last night's change window. Health checks time out, and so does SSH. Three changes went in during that window, and each one broke connectivity at a **different layer**. In this lab you will work through the layers in the order that packets meet them: confirm the VM is running, read the **effective routes** on its network interface, read its **network security group** rules in priority order, and finally look inside the **guest operating system** at what the web server is actually listening on. After each fix you re-test, and how the symptom changes tells you which layer to look at next.

**Estimated Duration:** **25 Minutes**

**Learning Objectives:** By the end of this lab, you will be able to:

- Distinguish a connection that **times out** from one that is **refused**, and explain what each tells you about where traffic stops

- Read the effective route table of a network interface and identify a user-defined route that black-holes traffic

- Explain how NSG rules are evaluated by priority and fix a rule that is being shadowed by a higher-priority deny

- Diagnose a service that is healthy locally but bound only to the loopback address

## Task 1: Restore connectivity from the jump host to the Orders API

In this task, you will sign in to Azure as the lab service principal, reproduce the failure, and then fix a leftover route, an NSG rule-ordering mistake, and an nginx bind address, re-testing after each fix.

### Sign in and reproduce the problem

1. Connect to the **Lab VM** over SSH using the **LabVM SSH Command** and **LabVM Admin Password** on the **Environment** tab.

    ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/env.png)

1. Run the following commands to sign in to the Azure CLI as the lab service principal and select the lab subscription.

    ```bash
    az login --service-principal -u "$AZ_CLIENT_ID" -p "$AZ_CLIENT_SECRET" --tenant "$AZ_TENANT_ID" --output none
    az account set --subscription "$AZ_SUBSCRIPTION_ID"
    az account show --query "{Subscription:name, SignedInAs:user.name, Type:user.type}" -o table
    ```

    **Expected Output:**

    ```output
    Subscription           SignedInAs                            Type
    ---------------------  ------------------------------------  ----------------
    <your subscription>    <your application ID>                 servicePrincipal
    ```

    >**Note:** `Type` is **servicePrincipal**, not **user**. A service principal is an application identity with a client ID and a secret. It is how scripts and pipelines authenticate to Azure non-interactively, and it can only do what its role assignments allow, which here is scoped to your lab resource group.

1. Run the following command to test the Orders API health endpoint on the application server.

    ```bash
    curl -sS -m 5 http://$APP_VM_IP/health
    ```

    **Expected Output:**

    ```output
    curl: (28) Connection timed out after 5001 milliseconds
    ```

1. Run the following command to test SSH (TCP port 22) to the same server.

    ```bash
    nc -zv -w 5 $APP_VM_IP 22
    ```

    **Expected Output:**

    ```output
    nc: connect to 10.0.2.10 port 22 (tcp) timed out: Operation now in progress
    ```

    >**Note:** Pay attention to **how** a connection fails, because it is your first diagnostic clue. A **timeout** means nothing came back at all: a packet was silently dropped somewhere, either on the way in or on the way back. A **connection refused** means the packet reached the machine and the machine actively answered "nobody is listening here". Right now both ports time out, so something in the network path is dropping traffic.

### Rule out the obvious: is the VM running?

1. Run the following command to check the power state of the application server.

    ```bash
    az vm get-instance-view -g $RG -n $APP_VM --query "instanceView.statuses[?starts_with(code,'PowerState')].displayStatus" -o tsv
    ```

    **Expected Output:**

    ```output
    VM running
    ```

    >**Note:** Always check this first. A stopped or deallocated VM produces exactly the same timeouts as a network fault, and it takes five seconds to rule out.

### Layer 1: Check the network security group

1. Run the following command to list the inbound rules on the application server's NSG, sorted in the order Azure evaluates them.

    ```bash
    az network nsg rule list -g $RG --nsg-name $APP_NSG \
      --query "sort_by(@, &priority)[].{Priority:priority, Name:name, Access:access, Port:destinationPortRange, Source:sourceAddressPrefix}" -o table
    ```

    **Expected Output:**

    ```output
    Priority    Name                       Access    Port    Source
    ----------  -------------------------  --------  ------  -----------
    100         Allow-SSH-From-LabSubnet   Allow     22      10.0.1.0/24
    200         Deny-HTTP-Inbound          Deny      80      *
    300         Allow-HTTP-From-LabSubnet  Allow     80      10.0.1.0/24
    ```

1. Study this output before you change anything. SSH on port 22 is **allowed** from the jump host subnet (`10.0.1.0/24`) at priority 100, yet SSH still timed out. So the NSG is not the reason SSH fails, and something else in the path must be dropping traffic. Note the two port 80 rules. You will come back to them.

    >**Note:** **Azure portal checkpoint:** open **appvm-<inject key="DeploymentID" enableCopy="false"/>**, select **Networking**, then **Network settings**, and review the **Inbound port rules**. The portal lists the same three custom rules followed by the default rules (65000 and above).

    ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/m01-portal-nsg-rules.png)

### Layer 2: Check the effective routes

1. Run the following command to show the routes that are actually applied to the application server's network interface. This takes about 30 seconds.

    ```bash
    az network nic show-effective-route-table -g $RG -n $APP_NIC \
      --query "value[?source=='User' || nextHopType=='VnetLocal'].{Source:source, State:state, Prefix:addressPrefix[0], NextHop:nextHopType, NextHopIP:nextHopIpAddress[0]}" -o table
    ```

    **Expected Output:**

    ```output
    Source    State    Prefix       NextHop           NextHopIP
    --------  -------  -----------  ----------------  -----------
    Default   Active   10.0.0.0/16  VnetLocal
    User      Active   10.0.1.0/24  VirtualAppliance  10.0.254.4
    ```

    >**Note:** This is the fault. Azure picks a route by **longest prefix match**, so for any destination in `10.0.1.0/24` (the jump host subnet), the more specific **User** route beats the default `10.0.0.0/16` VNet route. When the application server **replies** to the jump host, the reply is sent to a firewall appliance at `10.0.254.4`. The incident brief says that appliance was decommissioned in CHG-4471. Inbound packets arrive, but every reply is dropped. That is why SSH times out even though the NSG allows it.

1. Run the following command to see the route table that contains this route.

    ```bash
    az network route-table route list -g $RG --route-table-name $ROUTE_TABLE \
      --query "[].{Name:name, Prefix:addressPrefix, NextHop:nextHopType, NextHopIP:nextHopIpAddress}" -o table
    ```

    **Expected Output:**

    ```output
    Name                   Prefix       NextHop           NextHopIP
    ---------------------  -----------  ----------------  -----------
    to-lab-subnet-via-nva  10.0.1.0/24  VirtualAppliance  10.0.254.4
    ```

    >**Note:** **Azure portal checkpoint:** open the network interface **appvm-<inject key="DeploymentID" enableCopy="false"/>-nic**, and under **Help** select **Effective routes**. The user route for `10.0.1.0/24` appears alongside the system routes.

    ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/m01-portal-effective-routes.png)

1. Run the following command to delete the leftover route.

    ```bash
    az network route-table route delete -g $RG --route-table-name $ROUTE_TABLE -n to-lab-subnet-via-nva
    ```

    >**Note:** You delete the **route**, not the route table. The route table stays associated with `app-subnet`, ready for the next legitimate route. Removing a route the change ticket forgot to clean up is the smallest change that fixes the fault.

    >**Note:** **Azure portal checkpoint:** open the route table **rt-app-<inject key="DeploymentID" enableCopy="false"/>** and select **Routes**. The list is now empty, and **Subnets** still shows `app-subnet` associated.

    ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/m01-portal-route-deleted.png)

1. Run the following command to test SSH again.

    ```bash
    nc -zv -w 5 $APP_VM_IP 22
    ```

    **Expected Output:**

    ```output
    Connection to 10.0.2.10 22 port [tcp/ssh] succeeded!
    ```

    >**Note:** If you still see a timeout, wait 30 seconds and retry. Route changes take a few seconds to program into the host.

1. Run the following command to test the health endpoint again.

    ```bash
    curl -sS -m 5 http://$APP_VM_IP/health
    ```

    **Expected Output:**

    ```output
    curl: (28) Connection timed out after 5001 milliseconds
    ```

    >**Note:** SSH is fixed but HTTP still times out, so HTTP must be dropped by something that does not affect SSH. Go back to the two port 80 rules you saw in the NSG.

### Layer 3: Fix the NSG rule priority

1. Look again at the NSG output from earlier. NSG rules are evaluated **in ascending priority order**, and processing **stops at the first rule that matches**. HTTP from the jump host matches `Deny-HTTP-Inbound` at **200** first, so `Allow-HTTP-From-LabSubnet` at **300** is never reached. The allow rule is correct but **shadowed** by the deny.

1. Run the following command to move the allow rule ahead of the deny rule.

    ```bash
    az network nsg rule update -g $RG --nsg-name $APP_NSG -n Allow-HTTP-From-LabSubnet --priority 150 \
      --query "{Name:name, Priority:priority, Access:access, Port:destinationPortRange, Source:sourceAddressPrefix}" -o table
    ```

    **Expected Output:**

    ```output
    Name                       Priority    Access    Port    Source
    -------------------------  ----------  --------  ------  -----------
    Allow-HTTP-From-LabSubnet  150         Allow     80      10.0.1.0/24
    ```

    >**Note:** You did **not** delete `Deny-HTTP-Inbound`. It still blocks HTTP from every other source, which was the intent of the hardening change CHG-4472. Reordering keeps that protection and adds back exactly one narrow exception: the jump host subnet.

1. Run the following command to confirm the new evaluation order.

    ```bash
    az network nsg rule list -g $RG --nsg-name $APP_NSG \
      --query "sort_by(@, &priority)[].{Priority:priority, Name:name, Access:access, Port:destinationPortRange, Source:sourceAddressPrefix}" -o table
    ```

    **Expected Output:**

    ```output
    Priority    Name                       Access    Port    Source
    ----------  -------------------------  --------  ------  -----------
    100         Allow-SSH-From-LabSubnet   Allow     22      10.0.1.0/24
    150         Allow-HTTP-From-LabSubnet  Allow     80      10.0.1.0/24
    200         Deny-HTTP-Inbound          Deny      80      *
    ```

    >**Note:** **Azure portal checkpoint:** refresh **appvm-<inject key="DeploymentID" enableCopy="false"/>** > **Networking** > **Network settings**. `Allow-HTTP-From-LabSubnet` now appears above `Deny-HTTP-Inbound`.

    ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/m01-portal-nsg-fixed.png)

1. Run the following command to test the health endpoint again.

    ```bash
    curl -sS -m 5 http://$APP_VM_IP/health
    ```

    **Expected Output:**

    ```output
    curl: (7) Failed to connect to 10.0.2.10 port 80 after 2 ms: Connection refused
    ```

    >**Note:** The symptom has changed from **timed out** to **connection refused**, and it came back in milliseconds. That is progress: your packet now reaches the VM and the VM's operating system answers. There is no Azure network fault left. Nothing is listening on `10.0.2.10:80`, so the next place to look is inside the VM.

### Layer 4: Check the guest operating system

1. Run the following commands to create an SSH key on the jump host and install it on the application server. When prompted, enter your **LabVM Admin Password**. This is the last time you type it for the application server.

    ```bash
    ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519 -q
    ssh-copy-id -o StrictHostKeyChecking=accept-new azureuser@$APP_VM_IP
    ```

    **Expected Output:**

    ```output
    Number of key(s) added: 1
    ```

    >**Note:** SSH to the application server only works now because you fixed the route. From here on you can run commands on it from the jump host with `ssh azureuser@$APP_VM_IP '<command>'`, which is how you will work in Lab 2 as well.

1. Run the following command to test the health endpoint **from inside** the application server.

    ```bash
    ssh azureuser@$APP_VM_IP 'curl -s http://127.0.0.1/health'
    ```

    **Expected Output:**

    ```output
    orders-api: healthy
    ```

    >**Note:** The service itself is fine. It answers when you ask it from the same machine, but refuses connections from the network. This pattern almost always means a **bind address** problem.

1. Run the following command to see which address and port nginx is listening on.

    ```bash
    ssh azureuser@$APP_VM_IP "sudo ss -tlnp 'sport = :80'"
    ```

    **Expected Output:**

    ```output
    State  Recv-Q Send-Q Local Address:Port Peer Address:Port Process
    LISTEN 0      511        127.0.0.1:80        0.0.0.0:*    users:(("nginx",pid=2140,fd=6),("nginx",pid=2139,fd=6))
    ```

    >**Note:** `127.0.0.1:80` is the loopback address, which is reachable only from processes on the same machine. A server that needs to accept connections from other hosts must listen on its private IP or on all addresses (`0.0.0.0`). Your process IDs will differ.

1. Run the following command to find the line in the nginx site configuration that sets this. The refactor in CHG-4473 introduced it.

    ```bash
    ssh azureuser@$APP_VM_IP 'grep -n listen /etc/nginx/sites-available/orders-api'
    ```

    **Expected Output:**

    ```output
    2:    listen 127.0.0.1:80;
    ```

1. Run the following command to change nginx to listen on all IPv4 addresses, test the configuration, and restart the service.

    ```bash
    ssh azureuser@$APP_VM_IP "sudo sed -i 's/listen 127.0.0.1:80;/listen 80;/' /etc/nginx/sites-available/orders-api && sudo nginx -t && sudo systemctl restart nginx"
    ```

    **Expected Output:**

    ```output
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    ```

    >**Note:** Always run `nginx -t` before restarting. If the configuration has a syntax error, `nginx -t` fails, the `&&` chain stops, and the running service is never taken down with a broken configuration.

1. Run the following command to confirm the new listener.

    ```bash
    ssh azureuser@$APP_VM_IP "sudo ss -tln 'sport = :80'"
    ```

    **Expected Output:**

    ```output
    State  Recv-Q Send-Q Local Address:Port Peer Address:Port Process
    LISTEN 0      511          0.0.0.0:80        0.0.0.0:*
    ```

### Confirm the fix end to end

1. Run the following command from the jump host to test the health endpoint one final time.

    ```bash
    curl -sS -m 5 -w 'HTTP %{http_code}\n' http://$APP_VM_IP/health
    ```

    **Expected Output:**

    ```output
    orders-api: healthy
    HTTP 200
    ```

    >**Note:** Look back at how the symptom changed at each step: **timeout** (route) → **timeout** on HTTP only (NSG) → **connection refused** (OS listener) → **HTTP 200**. Following the symptom layer by layer, rather than changing several things at once, is what lets you say exactly which change fixed which fault.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the guide.
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="c01064cb-4a5f-4407-916d-1afaf293b658" />

**Lab 1 Recap:** In this lab, you:

- Signed in to Azure as a service principal and confirmed the target VM was running before you investigated the network.

- Used the difference between **timed out** and **connection refused** to locate the layer where traffic stopped.

- Read the effective route table of the application server's NIC and removed a leftover user-defined route that sent return traffic to a decommissioned appliance.

- Fixed an NSG allow rule shadowed by a higher-priority deny by **reordering** it, keeping the hardening rule in place.

- Found that nginx was bound to `127.0.0.1` and changed it to listen on all addresses, validating the configuration before restarting.

## You have successfully completed Lab 1.

Now, click on **Next >>** from the lower right corner to move on to the next page.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/next1.png)
