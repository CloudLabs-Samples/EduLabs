# Module 2: Harmonic Balance 1-Tone simulation

**Learning Objectives:** In this module, you will complete the following tasks:

- Add HB controller
- Set the HB frequency
- Run the simulation

## Task 1: Add HB controller

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Keysight-Tech/ADS101-4A/LabGuidePackage/Image/image-8.png)

1. Select Simulation-HB palette (Harmonic Balance)

1. Insert the **HB controller**.

## Task 2: Set the HB frequency

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Keysight-Tech/ADS101-4A/LabGuidePackage/Image/image-4-1.png)

1. Set **Freq[1] = 7 GHz**

>**Important:** This setting is important for HB: the source frequency and simulation analysis frequencies must match. If not, the simulation will run and report an error indicating the frequencies do not match. If they do match, all the tones (harmonics or inter-mods) will be correctly simulated.

## Task 3: Run the simulation

**Run the simulation.**

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Keysight-Tech/ADS101-4A/LabGuidePackage/Image/ea1bd7ae-9cf7-477c-bdf9-caa146ba5b35.png)

>**Note:** Notice in the status window that the filter order is given as a warning. This can be ignored because the filter is behavioural. In general, ADS simulator **warnings** are easily understood or fixed.

>**Warning:** But if there is an **Error**, then it will not run and you will see the Error message.

## You have successfully completed Module 2.

Now, click on **Next >>** from the lower right corner to move on to the next page.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/next1.png)
