# Exercise 3: Getting Started with MongoDB Learning


## Overview

NoSQL databases (Not only SQL) are non-tabular databases and store data differently than relational tables. NoSQL databases come in a variety of types based on their data model. The main types are document, key-value, wide-column, and graph. They provide flexible schemas and scale easily with large amounts of data and high user loads.

## MongoDB

MongoDB is an open-source document-oriented database that is designed to store a large scale of data and also allows you to work with that data very efficiently. It is categorized under the NoSQL (Not only SQL) database because the storage and retrieval of data in the MongoDB are not in the form of tables. 

The data stored in the MongoDB is in the format of BSON documents. Here, BSON stands for Binary representation of JSON documents. The MongoDB server converts the JSON data into a binary form that is known as BSON and this BSON is stored and queried more efficiently. MongoDB has a rich set of queries for performing fast and easy operations.

Basic building blocks of MongoDB:

  - **Collection**: Its group of MongoDB documents. This can be thought similar to a table MySQL. This collection doesn’t enforce any structure. 
  - **Document**: Document is referred to as a record in MongoDB collection. Which is similar to **Table** in MySQL.
  - **Field**: It is a name-value pair in a document. A document has zero or more fields. Fields are like columns in relational databases.


### Task 1: Create and Drop Database Operations in MongoDB

In this section, you will learn how to manage databases in MongoDB including creating databases, viewing database features, and deleting databases.

1. Run the following query to connect to the MongoDB server from terminal.

   ```
   mongo
   ```
1. Once you are connected to the MongoDB server, a message will be displayed and the `>` prompt appears as shown below.

   ![](media/)

1. Run the following query to display all default databases in the current server. 
    
    ```
    show dbs;
    ```
    The output for the above command will be similar to below screenshot.
    
    ![](media/)
    
1. Execute the below query to create a sample database named **demodb** and connect to it. We will be using this database in further steps of this task. 

    ```
    use demodb;
    ```
    ![](media/)
   
1. Run the below query to create a connection inside **demodb** database. In MongoDB, we can't view the view the database until we create a connection inside the database.
   
   ```
   db.createCollection("Demo");
   ```
   ![](media/)
   
1. Run the following query to view the database **demodb** which we created in step 4. 
   
   ```
   show dbs;
   ```
   The output for the above command will be similar to below screenshot. Observe the newly added database in the output.
   
   ![](media/)
   
1. **db.dropDatabase();** command is used for deleting the databases in MongoDB. however we are not dropping the database now as we will be using it in further tasks.


### Task 2: MongoDB CRUD Operations

In this task we will learn about CRUD operations in MongoDB. CRUD stands for Create, Read, Update and Delete operations in MongoDB. 

CRUD operations mean:
  - C- Create or insert operations add new documents to a collection. If the collection does not currently exist, insert operations will create the collection.
  - R- Read operations retrieve documents from a collection; i.e. query a collection for documents. MongoDB provides the following methods to read documents from a collection.
  - U- Update operations modify existing documents in a collection. MongoDB provides the following methods to update documents of a collection.
  - D- Delete operations remove documents from a collection. MongoDB provides the following methods to delete documents of a collection.

1. Run the below query to create a new collection named **student** inside the **demodb** database. In MongoDB, **db.createCollection()** method is used to create collection.
   
   ```
   db.createCollection("student");
   ```
   ![](media/)
   
1. In the next step, you will insert the documents to the **student** collection by running the following queries. In MongoDB insert documents can be done using 2 methods, **insertOne()** and **insertMany()**. we are using insertMany() method here as we are inserting multiple documents.
   
   ```
   db.student.insertMany([
   { name:"Suraj", age:"21", department:"science"},
   { name:"Ram", age:"21", department:"maths"},
   { name:"Dev", age:"25", department:"history"},
   { name:"Tom", age:"26", department:"sociology"},
   { name:"Harry", age:"23", department:"science"}
   ]);
   ```
   ![](media/)
   
1. Run the following query in order to view the documents inside the **student** collection. 
   
   ```
   db.student.find();
   ```
   You will be prompted with documents within the **student** collection as shown below.
   
   ![](media/)
   
1. Execute the following query to output the documents in a formatted output. In MongoDB, we use **pretty()** method along with query for formatting the output data.
   
   ```
   db.student.find().pretty();
   ```
   ![](media/)
   
1. Run the below query and observe the output document. **findone()** method is used in MongoDB for retrieving the first document inside the collection.

   ```
   db.student.findOne();
   ```
   ![](media/)
   
   > Note: The above query will select the first document inside **student** connection.
   
1. Execute the following query select the records with **age=21**.
    
    ```
    db.student.find({"age":"21"});
    ```
    ![](media/)
   
1. The MongoDB query language supports 2 update operations **updateOne()** and **updateMany()**. Run the below query and observe the output for **updateOne()** method.

   ```
   db.student.updateOne( {age: "25"}, {"$set": {"age": "24"}} );
   ```
   ![](media/)
   
1. Execute the following query to view the updated document. The above query will update the value of **age=25** to **age=24** inside the **student** collection.
   
   ```
   db.student.find().pretty();
   ```
   ![](media/)
   
1. Execute the following query and observe the output for **updateMany()** method. This query will set all the records will **age=21** to **age=20**.
    
    ```
    db.student.updateMany( {age: "21"}, {"$set": {"age": "20"}} );
    ```
    ![](media/)
    
1. Execute the below query to view the updated document. The above query will update all the values of **age=21** to **age=20** inside the **student** collection.
   
   ```
   db.student.find().pretty();
   ```
   ![](media/)

1. Run the following query to delete the **document** inside the student collection. MongoDB query language supports 2 delete operations **deleteOne()** and **deleteMany()**. In the below query we are using **deleteMany()** method to delete the multiple documents. 
   
   ```
   db.student.deleteMany( {age: "20"});
   ```
   ![](media/)
   
   
1. Execute the below query to view the updated document. The above query will delete all the records with **age=20** inside the **student** collection.

    ```
    db.student.find().pretty();
    ```
    ![](media/)
    
1. Execute the following query to delete the collection **student** which we created in the task 1. **db.COLLECTION_NAME.drop()** query is used to delete the whole collection inside the database.
   
   > Note: Inside **db.COLLECTION_NAME.drop()**, **COLLECTION_NAME** refers to the name of the collection which you created.
   
    ```
    db.student.drop();
    ```
   ![](media/)
    
### Task 3: Comparison & Logical Operators in MongoDB

In this task, we will use various clauses that let you to filter how your data is queried to you. A clause in PostgreSQL is a part of a query that lets you filter or customizes how you want your data to be queried to you. PostgreSQL queries are SQL functions that help us to access a particular set of records from a database table. We can request any information or data from the database using the clauses. In the following task we will use **SELECT**, **FROM**, **WHERE**, **WITH**, **GROUP BY**, **HAVING**, **ORDER By** clauses to get the data from the database and observe how clauses will work for fetching the data.


1. Run the below query to create a new collection named **teachers**  and insert the documents to collection inside the **demodb** database. We will be using this collection in the further tasks.
   
   ```
   db.createCollection("teachers");

   ```
   ```
   db.teachers.insertMany([
   { name:"Sam", age:"28", department:"science", year:"1994"},
   { name:"Ram", age:"30", department:"maths", year:"1992"},
   { name:"Jerry", age:"27", department:"history", year:"1995"},
   { name:"Tom", age:"23", department:"sociology", year:"1998"},
   { name:"Harry", age:"32", department:"science", year:"1989"}
   ]);
   ```
1. Run the following query inorder to view the documents added inside the **teachers** table.
   
   ```
   db.teachers.find().pretty();
   ```
   
   ![](media/)
   
1. Execute the below to query and observe the ouput. **$gt** selects those documents where the value of the field is greater than (i.e. > ) the specified value.
   
   ```
   db.teachers.find({"age":{$gt:"30"}}).pretty();
   ```
   ![](media/)
   
   > Note :The above query will return the records whose age is greater than 30 inside the **teachers** collection.
   
1. Run the below query check the ouput records. **$lt** selects those documents where the value of the field is greater than (i.e. < ) the specified value.

    ```
    db.teachers.find({"age":{$lt:"25"}}).pretty();
    ```
    ![](media/)
    
    > Note :The above query will return the records whose age is less than 25 inside the student collection.

1. Execute the below to query and observe the ouput. **$gte** selects those documents where the value of the field is greater than or equals  (i.e. >= ) to the specified value.
   
   ```
   db.teachers.find({"age":{$gte:"30"}}).pretty();
   ```
   ![](media/)
   
   > Note :The above query will return the records whose age is greater than or equals 30 inside the **teachers** collection.

1. Run the below to query and observe the ouput. **$lte** selects those documents where the value of the field is less than or equals (i.e. <= ) to the specified value.
   
   ```
   db.teachers.find({"age":{$lte:"30"}}).pretty();
   ```
   ![](media/)
   
   > Note :The above query will return the records whose age is less than or equals 30 inside the **teachers** collection.
   
1. Execute the below to query and observe the ouput. **$ne** selects those documents where the value of the field is not equals (i.e. != ) to the specified value.
   
   ```
   db.teachers.find({"age":{$ne:"23"}}).pretty;
   ```
   ![](media/)
   
   > Note :The above query will return all the records except **age=23** inside the **teachers** collection.
   
1. Run the below query and observe the output records. **$and** operator evaluates one or more expressions and returns ouput only if all of the expressions are true. The following query will will return the document with **name=Sam** and **age=28**.
   
   ```
   db.teachers.find( { $and : [{age:"28"}, {name:"Sam"}]}).pretty();
   ```
   ![](media/)

1. Run the below query and observe the output records. **$or** operator selects the documents that satisfy at least one of the expressions. The following query will will return the document with **name=tom** or **age=30**.
  
   ```
   db.teachers.find( { $or : [{"name":"zayn"},{"age":"30"}]}).pretty();
   ```
   
   > Note: As we all know we don't have any document with name **zayn** in the **teachers** collection. So the **$or** operator will return the document with **age=30** from the **teachers** collection as shown in the below screenshot.
  
   ![](media/)

### Task 4: Update, Delete and Replace commands in PostgreSQL

In this task, we will use PostgreSQL **UPDATE** statement which can be used to modify any field value of any table and **DELETE** statement which is used to delete existing records in a table. The **REPLACE** statement in PostgreSQL works the same as the INSERT statement, except that if an old row matches the new record in the table for a PRIMARY KEY or a UNIQUE index, this command deleted the old row before the new row is added.

1. Execute the following query. In the below query **Update** command is used to update the data in the **Course** table. The following query replaces course ID **101** with **1001** inside **Course** table.
   
   ```
   UPDATE Course SET CourseId = 1001 WHERE CourseId = 101;
   ```
   ![](media/postgre-update.png)
   
1. Run following query and observe that the Name Bhaskar is replced with **John**. **Replace command** is used to replace all occurrences of a substring within a string, with a new substring. 
   
   ```
   SELECT CourseId, Name, Teacher, REPLACE (Teacher, 'Bhaskar', 'John') Teacher_New FROM Course;
   ```
   ![](media/postgre-replace.png)
   
1. Execute the following query. **DELETE FROM** command is used to delete the records based on the given condition from the table. The below command deletes the Teacher with name **Neelima** from **Course** table.

   ```
   DELETE FROM Course WHERE Teacher = 'Neelima';
   ```
   ![](media/postgre-delete.png)
   
1. Run the following query inorder to view the data inside the **Course** table, observe the data that has been removed from the table.
   
   ```
   SELECT * FROM Course;
   ```
   
   ![](media/postgre-select.png)
   

### Task 5: Joins in PostgreSQL

We will use PostgreSQL joins to combine columns from one (self-join) or more tables based on the values of the common columns between related tables. The common columns are typically the primary key columns of the first table and foreign key columns of the second table.

We will run the example queries with joins including inner join, left join, right join, and full outer join in the following task. Observe the data and changes made to the table after running each query.
    
1. Let us create one more table named **Qualification** and insert different values to the table by running the following queries. We need two tables for performing the actions in PostgreSQL using Joins. 
   
   ```
   CREATE TABLE Qualification
   (
    Qualification Varchar(20),
    Teacher_Name VARCHAR(50) PRIMARY KEY,
    Year_of_Passed DATE 
   );
   ```
   ```
   INSERT INTO Qualification( Qualification, Teacher_Name, Year_of_Passed ) VALUES ( 'MCA', 'Neelima', '2015-04-30' );
   INSERT INTO Qualification( Qualification, Teacher_Name, Year_of_Passed ) VALUES ( 'BCA', 'Hema', '2012-06-30' );
   INSERT INTO Qualification( Qualification, Teacher_Name, Year_of_Passed ) VALUES ( 'MCA', 'Bhaskar', '2012-04-10' );
   INSERT INTO Qualification( Qualification, Teacher_Name, Year_of_Passed ) VALUES ( 'PHD', 'John', '2019-01-04' );
   INSERT INTO Qualification( Qualification, Teacher_Name, Year_of_Passed ) VALUES ( 'MCA', 'Vani', '2017-04-30' );
   INSERT INTO Qualification( Qualification, Teacher_Name, Year_of_Passed ) VALUES ( 'MSC', 'Ashok', '2014-07-30' );
   ```
1. Run the following query to perform **INNER JOIN** operation on the tables **Course** and **Qualification**. Inner join is used to join both the tables. Data qualified only when the data exist in both the tables.(Based on the given fields). 
   > Note: In general, primary key fields will be used to join the tables.

   ```
   SELECT CourseId, Name, Teacher, Qualification, Year_of_Passed FROM Course A INNER JOIN Qualification B on A.Teacher  = B.Teacher_Name;
   ```
   ![](media/postgre-innerjoin.png)
   
1. Run the below query and observe the **Left outer join** operation. Left outer join is used to qualify all the records from the left table **Course** and only matched records from the right tabl **Qualification**.

   ```
   SELECT CourseId, Name, Teacher, Qualification, Year_of_Passed FROM Course A LEFT OUTER JOIN Qualification B on A.Teacher  = B.Teacher_Name;
   ```
   ![](media/postgre-leftjoin.png)
   
1. Execute following query and observe the output data inside table. **Right outer join** is used to qualify all the records from the Right table(Qualification) and only matched records from the left table(Course).
   
   ```
   SELECT CourseId, Name, Teacher, Qualification, Year_of_Passed FROM Course A RIGHT OUTER JOIN Qualification B on A.Teacher  = B.Teacher_Name;
   ```
   ![](media/postgre-rightjoin.png)
   
1. Run the following query to perform **FULL OUTER JOIN** operation on the tables **Course** and **Qualification**. The full outer join combines the results of both left join and right join. If the rows in the joined table do not match, the full outer join sets NULL values for every column of the table that does not have the matching row.
   
   ```
   SELECT CourseId, Name, Teacher, Qualification, Year_of_Passed FROM Course A FULL OUTER JOIN Qualification B on A.Teacher  = B.Teacher_Name;
   ```
   ![](media/postgre-outerjoin.png)
   
   > **Note:** Before moving to the next exercise enter the following command to exit from the PostgreSQL client.
    
   ```
   \q
   exit;
   ```
   
## Summary
 
 In this exercise, you have learned basic operations of PostgreSQL. Click on **Next** at the bottom of lab guide to move to the next exercise.
   


