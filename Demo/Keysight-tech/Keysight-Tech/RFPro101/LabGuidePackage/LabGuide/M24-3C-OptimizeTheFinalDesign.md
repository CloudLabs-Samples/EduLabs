# Lab 3C - Module 1: Optimize the final design

**Learning Objectives:** In this module, you will complete the following tasks:

- Open workspace
- Optimize design
- Run the simulation
- Examine and comparing result

In this exercise, we will optimize the final design and comparing the results to initial design. You will be using the optimized component values to get back the desired amplifier performance and will investigate the nonlinear behavior of our design.

## Task 1: Open workspace

1. **Open workspace**: C:\ADS_Home\RFPro101\Lab3C\RFPro_Lab3_wrk

   ![](../Image/3C-b3c8c68b-9001-4833-af67-5671d74833ae.png)

   ![](../Image/3C-03b967a3-6e6e-4e87-b857-3e3bd83a113f.png)

## Task 2: Optimize design

**Open** the schematic view of the cell:

   ![](../Image/3C-db08d388-439a-4f02-b425-ecfef7e52a29.png)

Use File > Save As… **`a4_Final_Opt_Design`**.

   ![](../Image/3C-a1b2b47a-dfd6-43d3-ac31-0bf5ac0be005.png)

Instead of adding the Optimization and Goal controller and running an optimization, we simply **change** the parameter value for the component to the best-found value.

1. Select the **SMD_L2-model** and **Push Into Hierarchy Edit**

   ![](../Image/3C-image-64.png)

   ![](../Image/3C-image-63.png)

1. Change **L2** from 22 nH to **6.8 nH** (optimized component value).

   ![](../Image/3C-9337c3eb-455d-473b-8ca5-ee8c5d3d0bf0.png)

1. Save and Pop Out ![](../Image/3C-6b5395b3-6877-4935-8cbd-04160a2ec56f.png).

## Task 3: Run the simulation

   ![](../Image/3C-image-67.png)

1. Go to **Simulate > Simulation Settings…**

1. Check “**Use cell name**” and "**Open** **Data Display**...."

1. Click Apply and **Simulate**.

## Task 4: Examine and comparing result

1. Add a rectangular plot displaying **dB(S(1,1))** , **dB(S(2,1))** and **nf(2)** (Right Y Axis).

1. Place a Line **Marker** at **1.8 GHz**

1. For comparison add also the initial **`a1_Matched_LNA_Circuit_Sim`**simulation results.

   ![](../Image/3C-ba84ecfd-e45a-44f4-9a10-e2e7d9ae888f.jpeg)

> **Note:** We can see that the initial amplifier response has been almost restored but now including the LTCC-Filter and all layout effects.

> **Note:** Also note the steep attenuation in the stop band which is needed for the harmonic suppression.

### Save and close the data display.

**Save** and close the Data Display.

## You have successfully completed Lab 3C - Module 1.
