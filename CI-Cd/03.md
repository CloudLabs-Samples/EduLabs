## Exercise 3: Monitoring, Logging, and Continuous Deployment with Azure

Duration: 40 minutes

Fabrikam Medical Conferences has its first website for a customer running in the cloud, but deployment is still a largely manual process, and we have no insight into the behavior of the application in the cloud. In this exercise, we will add monitoring and logging to gain insight into the application usage in the cloud. Then, we will disable the GitHub pipeline and show how to build a deployment pipeline in Azure DevOps.

### Task 1: Set up Application Insights

1. Run the below-mentioned command in the termial to deploy the app insights, make sure that you are in the correct directory:

    > Note: Make sure to run the deploy-appinsights.ps1 script from the infrastructure folder
    ```
    ./deploy-appinsights.ps1
    ```
    
1. Now save the `AI Instrumentation Key` specified in the output - we will need it for a later step.

    ```bash
    The installed extension 'application-insights' is in preview.
    AI Instrumentation Key="55cade0c-197e-4489-961c-51e2e6423ea2"
    ```

1. Using PowerShell navigate to the `./content-web` folder in your GitHub lab files repository by running the below-mentioned command.

   ```
   cd ..
   cd .\content-web
   
   ```
   
1. Now using PowerShell, execute the following command to install JavaScript support for Application Insights via NPM to the web application frontend.

    ```bash
    npm install applicationinsights --save
    ```

1. In this step we'll updating the `app.js` file by adding and configuring Application Insights for the web application frontend in the local folder. Please run the command mentioned below.
   
    `Copy-Item -Path C:\Workspaces\lab\mcw-continuous-delivery-lab-files\keyscript.txt -Destination C:\Workspaces\lab\mcw-continuous-delivery-lab-files\content-web\app.js -PassThru`
    
    `$instrumentationKey` = $(az monitor app-insights component create --app fabmedicalai-<inject key="DeploymentID" enableCopy="false" /> --location westeurope --kind web --resource-group fabmedical-rg-<inject key="DeploymentID" enableCopy="false" /> --application-type web --retention-time 120 --query instrumentationKey)
    
    `(Get-Content -Path "C:\Workspaces\lab\mcw-continuous-delivery-lab-files\content-web\app.js") | ForEach-Object {$_ -Replace "UPDATE AI Instrumentation Key", $instrumentationKey} | Set-Content -Path "C:\Workspaces\lab\mcw-continuous-delivery-lab-files\content-web\app.js"`

1. Add and commit changes to your GitHub lab-files repository. From the root of the repository, execute the following:

    ```pwsh
    git add .
    git commit -m "Added Application Insights"
    git push
    ```

1. Wait for the GitHub Actions for your lab files repository to complete before executing the next step.

      ![](media/update8.png "Azure Boards")

1. Redeploy the web application by running the below commands:

    ```
    cd C:\Workspaces\lab\mcw-continuous-delivery-lab-files\infrastructure
    ./deploy-webapp.ps1
    ```
    
1. Visit the deployed website and check Application Insights in the Azure Portal to see instrumentation data.

### Task 2: Linking Git commits to Azure DevOps issues

In this task, you will create an issue in Azure DevOps and link a Git pull request from GitHub to the Azure DevOps issue. This uses the Azure Boards integration that was set up in the Before Hands-on Lab.

1. Navigate to 'dev.azure.com' and select boards under **Boards** and click on **New item**.

     !["New issue for updating README.md added to Azure Boards"](media/continous1.png "Azure Boards")

2. Update the value as **Update README.md** in Azure Boards.

     !["New issue for updating README.md added to Azure Boards"](media/continous2.png "Azure Boards")

1. Using PowerShell create a branch from `main` and name it `feature/update-readme` by executing the commands mentioned below.

    ```pwsh
    git checkout main
    git checkout -b feature/update-readme  # <- This creates the branch and checks it out    
    ```    

1. Commit the change, and push it to GitHub.

    ```pwsh
    git commit -m "README.md update"
    git push --set-upstream origin feature/update-readme
    ```
1. Using Github, manually make a small change (for ex: add an extra blank line at the end) to README.md in the `feature/update-readme` branch.  

     ![](media/update9.png "Create pull request")

1. Create a pull request to merge `feature/update-readme` into `main` in GitHub. Add the annotation `AB#YOUR_ISSUE_NUMBER_FROM_STEP_4` in the description of the pull request to link the GitHub pull request with the new Azure Boards issue in step 4. For example, if your issue number is 2, then your annotation in the pull request description should include `AB#2`. 

    > **Note**: The `Docker` build workflow executes as part of the status checks.

     !["Pull request for merging the feature/update-main branch into main"](media/createpr.png "Create pull request")

1. Select the `Merge pull request` button after the build completes successfully to merge the Pull Request into `main`.

    !["Pull request for merging the feature/update-main branch into main"](media/mergepr.png "Create pull request")

    > **Note**: Under normal circumstances, this pull request would be reviewed by someone other than the author of the pull request. For now, use your administrator privileges to force the merge of the pull request.

1. Observe in Azure Boards that the Issue is appropriately linked to the GitHub comment.

    !["The Update README.md issue with the comment from the pull request created in step 6 linked"](media/hol-ex2-task3-step8-1.png "Azure Boards Issue")

### Task 3: Continuous Deployment with Azure DevOps Pipelines

> **Note**: This section demonstrates Continuous Deployment via ADO pipelines, which is equivalent to the Continuous Deployment via GitHub Actions demonstrated in Task 2. For this reason, disabling GitHub action here is critical so that both pipelines (ADO & GitHub Actions) don't interfere with each other.
> **Note**: To complete [Exercise 3: Task 3](#task-3-continuous-deployment-with-azure-devops-pipelines), the student will need to request a free grant of parallel jobs in Azure Pipelines via [this form](https://aka.ms/azpipelines-parallelism-request). More information can be found [here regarding changes in Azure Pipelines Grant for Public Projects](https://devblogs.microsoft.com/devops/change-in-azure-pipelines-grant-for-public-projects/)

1. Disable your GitHub Actions by adding the `branches-ignore` property to the existing `docker-publish.yml` workflow in your lab files repository (located under the `.github/workflows` folder).

    ```pwsh
    on:
      push:
        branches-ignore:    # <-- Add this list property
          - '**'            # <-- with '**' to disable all branches
    ```
    
   ![](media/update11.png "Azure DevOps Pipelines")

1. Navigate to your Azure DevOps `Fabrikam` project, select the `Project Settings` blade, and open the `Service Connections` tab.

   ![Initial creation page for a new Azure DevOps Pipeline.](media/image20.png "Azure DevOps Pipelines")
   
1. Click on **Create Service Connection**.

   ![](media/createserviceconnection.png)
   
1. On the New Service Connection tab, search for Docker and select **Docker Registry**, then click on **Next**.

   ![](media/docker.png)

1. Create a new `Docker Registry` service connection and set the values to:

    - Docker Registry: `https://ghcr.io`
    - Docker ID: [GitHub account name]
    - Docker Password: [GitHub Personal Access Token]
    - Service connection name: GitHub Container Registry
    - Click on **Save**

    ![Azure DevOps Project Service Connection Configuration that establishes the credentials necessary for Azure DevOps to push to the GitHub Container Registry.](media/newdocker.png "Azure DevOps Project Service Connection Configuration")

1. Navigate to your Azure DevOps `Fabrikam` project, select the `Pipelines` blade, and click on **Create pipeline**.

    ![Initial creation page for a new Azure DevOps Pipeline.](media/hol-ex3-task3-step4-1.png "Azure DevOps Pipelines")

1. In the `Connect` tab, choose the `GitHub` selection.

    ![Azure DevOps Pipeline Connections page where we associate the GitHub repository with this pipeline.](media/hol-ex3-task3-step5-1.png "Azure DevOps Pipeline Connections")

1. Select your GitHub lab files repository.  Azure DevOps will redirect you to authorize yourself with GitHub. Log in and select the repository that you want to allow Azure DevOps to access.

     ![Azure DevOps Pipeline Connections page where we associate the GitHub repository with this pipeline.](media/repo.png "Azure DevOps Pipeline Connections")

1. In the `Configure` tab, choose the `Starter Pipeline`.

    ![Initial creation page for a new Azure DevOps Pipeline.](media/starter.png "Azure DevOps Pipelines")

1. Remove all the steps from the YAML. The empty pipeline should look like the following:

    ```yaml
    # Starter pipeline
    # Start with a minimal pipeline that you can customize to build and deploy your code.
    # Add steps that build, run tests, deploy, and more:
    # https://aka.ms/yaml

    trigger:
    - main

    pool:
      vmImage: ubuntu-latest

    steps:
    ```

1. Click on **Show assistant** to view the sidebar, find the `Docker Compose` task, and configure it with the following fields:

    - Container Registry Type: Container Registry
    - Docker Registry Service Connection: GitHub Container Registry (created in step 3)
    - Docker Compose File: **/docker-compose.yml
    - Additional Docker Compose Files: build.docker-compose.yml
    - Action: Build Service Images
    - Additional Image Tags = $(Build.BuildNumber)
    - Click on **Add**

    ![Docker Compose Task definition in the AzureDevOps pipeline.](media/hol-ex3-task3-step9-1.png "Docker Compose Task")
    
    ![](media/docker%20compose.png)

1. Repeat step 9 and add another `Docker Compose` task and configure it with the following fields:

    - Container Registry Type: Container Registry
    - Docker Registry Service Connection: GitHub Container Registry (created in step 3)
    - Docker Compose File: **/docker-compose.yml
    - Additional Docker Compose Files: build.docker-compose.yml
    - Action: Push Service Images
    - Additional Image Tags = $(Build.BuildNumber)
    - Click on **Add**

    ![](media/docker-composer-registry.png)
    
1. The final file should be similar to the one below:
    
    ![Docker Compose Task definition in the AzureDevOps pipeline.](media/final1.png "Docker Compose Task")

1. Now click on Save and run from the right corner to run the build. New docker images will be built and pushed to the GitHub package registry.

    ![Run detail of the Azure DevOps pipeline previously created.](media/save%20and%20run.png "Build Pipeline Run detail")
    
1. On Save and run page, leave everything as default and click on **Save and run**.

     ![](media/save%20and%20run1.png)
     
1. You will be prompted with a Warning to grant permissions for the pipeline, click on **View**.

     ![](media/view.png)
     
1. On the Waiting for review page, click on **Permit** to grant permissions.

     ![](media/permit.png)
     
1. Navigate to your `Fabrikam` project in Azure DevOps and select the `Project Settings` blade. From there, select the `Service Connections` tab.

1. On the **Service Connections** page, click on **New service connection**.

     ![](media/new%20service%20conenctions.png)
    
1. Select  `Azure Resource Manager` and click on **Next**.

1. On the new service connection tab choose **Service Principal (manual)** and select **Next**

    ![Run detail of the Azure DevOps pipeline previously created.](media/image22.png "Build Pipeline Run detail")

1. Enter your subscription ID, Name and get the Service Principal details from **Environment Details -> Service Principal** details tab and then Service Connection name to **Fabrikam-Azure**. The value of the Service Principal Id is the same as the Application Id and the Service Principal Key value is the same as the Secret key. Once done click on verify and the Save.
 
   >**Note**: You can get the subscription name from the Azure portal -> Subscriptions.

1. Navigate to Pipelines and select the pipeline you create in the last step and click `Edit` mode, and then select the `Variables` button on the top-right corner of the pipeline editor. 

    ![Run detail of the Azure DevOps pipeline previously created.](media/image23.png "Build Pipeline Run detail")
    
    ![Run detail of the Azure DevOps pipeline previously created.](media/image24.png "Build Pipeline Run detail")

1. Add a secret variable `CR_PAT`, check the `Keep this value secret` checkbox, and copy the GitHub Personal Access Token from the Before the Hands-on lab guided instruction into the `Value` field. Save the pipeline variable - we will reference it in a later step.

    ![Adding a new Pipeline Variable to an existing Azure DevOps pipeline.](media/hol-ex3-task3-step15-1.png "New Pipeline Variable")

1. Modify (replace) the build pipeline YAML to split into a build stage and a deploy stage, as follows. Make sure to replace **arguments** value with **<inject key="Deploymentid" />**, once done save the pipeline.
 

    ```yaml
    # Starter pipeline
    # Start with a minimal pipeline that you can customize to build and deploy your code.
    # Add steps that build, run tests, deploy, and more:
    # https://aka.ms/yaml

    trigger:
    - main

    pool:
      vmImage: ubuntu-latest

    stages:
    - stage: build
      jobs:
      - job: 'BuildAndPublish'
        displayName: 'Build and Publish'
        steps:
        - task: DockerCompose@0
          inputs:
            containerregistrytype: 'Container Registry'
            dockerRegistryEndpoint: 'GitHub Container Registry'
            dockerComposeFile: '**/docker-compose.yml'
            additionalDockerComposeFiles: 'build.docker-compose.yml'
            action: 'Build services'
            additionalImageTags: '$(Build.BuildNumber)'
        - task: DockerCompose@0
          inputs:
            containerregistrytype: 'Container Registry'
            dockerRegistryEndpoint: 'GitHub Container Registry'
            dockerComposeFile: '**/docker-compose.yml'
            additionalDockerComposeFiles: 'build.docker-compose.yml'
            action: 'Push services'
            additionalImageTags: '$(Build.BuildNumber)'    

    - stage: DeployProd
      dependsOn: build
      jobs:
      - deployment: webapp
        environment: production
        strategy:
          runOnce:
            deploy:
              steps:
              - checkout: self

              - powershell: |
                  (gc .\docker-compose.yml) `
                    -replace ':latest',':$(Build.BuildNumber)' | `
                    set-content .\docker-compose.yml
                    
              - task: AzureCLI@2
                inputs:
                  azureSubscription: 'Fabrikam-Azure' # <-- The service
                  scriptType: 'pscore'                # connection from step 14
                  scriptLocation: 'scriptPath'
                  scriptPath: './infrastructure/deploy-webapp.ps1'
                  workingDirectory: ./infrastructure
                  arguments: 'deploymentID'         # <-- This should be your custom
                env:                       # lowercase three character 
                  CR_PAT: $(CR_PAT)  # prefix from an earlier exercise.
                                # ^^^^^^
                                # ||||||
                                # The pipeline variable from step 15
    ```

1. Navigate to the `Environments` category with the `Pipelines` blade in the `Fabrikam` project and select the `production` environment.

    ![Approvals and checks selection in the vertical ellipsis menu in the top right corner of the Azure DevOps pipeline editor interface.](media/image25.png "Approvals and checks selection")

1. From the vertical ellipsis menu button in the top-right corner, select `Approvals`.

    ![Approvals and checks selection in the vertical ellipsis menu in the top right corner of the Azure DevOps pipeline editor interface.](media/hol-ex3-task3-step18-1.png "Approvals and checks selection")

1. Add an `Approvals` check.  Add your account as an `approvals` and create the check.

    ![Adding an account as an `Approver` for an Approvals check.](media/approve.png "Checks selection")
    
    ![Adding an account as an `Approver` for an Approvals check.](media/create.png "Checks selection")
    
1. Now go back to the Pipeline and run the build pipeline.

1. Run the build pipeline and note how the pipeline waits before moving to the `DeployProd` stage. You will need to approve the request before the `DeployProd` stage runs.

    ![Reviewing DeployProd stage transition request during pipeline execution.](./media/wait.png "Reviewing pipeline request")
    
1. You will be prompted with a Warning to grant permissions for the pipeline, click on **View**.

     ![](media/view.png)
     
1. On the Waiting for review page, click on **Permit** for both **Service Connection** and **Environment**.

     ![](media/permit2.png)
  
1. Now click on the Review button and click **Approve** button to start the DeployProd stage in the pipeline

     ![Reviewing DeployProd stage transition request during a pipeline execution.](./media/1.png "Reviewing pipeline request")
     
     ![Reviewing DeployProd stage transition request during a pipeline execution.](./media/2.png "Reviewing pipeline request")

Congratulation, You have completed this workshop.
-------
    
