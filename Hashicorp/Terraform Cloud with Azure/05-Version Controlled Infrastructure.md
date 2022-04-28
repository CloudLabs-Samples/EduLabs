## Version Controlled Infrastructure

The team has grown and you need to implement code reviews. Terraform Cloud can connect to popular Version Control Systems to enable collaboration and testing.

In order for different teams and individuals to be able to work on the same Terraform code, you need to use a Version Control System (VCS). Terraform Cloud can integrate with the most popular VCS systems including GitHub, GitLab and Bitbucket.
You will need a free GitHub.com account for this challenge. We recommend using a personal account for training instead your work account (if you have one).
 
 
 1. Create a **fork** of the hashicat-azure repository. Visit this URL and click on the Fork button in the upper right corner to create your own copy of the repo.
   ```
   https://github.com/hashicorp/hashicat-azure
   ```
   
   Note: If you ran this track in the past and already forked the repository, please delete your fork and re-fork it to make sure you are using the latest version and that it does not have changes which you will push to it later in this track. You can delete a repository by clicking on the "Settings" menu of it, scrolling all the way to the bottom of the page, clicking the "Delete this repository" button in the "Danger Zone" section, typing the full repository name, and then clicking the "I understand the consequences, delete this repository" button. Then re-fork the repository as above.

2. Navigate back to cloudshell and run the following commands to update your git configuration for your own repository. Don't forget to replace **YOURGITUSER** with your own git username in the second command.

  ```
  git remote remove origin
  git remote add origin https://github.com/YOURGITUSER/hashicat-azure
  ```

3. If the second command is split across two lines after copying it from the assignment and you are unable to edit it, try making your browser window wider or hiding the assignment termporarily so it fits on one line.

4. Also run these commands:
   ```
   git pull
   git branch --set-upstream-to=origin/master master
   git config --global core.editor "vi"
   ```

5. Next use these commands to set your email and name:

```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

6. To complete your git operations, please commit and push your modified remote_backend.tf file with these commands on your **cloud shell** tab:
```
git add .
git commit -m "Added remote backend"
git push origin master
```
Note that you'll have to provide your GitHub username and personal access token in order to complete the git push command.

7. If you have two-factor authentication enabled and don't remember your personal access token, you'll need to create a new one. To do that, log onto GitHub and visit the Tokens page:https://github.com/settings/tokens

8. Then click on **Personal Access Tokens** and **generate a new token** for the workshop. Give it at least the repo | public_repo scope, but you can grant the entire repo scope and other scopes if desired. You can delete the token afterwards if you like. This token enables you to push changes from your workstation to your public fork of the hashicat-azure repository.

9. Now that you have your own copy of the hashicat-azure repo to work with, follow the Configuring GitHub Access section of the TFC documentation to connect your GitHub account to your Terraform Organization.
https://www.terraform.io/docs/cloud/vcs/github.html

10. Or navigate to the terraform organization's settings and select **Providers** under **Version control** section and click on **Add a VCS provider** 

11. Now, under **Control to VCS** tab choose Github and **Github.com(custom)** option from the drop down menu

12. Next from the **Set up provider** navigate to the URL and enter the information mentioned in the step 1 of the Set up provider section and click on **Register application**

13. You will be navigated to the created application page, note down the **Client ID** and **Client secrets** as you will need it in the next step of Set up provider section

14. After enter all the details under Set up provider section click on **Connect and continue** button

15. Click on **Authorize YOURGITHUBUSER** to authorize the connection

16. Next navigate to the **hashicat workspace-> Settings** and select **Version control** from the drop down menu

17. Click on **Connect to version control** and select **Version control workflow** under **Choose your workflow** tab

18. Select **Github(Custom)** from the **Connect to a version control provider** tab

19. **Choose a repository** from the list 
 >Make sure you configure an OAuth connection for your organization and not the GitHub App for a single workspace! Once you've configured GitHub access for your organization, you can update your workspace to use your hashicat-azure repository as the source for all Terraform runs. Go into the Settings > Version Control settings page for your workspace. Connect your workspace to the fork of your hashicat-azure repository on GitHub.

20. Enable the **Automatic speculative plans** feature and then  click on **Update VCS settings** from the **version Control** page 

21. The first VCS-backed apply should trigger immediately. Click on the **Runs** tab to view the run in action.

Congratulations, all Terraform changes must now go through version control before they are used in your workspace. This enables you to do code reviews before any changes are pushed to production. It also provides a valuable record of any and all changes made to the code that built your infrastructure. This can prevent configuration drift and undocumented changes.

Click the Next button to let Jane know she can clone the hashicat-azure repo for QA testing.

