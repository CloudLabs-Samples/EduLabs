# Exercise

1. In your VM, double click on the **Azure Portal** icon to sign in. You can get your Azure user credentials in the **Environment Details** tab.

   ![image](../media/lab01-creds.png)

1. On the Sign-in tab, enter your username and click **Next**.

   ![image](../media/lab01-user-sign-in.png)

1. Enter the password for your username and click **Sign-in**.

   ![image](../media/lab01-sign-in-pass.png)

1. On the **Help us protect your account** tab, click **Skip for now (14 days until this is required)**.

   ![image](../media/lab01-sign-in-skip.png)

1. On the **Stay signed in?** tab, click **Yes**.

   ![image](../media/lab01-stay-signed-in.png)

1. In the Azure portal, search for Virtual Machines and verify that the server is named as **DC01**.
   
   ![image](../media/lab01b.png)
   
1. In the Azure portal, search for **Resource groups**, select your resource group and select your server's public IP.

1. On the **Settings** tab, click on **Configurations** and verify that the IP address assignment is set to **Static**.

   ![image](../media/lab01_pip.png)
   
1. In your VM, search for **Server Manager** and on the Dashboard click on **Add roles and features**.
   
   ![image](../media/lab01c.png)
   
1. Select **Role-based or feature-based installation** as the installation type and click **Next**.
   
   ![image](../media/lab01_d.png)
   
1. In **Server Selection**, select your current server **DC01** as the destination server and click **Next**.

   ![image](../media/lab01e.png)
   
1. In **Server Roles**, check the box for **Active Directory Domain Services** and click **Add Features**.

   ![image](../media/lab01f.png)
   
   ![image](../media/lab01g.png)
   
1. In **Select Features**, review the selected features for AD DS and click **Next**.

   ![image](../media/lab01-13.png)
   
1. In **Active Directory Domain Services**, go through the overview of Active Directory Domain Services (AD DS) and click **Next**.

   ![image](../media/lab01-14.png)

1. Confirm installation selections in the **Confirmation** tab and click **Install**.

   ![image](../media/lab01h.png)
   
1. Wait for the feature installation to complete and click **Promote this server to a domain controller**.

   ![image](../media/lab01i.png)
   
1. In **Deployment Configuration**, select **Add a new forest**, specify the root domain name as **DUOC.CL** and click **Next**.

   ![image](../media/lab01_j.png)
   
1. In **Domain Controller Options**, specify the Directory Services Restore Mode (DSRM) password and click **Next**.

   ![image](../media/lab01k.png)
   
1. In **DNS Options**, ignore the warning and click **Next**.

   ![image](../media/lab01l.png)
   
1. In **Additional Options**, verify that the NetBIOS domain name is set to **DUOC** and click **Next**.

   ![image](../media/lab01_m.png)
   
1. In **Paths**, verify that the paths of Database folder, Log files folder and SYSVOL folder are set to **C:\Windows\NTDS**, **C:\Windows\NTDS** and **C:\Windows\SYSVOL** respectively and click **Next**.

   ![image](../media/lab01n.png)
   
1. Review the options on the **Review Options** tab and click **Next**.

   ![image](../media/lab01_o.png)
   
1. In **Prerequisites Check**, verify that all the prerequisites checks have passed successfully and click **Install**.

   ![image](../media/lab01_p.png)
   
1. Once the installation is complete, a pop-up dialog box appears which says **You're about to be signed out** and your server will be restarted.

   ![image](../media/lab01q.png)
   
1. When the server is restarted, please wait for the Group Policy client to be configured.

   ![image](../media/lab01r.png)
   
1. In your VM, search for **Server Manager** and verify that **AD DS** and **DNS** features are installed.

   ![image](../media/lab01s.png)
   
1. In **Server Manager**, click **Tools** and select **Active Directory Users and Computers**.

   ![image](../media/lab01t.png)
   
1. In **Active Directory Users and Computers**, right click on your domain **DUOC.CL**, click **New** and select **Organizational Unit**.

   ![image](../media/lab01u.png)
   
1. Name your new Organizational Unit **Sales** and click **OK**.

   ![image](../media/lab01v.png)
   
1. Similarly, folow the steps 28 and 29 to create two more Organizational Units, **Support** and **Management**.

   ![image](../media/lab01w.png)
   
1. In **Active Directory Users and Computers**, right click on your domain **DUOC.CL**, click **New** and select **User**.

   ![image](../media/lab01x.png)
   
1. Enter the following credentials given below and click **Next**.

   | Setting | Value |
   | --- | --- |
   | First name | **Juan** |
   | Last name | **Pérez** |
   | Full name | **Juan Pérez** |
   | User logon name | **Juan.Pérez** |

   ![image](../media/lab01y.png)
   
1. Enter a secure password for the user, check the box for **User must change password at next logon** and click **Next**.

   ![image](../media/lab01z.png)
   
1. Review the user credentials and click **Finish**.

   ![image](../media/lab01-z.png)
   
1. Similarly, follow the steps from 31 to 34 to create two more users, **Pedro González** and **Rodrigo Silva**.

   ![image](../media/lab01-ad-users.png)
   
1. In **Active Directory Users and Computers**, right click on your domain **DUOC.CL**, click **New** and select **Group**.

   ![image](../media/lab01-grp.png)
   
1. Name the new group **Global Admins**, leave the other settings as default and click **OK**. 

   ![image](../media/lab01-grp-name.png)
   
   ![image](../media/lab01-ga-grp.png)
   
1. Open the **Global Admins** group, in the **Members** tab click **Add**.

   ![image](../media/lab01-36.png)
   
1. In **Select Users, Contacts, Computers, Service Accounts, or Groups**, search for **Juan** and click **Check Names**.

   ![image](../media/lab01-37.png)
   
1. In **Select Users, Contacts, Computers, Service Accounts, or Groups**, full name of the user appears with the user logon name. Click **OK**.

   ![image](../media/lab01-38.png)
   
1. In **Global Admins Properties**, verify that the user is added as a member of the group.

   ![image](../media/lab01-39.png)
   
1. Simlarly, follow the steps from 38 to 40 to add another member **Pedro González** and verify that there are two members added to the **Global Admins** group.

   ![image](../media/lab01-40.png)
   
1. In **Global Admins Properties**, switch to the **Member Of** tab and click **Add**.

   ![image](../media/lab01-41.png)
   
1. In **Select Groups**, search for **Admin** or **Administrators** and click **Check Names**.
   
   ![image](../media/lab01-42.png)
   
1. In **Select Groups**, the built-in **Administrators** group appears. Click **OK**.

   ![image](../media/lab01-43.png)
   
1. In **Global Admins Properties**, verify that **Administrators** is a member of the group and click **OK**.

   ![image](../media/lab01-44.png)
