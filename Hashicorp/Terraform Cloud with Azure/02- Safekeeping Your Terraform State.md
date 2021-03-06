## Safekeeping Your Terraform State

An unexpected outage has taken down one of the production websites. It took longer than expected to recover because the Terraform state file was stored on someone's laptop. Terraform Cloud's remote state feature is here to help.

Your task is to configure remote state using your Terraform Cloud account. In order to complete this challenge you'll need the following:
>A free Terraform Cloud account - log in at https://app.terraform.io

>A Terraform Cloud organization. You just created this in the previous exercise.

>A workspace named hashicat-azure with its Execution Mode set to Local (not Remote)

>A token for authentication

>A  remote_backend config stored in your workspace

1. Let's generate a new user token for use on your workstation. Visit the User Settings > Tokens page in Terraform Cloud:
https://app.terraform.io/app/settings/tokens

2. Click on the Create an API token button. You can name the token whatever you like. Copy the entire token using your mouse or the small copy-paste icon.

3. Now navigate back to your cloudlabs environment , run the below command
   ```
   cd hashicat-azure
   ```
4. Run the below command for logging in to the terraform cloud
    ```
    terraform login
   ```
 **Remember to type yes on the prompt when you are prompted by Terraform to proceed with the authentication**

5. Paste the api token that you copied in step 2 and press **Enter**

6. Return to your **Editor** tab in the cloud shell and edit the **remote_backend.tf** file, replacing the YOURORGANIZATION placeholder with your organization name. Save the file.
  
7. Next, edit the **terraform.tfvars** file, replacing the **rgname** with your resource group name **terraform-<inject key="DeploymentID" />**

>First, set prefix to your name (first and last with or without a hyphen between them and all lower case).Keep your prefix string all lower case, and between 5-12 characters long. Do not use an underscore in your prefix.
The prefix will become part of your application hostname, and therefore must be DNS-compliant. Valid characters for hostnames are ASCII(7) letters from a to z, the digits from 0 to 9, and the hyphen (-). A hostname may not start with a hyphen.

8. In the same file, replace the **location** with your resource group location, ensure to save the file
 
>Set location to a valid Azure location near you such as "East US", "Central US", "UK South", or "Southeast Asia". You can also use shorter names like "eastus", "centralus", "uksouth", or "southeastasia"; in fact, Terraform will convert the longer names with spaces to the shorter names without them.

9. Run the below command
  ```
  terraform init
  ```
  
10. Now, run the below command in the powershell (Cloud shell) to import the pre-created resource group into Terraform state.

Note: Make sure you replace the {subscription-id} and {DID} before running the command. You can find the values on the Environment details page.
```
terraform import azurerm_resource_group.myresourcegroup /subscriptions/{subscription-id}/resourceGroups/terraform-{DeploymehtID}
```

11. The variables are actually declared in the **variables.tf** file. The "terraform.tfvars" file is just being used to set values for them.
Once you've got all the pieces in place, try running a terraform init and then terraform apply command.

 ```
terraform init
terraform apply
```
 
 **Remember to type yes on the prompt when you are prompted by Terraform to confirm the apply**

12. When the terraform apply finishes, you should see output like this:
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:
catapp_ip = "http://"
catapp_url = http://sean-carolan-meow.centralus.cloudapp.azure.com

13. Please click on the second URL to test that your application is working.
To see a valid value for the catapp_ip output, you sometimes might first need to run **terraform refresh**.

Note: If you ran terraform locally before configuring the remote backend, you might have a local state file called terraform.tfstate. If so, please delete it by running **rm terraform.tfstate**.

14. If you'd like to see the hashicat application in your web browser, simply copy the link from the output of your Terraform run, and paste it into the URL bar in another tab or window.

Click on **Next** once you've successfully deployed the hashicat application with remote state enabled.
