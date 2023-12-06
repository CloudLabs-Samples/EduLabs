## Task 1: Provision Azure resources

1. In the **Azure portal**, search for **deploy** and select **Deploy a custom template** from the services list.

   ![](images/s1.png)

1. On the **Custom deployment** blade, select **Build your own template in the editor** 

   ![](images/s2.png)

1. On the **Edit template** blade, click on **Load file** and navigate to the **C:\LabFiles** and upload the file **azuredeploy-01.json**.

   ![](images/s3.png)

   ![](images/s4.png)

1. Click on **Save**

1. On the **Custom deployment** blade, select the resource group name **callcenter-<inject key="Deployment-id" enableCopy="false"></inject>** from the dropdown.

    ![](images/s5.png)

1. Scroll down and replace the existing **EnterUniqueID** text value with **<inject key="Deployment-id" enableCopy="false"></inject>** for the Deployment Id Parameter, and leave all other default values and click on **Review + create**

    ![](images/s6.png)

1. Click on **Create**

   ![](images/s7.png)
   
1. Wait for deployment to be completed.It might take around 5-7 mins.

## End OF Task-1

## Proceed to Next Task
