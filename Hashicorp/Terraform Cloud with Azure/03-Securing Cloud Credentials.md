Your team has started building cloud infrastructure on Azure, but the security team is concerned about protecting access to everyone's cloud credentials.


After the Azure credentials issue, the security team is tightening down access to your Azure account. API creds must now be secured as stored variables in Terraform Cloud. Your task is to find your Azure credentials, and move them into your workspace as secure environment variables.
In order to complete this challenge you'll need to do the following:
1.	Find your Azure credentials with the following command:
env | grep ARM
1.	The four environment variables you need are ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, and ARM_SUBSCRIPTION_ID.
2.	Update the Execution Mode settings in your workspace to Remote on the Settings > General tab.
3.	Change the Apply Method to "Auto apply" on the same page. This will save you the trouble of having to approve every Terraform run manually. Remember to click the Save settings button at the bottom of the page!
4.	Set Environment Variables for your Azure credentials on the Variables tab and mark the ARM_CLIENT_SECRET as Sensitive. The other three environment variables may remain in plaintext.
5.	Set Terraform Variables for your prefix and location. Learn more about these variables by looking in the variables.tf file. Set the same values you used in your terraform.tfvars file to avoid all the resources being destroyed and re-created (unless you like waiting longer). NOTE: You must configure these variables on the remote workspace, as they will no longer be read from your local terraform.tfvars file.
Test your work by running terraform init. Your backend configuration will be updated for remote execution.
Next try running terraform plan. This will trigger what's known as a speculative plan. You can view this plan by copying the link from your "Shell" tab. This plan will not show up in your ordinary terraform runs that are triggered via the UI or API. A copy of the plan output will be streamed back to your "Shell" tab.
Run a terraform apply. This apply will show up if you navigate to the runs page in the Terraform Cloud UI.
terraform apply
Congratulations, your Azure credentials are now safely encrypted and stored in your Terraform Cloud workspace.
You can continue to run terraform plan and terraform apply in your "Shell" tab, but the execution is now done in Terraform Cloud.
