## Exercise 3 : Starting the Daemons

### Overview

Daemons in computing terms is a process that runs in the background. Hadoop has five such daemons. They are NameNode, Secondary NameNode, DataNode, JobTracker and TaskTracker.

 - NameNode – Is is the Master node which is responsible for storing the meta-data for all the files and directories. 
 - DataNode – It is the Slave node that contains the actual data. 
 - Secondary NameNode – It periodically merges all the changes in the NameNode with the edit log. It also keeps a copy of the image which can be used in case of failure of NameNode.

### HDFS

HDFS is a distributed file system that handles large data sets running on commodity hardware. It is used to scale a single Apache Hadoop cluster to hundreds (and even thousands) of nodes. HDFS is one of the major components of Apache Hadoop, the others being MapReduce and YARN. The goals of HDFS are Fast recovery from hardware failures, Access to streaming data.
  

### Task 1 : To initialize the HDFS

In this task, you are initializing the HDFS for the Hadoop.

1. To initialize the **HDFS** perform the following command in the command prompt 
   ```````
    hdfs namenode -format
   ```````
   >Note : If you encounter any error while performing the above then perform the steps that are mentioned below.
1. Navigate to the [HDFS jar file](https://github.com/FahaoTang/big-data/blob/master/hadoop-hdfs-3.2.1.jar) and download it.

1. Now place the downloaded file in C:\LabFiles\hadoop-3.2.1\etc\hadoop\hdfs

### Task 2 : Start HDFS and YARN daemons

In this task, you will start the daemons that are necessary while running the Hadoop application.

1. Run the following command to start HDFS daemons

   `````
   cd C:\labfiles\hadoop-3.2.1

   cd sbin\start-dfs.cmd
   `````
1. Run the following command (with elevated permissions) to start YARN daemons.
   ``````
   cd C:\labfiles\hadoop-3.2.1

   cd sbin\start-yarn.cmd
   ``````
1. Now open the Microsoft Edge and navigate to the URLs, to verify the status of Hadoop.
     ``````
     http://localhost:8088 
     ``````
In this lab you have learnt how to start the daemons that are required and accessing the Hadoop Dashboard.
