# Lab 1B - Module 1: Simulating the low-pass filter circuit design

**Learning Objectives:** In this module, you will complete the following tasks:

- Open example workspace
- Add vendor component library to workspace
- Open the supplied schematic view
- Simulate the filter design
- Add marker icons to data display
- Initial circuit performance

This module contains the following lessons:

## Task 1: Open example workspace

   ![](../Image/1B-cc1bb986-256e-49b0-b1bb-b9c673c672cc.png)

1. Click the icon **Open An Example Workspace** ![](../Image/1B-db033a59-0e43-425c-b3f0-13bbb10d28cf.png)

1. Type in the Search field **RFPro_lab**

1. **Open** the workspace: **RFPro_Lab1_wrk.7zads.**

1. Set Destination path: C:\ADS_Home\RFPro101\Lab1B

1. Click **Finish**

1. In the **Unarchive Status** message, click **OK**

   ![](../Image/1B-4429651f-d1aa-4169-b6fa-60dd09d05998.png)

## Task 2: Add vendor component library to workspace

1. At Main window, select **DesignKits > Unzip Design Kit.**

1. Navigate to : C:\Program Files\Keysight\ADS2026_Update1\oalibs\componentLib

1. Select **RF_Passive_SMT_vendor_kit.7z**. Click **Open**

1. Navigate to: C:\ADS_Home\RFPro101\Lab1B. Click **Select Folder**

1. Keep the Design Kit name

   ![](../Image/1B-image-6.png)

   ![](../Image/1B-image-2-1.png)

1. Click **OK**

1. Click **Yes** to add it

## Task 3: Open the supplied schematic view

After closing the Readme schematic, expand the **`a1_LP_Filter`** cell and then open the supplied schematic view

   ![](../Image/1B-aa6049f2-3920-430b-b6b8-f50dd9addcd6.png)

### Examine the design

This design consists of accurate vendor component models, which are already optimized for a 2 GHz low-pass filter.

   ![](../Image/1B-image-5-1.png)

## Task 4: Simulate the filter design

**Simulate** the filter-design

   ![](../Image/1B-image-6-1.png)

> **Note:** Note that there may be a loading delay.

### Data display will pop up

![](../Image/1B-63809d3b-7970-428c-a6ff-643408aca361.png)

## Task 5: Add marker icons to data display

In data display window, right-click the tool bar and select the check boxes to add **Marker** icons to your data display window.

   ![](../Image/1B-image-8.png)

## Task 6: Initial circuit performance

   ![](../Image/1B-image-7-1.png)

1. Create a rectangular plot ![](../Image/1B-f7611a60-e13a-4f8c-97ad-84a2b2c992d1.png)

1. Add the **a1_LP_Filter** data for **dB(S(1,1))** and **dB(S(2,1))**

1. Add a **Line Marker** ![](../Image/1B-1d002784-63aa-491b-8bcd-81380be27dcc.png) at the filter edge @ 2GHz.

### Save and Close

Finally Save and Close the DataDisplay and the Schematic view.

## You have successfully completed Lab 1B - Module 1.
