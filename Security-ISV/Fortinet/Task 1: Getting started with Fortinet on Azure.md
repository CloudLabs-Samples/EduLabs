# Getting started with Fortinet on Azure

## Overview: FortiGate Next-Generation Firewall - A Single VM 

As workloads are being moved from local data centers connectivity and security are key elements to take into account. FortiGate-VM offers a consistent security posture and protects connectivity across public and private clouds, while high-speed VPN connections protect data. This single FortiGate-VM setup a basic setup to start exploring the capabilities of the next generation firewall. The central system will receive, using user-defined routing (UDR), all or specific traffic that needs inspection going to/coming from on-prem networks or the public internet. Additionally, Fortinet Fabric Connectors deliver the ability to create dynamic security policies. This environment contains the following components:

  * 1 standalone FortiGate firewall 
  * 1 VNETs containing a protected subnet
  * User Defined Routes (UDR) for the protected subnets

## Architecture Diagram

   ![](../images/image_design.png)
 
 ## Task 1: Getting started with the environment
 
 In this task, you will view the pre-deployed Fortigate Singe-VM, network interfaces and a backend web server.
 
 1. **Launch** the Edge browser and **Navigate** to https://portal.azure.com.

 2. **Login** with your username and password as provided in the **Environment Details** tab.

 3. To toggle **show/hide** the Portal menu options with icon, **Click** on the **Show Menu** button.
 
       ![](../images/Picture1.png)
       
 4. **Click** on the **Resource groups** button in the **Menu navigation bar** to view the Resource groups blade.

       ![](../images/Picture2.jpg)
       
 5.  Select the **fortiGate-XXXX** resource group in the resource groups blade.

       ![](../images/image_500.png)
       
 6. On the Resource group blade, click on **Overview**.

       ![](../images/image_501.png)
       
 7. Select the **fortigatevm-XXXX** virtual machine from the resource list.

       ![](../images/image_502.png)
       
 8. On the virtual machine blade, scroll down to the **Settings** section, click on **Networking**

       ![](../images/image_503.png)
       
 9. Select the **fortigatevm-xxxx-Nic1** Network Interfaces.

       ![](../images/image_504.png)
       
 10. In the Network Interfaces blade, you can see the **Private IP address** of **fortigatevm-XXXX**. Copy the value of the Private IP address. You will need it in the next task.

       ![](../images/image_505.png)
       
 11. Select the **fortigatevm-xxxx-Nic2** Network Interfaces.

       ![](../images/image_506.png)
       
 12. In the Network Interfaces blade, you can see the **Private IP address** of **fortigatevm-XXXX**. Copy the value of the Private IP address. You will need it in the next task.

       ![](../images/image_507.png)
       
 13.  Repeat steps **7 to 10** to obtain the **Private IP address** of **apache-vm** as well by selecting **apache-vm** in step **7**.

       ![](../images/image_508.png)
       
 14. Navigate back to the Resource groups and select your Resource Group

       ![](../images/image_509.png)
       
 15. On the Resource group blade, click on Overview.

       ![](../images/image_501.png)
       
 16. Explore through pre-deployed resources from the resource list

 17. Click on **Next** to continue to the next section of the lab.
      
 
