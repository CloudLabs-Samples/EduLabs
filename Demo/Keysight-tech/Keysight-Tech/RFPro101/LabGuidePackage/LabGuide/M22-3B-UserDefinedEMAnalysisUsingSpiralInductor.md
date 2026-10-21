# Lab 3B - Module 1: User-defined EM analysis using spiral inductor

**Learning Objectives:** In this module, you will complete the following tasks:

- Overview
- Open workspace
- Open the rfpro view
- Select components
- Flatten the design
- Change component role to layout
- Select the subcircuit
- Assign output pin to ground layer
- Setup an user defined EM analysis
- Frequency plans
- FEM simulator
- Run the simulation
- S-Parameters results
- Inductance parameter result

## Task 1: Overview

In this part, we will have a closer look to a single **spiral inductor** and a **bondwire** transition, to investigate the overall inductance of these two components.

## Task 2: Open workspace

1. **Open workspace**: C:\ADS_Home\RFPro101\Lab3B\RFPro_Lab3_wrk

**![](../Image/3B-b3c8c68b-9001-4833-af67-5671d74833ae.png)**

   ![](../Image/3B-42fff4f9-bfd6-4618-83f8-2d5e325b1d83.png)

## Task 3: Open the rfpro view

Open the rfpro view **`a3_SmartMount_LNA_LP`**

   ![](../Image/3B-5219c9d5-6f04-4e15-a2a0-c88f039bdbd4.png)

Set the **Visibility** to **Wireframe**.

   ![](../Image/3B-58645a58-3b3e-4644-9950-f473c3f7407d.png)

## Task 4: Select components

Select in the Components branch the **2_LTCC_Filter_Design** and **both pins** in the X3 sub-directory (Use Ctrl-key).

   ![](../Image/3B-28eab97b-9300-46b1-bab4-639fbcea9210.png)

### The entire filter is now highlighted as one part

   ![](../Image/3B-f79224e2-c1a5-4c1e-8ea6-0e300b36aaaf.jpeg)

## Task 5: Flatten the design

To get access to a single spiral inductor, we need to **change** the **Component Role** of the **LTCC_Filter** to **SubDesign** to flatten the design.

   ![](../Image/3B-23e3310a-b241-49ac-b9ea-89c40f6c775f.png)

## Task 6: Change component role to layout

| ![](../Image/3B-610069df-291e-4b2d-89d6-7f07c4db785c.png) | ![](../Image/3B-4eb0eb8c-6e42-4011-a6bc-46df28706c7c.png) |
|---|---|

1. In the **Project** panel, under the **Components** branch, select **cap** and **connect**

1. Right-click and **Change Component Role > To Layout**

## Task 7: Select the subcircuit

Now we can access the single **spiral X3.X1** with the intended output pin **P1** and the **Bondwire1** with **W1_P2** as intended input pin. Use the Ctrl-key for the selection.

   ![](../Image/3B-da8b9ebf-25c4-4835-a2a8-a4715e307691.png)

The **input pin** (Bondwire 1) is referenced to the ground layer on **`Board_Gnd`**. However, for the **output pin** (Spiral P1) we want to assign the **`ltcc_gnd`** as ground layer.

## Task 8: Assign output pin to ground layer

   ![](../Image/3B-9a06cb19-f36b-465f-b40a-9da7ab276771.png)

1. Right click **P1** of the spiral X3.X1.

1. Create **Virtual Pin at the same XY** dimension **on `ltcc_gnd`**

### It should look like this

   ![](../Image/3B-image-51.png)

## Task 9: Setup an user defined EM analysis

Now we are ready to prepare the User Defined EM Analysis.

| ![](../Image/3B-image-52.png) | ![](../Image/3B-bc6838c8-c28e-413a-9a58-325698a09bcf.png) |
|---|---|

1. Drag & drop the **X3.X1** component and the **Bondwire1** into the **Parts**-branch of the **User Defined EM Analysis**.

| ![](../Image/3B-image-53.png) | ![](../Image/3B-59a68896-40ab-461d-b485-29007817025e.png) |
|---|---|

1. Drag & drop **P1** and **P2** (Ctrl-key) into the **Ports**-branch.

### Examine ports

Select the **Ports** branch to confirm the correct placement of the **Plus** and **Minus Pins** for the bondwire and the spiral inductor.

   ![](../Image/3B-image-54.png)

> **Note:** Note also, that the needed nets are copied automatically into the **Nets**-branch.

## Task 10: Frequency plans

1. Double click **Options**

   ![](../Image/3B-image-55.png)

1. Define an **Adaptive** Frequency Plan from **0.1 GHz** to **3 GHz**. Turn on the **Near Field**.

1. Add a **Single** point at **1.8 GHz**. Turn on the **Near Field**.

   ![](../Image/3B-image-56.png)

1. Change to the **Settings** tab and **Save fields for “All Frequencies”**.

## Task 11: FEM simulator

   ![](../Image/3B-7e850ac8-f781-4c57-ab20-022bdf14001b.png)

1. Choose the **FEM** simulator.

1. Pick **Generation 2** mesher.

1. Set **Refinement Frequency** at **1.8 GHz**.

1. Click **Done** twice.

## Task 12: Run the simulation

**Run** the Simulation.

   ![](../Image/3B-6432a889-4869-4148-807d-686255426da9.png)

In less than 30 seconds the analysis should be finished.

   ![](../Image/3B-102b35ad-df26-4915-aa78-e6d5df32265f.png)

## Task 13: S-Parameters results

1. Double-click on **S-Parameters** in the **Results**-branch

   ![](../Image/3B-8fbf7b74-9ccd-490c-b229-557fb1fb5bd5.png)

1. Select in the **Matrix Selector** (on the lower right side) **S(1,1)** and **S(2,1)**.

1. Use the **Crosshairs Tool** to get the simulation values at **1.8** **GHz**.

   ![](../Image/3B-31342073-5b10-47fd-adb8-f402fbe29119.jpeg)

## Task 14: Inductance parameter result

1. Select **Inductance** parameter

1. Check in the **Matrix Selector** **L(2,1)** only, to find a value of **4.26 nH** **@ 1.8 GHz**.

   ![](../Image/3B-1b5aefc1-a627-4b17-9525-80bcb029a52f.jpeg)

## You have successfully completed Lab 3B - Module 1.
