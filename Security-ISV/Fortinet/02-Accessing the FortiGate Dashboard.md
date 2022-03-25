# 01 - Accessing the Fortinet Dashboard 

## Overview 

In this task, you will access the FortiGate dashboard through the internet by using the FortiGate FQDN and connect to the Apache webserver via the CLI Console.

## Task 1: Accessing the FortiGate Dashboard 

 1. Open a new tab in the browser and copy-paste the FortiGateFQDN <inject key="FortiGateFQDN"></inject>
     
 2. A page shown below will apear. Click on **Adavanced**.

     ![](../images/image_701.png)
     
 3. Click on the following link on the page as shown below. 

     ![](../images/image_702.png)
     
 4. You will be redirected to the page shown below with empty **Username** and **Password** text boxes. Enter the following username/password and then click on **Login**.
     
     * **Username**:  <inject key="AdminUsername"></inject>
     * **Password**:  <inject key="AdminPassword"></inject>

     ![](../images/image_703.png)
     
 5. A **FortiGate Setup** page appears as shown below. Click on **Begin**

     ![](../images/image_705.png)
     
 6. A **Dashboard Setup** page appears as shown below. Keep the **Optimal** option as default and click on **OK**

     ![](../images/image_706.png)

 7. The **Fortinet** dashboard will appear as shown below.

     ![](../images/image_708.png)
     
 ## Task 2: Connect to the Apache webserver
     
 1. To connect to the Apache webserver, click on the **CLI Console** on the FortiGate dashboard as shown below.
     
     ![](../images/image_400.png)
     
 2. Connect to the webserver host via the CLI Console by copying the following command and password in the console.
     
     * **exec ssh labuser@10.0.3.4**
     * **labuser@10.0.3.4's password**:  <inject key="AdminPassword"></inject>
     
     ![](../images/image_401.png)
     
 3. Minimize the CLI Console.
 
     ![](../images/image_411.png)
     
 11. Click on **Next** to continue to the next section of the lab.
     

