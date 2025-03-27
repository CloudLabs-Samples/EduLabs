# Lab 5: Introduction to Cloud Computing - SQL Databases

## Prerequisites:
Before beginning this lab, make sure you have the following tools installed:
- **SQL Server Management Studio (SSMS)** or **Azure Data Studio**.
  - **Download SSMS** from [here](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16).
  - **Download Azure Data Studio** from [here](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio?tabs=win-install%2Cwin-user-install%2Credhat-install%2Cwindows-uninstall%2Credhat-uninstall#download-azure-data-studio).

Ensure that these tools are installed and working correctly before proceeding with the lab.

## Lab Steps:

### Step 1: Create a SQL Database
1. **Create a new SQL Database** on Azure for a development workload environment:
   - Log into your [Azure Portal](https://portal.azure.com/).
   - In the left sidebar, click **Create a resource**, then search for **SQL Database**.
   - Click on **SQL Database** and then click **Create**.
   - Fill in the necessary details:
     - **Subscription**: Choose your active subscription.
     - **Resource Group**: Select or create a new resource group.
     - **Database Name**: Choose a name for your SQL Database.
     - **Server**: Either select an existing server or create a new one.
     - **Subscription**: Choose your subscription.
   - Select **Locally Redundant Storage** (LRS) for backup options.
   
2. **Enable both SQL and Microsoft Entra authentication**:
   - In the **Authentication Method** section, select both **SQL Authentication** and **Microsoft Entra authentication**.
   - For SQL Authentication, you will need to specify the SQL admin username and password.
   - For Microsoft Entra Authentication, ensure your Azure Active Directory (AAD) credentials are ready to use.

3. **Select Locally Redundant Backup Storage**:
   - Under the **Backup** section, choose **Locally redundant** as the backup storage redundancy option. This ensures that backups are stored in the same region for high availability.

4. Take **screenshots**:
   - Screenshot showing the configuration of the **SQL database** creation form.
   - Screenshot focusing on the settings where you enable both **SQL Authentication** and **Microsoft Entra Authentication**.
   - Screenshot of the backup configuration where you select **Locally Redundant Storage**.

### Step 2: Login to the Database
1. **Login to the database** using **SQL Server Management Studio (SSMS)** or **Azure Data Studio**.
   - Open SSMS or Azure Data Studio and connect to the SQL Database server created in Step 1.
   
2. **Login with SQL Authentication**:
   - Enter the **SQL login** credentials that you set during the database creation in Step 1 (SQL admin username and password).
   - Click **Connect**.
   - Take a screenshot showing the credentials being entered in SSMS/Azure Data Studio and confirm the successful sign-in.

3. **Login with Microsoft Entra Authentication**:
   - In SSMS or Azure Data Studio, select **Azure Active Directory – Password** as the authentication method.
   - Enter your **Microsoft Entra** credentials (username and password).
   - Click **Connect**.
   - Take a screenshot showing the credentials being entered and confirm the successful sign-in with Microsoft Entra authentication.

### Step 3: Delete Resources
1. **Delete the SQL Database**:
   - After completing the lab, go back to the **Azure Portal**.
   - Locate the SQL Database and SQL Server resources you created.
   - Click on the SQL Database, then click **Delete** to remove the database.
   - Confirm the deletion and wait for the resources to be deleted.

2. **Delete any other resources** (e.g., resource groups, servers, etc.) that were created during the lab to ensure clean-up of all resources.

**Note**: Make sure to follow the lab instructions carefully and ensure that the necessary configurations and settings are applied during each step.

