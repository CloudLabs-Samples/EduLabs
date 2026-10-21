# Lab 1B - Module 5: Perform circuit-EM cosimulation

**Learning Objectives:** In this module, you will complete the following tasks:

- Overview
- Generate test bench
- Update test bench
- Run EM-circuit cosimulation
- Open data display
- Compare with initial circuit performance

This module contains the following lessons:

## Task 1: Overview

In the next steps, we will generate and export a schematic for ADS to run an EM-Circuit cosimulation to recombine the EM-simulated results with the lumped vendor component data.

## Task 2: Generate test bench

1. In the **Results** branch, double-click **Generate Test Bench**.

   ![](../Image/1B-958a49a6-7d55-46bf-8e8c-e8bb3ca498d6.png)

Take a moment to understand all parts of this schematic.

## Task 3: Update test bench

1. **Delete** the existing **DisplayTemplate**

   ![](../Image/1B-2d30e702-1632-4997-9ace-0ae027c7965e.png)

### Linear frequency sweep setup

   ![](../Image/1B-cf8cc0b3-ba89-4912-9e68-134881877042.png)

1. Double click the **S-Parameters** controller

1. Set Sweep Type = **Linear**

1. Set **Step-size** = **10 MHz**.

### Linear frequency sweep setup

   ![](../Image/1B-ca060436-12b3-4982-ba98-ce0114574104.png)

1. Under the Display-Tab

1. Unselect the “Dec” and select “Step” instead.

1. Click **OK**

### It should look like this

   ![](../Image/1B-44eff4af-4afa-4f9c-8639-84471d456b3d.png)

### Your test bench should look like this

You can rearrange the items in your Test Bench if desired.

   ![](../Image/1B-5989ac78-b1d9-4b40-9cc0-6f6856aa450e.png)

## Task 4: Run EM-circuit cosimulation

   ![](../Image/1B-5c317732-23bf-4801-930f-78555e4e61d5.png)

1. Go to **Simulate > Simulation Settings**

1. Uncheck "Use cell name"

1. Change Dataset name to `**a3_LP_Filter_RFPro_Mom**`

1. Uncheck “Open Data Display when simulation completes”.

1. Click **Apply**.

1. Close the window.

1. Run the simulation

   ![](../Image/1B-8e33efb3-5b06-450f-9ef1-1028246bfe0a.png)

## Task 5: Open data display

In the ADS main window, open the data display **a1_LP_Filter.dds**

   ![](../Image/1B-9ff3ab49-c573-4eaa-bbd1-897178a0eb4e.png)

## Task 6: Compare with initial circuit performance

1. Add the **a3_LP_Filter_RFPro_Mom** data for **dB(S(1,1))** and **dB(S(2,1))**.

As you can see the low-pass filter response has been shifted down about 17% due to the included layout effects.

   ![](../Image/1B-78edb899-a97c-4667-a1b4-16673c8c55ec.png)

## You have successfully completed Lab 1B.
