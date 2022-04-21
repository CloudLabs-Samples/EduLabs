Developers in your organization are running large VMs that are costing a lot of money. You need a way to restrict the costs of each workspace.

In this challenge you'll use Terraform Cloud's Cost Estimation feature to inform developers what the estimated monthly costs of their hashicat-azure workspace will be.
Enabling Cost Estimation across all workspaces of an organization in Terraform Cloud is very easy. All you need to do is visit the "Settings | Cost estimation" page of your organization and check the "Enable Cost Estimation for all workspaces" checkbox.
Note that in Terraform Enterprise, you also need to provide cloud credentials for the clouds for which you want cost estimates. See this link.
To see a cost estimate for your hashicat-azure workspace, just trigger a new run in it by clicking the Actions drop-down and then selecting "Start a new plan". You will then see the estimated monthly cost of the workspace which is based on the costs of the azurerm_virtual_machine resource provisioned for the hashicat-azure workspace.
A complete list of Azure resources for which cost estimates are available in Terraform Cloud is here.
Finally, note that Sentinel's tfrun import can be used to prevent runs from being applied when workspaces would incur excessive monthly costs or cost increases.
See the following example Sentinel policies:
•	limit-proposed-monthly-cost.sentinel
•	limit-cost-by-workspace-name.sentinel
•	limit-cost-and-percentage-increase.sentinel
