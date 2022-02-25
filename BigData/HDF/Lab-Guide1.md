### Exercise 2 : Setup Hadoop on the environment provided
 
 ### Task 1 : Set up Hadoop
 
1. Navigate to the location **C:\Users\labuser** and check for the **hadoop-3.2.1** if it is installed proceed to **Task 2**, else perform the below steps. 
 
1. In the browser, navigate to the link provided, [Hadoop](https://archive.apache.org/dist/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz), that will automatically download hadoop version 3.2.1.

1. In the lab vm, select command prompt, Select the path where you have downloaded the file earlier.  
  `````
   cd C:\Users\labuser\Downloads
  `````
1. To Unzip the hadoop binary package, run the following command
  `````
   tar -xvf hadoop-3.2.1.tar.gz
  `````

### Task 2 : Install Hadoop native IO binary and configure environment variables

1. Navigate to the link [Hadoop binary files](https://github.com/cdarlint/winutils/tree/master/hadoop-3.2.1/bin) and download all the binary files.

1.  Once you have downloaded, copy the contents of hadoop-3.2.1/bin into the extracted location of the Hadoop binary package.

1. Open the Start Menu and type in 'environment' and press enter. Then select **Edit the system environment variables** and in the system properties page select **Environment variables**.

1. In the **User Variables for labuser**, select new.

1. Create a new User variable with the variable name as HADOOP_HOME and the value as C:\Users\labuser\Downloads\hadoop-3.2.1.
 
    >Note : The value should be the hadoop where you have downloaded.

1. Click Path and then Edit.

1. Click New on the top right.

1. Add C:\Users\labuser\Downloads\hadoop-3.2.1\bin.

### Task 3 : Configure Hadoop

Now  we need to configure hadoop configurations which involves Core, YARN, MapReduce, and HDFS configurations.

1. Now we need to configure hadoop files

1. Navigate to the location **C:\Users\labuser\hadoop-3.2.1\etc\hadoop** and edit **core-site.xml** and replace the code between the <configuration> and </configuration>

    ```````
    <configuration>
     <property>
       <name>fs.default.name</name>
       <value>>hdfs://0.0.0.0:19000</value>
     </property>
   </configuration>

    ```````
 
1. On the desktop VM, select **file explorer** and navigate to the location **C:\Users\labuser\hadoop-3.2.1** and create a folder named **Data** and create two folders inside **Data folder**, one for namenode directory and the another one for data directory.

1. Navigate to the location **C:\Users\labuser\hadoop-3.2.1\etc\hadoop** and edit **hdfs-site.xml** and replace the code between the <configuration> and </configuration>
   ```````
   <configuration>
   <property>
     <name>dfs.replication</name>
     <value>1</value>
   </property>
   <property>
     <name>dfs.namenode.name.dir</name>
     <value>file://C:/Users/labuser/hadoop-3.2.1/Data/data</value>
   </property>
   <property>
     <name>dfs.datanode.data.dir</name>
     <value>file://C:/Users/labuser/hadoop-3.2.1/Data/name</value>
   </property>
   </configuration>
   ```````
   >Note : In the **value** under **name** replace the values accoriding to the files you have created in the previous step.

1. Navigate to the location **C:\Users\labuser\hadoop-3.2.1\etc\hadoop** and edit **mapred-site.xml** and replace the code between the <configuration> and </configuration>
   ```````
    <configuration>
   <property>
     <name>mapreduce.framework.name</name>
     <value>yarn</value>
   </property>
   <property> 
     <name>mapreduce.application.classpath</name>
     <value>%HADOOP_HOME%/share/hadoop/mapreduce/*,%HADOOP_HOME%/share/hadoop/mapreduce/lib/*,%HADOOP_HOME%/share/hadoop/common/*,%HADOOP_HOME%/share/hadoop/common/lib/*,%HADOOP_HOME%/share/hadoop/yarn/*,%HADOOP_HOME%/share/hadoop/yarn/lib/*,%HADOOP_HOME%/share/hadoop/hdfs/*,%HADOOP_HOME%/share/hadoop/hdfs/lib/*</value>
   </property>
   </configuration>
    ```````
1. Navigate to the location **C:\Users\labuser\hadoop-3.2.1\etc\hadoop** and edit **yarn-site.xml** and replace the code between the <configuration> and </configuration>
   ```````
   <configuration>
   <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>localhost</value>
   </property>
   <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
   </property>
   <property>
    <name>yarn.nodemanager.env-whitelist</name>
    <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
   </property>
   </configuration>
   ```````
1. To initialize the **HDFS** perform the following command in command prompt 
   ```````
    hdfs namenode -format
   ```````
   >Note : If you encounter any error while performing the above then perform the steps that is mentioned below.
1. Navigate to the [HDFS jar file](https://github.com/FahaoTang/big-data/blob/master/hadoop-hdfs-3.2.1.jar) and download it.

1. Now place the downloaded file in C:\LabFiles\hadoop-3.2.1\etc\hadoop\hdfs

### Task 4 : Start HDFS and YARN daemons

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
### Task 5 : Stop HDFS and YARN daemons

1. Run the following command to start HDFS daemons

   `````
   cd C:\Users\labuser\hadoop-3.2.1

   cd sbin\stop-dfs.cmd
   `````
1. Run the following command (with elevated permissions) to stop YARN daemons.
   ``````
   cd C:\Users\labuser\hadoop-3.2.1

   cd sbin\stop-yarn.cmd
   ``````
