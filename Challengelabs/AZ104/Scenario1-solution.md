## Scenario 1: Solution
You are provided with two Azure Virtual Networks Vnet1 and Vnet2 in a resource group, these virtual networks can be in the same region or different regions.

i. A web server is deployed in the virtual network Vnet1

ii. A windows virtual machine is deployed in the virtual network Vnet2

At the end of the challenge, you should be able to:

i. Access the web server deployed in the virtual network Vnet1 over a browser

ii. Establish the communication between the two virtual machines.

### Skills tested: 
Azure Networking

## Steps

## Access the web server deployed in the virtual network Vnet1 over a browser

1. Click on the **Azure Portal** icon on the VM desktop and login with the Azure credentials from the Lab Environment output page.

2. On the **Sign in to Microsoft Azure** blade, you will see a login screen, in which enter the following email/username and then click on **Next**.  

   * **Azure Username/Email**:  <inject key="AzureAdUserEmail"></inject> 
   * **Azure Password**:  <inject key="AzureAdUserPassword"></inject>

        **Note**: Refer to the **Environment Details** tab for any other lab credentials/details.

3. From the **Search resources, Services, and docs(G+/)** blade, search for and select **Virtual machines**, and then choose the virtual machine **labvm**

4. Copy the **Public IP address** from the labvm's **Overview** blade and access the web server through a server.
   
   >You will not be able to access the web server, you will troubleshoot it in the next steps

5. Switch to the **Networking** tab, and check the Inbound port rules that are added from the **Inbound port rules** .

6. Select the Inbound port rule with Priority **310** and name **AllowAnyCustom80Inbound**, Modify the priority to **100** and **Save** to process this rule.
   >DenyAnyCustom80Inbound rule had lower priority number **305** and had higher priority than AllowAnyCustom80Inbound as a result communication with port 80 was denied. 

7. Now, try accessing the web server **labvm** again with the Public IP address.

8. You will be successfully be able to access the web server.

## Establish the communication between the two virtual machines

1. From the **Search resources, Services, and docs(G+/)** blade, search for and select **Virtual machines**

2. Select the Virtual machines **labvm** and **labvm2** and try to RDP to the machines
  >You will not be able to login or RDP to the VM's , you will troubleshoot it in the next steps

3. From the **Networking** tab of the two virtual machines, investigate the Inbound port rules that are added from the **Inbound port rules** 

4. Notice that the **Inbound port rule** for Port **3389** is not added.

5. Add the **Inbound port rule** for Port **3389** to both the Virtual machines/

6. Now, you will be successfully be able to access the Virtual machines through RDP.

7. Since the Virtual machine **labvm** is deployed in Virtual network **Vnet1** and the Virtual machine **labvm2** is deployed in different Virtual network **Vnet2** the virtual machines would not be able to communicate with each other.

8. You can connect virtual networks to each other with **virtual network peering**. Once both the virtual networks are peered, resources in both virtual networks can communicate with each other over a low-latency, high-bandwidth connection using Microsoft backbone network

9. Login to both the virtual machines and try pinging the other virtual machine using the private ip address of the virtual machine.

10. You still will not be able to establish communication between the virtual machines.

11. Investigate the Network Security groups of both the virtual machines.

12. Notice that the NSG of the Virtual machine **labvm2** has the inbound port rule **DenyTagCustomAnyInbound** ((This rule denies the access to and from any virtual networks) with Priority **350** which is overriding the default rule **AllowVnetInBound** (This rule allows the access to and from any virtual networks) hence though the Virtual network Peering is successful , the communication between the virtual machines is not successful because of the Inbound port rule **DenyTagCustomAnyInbound**

13. Delete the Inbound port rule **DenyTagCustomAnyInbound**

14. Navigate back to the virtual machines and try pinging the other virtual machine using the private ip address of the virtual machine

15. You will be successfully be able to establish the communication between the two virtual machines
