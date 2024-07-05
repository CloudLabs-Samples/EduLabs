## Task 3: End to End Use Case
**Objective:** We have already familiarized ourselves with the basic features and interface of Astera Data Pipeline Builder and applied these skills to create a simple dataflow.Now let’s develop a more advanced dataflow and workflow to provide you with practical experience, we'll explore a scenario where DataTech Solutions aims to enhance customer insights, optimize marketing efforts, and improve operational efficiency through the integration and transformation of data. Additionally, they seek to automate these processes to ensure accurate, up-to-date data for strategic business analysis and informed decision-making. Let’s achieve this using Astera Data Pipeline Builder.

### Step 1: Advanced Dataflow

1. **Create a New Dataflow:**

   - Right-click on the project name "Astera Trial."

   - Select *Add > Add New Item > Dataflow*.

2. **Connect to Data Sources:**

   - Drag and Drop a *Delimited Source object* on the canvas.

   - Double click on its header to specify the file path for the customer data file.

    *Note: you can find the customers.csv file at* “C:\Users\labuser\Documents\Resources”

    ![](images/image-004.jpg)

   - Drag and Drop a *Database Table Source* object on to the canvas.

     ![](images/image-005.jpg)

   - To configure the *Database Table Source* object, right-click on its header and select Properties from the context menu.

     ![](images/image-006.png)

   - Please use the credentials listed in the environment tab to connect to the 'NorthWind' database. The required details are:
      ▪ User ID: SQL Server username from the environment file
      ▪ Password: SQL Server password from the environment file

   - Next, you will see a *Pick Source Table* and *Reading Options* window. On this window, you will select the Orders table from the database that you previously connected to. 

     ![](images/image-007.jpg)

3. **Join Data Sources:**

   - Drag and drop the *Join* transformation from the toolbox, to create a unified dataset with customer details and their corresponding orders.

     ![](images/image-008.png)

   - Connect the *Delimited Source* and *Database Source* to the *Join* transformation.

     ![](images/image-009.jpg)

   - Open properties

     ![](images/image-010.jpg)

   - Set the Join Type to Inner.

   - Ensure Sort Left Input and Sort Right Input are checked.

   - Match the fields to join on:
   
       - Left Field: CustomerID
   
       - Right Field: CustomerID (or CustomerID_1 if the source data has a different name for this field)

     ![](images/image-011.png)
   
*To learn more about Join Transformation, please visit:* https://documentation.astera.com/dataflows/transformations/join-transformation

4. **Add Transformations:**

   - **Filter Transformation:**
        - Drag and drop the *Filter* transformation.
        - Map all the fields from the Join Transformation to the Filter Transformation.

     ![](images/image-012.jpg)
   
   - To configure the *Filter* transformation, right-click on its header and select Properties from the context menu.

   - Under the *Expression* section of the *Filter* transformation properties window, **define the criteria to filter records where the** Region **is not null.**

     ![](images/image-013.png)

*To learn more about Filter Transformation, please visit:* https://documentation.astera.com/dataflows/transformations/filter-transformation

  - **Expression Transformation:**

      - Drag and drop an *Expression* transformation.
     
      - Map all the fields from *Filter* transformation to Expression transformation.

     ![](images/image-014.jpg)
   
      - To configure the *Expression* transformation, right-click on its header and select Properties from the context menu.

      - Since we want to write the address details from multiple fields into a single field, let’s create a new field named *Full_Address*, and specify the *Data Type* as String and check the *Output* option.

        ![](images/image-015.jpg)

      - You can either write an expression directly in the Expression box in the Layout Builder window, or you can build an expression in the Expression Builder. To access the Expression Builder, click on ![](images/image-016.png) option. An Expression Builder window will open.

      - In this example, we can either use a concatenate function from the built-in functions or write an expression of our own to return the complete address information in a single field.

        ![](images/image-017.png)

      - You can now see your expression appear in the Expression field.

        ![](images/image-018.jpg)

*To learn more about Expression Transformation, please visit:* https://documentation.astera.com/dataflows/transformations/expression-transformation

- **Sort Transformation:**
  
  - Drag and drop a Sort transformation.
   
  - Map the fields from Expression transformation. (Map the full address field instead of mapping the four fields separately)

    ![](images/image-019.jpg)
   
  - To configure the *Sort* transformation, right-click on its header and select Properties from the context menu.

  - In the *Sort Transformation* Properties window, set the Sort field to OrderDate in ascending order.

    ![](images/image-020.png)

*To learn more about Sort Transformation, please visit:* https://documentation.astera.com/dataflows/transformations/sort-transformation

5. **Write to a Destination:**
   - Add an *Excel Destination* object.

   - Connect it to the *Sort* transformation.
 
     ![](images/image-021.jpg)
   
   - Configure the output settings to write the data to an Excel file.

   - To verify that your data flow is working fine, preview the output by right clicking on the excel destination object and selecting preview output.

### Step 2: Workflow Creation
Now to organize multiple dataflows sequentially to streamline data processing let’s create a workflow.

1. **Create a New Workflow:**
    - Right-click on the project name "Astera Trial."
    - Select *Add > Add New Item > Workflow*.

2. **Add Dataflows to Workflow:**
   - Drag and drop the two dataflows created in Tasks 3 and 4 onto the workflow canvas from the project explorer.

     ![](images/image-022.jpg)

  *Note: Please ensure that you have saved all changes to your dataflows before proceeding.*

3. **Configure Sequence:**
   - Connect the dataflows to run sequentially.

   ![](images/image-023.png) 

4. **Run the Workflow:**
   - Click the execute button to execute the workflow.

     ![](images/image-024.jpg) 

*To learn more about Workflows, please visit:* https://documentation.astera.com/workflows/creating-workflows-in-astera

### Step 3: Scheduling the Workflow
Now that we have configured our dataflows and workflow for DataTech, let's schedule this on a weekly basis to automate the process and minimize manual intervention, ensuring smooth data processing.

1. **Access the Job Scheduler:**
   - Navigate to *Server > Jobs > Job Schedules*.

     ![](images/image-025.jpg) 

2. **Create a New Schedule:**
   - Click on *Add Scheduler Task* icon to create a new schedule.

     ![](images/image-026.jpg) 

3. **Configure Schedule Details:**
   - Name your schedule to easily identify it later.
   - Choose File as the schedule type as we want to create a schedule for a workflow.
   - In the File Location section, provide the File Path to the file that you want to schedule. (In our case the file path of where our workflow is saved)

     ![](images/image-027.jpg) 

4. **Set Execution Frequency:**
   - Set the Frequency to Weekly.
   - Specify the Start Time for the scheduled execution.
   - Select the specific Day of the Week you want the workflow to execute.

     ![](images/image-028.png) 

5. **Save the Schedule:**
   - Save your schedule configuration.

     ![](images/image-029.jpg) 

*To learn more about Scheduling, please visit:* https://documentation.astera.com/project-management-and-scheduling/job-scheduling/scheduling-jobson-the-server
