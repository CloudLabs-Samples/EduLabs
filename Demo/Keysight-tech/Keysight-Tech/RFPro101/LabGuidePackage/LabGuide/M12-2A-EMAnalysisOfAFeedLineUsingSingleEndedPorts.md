# Lab 2A - Module 2: EM analysis of a feed line using single-ended ports

**Learning Objectives:** In this module, you will complete the following tasks:

- Launch RFPro
- Change visibility for conductors
- Identify nets
- Setting up THROUGH net as signal
- Create virtual pins
- Create SE_Ports analysis
- Define an Adaptive Frequency Plan
- Simulator setup
- Run the simulation
- S-Parameter result

This module contains the following lessons:

## Task 1: Launch RFPro

1. Use **Tools > RFPro > New**

   ![](../Image/2A-image-6-1.png)

## Task 2: Change visibility for conductors

   ![](../Image/2A-image-7-1.png)

1. Change the **Visibility** for the Conductors to **Wireframe**.

## Task 3: Identify nets

   ![](../Image/2A-image-8.png)

1. In the **Project** panel, open the layout branch, then **Nets.**

1. Click on **RX_OUT** and **TX_IN** to identify the signal nets (yellow).

1. Select other nets like **Power** (red) or **Ground** (black).

1. There are also nets that have not been assigned to a signal/ground/power role and are labeled as **Undefined** (turquoise).

## Task 4: Setting up THROUGH net as signal

Right-click on the **THROUGH** net and **Set as Signal**.

   ![](../Image/2A-721a1426-84a7-4ee7-82ac-ea25bb89e364.jpeg)

### It should look like this

   ![](../Image/2A-image-10.png)

## Task 5: Create virtual pins

1. Open the **Pins** branch.

You’ll find the predefined 8 pins from the layout.

   ![](../Image/2A-1d120f3f-2f49-4987-9529-f636ad21e421.png)

There are also an empty **Virtual Pins** branch.

A **Reference Pins** branch assigned to the **ETCH_BOTTOM** ground layer (see Port Editor definitions made in the layout).

For the **User Defined EM Analysis**, we’ll add our own Virtual Pins instead of using the Reference Pins.

   ![](../Image/2A-504e2eec-eb8c-4780-b8ab-ab98680ee58c.png)

1. Select the pins **P1** and **P2** (Ctrl-key).

1. Right-click and create **Virtual Pins at the same XY** on the **ETCH_BOTTOM** layer.

### Rename VPin

   ![](../Image/2A-image-12.png)

1. Rename (F2) the first virtual pin to **VPin1**

## Task 6: Create SE_Ports analysis

   ![](../Image/2A-image-17.png)

1. In the **Setup** panel, **delete** the branch Full EM Analysis.

1. Rename the User Defined EM Analysis to **SE_Ports**.

### Assign ports

   ![](../Image/2A-image-13.png)

1. Drag & drop the two virtual pins that you just created into the **Ports** branch

### It should look like this

   ![](../Image/2A-image-14.png)

Note that the associated signal pins and nets are automatically added to the analysis.

### Update ports properties

   ![](../Image/2A-d33cddad-1079-4fd9-bd1a-4327b564b04e.jpeg)

1. Right-click on **Ports > All Properties**

   ![](../Image/2A-5ee261d2-728d-4559-b8f5-7a12739ea2a7.png)

1. Change the **Feed Type** for **P1** to **TML**.

1. Click **Done**.

## Task 7: Define an Adaptive Frequency Plan

1. Double-click on **Options.**

   ![](../Image/2A-cbfbf9c9-1197-45cd-ace6-c422cd431d2f.png)

   ![](../Image/2A-2b70cf93-f78a-41cc-b014-cadbfd1a1f33.jpeg)

1. Set transmit frequency range from **6 GHz to 14 GHz**

## Task 8: Simulator setup

   ![](../Image/2A-ac241485-7a5b-4f0f-8c86-bb7eb1fd6410.png)

1. Go to Simulator tab

1. Choose **Simulator =** **FEM**

1. Pick the **Generation 2** mesh generator

1. **Turn on** the **Mesh Domain Optimization**.

1. Click **Done** twice.

## Task 9: Run the simulation

Double-click on **Run** to start the analysis.

   ![](../Image/2A-image-19.png)

After about one minute the simulation should be finished.

   ![](../Image/2A-425679eb-2b15-430c-b736-650cfeabbae0.png)

## Task 10: S-Parameter result

1. Double-click **S-Parameters** in the **Results** branch.

   ![](../Image/2A-be93b431-0897-43b9-a61d-1e0de2206bda.png)

1. In the **Matrix Selector** window, select first **S(2,1)** only.

   ![](../Image/2A-e309a8f0-2b16-43e4-865e-d036c83dca52.png)

1. Add **S(1,1)**

   ![](../Image/2A-6e9f9e44-d97d-43d6-815f-9634574da218.png)

> **Note:** The results show a good matched feed line with an average insertion loss of 0.2 dB and return loss higher than 16 dB.

### Close the results

Close the results and simulation windows.

## You have successfully completed Lab 2A - Module 2.
