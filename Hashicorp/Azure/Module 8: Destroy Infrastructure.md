# Module 8: Destroy Infrastructure

You have now used Terraform to configure and update Azure resources. In this module, you will use Terraform to destroy your infrastructure.

Once you no longer need infrastructure, you may want to destroy it to reduce your security exposure and costs. For example, you may remove a production environment from service or manage short-lived environments like build or testing systems. In addition to building and modifying infrastructure, Terraform can destroy or recreate the infrastructure it manages.

## Destroy

The `terraform destroy` command terminates resources managed by your Terraform project. This command is the inverse of `terraform apply` in that it terminates all the resources specified in your Terraform state. It does not destroy resources running elsewhere that are not managed by the current Terraform project.

Run the below command to destroy the infrastructure you created, type `yes` to execute this plan and destroy the infrastructure.

   ```
      terraform destroy
   ```
   
   >**Note:** Just like with apply, Terraform determines the order in which things must be destroyed. In more complicated cases with multiple resources, Terraform will destroy them in a suitable order to respect dependencies.

## Summary

In this module, you learned to:
   
   - Terminate the resources specified in the Terraform state.
