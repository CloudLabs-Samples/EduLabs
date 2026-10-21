# Lab 3A - Module 5: Setup of a full EM analysis in RFPro

**Learning Objectives:** In this module, you will complete the following tasks:

- Create RFPro view
- Change Component Role
- Setup a full EM analysis
- Simulation setup
- Run the analysis
- Generate test bench
- S-Parameters and Options setup
- Run the simulation
- Examine and compare result

## Task 1: Create RFPro view

Use **RF** icon or **Tools > RFPro > New**.

   ![](../Image/3A-12f52642-7ba3-482c-bd34-63d943be7040.png)

## Task 2: Change Component Role

   ![](../Image/3A-image-39.png)

1. In **Project** panel, select two **SMD parts**, right-click and **Change Component Role > To Circuit**

1. Select **a2_LTCC_Filter_Design** and **EBOND**, right-click and **Change Component Role > To Layout**

## Task 3: Setup a full EM analysis

   ![](../Image/3A-633ca459-2d50-46cc-9d3b-7d136c0bdb53.png)

1. Drag & drop **both Pins** into the **Ports** branch of the Setup Panel.

1. Drag & drop the **3 Components** with Circuit Role into the **Components Model** branch in the **Setup** panel.

   ![](../Image/3A-95eeb03a-589b-411d-a95a-ad2614a2e68a.png)

   ![](../Image/3A-fab78225-61c6-4aa7-a5ad-8afa8c3cdc08.png)

1. Right-click on the **Ports** branch and select **All Properties** to open the Ports Editor.

1. Change the **Feed Type** for both ports to **TML**.

1. Click **Done**

## Task 4: Simulation setup

1. Double click **Options**

   ![](../Image/3A-551a5be8-674b-4e9f-bf3d-f5a98343dc6c.png)

### Add the Frequency Plans

1. Add the **Frequency Plans** as shown here.

   ![](../Image/3A-bb271f03-b278-40f2-8740-e8807855e8f5.png)

Note that the simulation goes up to **9 GHz** to cover also the 5th harmonic of the fundamental frequency at **1.8 GHz** and provide so accurate data up to the highest harmonic for a Harmonic Balances simulation, which we run later on.

### FEM simulator

   ![](../Image/3A-8070174f-ab79-4a54-8204-7d16efcad658.png)

1. Make sure that the **FEM**-Simulator has been selected.

1. Pick under the **Advanced Simulation Setup** the **Generation 2** meshing algorithm

1. Define a **Refinement Frequency** at **1.8 GHz**

1. Click **Done** twice

## Task 5: Run the analysis

1. Click the **gear** icon.

   ![](../Image/3A-85d1f3a8-2112-4a87-98ff-e97c75ba28d5.png)

In about 1 minute the simulation should be finished.

   ![](../Image/3A-4e13b8bb-3c02-4abb-9700-94a5337de434.png)

## Task 6: Generate test bench

Under **Results -** **Generate Test Bench…**.

   ![](../Image/3A-7b27f2f6-84cb-463e-8029-af96a00399c9.png)

## Task 7: S-Parameters and Options setup

**Remove** the existing controller (**S-Parameter** and **Display Template**)

   ![](../Image/3A-13abde41-bbe9-4fc3-85c5-a97cb91037b1.png)

Copy from **`a1_Matched_LNA_Circuit_Sim`** schematic the **S-Parameter controller** and the **Options** into your new test bench.

   ![](../Image/3A-0f11b4a7-a0ae-4fe8-8e4b-7b1917e2505f.png)

## Task 8: Run the simulation

   ![](../Image/3A-72aad79e-a7b5-4a17-9441-321cadc54665.jpeg)

1. Go to the menu **Simulate > Simulation Settings…**

1. Set **Dataset** name = **`a3_SmartMount_LNA_LP`**

1. Check the box for opening the Data Display automatically.

1. **Apply** and **Simulate** the test bench

## Task 9: Examine and compare result

1. Add a rectangular plot ![](../Image/3A-5db1365e-6216-4fc7-81c3-cfeee8062701.png)displaying **dB(S(1,1))** and **dB(S(2,1))**

1. Add for comparison the results dB(S(1,1)) and dB(S(2,1)) from initial **`a1_Matched_LNA_Circuit_Sim`** simulation.

1. Place a Line Marker ![](../Image/3A-f661d3c3-cc80-496d-91e1-144218e26802.png) at the new matched frequency at 1.48 GHz.

   ![](../Image/3A-f52c7b1c-3a20-4fda-9157-54b6435740f4.jpeg)

> **Note:** We can observe that the board layout effects cause a **18% shift** to lower frequencies for the matched amplifier.

> **Note:** In addition. the Low-Pass Filter increases the attenuation in the stop band significantly.

### Save and close data display

Save and close the data display

## You have successfully completed Lab 3A.
