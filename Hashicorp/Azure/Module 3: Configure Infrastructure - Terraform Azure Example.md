# Module 3: Configure Infrastructure - Terraform Azure Example

In this module, you will learn about the basics of Terraform and initialize the Terraform configuration using Windows PowerShell.

## Task 1: Basics of Terraform

### Overview

The syntax of Terraform configurations is called **HashiCorp Configuration Language (HCL)**. It is meant to strike a balance between human-readable and editable as well as being machine-friendly. For machine-friendliness, Terraform can also read JSON configurations. For the Terraform configuration, you will be using the **.tf** extension.

The Terraform language syntax is built around two key syntax constructs: Arguments and blocks.

- **Arguments** : An argument assigns a value to a particular name

    `string_id = "abc123"`
    The identifier before the equals sign is the argument name, and the expression after the equals sign is the argument's value.
    
- **Blocks**: A block is a container for other content

   ```
   resource "azure_instance" "example" {
        ami = "abc123"
        network_interface {
         ...
      }
   }
   ```
   
   A block has a type (resource in this example). Each block type defines how many labels must follow the type keyword. The resource block type expects two labels, which are azure_instance and example in the example above. A particular block type may have any number of required labels, or it may require none as with the nested network_interface block type.
   
   After the block type keyword and any labels, the block body is delimited by the { and } characters. Within the block body, further arguments and blocks may be nested, creating a hierarchy of blocks and their associated arguments.
   
### Identifiers

Argument names, block type names, and the names of most Terraform-specific constructs like resources, input variables, etc. are all identifiers.

Identifiers can contain letters, digits, underscores (_), and hyphens (-). The first character of an identifier must not be a digit, to avoid ambiguity with literal numbers.

For complete identifier rules, Terraform implements the Unicode identifier syntax, extended to include the ASCII hyphen character -.

### Comments

The Terraform language supports three different syntaxes for comments:

  - **#** begins a single-line comment, ending at the end of the line.

  - **//** also begins a single-line comment, as an alternative to **#**.

  - `/* and */ `are the start and end delimiters for a comment that might span over multiple lines.

  - The **#** single-line comment style is the default comment style and should be used in most cases. Automatic configuration formatting tools may automatically transform **//** comments into **#** comments since the double-slash style is not idiomatic.

### Write configuration

You can have a look at the sample configuration of Terraform file `main.tf` below:

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
  name     = "myTFResourceGroup"
  location = "westus2"
}
```

In the following sections, you will review each block of the configuration in more detail.

  - **Terraform Block:**

The `terraform {}` block contains Terraform settings, including the required providers Terraform will use to provision your infrastructure. For each provider, the `source` attribute defines an optional hostname, a namespace, and the provider type. Terraform installs providers from the Terraform Registry by default. In this example configuration, the `azurerm` provider's source is defined as `hashicorp/azurerm`, which is shorthand for `registry.terraform.io/hashicorp/azurerm`.

You can also define a version constraint for each provider in the `required_providers` block. The `version` attribute is optional, but we recommend using it to enforce the provider version. Without it, Terraform will always use the latest version of the provider, which may introduce breaking changes.

   - **Providers:**

The `provider` block configures the specified provider, in this case, `azurerm`. A provider is a plugin that Terraform uses to create and manage your resources. You can define multiple provider blocks in a Terraform configuration to manage resources from different providers.


   - **Resource:**

You will be using `resource` blocks to define components of your infrastructure. A resource might be a physical component such as a server, or it can be a logical resource such as a Heroku application.

Resource blocks have two strings before the block: the resource type and the resource name. In this example, the resource type is `azurerm_resource_group` and the name is `rg`. The prefix of the type maps to the name of the provider. In the example configuration, Terraform manages the `azurerm_resource_group` resource with the `azurerm` provider. Together, the resource type and resource name form a unique ID for the resource. For example, the ID for your network is `azurerm_resource_group.rg`.

## Task 2: Initialize your Terraform Configuration
   
Terraform must authenticate to Azure to create infrastructure.

1. In your terminal, use the Azure CLI tool to login to Azure

   ```
      az login
   ```
   
2. Your browser will open and prompt you to enter your Azure login credentials. After successful authentication, your terminal will display your subscription information.

![IMG12](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img12.png?raw=true)

3. Now copy and paste the below command in the PowerShell terminal to create a new folder called `learn-terraform-azure` and minimize the terminal.

   ```
      New-Item -Path "c:\" -Name "learn-terraform-azure" -ItemType "directory"
   ```

4. Copy and paste the below configuration in a new file called `main.tf` using Visual Studio Code, make sure you replace **{DID}** value under resource group name with **<inject key="DeploymentID" />** and save it under **C:\learn-terraform-azure**.

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
       name     = "lab-rg-{DID}"
       location = "westus2"
    }
    ```
    >**Note:** Make sure you select **Save as type** as **All files**, while saving the **main.tf** file.

5. Now, navigate to the newly created directory by running the following command.

    ```
       cd C:\learn-terraform-azure
    ```
    
6. Run the below command to initialize your `learn-terraform-azure` directory in your terminal.

   ```
      terraform init
   ```
   
   > **Info**: The above command will initialize the working directory containing Terraform configuration files and install any required plugins.

![IMG15](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img15.png?raw=true)

7. Run the below command to automatically update configurations in the current directory for readability and consistency.

   ```
      terraform fmt
   ```
     
8. Terraform will print out the names of the files it modified if any. In this case, your configuration file was already formatted correctly, so Terraform will display the name of the newly created file.

![IMG16](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img16.png?raw=true)

9. You can also make sure your configuration is syntactically valid and internally consistent by running the below command.

   ```
      terraform validate
   ```
     
![IMG17](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img17.png?raw=true)

10. Run the below command to apply the changes to your infrastructure. Enter **yes** to the prompt to confirm the changes.

   ```
      terraform apply
   ```

![IMG18](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img18.png?raw=true)

>**Note**: As it is a pre-created resource group, you will get an error as the resource group already exists. You can ignore the error and continue with the next step.

11. Now, run the below command in **Windows PowerShell (Admin)** to import the created resource group into Terraform state.
>**Note:** Make sure you replace the **{subscription-id}** and **{DID}** before running the command. You can find the values on the **Environment details** page.

   ```
      terraform import azurerm_resource_group.rg /subscriptions/{subscription-id}/resourceGroups/lab-rg-{DID}
   ```
   
   > **Info:** The above command will find the existing resource from subscription ID and import it into your Terraform state.
       
![IMG19](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img19.png?raw=true)

12. You can inspect the current state of the resource group by running the following command.

   ```
      terraform show
   ```
![IMG20](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img20.png?raw=true)

13. To review the information in your state file, use the **state** command. If you have a long state file, you can see a list of the resources you created with Terraform by using the **list** subcommand.

   ```
      terraform state list
   ```
     
![IMG21](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img21.png?raw=true)

14. Use the following command, to see a full list of available commands to view and manipulate the configuration's state.

   ```
      terraform state
   ```
     
![IMG22](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img22.png?raw=true)

15. Now you have successfully imported the resource group `lab-rg-{DID}` using Terraform configuration.

## Summary

In this module, you learned to:

 - Initialized the Terraform configuration
 - Imported the pre-created resource group into Terraform state
