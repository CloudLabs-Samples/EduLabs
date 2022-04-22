# Module 5: Define Input Variables

In this module, you will learn to include variables to make Terraform configuration more dynamic and flexible.

## Define your variables

In your `learn-terraform-azure` directory, create a new file called `variables.tf` using **Visual Studio Code** . Copy and paste the variable declaration below.

   ```
      variable "resource_group_name" {
      default = "lab-rg-{DID}"
      }
   ```
   
   >**Note:** Make sure to select the **File Type** as **All Files** and **Save it**.
   >This declaration includes a default value for the variable, so the `resource_group_name` variable will not be a required input.

### Update your Terraform configuration with your variables

Update your `azurerm_resource_group` configuration to use the input variable for the resource group name. Modify the `main.tf` file as follows:

   ```
      resource "azurerm_resource_group" "rg" {
      name     = var.resource_group_name
      location = "westus2"
      
      tags = {
      Environment = "Terraform Getting Started"
      Team        = "DevOps"
      }
      }
   ```
   
### Apply your configuration

Run the below command to recreate your infrastructure using input variables. Respond `yes` to the prompt to confirm the operation.

   ```
      terraform apply
   ```
   
## Summary

In this module, you learnt about:

   - Input Variables
   - How to Define those variables in the main configuration

