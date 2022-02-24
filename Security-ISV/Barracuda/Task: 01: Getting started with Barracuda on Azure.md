# Getting started with Barracuda on Azure

## Overview 

This document will help you in configuring the Barracuda Web Application firewall hosted on Azure for publishing IIS Based websites.

## Task 1: Getting started with the environment

1.	**Launch** the Edge browser and **Navigate** to https://portal.azure.com.

2.	**Login** with your Microsoft Azure credentials.

3.	To toggle **show/hide** the Portal menu options with icon, **Click** on the **Show Menu** button.

   ![](../images/Picture1.png)

4.	**Click** on the **Resource groups** button in the **Menu navigation bar**, to view the Resource groups blade.
 
   ![](../images/Picture2.jpg)

5.	Select the Resource Group in which you deployed the quick start template.

   ![](../images/Picture3.jpg)
 
6.	From **Settings**, select **Deployments**.

   ![](../images/Picture4.png)

7.	Select the latest **deployment** available on this resource group.

   ![](../images/Picture5.jpg)
 
8.	In the Deployment blade, Click on the **Outputs** section (1). You will see the **Public IP address** of **Barracuda WAF VM** (3) and **Load Balancer(2)**.

   ![](../images/Picture6.jpg)

9.	Click the **Copy icon** to copy the **Public IP address**. Create a new text document in **Notepad** or **Notepad++** and paste both IP addresses to it as **Load Balancer Public Ip** and **Barracuda WAF Public IP**.
 
   ![](../images/Picture7.png)

10.	Navigate back to the Resource groups and select your **Resource Group**.

   ![](../images/Picture8.png)
 
11.	On the Resource group blade, click on **Overview**.

   ![](../images/Picture9.png)

12.	Select the **web-vm1** virtual machine from the resource list.

   ![](../images/Picture10.jpg)
 
13.	On the virtual machine blade, scroll down to the **Settings** section, click on **Networking**

   ![](../images/Picture11.png)

14.	Select the **web-vm-nic1** Network Interfaces.

   ![](../images/Picture12.jpg)
 
15.	In the Network Interfaces blade, you can see the **Private IP address** of **web-vm1**. Save this IP address to the notepad as **web-vm1 private IP**.

   ![](../images/Picture13.jpg)

16.	Repeat steps **11 to 13** to obtain the **Private IP address** of **web-vm2** as well by selecting
**web-vm2** in step **11**. Now, you will have all the following IP addresses in your notepad.

   ![](../images/Picture14.png)
