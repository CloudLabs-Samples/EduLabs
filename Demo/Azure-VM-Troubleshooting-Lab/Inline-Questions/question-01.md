## MetaData
Question Type : Single Choice

## Question
1. In Lab 1, after you moved `Allow-HTTP-From-LabSubnet` to priority 150, `curl` to port 80 stopped timing out and instead returned **Connection refused** within milliseconds. What did that change in symptom tell you?

## Options

Option 1 : The NSG was still dropping HTTP, but after the change it began sending a reset back to the client

Option 2 : Packets now reached the VM, whose operating system replied that nothing was listening on that port

Option 3 : The route deletion had not finished programming, so replies were still being sent to the old firewall appliance

Option 4 : The jump host's own outbound NSG rule was blocking the reply, which the client reports as a refused connection

## Answers
Option 2 : 1

## Number of Retries
1
