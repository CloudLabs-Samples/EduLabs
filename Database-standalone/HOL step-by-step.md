# Exercise1: MYSQL Learning


## Database: A database is merely a structured collection of data.
The data relating to each other by nature. Therefore, we use the term relational database.
A table contains columns and rows. It is like a spreadsheet.
A table may relate to another table using a relationship, e.g., one-to-one and one-to-many relationships.

## SQL(structured query language) – the language of the relational database
SQL is the standardized language used to access the database. ANSI/SQL defines the SQL standard.
SQL contains three parts:
   - **Data definition language** includes statements that help you define the database and its objects, e.g., tables, views, triggers, stored procedures, etc.
   - **Data manipulation language** contains statements that allow you to update and query data.
   - **Data control language** allows you to grant the permissions to a user to access specific data in the database.

## MySQL

The daughter’s name of the MySQL’s co-founder is **Monty Widenius**. The name of MySQL is the combination of My and SQL, MySQL.

MySQL is a database management system that allows you to manage relational databases. It is open source software backed by Oracle. It means you can use MySQL without paying a dime. Also, if you want, you can change its source code to suit your needs. Even though MySQL is open source software, you can buy a commercial license version from Oracle to get premium support services. MySQL is pretty easy to master in comparison with other database software like Oracle Database, or Microsoft SQL Server.




### Task 1: Connect to MySQL server(In Ubuntu VM)

1. To connect to the MySQL Server, use this command:

   ```
     sudo mysql -u root
   ```

1. The following command will be prompted if you successfully connected to the MySQL server:

   `mysql>`

1. Use the SHOW DATABASES to display all databases in the current server. The output for the above command will be shown as below:
    ```
    show databases;
    ```
1. Use the following commands for creating a sample database **demo** and we will be using it in further steps of this task.
    ```
    CREATE DATABASE demo;
    ```
   The following message will be prompted after running the above command successfully.
   
   `Query OK, 1 row affected (0.02 sec)`
   
1. Run the following command for using the database **demo** which we created in the above step. After running the command you will be prompted with a message saying **Database changed**.
   ```
   USE demo;
   ```
1. **DROP DATABASE** command is used for deleting the databases in MySQL. After running the following command the database **demo** which we created at the step 6 will be deleted. The query will resuls with a message saying **Query OK, 0 rows affected (0.03 sec)**.
   ```
   DROP DATABASE demo;
   ```

### Task 2: CRUD(Create, Read, Update and Delete) operations in MySQL

1. 
