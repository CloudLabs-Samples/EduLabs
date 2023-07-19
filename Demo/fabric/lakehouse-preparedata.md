# Prepare and transform data in the lakehouse

In this task, you will use notebooks with Spark runtime to transform and prepare the data

## Prepare data
From the previous tasks, we have raw data ingested from the source to the Files section of the lakehouse. Now you can transform that data and prepare it for creating delta tables.

1. Download the **notebooks** from the **[Lakehouse Tutorial Source Code](https://github.com/microsoft/fabric-samples/tree/main/docs-samples/data-engineering/Lakehouse%20Tutorial%20Source%20Code)**  folder 
   
2. From the experience switcher located at the bottom left of the screen, select **Data engineering**.

   ![](images/workload-switch-data-engineering.png)

3. Select **Import notebook** from the **New** section at the top of the landing page.

4. Select **Upload** from the **Import status** pane that opens on the right side of the screen.

5. Select all the notebooks that were downloaded in step 1 of this section.

6. Select **Open**. A notification indicating the status of the import appears in the top right corner of the browser window.

   ![](images/select-notebooks-open.png)

7. After the import is successful, you can go to items view of the workspace and see the newly imported notebooks. Select **wwilakehouse** lakehouse to open it.

   ![](images/imported-notebooks-lakehouse.png)  

8. Once the **wwilakehouse** lakehouse is opened, select **Open notebook** > **Existing notebook** from the top navigation menu.

    ![](images/existing-notebook-ribbon.png)

9. From the list of existing notebooks, select the **01 - Create Delta Tables** notebook and select **Open**.

10. In the open notebook in **Lakehouse explorer**, you see the notebook is already linked to your opened lakehouse.

11. Before you write data as delta lake tables in the **Tables** section of the lakehouse, you use two Fabric features (**V-order and Optimize Write**) for optimized data writing and for improved reading performance. To enable these features in your session, set these configurations in the first cell of your notebook.

    To start the notebook and execute all the cells in sequence, select **Run All** on the top ribbon (under **Home**). Or, to only execute code from a specific cell, select the **Run** icon that appears to the left of the cell upon hover, or press **SHIFT + ENTER** on your keyboard while control is in the cell.

    ![](images/spark-session-run-execution.png)

   >Note: When running a cell, you didn't have to specify the underlying Spark pool or cluster details because Fabric provides them through Live Pool. Every Fabric workspace comes with a default Spark pool, called Live Pool. This means when you create notebooks, you don't have to worry about specifying any Spark configurations or cluster details. When you execute the first notebook command, the live pool is up and running in a few seconds. And the Spark session is established and it starts executing the code. Subsequent code execution is almost instantaneous in this notebook while the Spark session is active.

12. Next, you read raw data from the **Files** section of the lakehouse, and add more columns for different date parts as part of the transformation. Finally, you use partitionBy Spark API to partition the data before writing it as delta table based on the newly created data part columns (Year and Quarter).

    ```
    from pyspark.sql.functions import col, year, month, quarter
    table_name = 'fact_sale'
    df = spark.read.format("parquet").load('Files/wwi-raw-data/full/fact_sale_1y_full')
    df = df.withColumn('Year', year(col("InvoiceDateKey")))
    df = df.withColumn('Quarter', quarter(col("InvoiceDateKey")))
    df = df.withColumn('Month', month(col("InvoiceDateKey")))
    df.write.mode("overwrite").format("delta").partitionBy("Year","Quarter").save("Tables/" + table_name)
    ```
13. After the fact tables load, you can move on to loading data for the rest of the dimensions. The following cell creates a function to read raw data from the **Files** section of the lakehouse for each of the table names passed as a parameter. Next, it creates a list of dimension tables. Finally, it loops through the list of tables and creates a delta table for each table name that's read from the input parameter.

    ```
    from pyspark.sql.types import *
    def loadFullDataFromSource(table_name):
    df = spark.read.format("parquet").load('Files/wwi-raw-data/full/' + table_name)
    df.write.mode("overwrite").format("delta").save("Tables/" + table_name)
    full_tables = [
    'dimension_city',
    'dimension_date',
    'dimension_employee',
    'dimension_stock_item'
    ]
    for table in full_tables:
    loadFullDataFromSource(table)
    ```
14. To validate the created tables, right click and select refresh on the **wwilakehouse** lakehouse. The tables appear.

     ![](images/tutorial-lakehouse-explorer-tables.png)
