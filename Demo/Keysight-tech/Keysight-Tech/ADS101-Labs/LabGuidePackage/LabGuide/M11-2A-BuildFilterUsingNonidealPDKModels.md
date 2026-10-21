# Lab 2A - Module 2: Build filter using nonideal PDK models

**Learning Objectives:** In this module, you will complete the following tasks:

- Create schematic
- DemoKit_Non_Linear palette
- Build filter

## Task 1: Create schematic

   ![](../Image/2A-3f39cdcd-2618-4b45-a515-e9797cc5fbb7.png)

1. Add a **New Schematic** ![](../Image/2A-image-5.png)

1. Name the cell **`LPF_design_PDK`**

1. Click **Create Schematic**

## Task 2: DemoKit_Non_Linear palette

Notice that the **DemoKit_Non_Linear** palette is available.

   ![](../Image/2A-e12a56f2-74b6-4edf-9996-815a516c16d4.png)

## Task 3: Build filter

1. Insert **TechInc** component ![](../Image/2A-48aaac2e-f306-4cea-9543-6859e7bc24b6.png)

> **Note:** Please note that the Choose Technology for library will pop up when inserting the TechInc component of DK the first time. Click Finish to confirm the usage of the DemoKit technology.

   ![](../Image/2A-ffaee1f3-f9d3-4055-b10f-6f08b98e8a7c.png)

> **Note:** The **TechInc** (netlist DEMO KIT TECH INCLUDE) component contains the PDK technology information for the simulator.

   ![](../Image/2A-4884d0e0-101a-4956-8a3d-aeea2eb8297a.png)

   ![](../Image/2A-6ac8aece-14cb-407a-9971-42aa901db6b8.png)

1. Insert Demo_Cap **C1, C2** component.

1. Set **C1 = 0.5 pF,** **C2 = 0.5 pF**

1. Insert Demo_Ind **L1** component

1. Set **L1 nturns = 2.5**

> **Note:** The value of L1 is computed from a callback based on the number of turns (multiples of ¼ turn are allowed) one defines.

1. Insert **Term** component

   ![](../Image/2A-image-8.png)

1. Insert wires and ground as shown.

### Insert S-parameter

   ![](../Image/2A-5076c831-b6dc-49a7-becd-c2a73303e3e3.png)

1. Select **Simulation-S_Params** palette

1. Insert **S_Param** controller ![](../Image/2A-8a22720f-8015-4104-a806-03c832f4323c.png)

1. Change the simulation step size **S_Param Step = 0.5 GHz**.

### It should look like this

   ![](../Image/2A-2e289936-1576-43ae-b4bb-ed28fe734e83.png)

## You have successfully completed Lab 2A - Module 2.
