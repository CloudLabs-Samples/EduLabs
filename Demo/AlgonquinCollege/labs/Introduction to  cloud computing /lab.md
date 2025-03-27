# Lab 5: Introduction to Cloud Computing

## Prerequisites:
A VM with **Azure Data Studio** and **SQL Server Management Studio (SSMS)** pre-installed has been provided to you; please use these tools for the lab.

## Lab Steps:

## SQL Databases

A **SQL Database** is a type of database that uses **Structured Query Language (SQL)** to manage and manipulate relational data. SQL databases store data in **tables** (rows and columns), where each table represents a different entity, and relationships between entities are defined using keys (e.g., primary and foreign keys).

Key features of SQL databases include:
- **Structured Data**: Data is stored in tables with predefined structures.
- **Relational Model**: Data is linked across tables using relationships such as primary and foreign keys.
- **SQL**: The language used to interact with the database, including querying, inserting, updating, and deleting data.
- **ACID Properties**: Ensures that database transactions are processed reliably and maintain data integrity (Atomicity, Consistency, Isolation, Durability).
  
Examples of SQL databases include **Microsoft SQL Server**, **MySQL**, **PostgreSQL**, and **Oracle Database**. These databases are widely used in various applications, including business systems, e-commerce, and financial applications.

In cloud computing, services like **Azure SQL Database** allow users to manage relational data in the cloud without the need for physical infrastructure management.

### Task 1: Create a SQL Database

1. Log into your **Azure Portal** if you haven't already.
   
2. In the left sidebar, click **Create a resource**, then search for **SQL Database**.
   ![Create a Resource](images/1.png)

3. Click on **SQL Database** and then click **Create**.

4. Fill in the necessary details:
   1. **Subscription**: Choose your active subscription.
   2. **Resource Group**: Select or create a new resource group.
   3. **Database Name**: Choose a name for your SQL Database.
   4. **Server**: Either select an existing server or create a new one.
   5. **Subscription**: Choose your subscription.
5. Select **Locally Redundant Storage (LRS)** for backup options.
6. In the **Authentication Method** section, select both **SQL Authentication** and **Microsoft Entra authentication**.
8. For SQL Authentication, you will need to specify the SQL admin username and password.
9. For Microsoft Entra Authentication, ensure your Azure Active Directory (AAD) credentials are ready to use.
10. Under the **Backup** section, choose **Locally redundant** as the backup storage redundancy option. This ensures that backups are stored in the same region for high availability.
11. Take screenshots:
   1. Screenshot showing the configuration of the **SQL database** creation form.
   2. Screenshot focusing on the settings where you enable both **SQL Authentication** and **Microsoft Entra Authentication**.
   3. Screenshot of the backup configuration where you select **Locally Redundant Storage**.

---

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

