## MetaData
Question Type : Single Choice

## Question
2. The NSG on appvm contained `Deny-HTTP-Inbound` (priority 200, source `*`, port 80) and `Allow-HTTP-From-LabSubnet` (priority 300, source `10.0.1.0/24`, port 80). A request arrives from `10.0.1.10` on port 80. What happens, and why?

## Options

Option 1 : It is allowed, because a rule with a specific source prefix always overrides a rule whose source is any address

Option 2 : It is allowed, because when an allow rule and a deny rule both match, Azure applies the more permissive rule

Option 3 : It is denied, because deny rules are always processed before allow rules, whatever priority numbers they carry

Option 4 : It is denied, because rules are processed in ascending priority order and evaluation stops at the first match

## Answers
Option 4 : 1

## Number of Retries
1
