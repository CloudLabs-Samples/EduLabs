## Task 2: Apply What You've Learned
**Objective:** Reinforce your learning by replicating the steps demonstrated in the interactive demo.

1. **Launch Astera Data Pipeline Builder client:** Double-click the Astera client icon on your desktop or click the icon on the taskbar.

    ![](images/image-000.jpg)

2. **Create a New Project:** Go to *Project > New > Integration Project* and name your project "Astera Trial."

   ![](images/image-001.jpg)

3. **Add a Dataflow:**

   - In Project Explorer, right-click on the project "Astera Trial."

   - Select *Add > Add New Item*

    ![](images/image-002.jpg)

   - Select Dataflow in the *Add new item* wizard.

    ![](images/image-003.jpg)
   
4. **Replicate Steps:** Using what you learned in the interactive demo, replicate the steps. This includes:

   - **Creating a New Dataflow**: As described in step 3.

   - **Add an Excel Source:** Drag and Drop an *Excel Source* object from the toolbox. Open properties to configure the object as shown in the demo.

   - **Adding and Configuring Transformations:** Drag and drop *Cleanse* transformation and configure it as shown in the demo.

   - **Writing to a Destination:** Drag and Drop a *Database Destination* object.


   - **Database Destination Configuration:**
       o Double click on the header to configure its properties.
       o Please use the credentials listed in the environment tab to connect to the 'ADPTest' database. The required details are:
             ▪ User ID: SQL Server username from the environment file
             ▪ Password: SQL Server password from the environment file
     o On the next screen select the customers table in the *Pick* table dropdown

