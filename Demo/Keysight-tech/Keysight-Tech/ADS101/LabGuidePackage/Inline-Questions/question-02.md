## Metadata
Question Type : Single Choice

## Question
2. In Lab 4A, which value must the Harmonic Balance controller's **Freq[1]** match for the simulation to run without a frequency error?

## Options

Option 1 : The pass-band frequency (Fpass) set on the LPF Butterworth filter

Option 2 : The stop frequency of the AC simulation sweep used in Lab 3B

Option 3 : The frequency of the P_1Tone source, which is 7 GHz in this lab schematic

Option 4 : The highest harmonic you want to see in the spectrum

## Answers
Option 3 : 3

## Correct Answer Feedback
Correct! The source frequency and the HB analysis frequency must match. When they do, all tones (harmonics or inter-mods) are simulated correctly.

## Incorrect Answer Feedback
Not quite. Freq[1] must match the frequency of the P_1Tone source (7 GHz in this lab). If they differ, the simulation reports an error that the frequencies do not match.

## Number of Retries
1
