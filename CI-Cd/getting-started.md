
# Getting Started with Lab

1. Once the environment is provisioned, a virtual machine (JumpVM) and lab guide will get loaded in your browser. Use this virtual machine throughout the workshop to perform the lab. You can see the number on the lab guide bottom area to switch on different exercises of the lab guide.

   ![](https://github.com/anushabc/MCW-Continuous-delivery-in-Azure-DevOps/blob/prod/Hands-on%20lab/media/image01.png?raw=true "Lab Environment")
   
   >Note: If you see any PowerShell windows running in your VM, please do not close that as it's setting up some configurations inside the environment.
   
1. In the environment click on **ok** if you receive a prompt regarding windows deprecation.

   ![](https://github.com/anushabc/MCW-Continuous-delivery-in-Azure-DevOps/blob/prod/Hands-on%20lab/media/imgdepre.png?raw=true "Lab Environment")     

1. To get the lab environment details, you can select the **Environment Details** tab. Additionally, the credentials will also be emailed to your email address provided at registration. You can also open the Lab Guide in a separate and full window by selecting the **Split Window** from the lower right corner. Also, you can start, stop and restart virtual machines from the **Resources** tab.

   ![](https://github.com/anushabc/MCW-Continuous-delivery-in-Azure-DevOps/blob/prod/Hands-on%20lab/media/image02.png?raw=true "Lab Environment")
 
    > You will see the SUFFIX value on the **Environment Details** tab, use it wherever you see SUFFIX or DeploymentID in lab steps.

## Set default browser

1. Within the LabVM, search for the **Default apps**.

    ![](media/default%20apps.png)
    
2. Scroll down to the web browser option at the bottom and select **Microsoft Edge** as the default browser.

    ![](media/MSedge.png)
    
 3. Close the setting tab by clicking on **X** from the top right corner.
 
## Login to Azure Portal
1. In the JumpVM, click on the Azure portal shortcut of the Microsoft Edge browser which is created on the desktop.

   ![](https://github.com/anushabc/MCW-Continuous-delivery-in-Azure-DevOps/blob/prod/Hands-on%20lab/media/image01.png?raw=true "Lab Environment")
   
1. On the **Sign in to Microsoft Azure** tab you will see the login screen, in that enter the following email/username, and click on **Next**. 
   * Email/Username: <inject key="AzureAdUserEmail"></inject>
   
      ![](media/imagesignin.png "Enter Email")
     
1. Now enter the following password and click on **Sign in**.
   * Password: <inject key="AzureAdUserPassword"></inject>
   
     ![](media/image8.png "Enter Password")
     
1. If you see the pop-up **Stay Signed in?**, click No

1. If you see the pop-up **You have free Azure Advisor recommendations!**, close the window to continue the lab.

1. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.
   
1. Now you will see Azure Portal Dashboard, click on **Resource groups** from the Navigate panel to see the resource groups.

    ![](media/select-rg.png "Resource groups")
   
1. Confirm you have all resource group is present as shown below.

    ![](https://github.com/anushabc/MCW-Continuous-delivery-in-Azure-DevOps/blob/prod/Hands-on%20lab/media/image03.png?raw=true "Resource groups")
   
1. Now, click on **Next** from the lower right corner to move on to the next page.
