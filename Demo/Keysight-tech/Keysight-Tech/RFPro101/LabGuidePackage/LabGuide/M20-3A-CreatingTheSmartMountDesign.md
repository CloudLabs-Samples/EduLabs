# Lab 3A - Module 4: Creating the smart mount design

**Learning Objectives:** In this module, you will complete the following tasks:

- Overview
- Multi-technology setup
- Define Smart Mount Technology options
- Open layout
- Mount LTCC-filter on PCB
- Create a schematic view (1)
- Add bond wires
- Assign ports to ground layer

## Task 1: Overview

So far, we have simulated the LNA and the LTCC-Filter individually and have a good idea about the initial performance. In the next steps we are going to mount both parts on a printed circuit board (PCB) und run a combined EM-simulation.

We have to define the Smart Mount Technology options in the LTCC-Library first before we can mount the LTCC-filter on the PCB.

## Task 2: Multi-technology setup

1. In the ADS Main window, click **Options > Technology >** **Multi-Technology**.

   ![](../Image/3A-f935749b-ead4-4c31-8d54-7980571b8af9.png)

## Task 3: Define Smart Mount Technology options

   ![](../Image/3A-30f308ea-b0aa-4616-8340-fc5beb278684.png)

   ![](../Image/3A-ff29f18d-ce15-4da0-a6fd-43d5dc765faa.png)

1. Select **LTCC_lib**.

1. Set **Smart Mount Subtype** = **Bottom Mount**

1. **Uncheck** Automatically Map Layer and Align

1. Set **Alignment Type** = **Layer On Top**

1. Click **OK**

These settings apply to any layout located in the library. However, you can override it in any layout view individually ( *File > Customize Pcell* ).

## Task 4: Open layout

Open the prepared layout view in the cell **`a3_SmartMount_LNA_LP`**.

   ![](../Image/3A-image-30.png)

If you get a message dialog about nesting, click OK.

### a3_SmartMount_LNA_LP

This layout contains already the LNA and the lumped components for matching. The only missing part is the LTCC-filter.

   ![](../Image/3A-3d2b38f4-2e9a-4377-9e67-b44e9fc234d5.png)

## Task 5: Mount LTCC-filter on PCB

1. Drag & drop the layout **`a2_LTCC_Filter_Design`** onto the mounting plate.

   ![](../Image/3A-image-31.png)

   ![](../Image/3A-ac61b959-995b-4f74-80ba-17bc229d24fa.png)

To connect the traces (cond) with the mounted LTCC-Filter (pc4) we need to add bond wires on both sides.

## Task 6: Create a schematic view (1)

In layout view **`a3_SmartMount_LNA_LP`**, use **Window > Schematic**

   ![](../Image/3A-b357869e-65a8-40de-be7c-5fd9df998a34.png)

### Create a schematic view (2)

| ![](../Image/3A-image-33.png) | ![](../Image/3A-image-34.png) |
|---|---|

1. In the Parts search field, type “**Sha**”

1. Click **EBOND_Shape** to insert one instance.

1. Double-click the symbol.

### Create a schematic view (3)

   ![](../Image/3A-image-35.png)

1. Set **Layer1** = **`"X3:pc4:drawing"`**

> **Important:** Edit manually the L1 parameter. Note this layer is not part of the pull-down menu. Change X3 to the instance name of your LTCC filter if different.

1. Set **Layer2** = **"cond:drawing"** (Select from the drop-down list)

1. Click **OK**

1. **Save** the schematic

## Task 7: Add bond wires

Return to the layout view.

1. Click **Insert > Bondwire**

1. Click **Insert > Coordinate entry.**

1. Define the **left wire** to go from **(15.3, 0)** to **(14.7, 0)**, from top to down.

   ![](../Image/3A-cf38ba27-7727-4843-ab0e-a2ad4aedf6f5.png)

   ![](../Image/3A-dcf87322-02e9-47ea-9f4a-3ba863887cba.png)

1. For the **right wire** go from **(17.9, 0)** to **(18.5, 0)**

   ![](../Image/3A-228ca5d3-d59a-400f-b048-4a247ceac2fe.png)

   ![](../Image/3A-0439c7e8-66dc-41f7-92d4-5f2df3c9fbc4.png)

### It should look like this

   ![](../Image/3A-cc6a8ffa-db32-4d51-8a31-98aacf64db44.png)

1. Click **Cancel** on EBOND component window

1. **Save** your layout

### Check the connections

1. To check the proper connection, click “3” for the 3D View

Note: You can turn off temporarily the **silk_screen*** layers.

   ![](../Image/3A-f002ccfe-21e8-4832-8559-c96afd7d01b8.png)

   ![](../Image/3A-image-37.png)

   ![](../Image/3A-image-36.png)

Press “2” to return.

## Task 8: Assign ports to ground layer

   ![](../Image/3A-image-38.png)

1. Open the Port Editor. ![](../Image/3A-2e404bbd-c984-473a-9d94-ec4f99061336.png)

1. Verify that the **`Board_Gnd`**has been assigned to be the Gnd Layer for the board.

1. **Close** the Port Editor

1. **Save** your layout.

## You have successfully completed Lab 3A - Module 4.
