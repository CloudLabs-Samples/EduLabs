# Module 7: Query Data with Output Variables

In this module, you will use output values to organize data to be easily queried and displayed to the Terraform user.

When building complex infrastructure, Terraform stores hundreds or thousands of attribute values for all your resources. As a user of Terraform, you may only be interested in a few values of importance. Outputs designate which data to display. This data is outputted when `apply` is called, and can be queried using the `terraform output` command.

## Define an output

Create a file called `outputs.tf` in your `learn-terraform-azure` directory. Add the following output definition to `outputs.tf`.

   ```
      output "resource_group_id" {
      value = azurerm_resource_group.rg.id
      }
   ```
   
   >**Note:** Make sure to select the **File Type** as **All Files** and **Save it**.
   
This defines an output variable named `resource_group_id`. The name of the variable must conform to Terraform variable naming conventions if it is to be used as an input to other modules. The `value` field specifies the value, the `id` attribute of your resource group.

You can define multiple `output` blocks to specify multiple output variables.

### Observe your resource outputs

Before you run `terraform apply` and query the `output`, you must import the created resource group into Terraform state.

1. Run the below command in **Windows PowerShell (Admin)** to import the created resource group into Terraform state.
>**Note:** Make sure you replace the **{subscription-id}** and **{DID}** before running the command. You can find the values on the **Environment details** page.

   ```
      terraform import azurerm_resource_group.rg /subscriptions/{subscription-id}/resourceGroups/lab-rg-{DID}
   ```
   
   > **Info:** The above command will find the existing resource from subscription ID and import it into your Terraform state.
       
![IMG19](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img19.png)

2. When you add an output to a previously applied configuration, you must re-run `terraform apply` to observe the new output.

3. Run the below command to apply the configuration, and confirm with `yes`.

   ```
      terraform apply
   ```
   
![IMG26](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img26.png)
![IMG27](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img27.png)

4. Notice that the `apply` run returns the outputs. Query the `output` using the output command with the output ID.

   ```
      terraform output resource_group_id
   ```
   
![IMG28](https://github.com/SD-14/EduLabs/blob/SD/Hashicorp/Azure/Images/Img28.png)

## Summary

In this module, you learned to:

   - Define an output variable
   - Query the output file to receive the output
