# Exercise

1. In your VM, double click on the **Azure Portal** icon to sign in. You can get your Azure user credentials in the **Environment Details** tab.

   ![image](../media/lab02-1.png)
  
1. On the Sign-in tab, enter your username and click **Next**.

   ![image](../media/lab01-user-sign-in.png)

1. Enter the password for your username and click **Sign-in**.

   ![image](../media/lab01-sign-in-pass.png)

1. On the **Help us protect your account** tab, click **Skip for now (14 days until this is required)**.

   ![image](../media/lab01-sign-in-skip.png)

1. On the **Stay signed in?** tab, click **Yes**.

   ![image](../media/lab01-stay-signed-in.png)
   
1. In the Azure portal, search for Virtual Machines and verify that there are two virtual machines, **DC01** and **WindowsClient**.

   ![image](../media/lab02-6.png)
   
1. Click on **DC01** and verify that the **Private IP Address** is **10.0.0.4**.

   ![image](../media/lab02-7.png)
   
1. Switch back to Virtual Machines, click on **WindowsClient** and verify that the **Private IP Address** is **10.0.0.5**.

   ![image](../media/lab02-8.png)
   
1. In your VM, search for **Server Manager** and on the Dashboard click on **Add roles and features**.
   
   ![image](../media/lab01c.png)
   
1. Select **Role-based or feature-based installation** as the installation type and click **Next**.
   
   ![image](../media/lab01_d.png)
   
1. In **Server Selection**, select your current server **DC01** as the destination server and click **Next**.

   ![image](../media/lab01e.png)
   
1. In **Server Roles**, check the box for **Web Server (IIS)** and click **Add Features**.

   ![image](../media/lab02-12a.png)
   
   ![image](../media/lab02-12b.png)
   
1. In **Select Features**, expand **.NET Framework 4.6 Features**, check the box for **ASP.NET 4.6**. In **.NET Framework 4.6 Features**, expand **WCF Services**, check the box for **HTTP Activation** and click **Add Features**.

   ![image](../media/lab02-13a.png)
   
   ![image](../media/lab02-13b.png)
   
1. In **Select Features**, expand **.NET Framework 3.5 Features**, check the box for **HTTP Activation** and click **Add Features**.

   ![image](../media/lab02-14a.png)
   
   ![image](../media/lab02-14b.png)
   
1. In **Select Features**, review the selected features and click **Next**.

   ![image](../media/lab02-15.png)
   
1. In **Web Server Role (IIS)**, go through the overview of Web Server Role (IIS) and click **Next**.

   ![image](../media/lab02-16.png)
   
1. In **Select Role Services**, expand **Security** and check the box for **Windows Authentication**.

   ![image](../media/lab02-18.png)
   
1. In **Select Role Services**, expand **Application Development** and chekc the box for **ASP.NET 3.5**.
   
   ![image](../media/lab02-19.png)
   
1. In **Select Role Services**, verify that the following services are selected and click **Next**.

   * Common HTTP Features
      * Default Document
      * Directory Browsing
      * HTTP Errors
      * Static Content
   * Securiy
      * Request Filtering
      * Windows Authentication
   * Application Development
      * .NET Extensibility 3.5
      * .NET Extensibility 4.6
      * ASP.NET 3.5
      * ASP.NET 4.6
      * ISAPI Extensions
      * ISAPI Filters
    * Management Tools
      * IIS Management Console
   
   ![image](../media/lab02-20.png)
   
1. Confirm installation selections in the **Confirmation** tab and click **Install**.

   ![image](../media/lab02-21.png)
   
1. Wait for the feature installation to complete and click **Close**.

   ![image](../media/lab02-22.png)
   
1. In **Server Manager**, verify that the **IIS** feature is installed.

   ![image](../media/lab02-23.png)
   
1. In Azure portal, search for Virtual Machines and connect to your **WindowsClient** virtual machine through **RDP**.

1. In your **WindowsClient** VM, open Microsoft Edge, search for **http://10.0.0.4** and verify that the Web Server that you installed on your DC01 is running.

   ![image](../media/lab02-25.png)
