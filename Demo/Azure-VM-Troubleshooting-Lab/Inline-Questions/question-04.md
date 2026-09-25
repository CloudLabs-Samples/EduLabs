## MetaData
Question Type : Multiple Choice

## Question
4. Which **TWO** commands show what is actually in effect on appvm's network interface, combining every source that applies, rather than the contents of a single resource?

## Options

Option 1 : `az network nic list-effective-nsg`, which merges subnet and NIC rules with the defaults

Option 2 : `az network nsg rule list`, which returns only the custom rules defined in one named security group

Option 3 : `az network route-table route list`, which returns the routes in one route table

Option 4 : `az network nic show-effective-route-table`, which merges system routes with any user routes

## Answers
Option 1 : 1
Option 4 : 1

## Number of Retries
1
