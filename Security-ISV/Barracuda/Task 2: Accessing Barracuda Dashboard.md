# Getting started with Barracuda CloudGen WAF on Azure

## Tasks Included

In this hands-on lab you will perform the following tasks:

- **Task 1: Accessing the Barracuda Dashboard**
- **Task 2: Accessing Barracuda Dashboard**
- **Task 3: Configuring Barracuda Firewall**
- **Task 4: Access Web VMs via RDP**

## Barracuda Web Application Firewall

The Barracuda Web Application Firewall inspects inbound web traffic and blocks SQL injections, Cross-Site Scripting, malware uploads & application DDoS, and other attacks targeted at your web applications. It also inspects the responses from the back-end web servers for Data Loss Prevention (DLP). The integrated access control engine enables administrators to create granular access control policies for Authentication, Authorization & Accounting (AAA), which gives organizations strong authentication and user control. The onboard L4/L7 Load Balancing capabilities enable organizations to quickly add back-end servers to scale deployments. Application acceleration capabilities, including SSL Offloading, caching, compression, and connection pooling, ensure faster web application content application delivery.

## Architecture Diagram

   ![](../images/image-diagram.jpg)# 01 - Accessing the Barracuda Dashboard  

## Overview 

In this task, you will access the Barracuda Cloudgen WAF dashboard by using the Public Ip address.

## Task 1: Accessing the Barracuda Dashboard 

1. Open a new tab in the browser and copy-paste the **Barracuda WAF Public IP** : <inject key="bwafIP"></inject> . Append a **colon** and the port number **8000** to the IP address as shown below. This port is used by the **BWAF** management web interface. Press **Enter** key.

    ![](../images/image-907.png)

1. A page as shown below will appear.

    ![](../images/Picture16.jpg)

    This is the **Barracuda End User License Agreement.**

1. Scroll down to the bottom of the page. enter the following information and then Click **Accept**.
 
   * **Name**: ODL_User
   * **Email Address**:  <inject key="AzureAdUserEmail"></inject> 

   ![](../images/Picture17.jpg)
 
 # Proceed to Task 2 - Configuring Barracuda Firewall 


