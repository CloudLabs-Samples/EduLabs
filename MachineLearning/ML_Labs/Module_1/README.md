# Lab Overview
[Azure Machine Learning Designer](https://docs.microsoft.com/en-us/azure/machine-learning/concept-designer) gives you a cloud-based interactive, visual workspace that you can use to easily and quickly prep data, train and deploy machine learning models. It supports Azure Machine Learning compute, GPU or CPU.

In this lab, we will be using **Adult Census Income Dataset** which is available from [Kaggle](https://www.kaggle.com/uciml/adult-census-income). The data is enriched with census data which contains many details like 'Age, Education, Marital Status, Occupation, Income'. We will learn to use Azure Machine Learning to process data, build, train, score, and evaluate a regression model to predict Income. To train the model, we will create Azure Machine Learning Compute resource. 

# Exercise 1: Register Dataset with Azure Machine Learning Studio

## Task 1: Upload Dataset

1. Download the [Adult-Census-Income](https://www.kaggle.com/uciml/adult-census-income) dataset to your machine.

1. Open [Azure portal](https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize?redirect_uri=https%3A%2F%2Fportal.azure.com%2Fsignin%2Findex%2F&response_type=code%20id_token&scope=https%3A%2F%2Fmanagement.core.windows.net%2F%2Fuser_impersonation%20openid%20email%20profile&state=OpenIdConnect.AuthenticationProperties%3D9RbHacLBqoneUWLcGM_b3Hf4Un0_XF3G6VNFoeQbojsIL_NUijyDA3SQxFnjKfMXMJgFE9lYjgnvzIb_OXEAHAXnHf2ajNgAN-66jBKMXWtGmMZccGIhuAkzh6mdE_FFIhhXSHlzT6Qh4MaHh8O1CzeX-TV1WZT0or4jlisi2wpULvkXxZKiyXoc2ar7wlvrHygXnwHGONjykyeIPc75z9XKViw97tRLJU7w3to1NQu7e81EudsNTRXgS3iLCoDq-CdO8nvQpXVyo1JQW5ZHF9bmzolk6fVqmuS4V5zLkigbWl3zKaTilO2D9InFuix2ELViBI21pHlppN0jUEIF4UDshHfrV8kBYsnAWuaWyq2UDKBZzEKpgJ9YtO2ry0CHMe5oezXuSnXbe4EpxSWQ8A&response_mode=form_post&nonce=637738305446507717.MzY3YmU4OWQtZGY1NS00Y2YzLTliZDgtNTk5YTQ4ZjE2MWJjYjZkMzM5NmUtZjZkMy00ZWExLTg4NmYtYzQ3NjY3YzFlNTAz&client_id=c44b4083-3bb0-49c1-b47d-974e53cbdf3c&site_id=501430&client-request-id=fff3e214-45e3-459b-b648-d995087b6b08&x-client-SKU=ID_NET472&x-client-ver=6.11.0.0&sso_reload=true) in a browser

1. On **Sign in to Micsoft Azure** tab you will see login screen, in that enter following email/username and then click on **Next**. 
   * Email/Username: <inject key="AzureAdUserEmail"></inject>
     
1. Now enter the following password and click on **Sign in**.
   * Password: <inject key="AzureAdUserPassword"></inject>
     
1. If you see the pop-up **Stay Signed in?**, click No

1. If you see the pop-up **You have free Azure Advisor recommendations!**, close the window to continue the lab.

1. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.
   
1. Now you will see Azure Portal Dashboard, click on **Resource groups** from the Navigate panel to see the resource groups.

1. Then navigate to the Resource-Group you have access to and select the Azure Machine Learning Resource.

1. Then, Select **Launch Studio** under the **Manage your machine learning lifecycle** message.

   ![Launch Azure ML Studio](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/001.png)

1. From the studio, select **Datasets, + Create dataset, From local files**.This will open *Create dataset from local files* prompt dialogue on the right.

   ![Create Dataset](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/002.png)
   
1. Provide the name - *Adult_Income_Data*, let the **Dataset Type be Tabular**, and **Description** is optional, and click on next.

   ![Dataset Name](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/003.png)
   
1. On the Datastore and file selection panel, let the **Datastore and file selection** be default, and click on *Upload* under **Select files for your dataset**, and upload the file which has been downloaded from [Kaggle](https://www.kaggle.com/uciml/adult-census-income). The upload path can be default, and after uploading click on Next.

   ![Upload Dataset](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/004.png)

## Task 2: Preview Dataset

1. On the Settings and preview panel, let all the values be default and make sure to check **Column headers** is set to **All files have same headers**. 

1. Scroll the data preview to the right to observe target column: **income**. After you are done reviewing the data, click Next.

   ![Preview Data](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/005.png)
   
## Task 3: Select Columns

1. Select columns from the dataset to include as part of your training dataset, let it be default choice( all columns are selected) and click on **Next**.

   ![Columns Selection](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/006.png)
   
## Task 4: Create Dataset

1. Confirm the dataset details and click on **Create**.

   ![Create Dataset](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/007.png)
   
# Exercise 2: Create New Training Pipeline

## Task 1: Open Pipeline Authoring Editor

1. From the studio, select **New Pipeline**. This will open a *visual pipeline authoring editor*.

   ![Pipeline editor](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/008.png)

## Task 2: Setup Compute Target

1. In the settings panel on the right, select **Select Compute Type as Compute instance**, and click on **Create Azure ML Compute Instance**.

   ![ML Compute](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/009.png)
   
2. A **Create Compute Instance Panel** opens up, and provide a name to the Compute.

   ![Compute Name](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/010.png)
   
3. Scroll down, and make sure the SKU selected is the default one, and click on **Create**.

   ![Create Compute](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/011.png)
   
4. Select the Compute Instance once it is in *Running State*.

   ![Running Compute](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/012.png)
   
## Task 3: Add Dataset

1. Select **Datasets** section in the left navigation pane, select the dataset which you just created( In my case, it is **Adult_Income_Data**), and drag and drop the selected dataset on to the canvas.

   ![Drag Dataset](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/013.png)
   
## Task 4: Select Required Columns

1. In the search bar which is located on the left navigation pane, search for **Select Columns**, and drag and drop it on the canvas.

   ![Select Columns](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/014.png)
   
2. Make sure to provide a connection from the **Dataset** to the **Select Columns**.

   ![Connection](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/015.png)
   
3. In the right navigation pane, click on **Edit Columns**.

   ![Edit Column](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/016.png)
   
4. Provide the respective column names: **Age, Education, Relationship, Race, Sex, and Income**, and click on **Save**.

   ![Column Names](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/017.png)
   
With the required columns selected, Data filtering is complete to use only the necessary columns in this module.

## Task 5: Train Model

We are going to be using a **Classification** algorithm , and we will be making use of **Two-Class Boosted Decision Tree** which is ideal in predicting true or false scenario.Hence, we want to train our model, and we begin to split the data before training our model.

1. In the left navigation pane, click on **Machine Learning Algorithms** and scroll down until you find **Two-Class Boosted Decision Tree**.

   ![ML Algorithm](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/018.png)
   
2. Drag and drop the **Two-Class Boosted Decision Tree** on to the canvas.

   ![Decision Tree](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/019.png)

Before training the model, we want to split the data.

3. In the search bar located on the left navigation pane, search for **Split Data** function, and drag and drop it on to the canvas.

   ![Split Data](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/020.png)
   
4. Change the value from 0.5 to 0.8 in the right navigation pane for **Split Data** function.( This means it will be using 80% of data as input instead of 50%)

   ![Input Split](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/021.png)
   
5. Search for **Train Model** function on the search bar located on the left navigation pane, and drag and drop it on to the canvas.

   ![Train](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/022.png)
   
6. Make sure to provide the necessary connections as shown below:

   ![Connections](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/023.png)
   
7. Select the **Train Model** function, and click on **Edit Columns** which is located on the right pane, and then select the **Income** field which is to be trained.

   ![Edit TrainColumn](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/024.png)
   
   ![Select Income](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/025.png)
   
## Task 6: Score, Evaluate the Model

After training the above model, we would like to know the accuracy of our model, evaluate and visualize the results.

1. Search for **Score Model** in the search bar located on the left navigation Pane, and drag and drop it below **Train Model** function.

   ![Score Model](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/026.png)
   
2. Search for **Evaluate Model** in the search bar located on the left navigation Pane, and drag and drop it below **Score Model** function. 

   ![Evaluate Model](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/027.png)
  
3. Make the necessary connections as shown below:

   ![Connection Evaluate](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/028.png)
   
4. The 20% of the left-over data in **Split Data** function will be used in **Score Model** function, the score model function contains the trained algorithm function will come across 20% data which is untrained or unexpected, and this will help us determine whether the **Score Model** function is capable of accuartely predicting a person's income or not.( **Training Any ML Model:** 70-80% of data is taken as training data and the remaining 20-30% data is used as test data to check the accuracy of the model).

   ![Connection Score](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/029.png)
   
5. Make sure to click on the **Submit** button.

   ![Submit](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/030.png)
   
6. Select **Create New**, provide an experiment name and **Submit**.( This will save and run the experiment)

   ![Submit Pipeline](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/031.png)
   
## Task 7: Visualize the Model.

1. Once the the run is successfully executed, click on **Evaluate Model**, select **Outputs+Logs** from the right-pane, and click on the **Histogram** icon.

   ![Output+Logs](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/032.png)
   
2. We can visualize the model, by expanding the Evaluation results and find out the accuracy of our model which is 0.829(82.9% in our case).

   ![Visualize](https://raw.githubusercontent.com/SD-14/EduLabs/main/MachineLearning/Images/033.png)
