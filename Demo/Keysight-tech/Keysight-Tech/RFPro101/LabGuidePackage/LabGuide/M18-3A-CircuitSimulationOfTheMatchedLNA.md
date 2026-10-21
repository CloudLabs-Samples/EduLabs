# Lab 3A - Module 2: Circuit simulation of the matched LNA

**Learning Objectives:** In this module, you will complete the following tasks:

- Matched LNA Design
- Simulate the design
- Inspect the data display results

By now you should have a good idea about the different technologies used by the libraries and we can start with the design steps.

## Task 1: Matched LNA Design

Change to **Folder View**, open the schematic of the cell **`a1_Matched_LNA_Circuit_Sim`**.

   ![](../Image/3A-image-12.png)

   ![](../Image/3A-image-13.png)

> **Note:** Notice the two inductors used as matching network.

### LNA_Sub design

1. Push into the **LNA_Sub** design.

   ![](../Image/3A-2e92593c-92b1-4d45-a574-87183b26bdf7.png)

You see that a NEC GaAS-MESFET model has been used for the LNA

   ![](../Image/3A-image-9-1.png)

   ![](../Image/3A-image-8-1.png)

### Pop out

Pop out of the LNA_Sub design.

   ![](../Image/3A-fd53d5c1-aa8f-4263-a968-2c6b6d17743f.png)

## Task 2: Simulate the design

Click the gear icon

   ![](../Image/3A-9aa69db7-6c56-4a98-b215-f6391227a875.png)

## Task 3: Inspect the data display results

   ![](../Image/3A-image-10-1.png)

> **Note:** As you can see the LNA has been matched for an operation at 1.8 GHz having a gain of about 14 dB and a Noise Figure of about 1.5 dB.

> **Note:** In addition, the StabMeas (positive) and StabFact ( > 1) prove the sufficient conditions for unconditional stability of the amplifier.

### Close all windows

Close all windows.

## You have successfully completed Lab 3A - Module 2.
