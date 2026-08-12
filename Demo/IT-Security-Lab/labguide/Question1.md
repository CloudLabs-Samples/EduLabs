## Metadata
Question Type : Single Choice

## Question
1. In Lab 2 you found the file `/opt/labdata/scanner` with the permission string `-rwsr-xr-x` and removed the `s` bit. Why was that specific bit dangerous on a copy of GNU `find`?

## Options
Option 1: It made the file readable by every account on the server, exposing its contents
Option 2: It caused the binary to execute with the privileges of its owner (root) regardless of who launched it, and `find -exec` could then spawn a root shell
Option 3: It marked the file as a system binary, so `apt` would overwrite it during the next upgrade
Option 4: It prevented any user other than root from deleting the file, so it could not be cleaned up

## Answers
Option 2 : 1

## Tags
Linux
Permissions
Privilege Escalation

## Number of Retries
1
