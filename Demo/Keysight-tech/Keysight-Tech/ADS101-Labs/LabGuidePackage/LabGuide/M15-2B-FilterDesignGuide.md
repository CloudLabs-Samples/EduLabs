# Lab 2B - Module 1: Filter design guide

**Learning Objectives:** In this module, you will complete the following tasks:

- Load workspace
- Create a new cell
- Filter DG window
- SmartComponent Overview
- Filter DG - All palette
- Place a smart component
- Select the smart component
- Design smart component
- Frequency setup and simulate
- Examine the data display
- Conclusion

## Task 1: Load workspace

   ![](../Image/2B-image-3.png)

1. Click **Open Workspace**

1. Select C:\ADS_Home\ADS101\Lab02\My_LPF_wrk

## Task 2: Create a new cell

   ![](../Image/2B-68f45b97-0cc5-4b1c-adeb-8db85dc844b9.png)

1. Use the Main window schematic icon ![](../Image/2B-499310c4-b4c4-4392-9e14-c84ba2aec9b7.png)

1. Set Cell = **`DGuide_LPF`**

1. Click **Create Schematic**

## Task 3: Filter DG window

   ![](../Image/2B-16d09518-f5c9-4ea7-9359-8aa7c15031c3.png)

   ![](../Image/2B-5b802de0-132f-40d5-8bba-dea3450d680d.png)

1. Select pull-down command **DesignGuide > Filter**

1. Select the **Filter Control Window**

1. Click **OK**.

## Task 4: SmartComponent Overview

When the Filter DesignGuide control window appears, look at the instructions in the Overview tab. These are the steps that this lab exercise will take you through.

   ![](../Image/2B-ac0fdd46-f77f-42df-8780-41e917a4a6df.png)

## Task 5: Filter DG - All palette

1. Select the Component Palette button.

   ![](../Image/2B-image-20.png)

Filter DG - All palette will appear in the schematic.

   ![](../Image/2B-image-21.png)

Minimize the Filter DesignGuide window.

## Task 6: Place a smart component

Next, you will select one of the filter types from the palette and insert it into the schematic.

   ![](../Image/2B-1c2f5327-4368-475e-8826-ff7cb14b89c7.png)

1. Select the **Low_Pass** icon ![](../Image/2B-26bcbaef-5754-4ec5-b663-459d5824e294.png)

1. Clicking **OK** to the prompt.

1. Insert it into the schematic

> **Note:** This tells the design guide which template to use. In this case, a LC low pass filter.

1. End the insert command from your cursor.

   ![](../Image/2B-9f8f5377-cd61-4ed2-8068-5757d39c1827.png)

### Smart component

You will see the **DA_LCLowpassDT1** component which is commonly called a Smart Component.

   ![](../Image/2B-1641f121-46bb-42c0-8314-76934988a59e.png)

## Task 7: Select the smart component

1. Return to the Filter DesignGuide window.

1. Select the **DA_LCLowpassDT1** component you just inserted.

   ![](../Image/2B-38b791aa-14c7-4cbc-af02-df43fe5df9dd.png)

Notice the component in schematic will be highlighted.

   ![](../Image/2B-e5519808-cad8-432a-bc77-c5dda56f984a.png)

## Task 8: Design smart component

   ![](../Image/2B-e4308b7b-50f3-46c1-9dbb-95dee03ea4f1.png)

1. Click the **Filter Assistant** tab

1. Change the **Fp** (Passband corner frequency) to **7.5 GHz.**

> **Tip:** The Fs (stopband frequency edge) should change automatically – if not, click in the **Fs** field and it should adjust.

### Build filter

   ![](../Image/2B-image-25.png)

1. Click **Design** button

> **Note:** The filter will be built with the parameters.

### The filter design

**Push into the hierarchy** of the smart component to see the filter design.

   ![](../Image/2B-07cda574-e571-4e5e-ae7e-45325b2ce3fe.png)

   ![](../Image/2B-image-24.png)

   ![](../Image/2B-c6104005-fb63-4a9b-b688-9b3adb6615aa.png)

### Pop out

Pop out, back to the upper level hierarchy

   ![](../Image/2B-image-26.png)

### New cell created

Look at the Main window, you will see the new cell created with the lower level schematic and symbol.

   ![](../Image/2B-image-27.png)

## Task 9: Frequency setup and simulate

   ![](../Image/2B-5dd872ad-1432-40cd-a078-0392f0d7d5d7.png)

1. Click the Simulation Assistant tab

1. Set **Start = 0**

1. Set **Stop = 10 GHz**

1. Set **Step = 100 MHz**

1. Click the **Simulate** button.

## Task 10: Examine the data display

Look for the data display plotted by the design guide after it runs the simulation. Examine it

   ![](../Image/2B-a4adfe34-04e0-4fb3-800e-4a85f0e58ca8.png)

Then close the data display and close the Filter DesignGuide window.

## Task 11: Conclusion

Now, you should have a good idea how to use the filter design guide.

## You have successfully completed Lab 2B.
