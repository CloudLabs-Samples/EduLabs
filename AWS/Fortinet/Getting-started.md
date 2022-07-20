# Getting started with Fortinet FortiGate Next-Generation Firewall

## Overview

The Fortinet FortiGate Next-Generation Firewall (NGFW) combines security and networking services to enable both content and network protection in 
an Amazon Web Services (AWS) environment. Fortinet designed this solution to inspect traffic as it enters and leaves the network, while simultaneously 
providing integrated security capabilities. The FortiGate NGFW can enable these security features without degrading performance and adversely affecting 
the end-user experience.

The FortiGate NGFW is part of the broader Fortinet Security Fabric architecture, designed to provide broad visibility and control of an organization’s
entire digital attack surface and automated operations, orchestration, and response. AI/ML, along with continuous threat intelligence provided by 
FortiGuard Labs security services, help to create and automate policies driving how the FortiGate NGFW responds to evolving threats. 

## Tasks Included
  
* **01 - Login to AWS console**
* **02 - Deploying the FortiGate Next-Generation Firewall solution and Web server**
* **03 - Accessing the FortiGate Dashboard**    
* **04 - Configure FortiGate for Web Traffic**
* **05 - Access the Webserver**

## Overview

In this task, you will deploy Fortinet FortiGate Next-Generation Firewall and a Apache web server. 

## 01: Login to AWS console

1. In a browser, open a new tab and sign in to the **AWS Console** using the sign-in link provided in the **Environment details** tab 
   
   ![](images/awssigninlink.png)

2. On the **Sign in as IAM User** blade, you will see a Sign-in screen,  enter the following email/username and then click on **Sign in**.  

   * **Azure Username/Email**:  <inject key="AzureAdUserEmail"></inject> 
   * **Azure Password**:  <inject key="AzureAdUserPassword"></inject>

   **Note**: Refer to the **Environment Details** tab for any other lab credentials/details.
        
   ![](images/awsconsolecreds.png)

3. Now you will be able to view the home page of the AWS console
   
    ![](images/consolehome.png)
    
4. Ensure to use the **N.Virginia** region at the top right corner for performing the lab.
   
    ![](images/region.png)
  
## 02: Deploying the FortiGate Next-Generation Firewall solution and Web server**

1. Search for **key pairs** and select **Key Pairs** from the EC2 feature

    ![](images/keypair.png)
 
2. On the **Create key pair** blade provide the name as **keypair-XXXXXX** and click on **Create key pair**

   ![](images/createkeypair.png)
 
3. Navigate to https://aws.amazon.com/marketplace/ , search and select the Marketplace image **Apache Web Server on Ubuntu 21.04**  
   
   ![](images/awsmp.png)

4. Click on **Continue to subscribe**
   
   ![](images/apachesubscribe.png)
    
5. Under the **Subscribe to this software** section click on **Accept Terms** to accept the terms and conditions
   
   ![](images/apacheterms.png)
   
  >NOTE: Your subscription to this product will be pending and may take a few minutes.

6. After the subscription process is complete, click on **Continue to Configuration**
   
   ![](images/apachectc.png)
   
7. On the **Configure this software** blade review the configurations and click **Continue to Launch** to launch the software
   
   ![](images/apachectl.png)  
 
8. Next, on the **Launch this Software** blade, select the following :
    - Choose Action : Launch from Website
    - EC2 instance type: Leave the option set to default
    - VPC Settings : Leave the option set to default VPC
    - Subnet Settings : Leave the option set to default
    
   ![](images/apachelts.png)  

9. Scroll down and under **Security Group Settings** select **Create New Based on Seller Settings**
   
   ![](images/apachelts2.png)  

10. Under the **Create New Based on Seller Settings** provide the Security group name, description and Click on **Save** 

    ![](images/apachelts3.png) 
   
11. Under the **Key Pair Settings** section select the existing key pair and click on **Launch**
   
    ![](images/apachelts4.png) 

12. Once the instance is deployed successfully you will get a message as follows, Click on **EC2 Console**
    
    ![](images/apachemsg.png) 

13. You will be navigated to the **Instances** Page

14. On the instances page, name the instance you just created as **Web Server** and click on **Save**

    ![](images/apachename.png) 
    
15. Ensure the instance is **Running** and the status shows as **2/2 checks passed**
   
    ![](images/apachestatus.png) 
   
16. Select the webserver and copy the Private ip address in a notepad as it will be required in the further tasks.
    
    ![](images/apacheprivateip.png)

17. Navigate to https://aws.amazon.com/marketplace/ , search and select the Marketplace image **Fortinet FortiGate Next-Generation Firewall**  
   
   ![](images/awsmp2.png)

18. Click on **Continue to subscribe**
   
   ![](images/fortinetsubscribe.png)
    
19. Under the **Subscribe to this software** section click on **Accept Terms** to accept the terms and conditions
   
   ![](images/fortinetterms.png)
   
  >NOTE: Your subscription to this product will be pending and may take a few minutes.

20. After the subscription process is complete, click on **Continue to Configuration**
   
   ![](images/fortinetctc.png)
   
21. On the **Configure this software** blade review the configurations and click **Continue to Launch** to launch the software
   
   ![](images/fortinetectl.png)  
 
22. Next, on the **Launch this Software** blade, select the following :
    - Choose Action : Launch from Website
    - EC2 instance type: Leave the option set to default
    - VPC Settings : Leave the option set to default VPC
    - Subnet Settings : Leave the option set to default
    
   ![](images/fortinetlts.png)  

23. Scroll down and under **Security Group Settings** select **Create New Based on Seller Settings**
   
   ![](images/apachelts2.png)  

24. Under the **Create New Based on Seller Settings** provide the Security group name, description and Click on **Save** 

    ![](images/fortinetlts3.png) 
   
25. Under the **Key Pair Settings** section select the existing key pair and click on **Launch**
   
    ![](images/apachelts4.png) 

26. Once the instance is deployed successfully you will get a message as follows, Click on **EC2 Console**
    
    ![](images/fortinetmsg.png) 

27. You will be navigated to the **Instances** Page

28. On the instances page, name the instance you just created as **Fortinet instance** and click on **Save**

    ![](images/fortinetname.png) 
    
29. Ensure the instance is **Running** and the status shows as **2/2 checks passed**
   
    ![](images/fortinetstatus.png) 
    
30. Select the instance and copy the Private ip address of the Fortinet instance in a notepad as it will be required in the further tasks.
   
    ![](images/fortinetprivateip.png)

31. Ensure that you have the private ip address information of both Apache web server and Fortinet instance noted in a notepad
    
    ![](images/notepad.png)

# 03 - Accessing the FortiGate Dashboard 

## Overview 

In this task, you will access the FortiGate dashboard through the internet by using the FortiGate Public IP and connect to the Apache webserver via the CLI Console.

## Task 1: Accessing the FortiGate Dashboard 

1. Select the Fortinet instance and copy the Public ip address and paste it in a browser tab
    
   ![](images/fortinetpip.png)
     
2. A page shown below will appear. Click on **Advanced** on the web page.

    ![](images/advanced.png)
     
3. Click on the link **Continue to fortigatevm-XXXXX** on the page as shown below. 

    ![](images/continue.png)
    
4. You will be redirected to the page with login disclaimer pop up window, Click on **Accept**
   
   ![](images/accept.png)

5. Navigate back to the instances page and copy the Instance id of the Fortinet instance
   
   ![](images/instances.png)

6. You will be redirected to the page shown below with  **Username** and **Password** text boxes. Enter the following username/password and then click on **Login**.
     
    * **Username**: admin
    * **Password**: Paste the instance id of the Fortinet instance

    ![](images/dashboardlogin.png)
     
7. A **Change Password** dialog box appears to update the default password to a new password. Once you update your Password click on **OK**
   
   ![](images/changepswd.png)
 
8. You may have to login again to the FortiGate dashboard

9. A **FortiGate Setup** page appears as shown below. Click on **Begin**

    ![](images/FortiGateSetup.png)

10. A **Setup Progress** box appears as shown below. Leave the default value and click on **OK**
    
    ![](images/hostname.png)

11. A **Dashboard Setup** page appears as shown below. Keep the **Optimal** option as default and click on **OK**

    ![](images/DashboardSetup.png)
    
12. Click on **OK** to bypass**What’s New in FortiOS 7.0** and switch the toggle on for **Don't show again**

     ![](images/Whatsnew.png)

13. The **FortiGate** dashboard will appear as shown below.

    ![](images/fortigatedashboard.png)

14. Navigate to **System->Settings**, under the Administration settings turn the toggle off for **Redirect to HTTPS** and click on **Apply**
    
    ![](images/redirect.png)

    
# 04 - Configuring FortiGate for Web Traffic

## Overview

In this task, you will try to access the webserver via FortiGate's Public IP address on port 80, configure Firewall policies on the FortiGate-VM firewall via the FortiGate dashboard, and then add Virtual IPs to provide secured access from your device to the webserver hosted in AWS and protected by the FortiGate.

## Task 1: Access the Webserver

1. Navigate back to the FortiGate dashboard and log in with the user credentials given below if the session has expired and click on **Login**.

    * **Username**:  admin
    * **Password**:  Provide the Password that you had set in previous tasks.
    
    ![](images/expired.png)

2. Open a new tab in the browser and attempt to access the webserver on Port 80 from the Public IP of the Fortinet instance.

   ```
   http://fortinetinstancepublicip
   ``` 
   
   ![](images/webserver-error.png)
    
3. You won't be able to access the webserver because the FortiGate is not yet configured to respond to port 80.

## Task 2: Configuring an Apache webserver through FortiGate dashboard

1. Navigate back to the FortiGate dashboard and log in with the user credentials given below if the session has expired and click on **Login**.

    * **Username**:  admin
    * **Password**:  Provide the Password that you had set in previous tasks.
    
     ![](images/expired.png)
    
2. On the FortiGate dashboard click on the **Policy & Objects** drop-down and select **Virtual IPs**.
    
    ![](images/vips.png)
    
3. Click on the **Create New** button and select **Virtual IP** from the drop-down.

    ![](images/createvip.png)
    
3. Create a new virtual IP to forward traffic for interface **port1** by entering the following values and then click on **OK**.
    
    * Name:  **WebTraffictoWebserver**
    * Interface:  **port1**
    * External IP Address/Range:  **Fortinet instance's Private IP**
    * Map to IPv4 Address/Range:  **Apache web server's Private IP**
    * Enable **Port Forwarding**
    * Protocol:  **TCP**
    * External service port:  **80**
    * Map to IPv4 port:  **80**

    ![](images/vipconfig.png)
    
4. Under **Policy & Objects** on the dashboard, click on **Firewall Policy** and then **Create New**.

    ![](images/firewallpolicy.png)

5. Create a new Firewall policy to access the webserver by entering the following values and then click **OK**. 
    
    >**NOTE**: This new policy will allow all traffic in port1 and out port2.

    * Name:  **WebTraffictoWebserverVIP**
    * Incoming Interface:  **port1**
    * Outgoing Interface:  **port1**
    * Source:  **all**
    * Destination: **WebTrafficToWebserver**
    * Service: **HTTP**
    
    ![](images/fpconfig.png)

# 05 - Access the Webserver

## Overview 

In this task, you will access the Apache webserver hosted in AWS via the internet using the Public IP of Fortinet instance on port 80 which was configured in the previous exercise by providing the Virtual IPs of the webserver.  

## Task: Connect to the Webserver

1. Open a new tab in the browser and attempt to access the webserver on Port 80 from the Public IP of the Fortinet instance.

   ```
   http://fortinetinstancepublicip
   ```     
2. You should be able to see the Apache webserver in the browser.

    ![](images/webserveraccess.png)   
    
## Summary

In this task, you accessed the Apache webserver through the internet using the Fortinet VM's Public IP. 
