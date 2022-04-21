# Module 8: Store Remote State

Now you have built, changed, and destroyed infrastructure from your local machine. In this module, you are going to run Terraform in a remote environment with a shared access state. This way, your teammates can access and collaborate on  the infrastructure.

**Terraform Cloud** allows teams to easily version, audit, and collaborate on infrastructure changes. It can also store access credentials off of developer machines, and provides a safe, stable environment for long-running Terraform processes.

You will now proceed to migrate your state to Terraform cloud.

## Pre-requisites

This module assumes you have completed the previous modules. If not, create a directory named `learn-terraform-azure` and paste this code into a file named `main.tf`.

   ```
      # Configure the Azure provider
      terraform {
      required_version = ">= 1.1.0"
      required_providers {
      azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.2"
      }
      }
      }
      
      provider "azurerm" {
      features {}
      }
     
     resource "azurerm_resource_group" "rg" {
     name     = "lab-rg-{DID}"
     location = "westus2"
     }
  ```
  
  ## Set up Terraform Cloud
  
First, you will configure Terraform Cloud. Terraform Cloud offers free remote state management. Terraform Cloud is the recommended best practice for remote state storage.

1. Sign up for [Terraform Cloud](https://app.terraform.io/signup/account) account.

2. After signing up, you will be asked to setup your workfloe, select **Start from scratch**.

![IMG29](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img29.png)

3. Provide a name for your **Organization**, and make a note of it, and proceed to create the **Organization**.

![IMG30](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img30.png)

4. You will be asked to create a **New Workspace**, select **CLI Driven Workflow** and provide a name for your workspace.

![IMG31](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img31.png)
 >**Note:** In my case, I have named the workspace `learn-terraform-azure`

5. Open your `main.tf` file, make respective changes and configure the `cloud` block with your organization name and the workspace name, as shown below:

   ```
      terraform {
      required_version = ">= 1.1.0"
      required_providers {
      azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.2"
      }
      }
      cloud {
      organization = "<ORG_NAME>"
      workspaces {
      name = "learn-terraform-azure"
      }
      }
      }
   ```
   
## Authenticate with Terraform Cloud

1. Now that you have defined your Terraform Cloud configuration, you must authenticate with Terraform Cloud in order to proceed with initialization.In order to authenticate with Terraform Cloud, run the below command:

   ```
      terraform login
   ```
   
2. You will be redirected to the Terraform cloud where you will be asked to login with your **Terraform Cloud Creds**.

3. After successfully logging in with your creds, you will be asked to generate a token where you could provide a token name in the Web UI or leave it to be the default name `terraform login`.

4. Click on **Create API Token** to generate authentication token.

![IMG32](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img32.png)

![IMG33](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img33.png)

5. Copy the token, and paste it into the **CLI**( Terraform will hide the token for security when you paste it into the terminal).

6. Press **Enter** to complete the authentication process.

![IMG34](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img34.png)

## Migrate the state file

1. Now you are ready to migrate your local state file to Terraform Cloud. Reinitialize your configuration to begin the migration. This causes Terraform to recognize your `cloud` block configuration by running the below command:

   ```
      terraform init
   ```
 ![IMG35](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img35.png)  
  
2. During reinitialization, Terraform presents a prompt saying that it will copy the state file to your Terraform Cloud workspace. Enter `yes` so Terraform will migrate the state from your local machine to Terraform Cloud.

![IMG36](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img36.png)

>**Note:** When using Terraform Cloud with the CLI-driven workflow, you can choose to have Terraform run remotely, or on your local machine. he default option is remote execution — Terraform Cloud will perform Terraform operations remotely. When using local execution, Terraform Cloud will execute Terraform on your local machine and remotely store your state file in Terraform Cloud. For this tutorial, you will use the default remote execution option for the workspace.

3. Now that Terraform has migrated the state file to Terraform Cloud, delete the local state file.

   ```
      rm terraform.tfstate
   ```
## Destroy the Infrastructure

Destroy your infrastructure, and remember to confirm with a `yes`.

   ```
      terraform destroy
   ```

## Summary

In this module, you learned how to:

   - run Terraform in a remote environment.
   - migrate your local terraform state file to Terraform cloud.
