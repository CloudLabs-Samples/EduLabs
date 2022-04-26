## Terraform Cloud Setup

1. Sign up for a free Terraform Cloud account at the following URL using your email address:
   https://app.terraform.io/signup/account

2. If you already have an account you can simply sign in with your existing credentials.

3. You will be navigated to Confirm Email Address page, check your inbox and confirm the email address.

4. You will be redirected to **Welcome to Terraform Cloud!** page, select **Start from scratch** from choose your setup workflow options.

5. Next you'll be prompted to create a organization. Provide the organization name as **demo-orgXXXXXX** or any other unique name.

6. Next you'll be prompted to create a workspace. Select the **CLI-driven workflow** panel, type **hashicat-azure**, enter a description such as **HashiCat for Azure**, and click the **Create workspace** button. You must name your workspace hashicat-azure. If you don't, the exercises will break. Do not attempt to name it something else.

 >**Note**: If you already have a hashicat-azure workspace, please delete the workspace by selecting the workpace-level Settings >> Destruction and Deletion menu, clicking the "Delete from Terraform Cloud" button, typing "hashicat-azure" to confirm, and then clicking the "Delete workspace" button. Then re-create it as above. Doing this avoids possible problems with mis-matched state versions when executing local runs after having executed remote runs. This could happen if you already played this track in the past.

IMPORTANT: DO NOT SKIP THIS NEXT STEP:

7. Navigate back to Azure portal and click on **Cloud shell** and ensure that Powershell is selected.

8. All the required files for the lab are already provisioned within the environment.
 
9. Now run **terraform version** from the cloud shell and then set the Terraform Version to match on the workspace's **Settings >> General settings** page.
Also, change the Execution Mode to **Local**.

8. Ensure to save your settings by clicking the **Save settings** button at the bottom of the page! This will allow us to run Terraform commands from our workstation with local variables.

9. Enable a free 30 day trial of Terraform Cloud's plan by navigating to your project's Settings menu and then to **Plan and billing**, select **Change Plan**, select the **Trial Plan** radio button, and click the **Start your free trial** button.
Or, if you have an existing account where you've already used a trial, provide your instructor with your organization's name. They will upgrade your organization to unlock a 30 day free trial of all paid features.

Before you click the Next button, did you change your Execution Mode to Local? This is an easy step to miss so we mention it twice.
