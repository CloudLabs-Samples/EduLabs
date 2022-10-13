# Course 03: Configure Active Directory Replication in Windows Server 2016

1. In your VM, search for **Server Manager**, click **Tools** and select **Active Directory Users and Computers**.

   ![image](../media/lab01t.png)
   
1. In **Active Directory Users and Computers**, right click on your domain **CCU.CL**, click **New** and select **Organizational Unit**.

   ![image](../media/lab03-2.png)
   
1. Name your new Organizational Unit **Duoc** and click **OK**.

   ![image](../media/lab03-3.png)
   
1. In **Active Directory Users and Computers**, right click on your Organizational Unit **Duoc**, click **New** and select **User**.

   ![image](../media/lab03-4.png)
   
1. Enter **duocano** for **First Name** and **User logon name** and click **Next**.

   ![image](../media/lab03-5.png)
   
1. Enter a secure password for the user, check the box for **User must change password at next logon** and click **Next**.

   ![image](../media/lab03-6.png)
   
1. Review the user credentials and click **Finish**.

   ![image](../media/lab03-7.png)
   
1. In **Active Directory Users and Computers**, verify that the **duocano** user is created inside the **Duoc** Organizational Unit.

   ![image](../media/lab03-8.png)
   
1. In your VM, double click on the **Azure Portal** icon to sign in. You can get your Azure user credentials in the **Environment Details** tab.

   ![image](../media/lab03-9.png)
   
1. On the Sign-in tab, enter your username and click **Next**.

   ![image](../media/lab01-user-sign-in.png)
   
1. Enter the password for your username and click **Sign-in**.

   ![image](../media/lab01-sign-in-pass.png)
   
1. On the **Help us protect your account** tab, click **Skip for now (14 days until this is required)**.

   ![image](../media/lab01-sign-in-skip.png)

1. On the **Stay signed in?** tab, click **Yes**.

   ![image](../media/lab01-stay-signed-in.png)
   
1. In Azure portal, search for Virtual Machines and connect to your **DC02** virtual machine through **RDP**.

1. In **DC02**, search for **File Explorer**, right click on **Network** and click **Properties**.

   ![image](../media/lab03-15.png)
   
1. In **Network and Sharing Center**, click on **Ethernet**.

   ![image](../media/lab03-16.png)
   
1. In **Ethernet Status**, click on **Properties**.

   ![image](../media/lab03-17.png)
   
1. In **Ethernet Properties**, select **Internet Protocol Version 4 (TCP/IPv4)**.

   ![image](../media/lab03-18.png)
   
1. In **Internet Protocol Version 4 (TCP/IPv4) Properties**, select **Use the following IP address** and specify the following address range and click **OK**.

   | Setting | Value |
   | --- | --- |
   | IP address | **10.0.0.5** |
   | Subnet mask | **255.0.0.0** |
   | Default gateway | **10.0.0.1** |
   | Preferred DNS server | **10.0.0.4** |
   
   ![image](../media/lab03-19.png)
   
1. In **DC02**, search for **Server Manager**, go to the **Local Server** tab and click on the computer name **DC02**.

   ![image](../media/lab03-20.png)
   
1. In **System Properties**, click on **Change**.
   
   ![image](../media/lab03-21.png)
   
1. In **Computer Name/Domain Changes**, select **Domain**, enter **ccu.cl** and click **OK**.

   ![image](../media/lab03-22.png)
   
1. Enter your admin credentials and click **OK**. You can get your Azure user credentials in the **Environment Details** tab.

   ![image](../media/lab03-23.png)
   
1. A pop-up window appears which specifies that the secondary server is joined to the **ccu.cl** domain. Once you click **OK**, another pop-up window appears stating to restart the computer to apply the changes. Click **OK**.

   ![image](../media/lab03-24a.png)
   
   ![image](../media/lab03-24b.png)
   
1. When the **Microsoft Windows** pop-up appears stating to restart your computer, click **Restart Now**.

   ![image](../media/lab03-25.png)
   
1. Go to Azure portal, search for Virtual Machines and connect to your **DC02** virtual machine through **RDP** once its restarted.

1. In **DC02**, search for **Server Manager**, go to the **Local Server** tab and verify that the domain of DC02 is **ccu.cl**.

   ![image](../media/lab03-27.png)
   
1. In **Server Manager**, switch back to Dashboard and click on **Add roles and features**.

   ![image](../media/lab01c.png)
   
1. Select **Role-based or feature-based installation** as the installation type and click **Next**.

   ![image](../media/lab03-29.png)
   
1. In **Server Selection**, select your current server **DC02.ccu.cl** as the destination server and click **Next**.

   ![image](../media/lab03-30.png)
   
1. In **Server Roles**, check the box for **Active Directory Domain Services** and click **Add Features**.

   ![image](../media/lab03-31a.png)
   
   ![image](../media/lab03-31b.png)
   
1. In **Select Features**, review the selected features for AD DS and click **Next**.

   ![image](../media/lab03-32.png)
   
1. In **Active Directory Domain Services**, go through the overview of Active Directory Domain Services (AD DS) and click **Next**.

   ![image](../media/lab03-33.png)
   
1. Confirm installation selections in the **Confirmation** tab and click **Install**.

   ![image](../media/lab03-34.png)
   
1. Wait for the feature installation to complete and click **Promote this server to a domain controller**.

   ![image](../media/lab03-35.png)
   
1. In **Deployment Configuration**, select **Add a domain controller to an existing domain** and click **Change**. Enter the username **azureuser@ccu.cl**, provide your admin password and click **OK**. You can get your vm admin password in the **Environment Details** tab.

   ![image](../media/lab03-36a.png)
   
   ![image](../media/lab03-36b.png)

1. In **Domain Controller Options**, specify the Directory Services Restore Mode (DSRM) password and click **Next**.

   ![image](../media/lab03-37.png)
   
1. In **DNS Options**, ignore the warning and click **Next**.

   ![image](../media/lab03-38.png)
   
1. In **Additional Options**, select **DC01.ccu.cl** from the dropdown for replication and click **Next**.

   ![image](../media/lab03-39.png)
   
1. In **Paths**, verify that the paths of Database folder, Log files folder and SYSVOL folder are set to **C:\Windows\NTDS**, **C:\Windows\NTDS** and **C:\Windows\SYSVOL** respectively and click **Next**.

   ![image](../media/lab03-40.png)
   
1. Review your selections on the **Review Options** tab and click **Next**.

   ![image](../media/lab03-41.png)
   
1. In **Prerequisites Check**, verify that all the prerequisites checks have passed successfully and click **Install**.

   ![image](../media/lab03-42.png)
   
1. Once the installation is complete, a pop-up window appears which says **You're about to be signed out** and your server will be restarted.

   ![image](../media/lab03-43.png)
   
1. In **DC02**, search for **Server Manager** and verify that **AD DS** and **DNS** features are installed.

   ![image](../media/lab01s.png)
   
1. To verify that the AD Replication was successful, in **Server Manager**, click **Tools** and select **Active Directory Users and Computers**.
   
   ![image](../media/lab01t.png)
   
1. In **Active Directory Users and Computers**, you should be able to see the **Duoc** Organizational Unit and a user named **duocano** created in your primary server **DC01**.

   ![image](../media/lab03-46.png)
