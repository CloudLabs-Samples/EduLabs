# Lab 5: Introduction to Cloud Computing

## Prerequisites:
A VM with **Azure Data Studio** and **SQL Server Management Studio (SSMS)** pre-installed has been provided to you; please use these tools for the lab.

## SQL Databases

A **SQL Database** is a type of database that uses **Structured Query Language (SQL)** to manage and manipulate relational data. SQL databases store data in **tables** (rows and columns), where each table represents a different entity, and relationships between entities are defined using keys (e.g., primary and foreign keys).

Key features of SQL databases include:
- **Structured Data**: Data is stored in tables with predefined structures.
- **Relational Model**: Data is linked across tables using relationships such as primary and foreign keys.
- **SQL**: The language used to interact with the database, including querying, inserting, updating, and deleting data.
- **ACID Properties**: Ensures that database transactions are processed reliably and maintain data integrity (Atomicity, Consistency, Isolation, Durability).
  
Examples of SQL databases include **Microsoft SQL Server**, **MySQL**, **PostgreSQL**, and **Oracle Database**. These databases are widely used in various applications, including business systems, e-commerce, and financial applications.

In cloud computing, services like **Azure SQL Database** allow users to manage relational data in the cloud without the need for physical infrastructure management.

In this lab, we will create a SQL database in Azure and then query the data in that database.

### Task 1: Create a SQL Database on Azure

1. Log into your **Azure Portal** if you haven't already using the credentials
   
   - **Email/Username:** <inject key="AzureAdUserEmail"></inject>

   - **Password:** <inject key="AzureAdUserPassword"></inject>
   
3. In the left sidebar, click **Create a resource**, then search for **SQL Database**.

   ![Create a Resource](images/1.png)

4. Click on **SQL Database** and then click **Create**.

   ![Create a Resource2](images/2.png)

5. **On the Basics tab of the Create SQL Database form**, under **Project details**, select the existing **Azure Subscription** and **Resource group**  **cloudcomputing-<inject key="DeploymentID" enableCopy="false"/>** 

   ![Create SQL DB](images/3.png)

6. For **Database name**, enter **mydb-<inject key="DeploymentID" enableCopy="false"/>**. For **Server**, select **Create new**

   ![SQL DB name](images/4.png)

8. Fill out the **New server** form with the following values:
   - **Server name**: Enter **mysqlserver-<inject key="DeploymentID" enableCopy="false"/>** 
   - **Location**: Select a location from the dropdown list.
   - **Authentication method**: Select **Use both SQL and Microsoft Entra authentication**.
   - **Set Microsoft Entra admin**: Click on **Set admin** and search for **Username:** <inject key="AzureAdUserEmail"></inject> and select it
   - **Server admin login**: Enter `sqluser`.
   - **Password**: Enter a password that meets the requirements, and enter it again in the **Confirm password** field.
   
   ![SQL DB name](images/5.png)

9. Select **OK**.
   
10. Leave **Want to use SQL elastic pool** set to **No**.

11. For **Workload environment**, specify **Development** for this exercise.
   - The **Azure portal** provides a **Workload environment** option that helps preset some configuration settings. These settings can be overridden.
   - The **Development** workload environment sets the following options:
     - **Backup storage redundancy** is **locally redundant storage**.
     - **Compute + storage** is **General Purpose, Serverless** with a single vCore. By default, there is a one-hour auto-pause delay.
   - Choosing the **Production** workload environment sets:
     - **Backup storage redundancy** is **geo-redundant storage**.
     - **Compute + storage** is **General Purpose, Provisioned** with 2 vCores and 32 GB of storage.
8. Under **Compute + storage**, select **Configure database**.
   - This quickstart uses a **serverless database**, so leave the **Service tier** set to **General Purpose (Most budget-friendly, serverless compute)** and set **Compute tier** to **Serverless**.
   - Select **Apply**.
9. Under **Backup storage redundancy**, choose a redundancy option for the storage account where your backups will be saved. 
   - To learn more, see **backup storage redundancy**.
10. Select **Next: Networking** at the bottom of the page.
    - **Screenshot** of the **Create SQL Database** page, **Basic** tab from the Azure portal.
11. On the **Networking** tab, for **Connectivity method**, select **Public endpoint**.
12. For **Firewall rules**, set **Add current client IP address** to **Yes**.
13. Leave **Allow Azure services and resources to access this server** set to **No**.
    - **Screenshot** of the **Azure portal** showing the **Networking** tab for **firewall rules**.
14. Under **Connection policy**, choose the **Default connection policy**, and leave the **Minimum TLS version** at the default of **TLS 1.2**.
15. Select **Next: Security** at the bottom of the page.
    - **Screenshot** that shows the **Networking** tab for **policy** and **encryption**.
16. On the **Security** page, you can choose to start a free trial of **Microsoft Defender for SQL**, as well as configure **Ledger**, **Managed identities**, and **Azure SQL transparent data encryption with customer-managed key** if desired.
17. Select **Next: Additional settings** at the bottom of the page.
18. On the **Additional settings** tab, in the **Data source** section, for **Use existing data**, select **Sample**.
    - This creates an **AdventureWorksLT sample database** so there are some tables and data to query and experiment with, as opposed to an empty blank database.
    - You can also configure **database collation** and a **maintenance window**.
19. Select **Review + create** at the bottom of the page:
    - **Screenshot** of the **Azure portal** showing the **Additional settings** tab.
20. On the **Review + create** page, after reviewing, select **Create**.


### Step 2: Login to the Database

1. Open SSMS or Azure Data Studio and connect to the SQL Database server created in Step 1.
2. Enter the **SQL login** credentials that you set during the database creation in Step 1 (SQL admin username and password).
3. Click **Connect**.
4. Take a screenshot showing the credentials being entered in SSMS/Azure Data Studio and confirm the successful sign-in.
5. In SSMS or Azure Data Studio, select **Azure Active Directory – Password** as the authentication method.
6. Enter your **Microsoft Entra** credentials (username and password).
7. Click **Connect**.
8. Take a screenshot showing the credentials being entered and confirm the successful sign-in with Microsoft Entra authentication.

---

### Step 3: Delete Resources

1. All the resources will be deleted automatically once the lab duration is exhausted.

---

**Note**: Make sure to follow the lab instructions carefully and ensure that the necessary configurations and settings are applied during each step.

