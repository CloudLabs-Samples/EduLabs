# Lab 3A - Module 2: DC FET curve tracer template

**Learning Objectives:** In this module, you will complete the following tasks:

- Create schematic

- DemoKit_Non_Linear palette

- Build schematic

- Begin the simulation

- How a sweep within a sweep is done in ADS?

## Task 1: Create schematic

1. Click **New Schematic Window** 

   ![](../Image/3A-68e5deea-a463-42ca-9e9e-0342f7874448.png)

1. Name the new cell **`FET_curves`**

   ![](../Image/3A-70181c8c-ac8d-4acf-a989-c3a162e51e67.png)

1. Select **ads_Templates:FET_curve_tracer**

1. Click **Create Schematic**

## Task 2: DemoKit_Non_Linear palette

1. In the new schematic, select the **DemoKit_Non_Linear** palette

   ![](../Image/3A-4bb717e8-b2fa-4686-b25c-b525ce992288.png)

1. The **TechInc** (netlist DEMO KIT TECH INCLUDE) component contains the PDK technology information for the simulator.

## Task 3: Build schematic

1. Insert **DEMO_NETLIST_INCLUDE**. 

   ![](../Image/3A-image-7.png)

1. Insert **demo_fet1**. 

   ![](../Image/3A-image-8.png)

1. The FET 1 text may overlap other text, components or wires. Move the component text using the fn+F5 keyboard key.

   ![](../Image/3A-ff88834f-b5f1-45eb-b301-13954db794cb.png)

### Wire components

   ![](../Image/3A-6c3e69fd-7af1-4b95-b66b-d8a546d9ee36.png)

1. Use  Wire FET (D) drain node to I_Probe.

   ![](../Image/3A-image-9.png)

1. Wire both FET source nodes (S1 and S2) to ground.

1. Wire FET (G) gate node to V_DC

1. **Save** the schematic.

## Task 4: Begin the simulation

1. Click **Gear** icon

   ![](../Image/3A-8301a3e6-b757-482b-a440-da73f43d4820.png)

1. On the upcoming message, check **Don't show this message again**

1. Click **Run Anyway**

1. Notice the status window and the data display will pop up immediately after.

   ![](../Image/3A-de58f5d8-1088-4a2b-85b0-a61d9a89dc56.png)

## Task 5: How a sweep within a sweep is done in ADS?

1. Notice that for each value of VGS, VDS is swept from 0 to 5 volts.

   ![](../Image/3A-8df09024-106f-4028-a6cf-f2a5796038ff.png)

1. Compare the Status information to the Parameter Sweep and DC simulation in schematic

   ![](../Image/3A-image-11.png)

   >**Note:** Notice that the variables must first be declared before they are used. The initial value is not used for the sweep, so they could be 0 volts or 100 volts when declared and the swept values will over-ride them.

## You have successfully completed Lab 3A - Module 2.