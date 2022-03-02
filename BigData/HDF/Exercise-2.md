
## Overview

### HDFS

HDFS is a distributed file system that handles large data sets running on commodity hardware. It is used to scale a single Apache Hadoop cluster to hundreds (and even thousands) of nodes. HDFS is one of the major components of Apache Hadoop, the others being MapReduce and YARN. The goals of HDFS are Fast recovery from hardware failures, Access to streaming data.
  
### Module 2 : Start Daemons

### Task 1 : To initialize the HDFS

In this task, you are initializing the HDFS for the Hadoop

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
   cd C:\Users\labuser\hadoop-3.2.1

   cd sbin\start-dfs.cmd
   `````
1. Run the following command (with elevated permissions) to start YARN daemons.
   ``````
   cd C:\Users\labuser\hadoop-3.2.1

   cd sbin\start-yarn.cmd
   ``````

