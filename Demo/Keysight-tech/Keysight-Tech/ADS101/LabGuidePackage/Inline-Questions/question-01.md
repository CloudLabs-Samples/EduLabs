## Metadata
Question Type : Single Choice

## Question
1. In Lab 3B, you changed the drain inductor L2 to `L_val nH`. Why must the `nH` unit be kept after the variable name?

## Options

Option 1 : Because the ParamSweep component only sweeps variables that carry an explicit unit suffix

Option 2 : Without it, ADS reads the value in Henrys, the default unit for inductance

Option 3 : Because the VAR component rejects unitless values and the simulation fails with an error

Option 4 : So the swept inductor values are shown in nH on the data display list

## Answers
Option 2 : 2

## Correct Answer Feedback
Correct! Henrys are the default unit for inductance in ADS, so without `nH` a value of 1.0 would mean 1 Henry instead of 1 nH.

## Incorrect Answer Feedback
Not quite. The unit must be kept because ADS uses Henrys as the default unit for inductance. Without `nH`, the value would be read in Henrys.

## Number of Retries
1
