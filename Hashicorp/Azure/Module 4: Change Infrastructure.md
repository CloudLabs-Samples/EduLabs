# Module 4: Change Infrastructure

In the previous module, you configured your infrastructure with Terraform: a resource group. Now you will modify your configuration by defining an additional resource that references your resource group and adding tags to your resource group.

## Create a new resource

In your `main.tf` file, add the resource block below to create a virtual network (VNet).

   ```
      # Create a virtual network
      resource "azurerm_virtual_network" "vnet" {
      name                = "myTFVnet"
      address_space       = ["10.0.0.0/16"]
      location            = "westus2"
      resource_group_name = azurerm_resource_group.rg.name
      }
   ```
   
   >**Note:** To create a new Azure VNet, you have to specify the name of the resource group to contain the VNet. By referencing the resource group, you establish a dependency between the resources. Terraform ensures that resources are created in proper order by constructing a dependency graph for your configuration.

### Apply your changes

After changing the configuration, run  the below command to see how Terraform will apply this change to your infrastructure. Respond `yes` to the prompt to confirm the changes.

   ```
      terraform apply
   ```

### Modify an existing resource

In addition to creating new resources, Terraform can modify existing resources.

Open your `main.tf` file. Update the `azurerm_resource_group` resource in your configuration by adding the tags block as shown below:

   ```
      resource "azurerm_resource_group" "rg" {
      name     = "lab-rg-{DID}"
      location = "westus2"
      
      tags = {
      Environment = "Terraform Getting Started"
      Team = "DevOps"
      }
      }
   ```
   
![IMG23](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img23.png)
   
   >**Note:** Run `Terraform apply` to modify your infrastructure. Respond `yes` to the prompt to confirm the operation.

### Review the updates to state

Use the below command to see the new values associated with this resource group.

   ```
      terraform show
   ```
   
![IMG24](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img24.png)

Run the below command to get the updated list of resources managed in your workspace.

   ```
      terraform state list
   ```
   
![IMG25](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img25.png)

## Summary

In this module, you learnt to:

   - Create a new resource
   - Modify an existing resources
   - Apply changes to the infrastructure and review it
