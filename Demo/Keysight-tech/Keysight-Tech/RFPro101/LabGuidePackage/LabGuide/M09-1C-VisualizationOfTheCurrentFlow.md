# Lab 1C - Module 1: Visualization of the current flow

**Learning Objectives:** In this module, you will complete the following tasks:

- Open workspace
- Open schematic
- Run AC simulation
- Near Field setup (1)
- Examine the current flow
- Get an animated current flow
- Unload the surface current density data
- Save and close all

This module contains the following lessons:

## Task 1: Open workspace

1. **Open workspace**: C:\ADS_Home\RFPro101\Lab1C\RFPro_Lab1_wrk

**![](../Image/1C-b3c8c68b-9001-4833-af67-5671d74833ae.png)**

   ![](../Image/1C-8f536c6f-a8e9-4610-a85c-7216a273aabb.png)

## Task 2: Open schematic

In ADS Main Window (folder view), open the schematic

   ![](../Image/1C-image-67.png)

### a4_LP_Filter_RFPro_Mom_AC

Use **File > Save As** to create **`a4_LP_Filter_RFPro_Mom_AC`**

   ![](../Image/1C-a50e1315-62a1-4643-a820-bd84deeae1f2.png)

### Replace S-Parameter with an AC controller

   ![](../Image/1C-image-66.png)

1. Replace the S-Parameter controller by an AC controller

1. Set a frequency range from **0.1 GHz up to 4 GHz** in 0.1 GHz steps.

### Edit first term to P_AC

   ![](../Image/1C-image-66-1.png)

1. Edit the first Term P1 component from **Term** to **P_AC** with **0 dBm** input power

## Task 3: Run AC simulation

   ![](../Image/1C-51febcbb-e791-48d0-9933-2cbb0b90bf0a.png)

1. Under **Simulate > Simulation Settings**

1. Turn on the Dataset option **“Use cell name”**

1. **Simulate** the design.

## Task 4: Near Field setup (1)

Go back to the RFPro window.

   ![](../Image/1C-4565a45e-adba-4e24-86f0-8df569022885.png)

### Near Field setup (2)

In the **Setup** panel, under **Result** branch, double click on **Near Field**.

   ![](../Image/1C-8763449a-f0f7-4493-b99c-e72a83150fd9.png)

### Near Field Setup (3)

   ![](../Image/1C-15e243d3-5120-4eed-9380-4a4b6031f4a0.png)

1. Set Excitation type = **Circuit Simulation Dataset**

1. Click on the button with the 3 dots.

1. Navigate to the **data** folder, choose **a4_LP_Filter_RFPro_Mom_AC.ds** .

> **Important:** The **Excitation Type** option may hide at the **right-most** side of the **View Controls** tab. Scroll the horizontal scroll bar to the right to see the option.

## Task 5: Examine the current flow

   ![](../Image/1C-image-69-1.png)

   ![](../Image/1C-image-70.png)

1. Right-click on the scale bar

1. Change the limits from **0 A/m to 8 A/m**

### Examine current flow

Now you can see the current flow **@ 100 MHz** as it would be under real operating conditions including the effect of the components.

   ![](../Image/1C-image-71.png)

In setup tab, change the Frequency to **1400 MHz** (**passband**) and **4000 MHz** (**stopband**) respectively to investigate the expected current flow behavior.

   ![](../Image/1C-image-72.png)

   ![](../Image/1C-14d2273c-22e9-47eb-af63-dffddf734f60.png)

> **Important:** The current flow might vary due to the layout arrangement of a3_LP_Filter_RFPro_Mom.

Change **Frequency** back to **1400 MHz** (**pass-band**)

   ![](../Image/1C-image-74.png)

## Task 6: Get an animated current flow

   ![](../Image/1C-296ae21b-5298-48d5-95dd-5ea545811817.png)

1. Go to the **Sequence** tab

1. **Uncheck** the box "**Compute Bounds**"

1. Select the **Play** button.

## Task 7: Unload the surface current density data

   ![](../Image/1C-e0063aaa-72c6-4f9e-a899-c39c31107899.png)

1. **Pause** the animation.

1. Unload the Surface Current Density data.

## Task 8: Save and close all

Finally **save** and **close** all your open windows (**File > Close All**).

   ![](../Image/1C-6a6e1e92-0cf4-4e51-8ecb-44835cca165b.png)

## You have successfully completed Lab 1C - Module 1.
