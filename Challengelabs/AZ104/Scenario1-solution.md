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
   
   >You will not be able to access the web server, you will troubleshoot in the next steps

5. Switch to the **Networking** tab, and check the Inbound port rules that are added from the **Inbound port rules** .

6. Select the Inbound port rule with Priority **310** and name **AllowAnyCustom80Inbound**, Modify the priority to **100** and **Save**
   >DenyAnyCustom80Inbound

7. Now, try accessing the web server **labvm** again with the Public IP address.

8. You will be successfully be able to access the web server.

