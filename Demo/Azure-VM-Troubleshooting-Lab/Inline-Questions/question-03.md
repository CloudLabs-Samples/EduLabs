## MetaData
Question Type : Single Choice

## Question
3. Before you deleted the route `to-lab-subnet-via-nva`, SSH to appvm timed out even though the NSG allowed port 22 from the jump host subnet. Why?

## Options

Option 1 : User-defined routes are evaluated before NSG rules, and any prefix they redirect is implicitly denied for inbound traffic

Option 2 : The route pointed inbound traffic for appvm at the appliance, so the SYN never reached the app server

Option 3 : appvm's replies to 10.0.1.0/24 were sent to an appliance that no longer existed, so each response was dropped

Option 4 : The route caused the default DenyAllInBound rule to be evaluated first, blocking port 22 before rule 100 ran

## Answers
Option 3 : 1

## Number of Retries
1
