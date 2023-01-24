## Scenario 2:
You are given a web app deployed in Azure and accessible over Public Internet. You must enable it to be accessible only from the subnet the VM-<depID> is deployed with minimal cost?

### Skills tested: 
Private Endpoint
  
Web App
  
Networking

## Steps

1. Click on the **Azure Portal** icon on the VM desktop and login with the Azure credentials from the Lab Environment output page.

2. On the **Sign in to Microsoft Azure** blade, you will see a login screen, in which enter the following email/username and then click on **Next**.  

   * **Azure Username/Email**:  <inject key="AzureAdUserEmail"></inject> 
   * **Azure Password**:  <inject key="AzureAdUserPassword"></inject>

        **Note**: Refer to the **Environment Details** tab for any other lab credentials/details.

3. From the **Search resources, Services, and docs(G+/)** blade, search for and select **App service**, and then choose the App service **webapp**

4. Copy the **URL** of the App service from the webapp's **Overview** blade and access the webapp through a browser.
   
   >You will be able to access the webapp both within the VM and local computer as it is accessible over Internet, you will troubleshoot it in the next steps to get it accessible only through VM and not externally (through Local computer).

5. Switch to the **Networking** tab of the App service, and select **Access restriction** from the Features section of the Inbound Traffic.

6. Turn off the **Allow public access** option and click on **Save**
   >Deny public network access will block all incoming traffic except that comes from private endpoints

8. Next, create a private end point 
  >Azure Private endpoint is the fundamental building block for Private Link in Azure. It enables Azure resources, like virtual machines (VMs), to privately and securely communicate with Private Link resources such as a web app.

9. Switch to the **Networking** tab of the App service, and notice that **Private endpoints** option is grayed out from the Features section of the Inbound Traffic.
  
10. This is because the App service plan **Free F1** does not support the Private endpoints feature 
  
11. Upgrade the App service plan from **Free F1** to the App service plan **Premium v2 P1V2** which is the plan with minimal cost that supports Private endpoints from the **Scale up(App service plan)** option.

12. Switch to the **Networking** tab of the App service, and notice that **Private endpoints** option is now available.

13. Select the **Private endpoints** and select **+Add** in the Private Endpoint connections page.

14. Once the Private endpoint is created, test the connectivity to private endpoint

15. Within the VM, open a browser and enter the URL of your web app, https://<webapp-name>.azurewebsites.net

16. Verify you receive the default web app page and you are able to access the web app successfully.

17. Now, open a web browser on your local computer and enter the URL of your web app, https://<webapp-name>.azurewebsites.net.

18. Verify that you receive a 403 page. This page indicates that the web app isn't accessible externally

19. You are successfully able to access the webapp only within the VM-<depID> and not externally with minimal cost
  
## Resources
https://learn.microsoft.com/en-us/azure/private-link/tutorial-private-endpoint-webapp-portal
