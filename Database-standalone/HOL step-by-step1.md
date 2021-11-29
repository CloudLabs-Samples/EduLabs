# Exercise 2: PostgreSQL Learning


## Database: A database is merely a structured collection of data.
Each POSTGRESQL server controls access to a number of databases. Databases are storage areas used by the server to partition information.

## PostgreSQL – POSTGRESQL is the most advanced open source database server.

PostgreSQL is a powerful, open source object-relational database system. It has more than 15 years of active development and a proven architecture that has earned it a strong reputation for reliability, data integrity, and correctness. PostgreSQL runs on all major operating systems, including Linux, UNIX (AIX, BSD, HP-UX, SGI IRIX, Mac OS X, Solaris, Tru64), and Windows.

## PostgreSQL

### Task 1:

1. Use the following commands to connect to the PostgreSQL Server.

   ```
   sudo su postgres
   psql
   ```
   
1. The following command will be prompted on screen if you successfully connected to the MySQL server:

   `postgres=#`

1. Use the **\l** to display all defualt databases in the current server. The output for the above command will be shown as below:
    
    ```
    \l
    ```
    ![](media/)
    
1. Use the following commands for creating a sample database **postgredb** and we will be using it in further steps of this task.

    ```
    CREATE DATABASE postgredb;
    ```
   
1. Run the following command for using the database **postgredb** which we created in the above step. After running the command you will be prompted with a message saying **You are now connected to database "postgredb" as user "postgres"**.
   
   ```
   \c postgredb
   ```
1. **DROP DATABASE** command is used for deleting the databases in PostgreSQL. We are not dropping the database now as we will be using it in further tasks.


### Task 2: Table creation and Insert commands

1. Run the below commands to create a table using **CREATE TABLE** command inside the **postgredb** database.
   
   ```
   CREATE TABLE sample_table(id int, name varchar(15));
   ```
   ![](media/)
   
1. **INSERT INTO** command is used for adding the data to the table which we created in the above step. The below command will add the data to the **sample_table**.
   
   ```
   INSERT INTO sample_table ( id, name ) VALUES ( 1, 'Sample data1' );
   INSERT INTO sample_table ( id, name ) VALUES ( 2, 'Sample data2' );
   INSERT INTO sample_table ( id, name ) VALUES ( 3, 'Sample data3' );
   ```
   ![](media/)
   
1. In order to view the data created inside the **sample_table**, run the following command and you will be prompted with a table with two fields **id** and **name**.
   
   ```
   SELECT * FROM sample_table;
   ```
   ![](media/)
   
1. With the below command we are only selecting the **name** field from the above table.
   
   ```
   SELECT name FROM sample_table;
   ```
   ![](media/)
   
1. To update values in the multiple columns of the table, you need to specify the assignments in the SET clause. For example, the following statement updates data in **name** field with **id=2**.
   
   ```
   UPDATE sample_table SET name = 'Hill' WHERE id = 2;
   ```
   ![](media/)
   
   Run the below command to view the changes to the table after running update command.
    
    ```
    SELECT * FROM sample_table;
    ```
    ![](media/)
    
1. To delete the data inside the above table, we are using **DELETE FROM** command with **WHERE** clause to delete the specific row of data inside the table.
   
   ```
   DELETE FROM sample_table WHERE id=3;
   ```
   Run the below command to view the changes to the table after running **DELETE FROM** command.The above command will delete the data with id=3.
    ```
    SELECT * FROM sample_table;
    ```
    ![](media/)
    
1. **DROP TABLE** command is used to delete the complete table inside database. you will be prompted with a `DROP TABLE` message after running the following command.
   
    ```
    DROP TABLE sample_table;
    ```

