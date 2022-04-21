# Module 3: Build Infrastructure - Terraform Azure Example

In this module, you will learn about the basics of Terraform and initialize the Terraform configuration using Windows PowerShell.

## Install the Azure CLI tool

1. You will use Azure CLI tool to authenticate with Azure.

2. Open your **Powershell** prompt as an **administrator** and run the following command:
  
   ```
      Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
   ```
   >**Info:** This will write a web request and will take some time to execute.
   
![IMG11](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img11.png)
   
## Authenticate Using the Azure CLI

Terraform must authenticate to Azure to create infrastructure.

1. In your terminal, use the Azure CLI tool to login to Azure

   ```
      az login
   ```
   
2. Your browser will open and prompt you to enter your Azure login credentials. After successful authentication, your terminal will display your subscription information.

![IMG12](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img12.png)
>Find the `id` column for the subscription account you want to use.

3. Once you have chosen the account **Subscription ID**, set the account with the Azure CLI.

   ```
      az account set --subscription "35akss-subscription-id"
   ```

## Create a Service Principal

Next, create a Service Principal. A Service Principal is an application within Azure Active Directory with the authentication tokens Terraform needs to perform actions on your behalf. Update the `<SUBSCRIPTION_ID>` with the **Subscription ID** you specified in the previous step.

( Requires Contributor Role)

## Write Configuration

1. Create a folder called `learn-terraform-azure`.

   ```
      New-Item -Path "c:\" -Name "learn-terraform-azure" -ItemType "directory"
   ```

2. Copy and paste the below configuration in a new file called `main.tf` using **Visual Studio**, and save it under **C:\learn-terraform-azure**.

   ```
       # Configure the Azure provider
        terraform {
         required_providers {
          azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 2.65"
           }
         }

        required_version = ">= 1.1.0"
      }

     provider "azurerm" {
        features {}
     }

    resource "azurerm_resource_group" "rg" {
       name     = "myTFRResourceGroup"
       location = "westus2"
    }
    ```
    >**Note:** Make sure you select **Save as type** as **All files**, while saving the **main.tf** file
    >**Note:** The `location` of your resource group is hardcoded in this example. If you do not have access to the resource group location `westus2`, update the `main.tf` file with your Azure region.

## Terraform Block

The `terraform {}` block contains Terraform settings, including the required providers Terraform will use to provision your infrastructure. For each provider, the `source` attribute defines an optional hostname, a namespace, and the provider type.Terraform installs providers from the Terraform Registry by default. In this example configuration, the `azurerm` provider's source is defined as `hashicorp/azurerm`, which is shorthand for `registry.terraform.io/hashicorp/azurerm`.

You can also define a version constraint for each provider in the `required_providers` block. The `version` attribute is optional, but we recommend using it to enforce the provider version. Without it, Terraform will always use the latest version of the provider, which may introduce breaking changes.

## Providers

The `provider` block configures the specified provider, in this case `azurerm`. A provider is a plugin that Terraform uses to create and manage your resources. You can define multiple provider blocks in a Terraform configuration to manage resources from different providers.

## Resource

Use `resource` blocks to define components of your infrastructure. A resource might be a physical component such as a server, or it can be a logical resource such as a Heroku application.

Resource blocks have two strings before the block: the resource type and the resource name. In this example, the resource type is `azurerm_resource_group` and the name is `rg`.The prefix of the type maps to the name of the provider. In the example configuration, Terraform manages the `azurerm_resource_group` resource with the `azurerm` provider. Together, the resource type and resource name form a unique ID for the resource. For example, the ID for your network is `azurerm_resource_group.rg`.

Resource blocks contain arguments which you use to configure the resource.

## Initialize your Terraform configuration

1. Navigate to the newly created directory by running the following command.

   ```
      cd C:\learn-terraform-azure
   ```
2. Run the below command to initialize your `learn-terraform-azure` directory in your terminal.

   ```
      terraform init
   ```
   > **Info**: The above command will initialize the working directory containing Terraform configuration files and install any required plugins.

![IMG13](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img13.png)

## Format and validate the configuration

The `terraform fmt` command automatically updates configurations in the current directory for readability and consistency.

Format your configuration. Terraform will print out the names of the files it modified, if any. In this case, your configuration file was already formatted correctly, so Terraform won't return any file names.

   ```
      terraform fmt
   ```

You can also make sure your configuration is syntactically valid and internally consistent by using the `terraform validate` command.

Validate your configuration. The example configuration provided above is valid, so Terraform will return a success message.

   ```
      terraform validate
   ```
   
![IMG14](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img14.png)

## Apply your terraform configuration

1. Run the below command to apply changes to your infrastructure.

   ```
      terraform apply
   ```

This output shows the execution plan and will prompt you for approval before proceeding. If anything in the plan seems incorrect or dangerous, it is safe to abort here with no changes made to your infrastructure. 

2. Type `yes` at the confirmation prompt to proceed.



       

 
