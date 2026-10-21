# Lab 2B - Module 1: Investigating process variations of Through line

**Learning Objectives:** In this module, you will complete the following tasks:

- Open workspace
- Open RFPro
- Create Through_Line analysis
- Create Through_Line_Underetching analysis
- Create Through_Line_Underertching_Er analysis

This module contains the following lessons:

## Task 1: Open workspace

1. **Open workspace**: C:\ADS_Home\RFPro101\Lab2B\RFPro_Lab2_wrk

**![](../Image/2B-b3c8c68b-9001-4833-af67-5671d74833ae.png)**

   ![](../Image/2B-f7ee37fb-b48c-446d-869e-3657ad1c2427.png)

## Task 2: Open RFPro

   ![](../Image/2B-9fbf9dcc-2e8e-4e13-8fe3-8ff529069c2a.png)

### Change visibility for conductor

   ![](../Image/2B-image-7-1.png)

1. Change the **Visibility** for the Conductors to **Wireframe**.

## Task 3: Create Through_Line analysis

   ![](../Image/2B-6462c6b6-c7bf-442b-a9fa-0559a7495cc3.png)

1. In the Setup panel, right-click the **CPW_Ports** analysis branch and **Copy > To Duplicate**.

   ![](../Image/2B-image-41.png)

1. **Rename** the new branch to **Through_Line**.

1. **Delete** the **Ports** and **Nets**.

### Define the first CPW port

   ![](../Image/2B-image-42.png)

1. In the **Nets** branch of the **Project** panel, select the **THROUGH** net to get it highlighted in the geometry window.

1. Zoom in ![](../Image/2B-2d2d0888-a186-49b1-af71-f0297af782dd.png) to the left side where we want to define the first **CPW port**.

### Create virtual pin

   ![](../Image/2B-f00e0d4c-bc1a-4c2e-adf4-3d1a929442df.png)

1. Right-click on the **Virtual Pins** branch. Select **Create Virtual Pin**.

### Create virtual pin

   ![](../Image/2B-image-44.png)

   ![](../Image/2B-image-45.png)

1. Position the mouse pointer at the edge center of the THROUGH line.

1. Left-click to create the pin

1. Click the Done button.

### New virtual pin created

In the **Virtual Pins** branch identify the new **VPin7**

   ![](../Image/2B-a76d5a96-61ff-4c15-bdff-491f7693486f.png)

### Create virtual pins on Coplanar Power/Ground Net

Right-click the new **Vpin7** and **Create Virtual Pins on Coplanar Power/Ground Net**.

   ![](../Image/2B-2d0dd41a-c320-4aab-9b3d-c4aefbd854a8.png)

### Two new virtual pins are created

   ![](../Image/2B-image-46.png)

Two new virtual pins are created automatically.

### Repeat previous steps for second CPW port

Repeat the previous steps, by creating another **Virtual Pin** and the related **Coplanar** **Ground Net** for the **second CPW port** at the right side of the THROUGH line.

   ![](../Image/2B-image-47.png)

Note: Sometimes it helps to take a perspective geometry view instead of a top view to select the edge of the ETCH_TOP layer.

### Delete the reference pins

   ![](../Image/2B-a01ef7e4-f454-42c8-89b7-3af4c28599eb.png)

1. **Delete** the default **Reference Pins** on ETCH_BOTTOM.

### Setting up symmetric CPW ports (1)

| ![](../Image/2B-image-48.png) | ![](../Image/2B-image-49.png) |
|---|---|

1. Drag & drop **VPin7** and **VPin10** into the **Ports** branch

As before, just one reference pin will be automatically assigned to each port.

### Setting up symmetric CPW ports (2)

   ![](../Image/2B-a1a8fcf0-d549-458a-a061-a9ec3b319a09.png)

1. Drag & drop the missing reference pins **VPin9** (or **VPin8**) to port 1

1. Drag & drop **VPin12** (or **VPin11**) to port 2

### Setting up symmetric CPW ports (3)

   ![](../Image/2B-image-50.png)

   ![](../Image/2B-image-51.png)

### Setting up symmetric CPW ports (4)

   ![](../Image/2B-image-51-1.png)

Note that the needed nets THROUGH and GND have been added to the analysis too.

### Run the analysis

Double-click **Run**

   ![](../Image/2B-5e002b11-db56-4957-bfc7-d68ddf6f5bd6.png)

After about two minutes, the analysis should be finished.

   ![](../Image/2B-ac40fc9e-a6ba-435d-9baa-c57f4618112f.png)

### Show S-Parameter result

1. Double-click on **S-Parameters** in the **Results** branch

   ![](../Image/2B-2980e481-985f-4d1b-8cd8-ecbd781f3df1.png)

### Show S-Parameter result

1. Plot the through path **S(2,1)**.

1. Rescale the graph as desired. ![](../Image/2B-8f156815-bfe9-4015-974f-0ebca6c26945.png)

The insertion loss is around 0.34 dB@10 GHz.

   ![](../Image/2B-8086958e-2c8d-42c6-bd65-caee0e04f067.png)

### Show S-Parameter result

1. Add **S(1,1)**.

The return loss is higher than 22 dB over the entire frequency range.

   ![](../Image/2B-01992efa-9aa0-464c-90bb-f5ae0b09fb64.png)

## Task 4: Create Through_Line_Underetching analysis

   ![](../Image/2B-image-54.png)

1. Right-click **Through_Line** branch and **Copy > To Duplicate**.

1. Rename the new branch to **Through_Line_Underetching**

### Add process variation: etch bias

   ![](../Image/2B-bc7446a7-2f1a-437d-b4cc-3fd3fa8e0b27.jpeg)

1. Expand **Through_Line_Underetching** branch

1. Double-click **Options**

1. Select **Process Variation.**

1. Enter an **Etch Bias** of -**1.2 mil**.

1. Click **Done**

### etch bias

   ![](../Image/2B-image-56.png)

Note that a **negative value** simulates the effect of **underetching**, which grows the conductor width. The original line **width** is **16 mil** and the **gap** size is **13.1 mil**, which corresponds to an impedance of **56 Ohm**.

The Underetching grows the **width** to **18.4 mil** (16 mil + (2 x 1.2 mil)) and reduces the **gap** size to **10.7 mil** (13.1 mil – (2 x 1.2 mil)), which corresponds to **52.5 Ohm**.

### Run the analysis

Click **Run** the analysis.

   ![](../Image/2B-8a355a7f-d541-4691-b1d0-ea818b072f36.png)

![](../Image/2B-ec14a6c4-b853-4a93-95fe-f2b09d02672c.png)

### Compare results of etch bias variation

Select the last two analyses. Right-click **Show S-Parameter Result(s)**.

   ![](../Image/2B-image-57.png)

### Compare results of etch bias variation

> **Note:** As we can see the insertion loss has increased over the entire frequency band and the return loss has been degraded but is still acceptable.

   ![](../Image/2B-87c752f3-1052-40c0-9805-c095005f7c00.png)

   ![](../Image/2B-ecf3814d-8fa0-41d1-9b25-2bec6befea6d.png)

## Task 5: Create Through_Line_Underertching_Er analysis

   ![](../Image/2B-image-60.png)

1. Right click the **Through_Line_Underetching** branch and **Copy > To Duplicate**.

1. Rename the new branch to **Through_Line_Underertching_Er**.

### Add process variation: permittivity bias

1. Expand **Through_Line_Underertching_Er** branch

1. Double-click **Options**

   ![](../Image/2B-095d8392-4b9a-453c-a9ed-88dcb3798633.png)

1. Select **Process Variation.**

1. Select **Materials** tab

1. Enter a **Permittivity** **Bias** of absolute **0.05** ( ***not*** percent!).

1. Click **Done**

According to the datasheet the max tolerance for the dielectric constant is just 3.48+/- 0.05.

   ![](../Image/2B-image-61.png)

### Run the analysis

Click **Run** the analysis.

   ![](../Image/2B-139c06f4-91b7-4372-820c-95c50e6fcec2.png)

![](../Image/2B-a1e6c7f0-f926-40de-9d62-ccda145779e6.png)

### Compare results of permittivity bias

Select the last two analyses. Right-click **Show S-Parameter Result(s)**.

   ![](../Image/2B-image-63.png)

### Compare results of permittivity bias

> **Note:** The results are again almost identical, showing that the given permittivity variation has no significant impact on the performance.

   ![](../Image/2B-51ba430d-7733-42d7-acf5-d0ceeafb66d1.png)

   ![](../Image/2B-f948653c-f815-427e-bd80-8c36d36f57bf.png)

## You have successfully completed Lab 2B - Module 1.
