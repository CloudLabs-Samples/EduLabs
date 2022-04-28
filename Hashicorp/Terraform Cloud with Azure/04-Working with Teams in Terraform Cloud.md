## Working with Teams in Terraform Cloud

As your Terraform usage increases more team members want to collaborate. Let's add some teams and access rules for our organization.

Teams and role-based access controls are a paid feature of Terraform Cloud. You will need to ensure your free trial has been activated from the earlier steps in order to complete this challenge.

In this challenge you'll create teams with different levels of access to your workspace. You can then invite other users to collaborate on code changes, approvals, and Terraform runs.

1.	Go into your organization's General Settings and click on the Teams link.

2.	Add a team called admins. Admins should be able to manage policies and policy overrides, manage workspaces, and manage VCS settings. Be sure to click the "Update team organization access" button after checking all 4 checkboxes.

3.	Add another team called developers. Developers should not have any organization-wide access.

4.	Add a third team called managers. Managers should also not have any organization-wide access.

5. Next, assign access rights to the hashicat-azure workspace. Go into the Team Access page of the hashicat-azure workspace settings. If you don't see the Team Access link you might need to log out and back into Terraform Cloud.

6. You'll want to click the "Add team and permissions" button and then click the "Select team" button next to each team to which you wish to grant workspace access. Then click the "Assign permissions" button for the desired permission.
•	Give the admins group admin level access.
•	Give the developers group write level access.
•	Give the managers group read level access.

7. Now that you have created teams and given them workspace access you can invite some users to your organization. Return to your General Settings for the organization, and select Users. Then click the "Invite a user" button.

8. If you're doing an instructor-led training, you can invite your instructor or a fellow student to your organization and place them on the developers team. You'll need the email address attached to their Terraform Cloud account to invite them.
Or you can use one of our example users below:
•	workshops+aisha@hashicorp.com
•	workshops+lars@hashicorp.com
•	workshops+hiro@hashicorp.com

Note that you will not see any users in your organization until they accept your invitations.

You will need at least two users (including yourself) in your organization to pass this challenge. The users you invite do not have to accept the invite to be counted.
