# Lab 2B - Module 2: Compare simulated results with measured data

**Learning Objectives:** In this module, you will complete the following tasks:

- Generate test bench
- Insert SP controller into test bench
- Run the simulation
- Inspect measured data from the THROUGH line
- Add simulated dataset to the plot
- Compare simulated results with measured data

This module contains the following lessons:

## Task 1: Generate test bench

   ![](../Image/2B-b34b1dbc-862d-4d66-8a74-c68f343786bb.png)

1. In the **Through_Line > Results** branch, double-click on **Generate Test Bench**

1. In the schematic view that opens, **delete** the **Display Template** and the **S-Parameter** controller.

## Task 2: Insert SP controller into test bench

1. In the ADS main window, open the schematic of the cell **SP_TB_THROUGH_Meas**.

   ![](../Image/2B-image-67.png)

Note this design contains already the measured Thru-Data provided by Analog Devices.

1. **Copy/paste** the **S-Parameter** controller into the new **Test Bench**

   ![](../Image/2B-27f8b147-b52b-4419-b57b-ccafc1399b7f.png)

## Task 3: Run the simulation

   ![](../Image/2B-5d80e721-49e9-4d5b-bc01-2b8f2860de04.png)

1. Go to **Simulate > Simulation Settings**

1. Set **Dataset Name** = **Through_Line**.

1. Uncheck the *Open Data Display …* flag.

1. Click on **Simulate**.

## Task 4: Inspect measured data from the THROUGH line

In the ADS Main window, open the **SP_TB_THROUGH_Meas.dds** to inspect the measured data from the through line. Note the different scaling for the Y-axles.

   ![](../Image/2B-a23d8c9f-d99f-4109-abca-43b677060bc0.jpeg)

## Task 5: Add simulated dataset to the plot

   ![](../Image/2B-669f5079-c02f-46e5-8aa9-bc02e3a1599e.png)

1. **Double-click** the plot.

1. Choose the **Through_Line** dataset. Add **dB(S(2,1))** and **dB(S(1,1))**.

1. Double-click the **dB(Through_Line..S(2,1))** entry

1. Select **Plot Axes** tab.

1. Pick **Right Y Axis**.

1. Click OK twice.

## Task 6: Compare simulated results with measured data

   ![](../Image/2B-9a9d0db6-0da9-4ab6-b471-4e5710d33e1d.png)

> **Note:** The measurements show a higher insertion loss despite a similar return loss.

> **Note:** This extra loss could be caused by the SMA connectors, which are included into the measurement.

## You have successfully completed Lab 2B.
