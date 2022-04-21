Developers in your organization are building cloud resources without tagging them properly. You need a way to enforce tagging on all your Azure instances that are built with Terraform. Meet Sentinel, the governance engine for Terraform.

In this challenge you'll use Sentinel to enforce a rule that requires any Azure Virtual Machine created in your account to have the correct billable and department tags.
Challenge Setup
1.	Create a fork of the following GitHub repo, which contains a Sentinel Policy Set that you can use in your own organization. As you did with the hashicat-azure repo, use the Fork button in the upper right corner of the screen to create your own copy.
https://github.com/hashicorp/tfc-workshops-sentinel
Note:: If you previously forked this repository before 9/20/2020, please delete your fork and re-fork it to ensure that you are using newer versions of the policies that use the Sentinel v2 imports.
Before moving on, please look at the enforce-mandatory-tags policy. This policy requires all Azure VMs to have Department and Billable tags. It uses some functions from a Sentinel module in a different repository called terraform-sentinel-policies. You'll find many useful Sentinel policies and functions in it.
1.	Go into the Organization Settings for your training organization and click on Policy Sets.
2.	Use the Connect a new policy set button to connect your new GitHub repo to your organization. Remember, the repository is named tfc-workshops-sentinel.
3.	Under Description you can enter "Sentinel Policies for our Azure resources".
4.	In the More Options menu set the Policies Path to /azure. This tells Terraform Cloud to use the Azure specific policies that are stored in the repo.
5.	Leave everything else at its default setting and click on the Connect policy set button at the bottom of the page.
You are now ready to begin the challenge.
The Challenge
You'll first need to run a git pull command to pull in the changes you made in the "Collaborating with VCS" challenge:
git pull
Then, add the Department tag with a value of "devops" to the azurerm_virtual_machine resource in your main.tf file. Be sure to save the file.
Then run the following commands to push the change to your forked repository:
git add .
git commit -m "Added the first tag"
git push origin master
These commands mean "add all your changes, commit them to the local git repo, then push them to the master branch of the remote repo." Note that you will have to provide your GitHub credentinals for the git push command.
A plan that successfully runs will be followed by a Sentinel policy check against the enforce-mandatory-tags.sentinel policy. This policy will fail because you have (intentionally) not yet added the Billable tag to your azurerm_virtual_machine resource. As a consequence, you will not be able to apply the run.
Now, add the Billable tag to the azurerm_virtual machine resource in your main.tf file with a value of "true" and then run these commands to push the change to your repository:
git add .
git commit -m "Added the second tag"
git push origin master
This time, the Sentinel policy should pass because your Azure VM now has both tags.
Each time you push a change to master, you'll trigger a new Terraform run. Keep trying until you pass the Sentinel policy check.
