Terraform Cloud has a fully featured RESTful API that you can use to integrate with external systems. Where we're going, we don't need a GUI!


In the final challenge you'll directly interact with the Terraform Cloud API. Terraform Cloud has a rich API that lets you do everything you can do in the GUI and more. Intermediate and advanced users utilize the API to create complex integrations that work with external systems.
Your goal is to configure three variables in the hashicat-azure workspace and then trigger a Terraform run using only the API. The three variables you need to configure are:
•	placeholder An image placeholder URL. Examples: placekitten.com, placedog.net, picsum.photos
•	height The height in pixels for your image. Set this to 600
•	width The width in pixels for your image. Set this to 800
If you've already configured any of the three variables in the UI please delete them before starting the challenge.
Challenge Setup:
Run this command to fetch your token and store it as the TOKEN environment variable:
export TOKEN=$(grep token /root/.terraform.d/credentials.tfrc.json | cut -d '"' -f4)
Next set your ORG variable with the following command, replacing MYORGNAME with your own:
export ORG="MYORGNAME"
Finally, fetch your workspace id with the following curl command. Curl is a command line tool that is handy for interacting directly with APIs. Note how your TOKEN and ORG variables are automatically embedded in the command:
curl -s --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/vnd.api+json"   https://app.terraform.io/api/v2/organizations/$ORG/workspaces/hashicat-azure | jq -r .data.id
Copy or save this workspace ID somewhere as you will need it during the challenge.
The Challenge:
Use the four *.json files located in the json directory to create your variables and trigger a Terraform plan/apply. Use the Terraform API docs (which are in one of this challenge's notes) to determine which commands to run. You can edit the files in your code editor to customize them for your workspace. Be sure to include @ before the JSON file names.
You can find the relevant curl request instructions here:
•	For workspace variables
•	To apply runs
When you've succesfully triggered a run via the API with the new variables, click the Check button to continue.

 
