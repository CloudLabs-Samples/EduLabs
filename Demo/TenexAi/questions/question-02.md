## MetaData
Question Type : Single Choice

## Question
Running crowdstrike_test_critical returns "is not recognized as an internal or external command", yet a Critical detection appears in the console. Why?

## Options

Option 1 : The sensor reads the command line and treats the reserved string as a test trigger, whether it runs or not

Option 2 : The command does run, in a hidden window, and the visible error refers only to console output

Option 3 : Windows forwards every failed command to the sensor, which evaluates each one of them against its detection rules

Option 4 : The detection comes from a file written to disk just before the shell reports it cannot be found

## Answers
Option 1 : 2

## Number of Retries
1
