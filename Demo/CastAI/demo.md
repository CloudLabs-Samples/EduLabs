# CloudLabs Demo : Cast AI

## Overview
This lab environment has a Ubuntu Virtual machine with a GUI (Graphical User Interface) along with Azure Kubernetes Service (AKS) pre-deployed

## Getting started

1. Once the environment is provisioned, a virtual machine (VM) on the left and lab guide on the right will get loaded in your browser. Use this virtual machine throughout to perform the lab.

   ![](images/vmandguide.png)
   
2. Within the Ubuntu VM, search for "Firefox" browser and use it throughout the lab

3. To get the lab environment details, you can select the **Environment details** tab, you can locate the **Environment details** tab in the upper right corner.
   
   ![](images/env-details.png)

4. You can also open the Lab Guide on a separate full window by selecting the **Split Window** button on the bottom right corner.
   
   ![](images/splitwindow.png)
 
5. You can **start(1)** or **stop(2)** the Virtual Machine from the **Resources** tab.

   ![](images/resources.png)
   
## Login to the Azure Portal

1. In the browser that you already opened, open a new tab, and sign in to the **Azure Portal** (<http://portal.azure.com>).

1. On the **Sign in to Microsoft Azure** blade, you will see a login screen, in which enter the following email/username and then click on **Next**.  

   * **Azure Username/Email**:  <inject key="AzureAdUserEmail"></inject> 
   * **Azure Password**:  <inject key="AzureAdUserPassword"></inject>

        **Note**: Refer to the **Environment Details** tab for any other lab credentials/details.
        
    ![](images/image-004.jpg)
  
    ![](images/image-005.jpg)
  
1. If you see the pop-up like below, click **Skip for now(14 days until this is required)**.

    ![](images/image004.png)

1. If you see the pop-up **Stay Signed in?** click ** Yes or No** based on your choice.

    ![](images/image-006.jpg)

1. If you see the pop-up **You have free Azure Advisor recommendations!** close the window to continue the lab. 

1. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.

    ![](images/image-007.jpg)

1. Now you will be able to view the Azure Portal Dashboard.

1. To toggle **show/hide** the Portal menu options with icon, **Click** on the **Show Menu** button.

      ![](images/Picture1.png)

1. **Click** on the **Resource groups** button in the **Menu navigation bar** to view the Resource groups blade.
 
      ![](images/Picture2.jpg)
      
1. Select the **castai-demo-DeploymentID** resource group in the resource groups blade.

      ![](images/rg.png)
    
1.  Select the AKS Cluster pre-deployed for you and perform the lab.
