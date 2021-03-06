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
