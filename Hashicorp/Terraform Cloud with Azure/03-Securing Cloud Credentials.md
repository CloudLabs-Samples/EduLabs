## Securing Cloud Credentials


Your team has started building cloud infrastructure on Azure, but the security team is concerned about protecting access to everyone's cloud credentials.


After the Azure credentials issue, the security team is tightening down access to your Azure account. API creds must now be secured as stored variables in Terraform Cloud. Your task is to find your Azure credentials, and move them into your workspace as secure environment variables.

1.	Update the **Execution Mode** settings in your terraform workspace to **Remote** on the **Settings > General** tab.

2.	Change the **Apply** Method to **Auto apply** on the same page. This will save you the trouble of having to approve every Terraform run manually. Remember to click the **Save settings** button at the bottom of the page!

3.	The four environment variables you need are ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, and ARM_SUBSCRIPTION_ID.
    
    i. ARM_Client_ID:<inject key="Application Id" />
    
    ii. ARM_CLIENT_SECRET:<inject key="Secret Key" />
    
    iii. ARM_TENANT_ID:<inject key="Tenant Id (Directory Id)" />
    
    iv. ARM_SUBSCRIPTION_ID:<inject key="Subscription Id" />

   NOTE: You can also get these values from the **Environment details-> Service Prinicipal** details

4.	Set **Environment Variables** for your Azure credentials on the **Variables** tab and mark the ARM_CLIENT_SECRET as Sensitive. The other three environment variables  ARM_CLIENT_ID, ARM_TENANT_ID, and ARM_SUBSCRIPTION_ID may remain in plaintext.
   
5. Set **Terraform Variables** for your **prefix and location**. Learn more about these variables by looking in the variables.tf file. Set the same values you used in your terraform.tfvars file to avoid all the resources being destroyed and re-created (unless you like waiting longer).
   NOTE: You must configure these variables on the remote workspace, as they will no longer be read from your local terraform.tfvars file.

6. Test your work by running **terraform init**. Your backend configuration will be updated for remote execution.
    ```
   terraform init
   ```
7. Next try running **terraform plan**. This will trigger what's known as a speculative plan. You can view this plan by copying the link from your Cloud Shell tab. This plan will not show up in your ordinary terraform runs that are triggered via the UI or API. A copy of the plan output will be streamed back to your Cloud Shell tab.
 ```
 terraform plan
 ```
8. Run a **terraform apply**. This apply will show up if you navigate to the runs page in the Terraform Cloud UI.
terraform apply
 ```
 terraform apply
 ```
Congratulations, your Azure credentials are now safely encrypted and stored in your Terraform Cloud workspace.

9. You can continue to run terraform plan and terraform apply in your Cloud Shell tab, but the execution is now done in Terraform Cloud.
