### Exercise 1 : Set up a lab for big data analytics using Docker deployment of HortonWorks DataFlow

This lab explains you to set up a big data analytics class. It assists the user in dealing with massive volumes of data and apply machine and statistical learning methods to obtain data insights. A key objective of this lab is to learn how to use data analytics technologies, such as Apache Hadoop's open-source software package, which provides tools for storing, managing, and processing massive data.

In this lab, we will use Hortonworks DataFlow (HDF), a popular commercial version of Hadoop provided by Cloudera. We are using HDP Sandbox 3.0.1, which is a free, simplified version of the platform that is used to design for learning and experimentation purpose. We may use either Windows or Linux virtual machines (VM) with HDP Sandbox deployed, but here we are using windows virtual machine to perform this lab.

### Task 1: Verifying the Pre-requisites of the lab

1. In the search Window, type windows features and select the windows features

1. In the **windows features** dialog box ensure that windows container and Hyper-V are turned on.
 
    ![](Media/screenshot01.png)
    
  >Note : If it is not enabled make sure that you are enabling it.
    
### Task 2 : Verfying the HDF Sandbox

1. On the Labvm desktop, select the **Git Bash**.

1. In the git bash, run the following to start the **HDF SandBox**

```
docker start sandbox-hdf

docker start sandbox-proxy

docker ps
```
   
### Task 3 : Connecting to the Ambari Dashboard

1. In the labvm desktop, select the microsoft edge icon.

1. In the browser, enter the following ip address 127.0.0.1:8080 or the local host. It navigates to the Ambari Signin Page.

1. By using the following credentials you can able to login to the Ambari Dashboard.

   |Setting|Value|
   |------|-------|
   |Username| admin|
   |Password| admin|

1. Once you have logged in, you can able to explore the various features of the Ambari Dashboard.

  ![](Media/screenshot05.png)

### Task 4 : Stop the HDF Sandbox

1. On the labvm, select git bash.

1. In the git bash, run the following commands to stop the **HDF Sandbox**

```
docker stop sandbox-hdf
docker stop sandbox-proxy
```

### Task 5 : To Restart the HDF Sandbox

1. On the labvm, select git bash.

1. In the git bash, run the following commands to restart the **HDF Sandbox** whenever it is required.

```
docker start sandbox-hdf
docker start sandbox-proxy
```

### Task 6 : Mapping SandBox IP to the desired hostname in the hosts file and the sandbox welcome page

1. Open the file explorer.

1. On the file explorer, navigate to the file located in C:\Windows\System32\drivers\etc and then select hosts file.

1. Select the hosts file, select open with and then select with **NotePad**.

1. On the hosts file, add the following {IP-Address} localhost sandbox-hdp.hortonworks.com sandbox-hdf.hortonworks.com

1. Replace the IP-Address with the following IP Address 127.0.0.1:8080.

1. Save the file.

1. In the browser, enter the localhost or 127.0.0.1:1080. The Sandbox Welcome Page is also known as the Splash Page.

   ![](Media/screenshot06.png)

1. On the welcome page, select launch dashboard.

1. It will be navigated to the signin page for the Ambari Dashboard. Login with the credentials provided.

   |Setting|Value|
   |------|-------|
   |Username| admin|
   |Password| admin|
   
### Task 7 : To check the Ambari server status

1. In the browser, enter the localhost or 127.0.0.1:1080. The Sandbox Welcome Page is also known as the Splash Page.

1. Under the **Advanced HDF**, select **Quick Links**. This will navigate to the **Advanced HDF Quick Links** Page

1. In the **Quick Links** page, select **Web Shell Client**.

     ![](Media/screenshot07.png)

1.  This will open a **Shell in a box** page.

1. Login with the credetials provided below.

   |Setting|Value|
   |------|-------|
   |Username| root|
   |Password| hadoop|
   
   ![](Media/screenshot08.png)
   
1. In the **Shell in a box** page, enter the following, to get the details of the Ambari server status

`````
sudo ambari-server status

`````
 ![](Media/screenshot09.png)  
  





     
