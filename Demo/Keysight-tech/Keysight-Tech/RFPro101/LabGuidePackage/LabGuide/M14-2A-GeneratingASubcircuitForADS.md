# Lab 2A - Module 4: Generating a subcircuit for ADS

**Learning Objectives:** In this module, you will complete the following tasks:

- Overview
- Generate sub circuit
- Open SP_TB_TX_Meas
- Assign subcircuit into schematic
- Run the simulation
- Examine the data display

This module contains the following lessons:

## Task 1: Overview

For further simulations in ADS, we’ll generate a subcircuit which contains the RFPro results.

## Task 2: Generate sub circuit

1. In setup panel, double-click on **Generate Sub Circuit**

   ![](../Image/2A-image-33.png)

1. Choose Create In **New cell**

1. Click **OK**

   ![](../Image/2A-image-34.png)

Have a short look at the new sub circuit before closing it.

   ![](../Image/2A-image-35.png)

## Task 3: Open SP_TB_TX_Meas

In the ADS Main window, open the schematic view of the cell **`SP_TB_TX_Meas`**which contains the measurement data of the front-end ADTR1107 IC (the transmit state).

   ![](../Image/2A-image-36.png)

   ![](../Image/2A-439670b8-0325-4c42-9bae-ceedda7ac090.png)

## Task 4: Assign subcircuit into schematic

   ![](../Image/2A-2ad2f6bc-bdd0-4157-a2fa-a342b8b5a8b6.png)

1. **Drag & drop** the generated **`a08_*_CPW_Ports`** subcircuit into the open wire connections to include the input/output lines.

1. Make sure that all components are connected properly.

## Task 5: Run the simulation

Simulate the entire design.

   ![](../Image/2A-image-38.png)

## Task 6: Examine the data display

The automatically created Data Display shows an almost flat gain of more than 20 dB over the entire frequency range for the transmit state.

   ![](../Image/2A-91dea356-ed90-4fe4-bb2f-760011186b32.png)

### Save your work

**Save** your work

## You have successfully completed Lab 2A.
