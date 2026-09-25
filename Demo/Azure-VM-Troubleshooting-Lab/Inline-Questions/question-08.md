## MetaData
Question Type : Single Choice

## Question
8. Why did Lab 2 need both a `Microsoft.Storage` service endpoint on `app-subnet` **and** a virtual network rule on the storage account?

## Options

Option 1 : The endpoint gives the storage account a private IP inside the VNet, and the rule publishes it in private DNS

Option 2 : The endpoint makes subnet traffic arrive identified by its subnet, and the rule tells the firewall to admit it

Option 3 : The endpoint grants the subnet's VMs a data-plane role, and the rule restricts that role to the reports container

Option 4 : The endpoint opens outbound port 443 in the subnet's NSG, and the rule adds the VM's public IP to the allow list

## Answers
Option 2 : 1

## Number of Retries
1
