# 02: Getting started with the Azure Portal

## Overview

In this task, you will view the pre-deployed F5 Advanced WAF VM and web servers. 

## Task 1: Getting started with the Azure Portal

1. In the browser that you already opened, open a new tab, and sign in to the **Azure Portal** (<http://portal.azure.com>).

1. On the **Sign in to Microsoft Azure** blade, you will see a login screen, in which enter the following email/username and then click on **Next**.  

   * **Azure Username/Email**:  <inject key="AzureAdUserEmail"></inject> 
   * **Azure Password**:  <inject key="AzureAdUserPassword"></inject>

        **Note**: Refer to the **Environment Details** tab for any other lab credentials/details.
        
    ![](../images/image-004.jpg)
  
    ![](../images/image-005.jpg)
  
1. If you see the pop-up like below, click **Skip for now(14 days until this is required)**.

    ![](../images/image004.png)

1. If you see the pop-up **Stay Signed in?** click **No**.

    ![](../images/image-006.jpg)

1. If you see the pop-up **You have free Azure Advisor recommendations!** close the window to continue the lab. 

1. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.

    ![](../images/image-007.jpg)

1. Now you will be able to view the Azure Portal Dashboard.

1. To toggle **show/hide** the Portal menu options with icon, **Click** on the **Show Menu** button.

      ![](../images/Picture1.png)

1. **Click** on the **Resource groups** button in the **Menu navigation bar** to view the Resource groups blade.
 
      ![](../images/Picture2.jpg)
      
1. Select the **F5-DeploymentID** resource group in the resource groups blade.

      ![](../images/f5-04.jpg)
 
1. On the Resource group blade, click on **Overview**.

      ![](../images/f5-05.jpg)
      
1. Select the **web-vm1** virtual machine from the resource list.

      ![](../images/f5-06.jpg)
      
1. On the virtual machine blade, scroll down to the **Settings** section, click on **Networking**

      ![](../images/Picture11.png)
      
1. Select the **web-vm-nic1** Network Interfaces.

      ![](../images/f5-07.jpg)
 
1. In the Network Interfaces blade, you can see the **Private IP address** of **web-vm1**. Copy the value of the Private IP address. You will need it for the next task.

      ![](../images/f5-08.jpg)

1. Navigate back to the Resource groups and select your Resource Group

      ![](../images/f5-09.jpg)
    
1. On the Resource group blade, click on Overview.

      ![](../images/f5-05.jpg)

1. Explore the pre-deployed resources
   
### Proceed to Task 3 - Configuring F5 Advanced Web Application firewall 

# 03: Configuring F5 Advanced Web Application firewall

## Overview

In this task, you will configure the F5 Advanced Web Application firewall hosted on Azure for publishing IIS Based websites.

## Task 1: Access the Webserver

1. Open a new tab in the browser and attempt to access the webserver via http to the same IP address as the F5.
   * <inject key="f5_httpURL"></inject>

    ![](../images/accesswebserver.png)
    
2. You won't be able to access the webserver because the F5 is not yet configured to respond to port 80.

## Task 2: Configuring F5 Advanced Web Application firewall  

### Exercise 1: Creating a pool and adding members to it

In this exercise, BIG-IP VE routes traffic to a pool. This pool should contain your application servers.

1. Switch back to F5 dashboard tab, On the **Main** tab, click **Local Traffic -> Pools -> Pool List**.

    ![](../images/f5-11.jpg)
    
1. Click **Create** to create the Pool.    
        
    ![](../images/f5-12.jpg)

1. In the **Name** field, type **web_pool**. Names must begin with a letter, be fewer than 63 characters, and can contain only letters, numbers, and the underscore (_) character. For **Health Monitors**, move **http_head_f5** from the **Available** to the **Active** list by clicking on <<.

    ![](../images/f5-13.jpg)  

1. In the **New Members** section, in the **Address** field, type the Private IP address which you copied in the previous task **(1)**. In the **Service Port** field, type **80** as service port **(2)** and Click **Add** **(3)**.

      **Note**: The list now contains the member **(4)**
        
    Click **Finished** **(5)**.
   
    ![](../images/f5-14.jpg)
    
1. Refresh the page and verify if the created pool's status is shown as **Available** (indicated in green) 
   
   ![](../images/f5-poolstatus.png)
    
### Exercise 2: Creating a virtual server

In this exercise, A virtual server listens for packets destined for the external IP address. You must create a virtual server that points to the pool you created.

1. On the **Main** tab, click **Local Traffic -> Virtual Servers-> Virtual Server List**

    ![](../images/f5-15.jpg)
    
1. Click **Create** to create the Virtual Server.  

    ![](../images/f5-16.jpg)
    
1. In the **General Properties** section, configure as below:

   - Name: **Demo-Websites** (Or your custom service name)
   - Destination Address/Mask: **0.0.0.0/0**
   - Service port: **80**
   - State: Leave the default

    ![](../images/f5-17.jpg)
 
1. Scroll down to the **Configuration** section, configure as below:

   - Source Address Translation: Select **Auto Map**

    ![](../images/f5-18.jpg)

1. Again, scroll down to the **Resource** section, configure it as below and click on **Finished**.

   - Default Pool: Select the Pool which you created in the previous exercise
    
    ![](../images/f5-19.jpg)
  
1. Verify if the created Virtual server's status is shown as **Available** (indicated in green) 
    
   ![](../images/f5-vsstatus.png)
    
1.  Open a new tab in the browser and copy-paste the following to access the webserver.
    * <inject key="f5_httpURL"></inject>
    
1. The request will be forwarded to the backend web server as configured and You should be able to see the webserver in the browser.
    
    ![](../images/Picture32.jpg)

# Conclusion

Congratulations, You have successfully completed this lab. In this lab, you were able to publish a Web Application hosted behind F5 advanced Web application firewall
