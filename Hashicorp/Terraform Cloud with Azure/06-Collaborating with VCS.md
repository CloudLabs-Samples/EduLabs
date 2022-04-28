## Collaborating with VCS

Now that you've got your version control system configured with Terraform Cloud, you can collaborate on changes to your Terraform built infrastructure.

In this challenge you'll make a small change to the code that deploys the hashicat-azure application, and then create a "Pull Request", which is simply a way of proposing a change and optionally allowing others to review your changes.

1. Find a partner, or if you're alone you can do this exercise solo. Exchange github usernames and browse to the other person's fork of the hashicat-azure repository. For example: https://github.com/YOURNAME/hashicat-azure
Please do NOT issue your pull request against the hashicorp/hashicat-azure repository!

2. Browse to the files/deploy_app.sh file and click on the small pencil icon in the upper right corner of the text area. This will allow you to edit the file right in your browser.

3. Replace the following text with your own catchy marketing slogan
Welcome to ${PREFIX}'s app. Replace this text with your own.

4. At the bottom of the screen, select the option that says "Create a new branch for this commit and start a pull request." Then, click the "Propose changes" button. 

5. Finally, submit a pull request by clicking the "Create pull request" button.
You'll notice that a check is run against your Terraform Cloud workspace. If you right-click the "Details" link of the check and then open the link in a new tab, you'll see the speculative plan that has been run in your workspace.

6. However, if you do open the link, you might need to refresh the GitHub page in order to see that the check has passed and so that the "Merge pull request" button will be enabled.

7. Your partner should now review and approve the pull request. Or, if you're working alone you can review your own pull request and merge the changes.
Once you've merged your changes to the master branch, watch the Terraform run that starts in the Terraform Cloud UI.
