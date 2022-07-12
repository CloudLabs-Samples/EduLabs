# Getting started with F5 BIG-IP Virtual Edition on AWS

## Tasks Included

In this hands-on lab you will perform the following tasks:

- **Task 1: Getting started with the AWS Console**
- **Task 2: Accessing the F5 Dashboard**
- **Task 3: Configuring F5 Advanced Web Application firewall**

## F5 BIG-IP Virtual Edition

The BIG-IP Virtual Edition (VE) is the industry’s most trusted and comprehensive app delivery and security solution. Providing everything from intelligent traffic management and visibility, to app security, access, and optimization, BIG-IP VE ensures your apps are fast, available, and secure wherever they are deployed.
BIG-IP Virtual Edition includes:
Local Traffic Manager (LTM)
Access Policy Manager (APM)
Advanced WAF
Network Firewall (AFM)

F5 Advanced WAF is an application-layer security platform protecting against application attacks. The industry-leading F5 Advanced WAF provides robust web application firewall protection by securing applications against threats including layer 7 DDoS attacks, malicious bot traffic, all OWASP top 10 threats and API protocol vulnerabilities.The F5 Advanced WAF leverages behavioral analytics, automated learning capabilities, and risk-based policies to secure your website, mobile apps, and APIs—whether in a native or hybrid Azure environment

## Architecture Diagram
   ![](../images/f5-archdiag.png)

# 01: Getting started with the AWS console

## Overview

In this task, you will deploy F5 BIG-IP Virtual Edition and web server. 

## Task 1: Getting started with the AWS

1. In the browser that you already opened, open a new tab, and sign in to the **AWS Console** https://.signin.aws.amazon.com/console/.

1. On the **Sign in as IAM User** blade, you will see a login screen, in which enter the following email/username and then click on **Sign in**.  

   * **Azure Username/Email**:  <inject key="AzureAdUserEmail"></inject> 
   * **Azure Password**:  <inject key="AzureAdUserPassword"></inject>

        **Note**: Refer to the **Environment Details** tab for any other lab credentials/details.
        
    ![](../images/image-004.jpg)
  
    ![](../images/image-005.jpg)

1. Now you will be able to view the home page of AWS console
 
1. Ensure to switch to **Ohio** region at the top right corner.

1. Search for **key pairs** and select **Key Pairs** from EC2 feature
 
1. On the **Create key pair** blade provide the name as **F5-Server-test** and click on **Create key pair**

1. After the keypair is created successfully, it will be downloaded to your machine. Ensure to save it safely as it is used in further steps

1. Navigate to the https://aws.amazon.com/marketplace/ and search for **F5 BIG-IP Virtual Edition - GOOD (PAYG, 25Mbps)**

1. Select the Marketplace image and click on **Continue to subscribe**

1. Under the **Subscribe to this software** section click on **Accept Terms** and to accept the terms and conditions

1. Now search for **Cloud Formation** select **stacks**

1. Select **Create stack**

      ![](../images/f5-06.jpg)
      
1. On the **Create stack** blade, provide the **Amazon S3 URL** and click on **Next**

      ![](../images/Picture11.png)
      
1. On the **Specify stack details** section. Provide the following details and click on **Next**
   - Stack name : **f5deployment**
   - Select the existing **VPC ID** 
   - Select the existing subnets for BIGIP external interface Subnet ID, BIGIP internal interface Subnet ID and BIGIP management interface Subnet ID

      ![](../images/f5-07.jpg)
 
1. On the **Review f5deployment** blade, review the configurations and scroll down to the bottom
      ![](../images/f5-08.jpg)

1. Now, under the **Capabilities** section check both the boxes and accept the terms

      ![](../images/f5-09.jpg)
    
1. Click on **Create stack** and wait for 3 minutes for the deployment to be completed.

      ![](../images/f5-05.jpg)

1. On the **Stacks** page ensure the status shows as **CREATE_COMPLETE**

1. Search for **EC2** and select **Instances** to view the F5 instance and web server instance

1. On the instances page , click on each of the instance and review the configurations.

1. Click on the Web server instance , from the **Security** tab select the security group 

1. Now from the security group page select **Edit inbound rules** 

1. Click on **add rule** and add the port 80 

1. Click **Save rules**

1. Click on the F5 instance scroll down to the bottom and select the security group 

1. Now from the security group page select **Edit inbound rules** 

1. Click on **add rule** and add the port 8443 and 443 if it's not added already

1. Click **Save rules** 

## Overview 

In this task, you will access the F5 Big IP dashboard by using the Public Ip address.

## Task 2: Accessing the F5 Dashboard

1. Navigate to the Cloudformation->stacks and copy the public ip address of F5 instance from the output section

1. Open **Putty** from your machine

   NOTE: If you don't have putty installed, you can download putty from this link : https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

1. Provide the F5 Public ip under **Hostname**

1. Navigate to the **Auth** option and click on **Browse** under **Private key file for authentication**

1. Select the downloaded key pair file and click on **Open**

1. If a pop window of **Putty Security Alert** appears, click on **Yes**

1. Login as admin

1. Run the following commands to set a password for F5 instance
   ```
   modify auth user admin password <yourpasswordhere>
   save sys config
   ```
 
1. Open a new tab in the browser and log in to the BIG-IP Configuration utility by using **https** with the **F5 Public IP**. Append a **colon** and the port number **8443** to the IP address as shown below. This port 8443 allows management traffic to reach BIG-IP VE. Press **Enter** key.

    ![](../images/f5-01.jpg)
   
   NOTE: You can also get it by navigating to the Cloudformation->stacks and copy the management portal URL of F5 instance from the output section
    
1. A page shown below will apear. Click on **Advanced** on the web page.

    ![](../images/f5-adv.png)
     
1. Click on the link **Continue to XXXXXX(unsafe)** on the page as shown below. 

    ![](../images/f5-cont.png)
    
1. You will be redirected to the **F5 Advanced WAF** Login page.

    ![](../images/f5-02.jpg)
    
1. Enter the following F5 Portal username and password and then click on **Log in**.  

   * **F5 Portal Username**:  <inject key="F5 Portal Username"></inject> 
   * **F5 Portal Password**:  <inject key="F5 Portal Password"></inject>

        **Note**: Refer to the **Environment Details** tab for any other lab credentials/details.
        
    ![](../images/f5-03.jpg)
 
1. Now, you will be able to see the F5 dashboard. 
 
    ![](../images/f5-10.jpg)
   


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
