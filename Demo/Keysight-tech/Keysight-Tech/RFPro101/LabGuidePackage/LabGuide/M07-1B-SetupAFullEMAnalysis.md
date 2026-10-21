# Lab 1B - Module 4: Setup a full EM analysis

**Learning Objectives:** In this module, you will complete the following tasks:

- Assign components
- Assign ports
- It should look like this
- Create frequency plan
- Simulator setup
- Run the simulation
- Investigate the created mesh cells
- S-Parameters result

This module contains the following lessons:

## Task 1: Assign components

   ![](../Image/1B-image-48.png)

1. In the **Project** panel, open **Components** branch.

1. Select both groups of components (use Ctrl key)

1. Drag & drop the components into the **Component Models** branch (under **Full EM Analysis)**.

## Task 2: Assign ports

   ![](../Image/1B-image-49.png)

1. In the **Project** panel, open the **Pins** branch.

1. Select **P1::RF_In** and **P2::RF_Out**.

1. Drag & drop the pins into the **Ports** branch (under **Full EM Analysis).**

## Task 3: It should look like this

The Full EM Analysis Setup should now look like this one.

   ![](../Image/1B-6fca144f-728f-4fa4-9863-af1ee5eba47c.png)

## Task 4: Create frequency plan

1. In the Setup panel, double-click on **Options**.

   ![](../Image/1B-9ed30ede-0c6c-4616-a76f-8aee40b5eb90.png)

### Create Simulated Adaptive frequency plan

   ![](../Image/1B-image-51.png)

1. Set **Start** = **0.1 GHz**

1. Set **Stop** = **4 GHz**

1. Turn on **Near Field**

   ![](../Image/1B-image-52.png)

1. Go to Settings tab

1. **Save fields** for **All Frequencies.**

## Task 5: Simulator setup

   ![](../Image/1B-b60e4f9a-ddce-447a-8c0e-eefdfdcb7343.png)

1. Click on the **Simulator** tab.

1. Choose **Momentum RF** and leave all other settings.

1. Click **Done**.

## Task 6: Run the simulation

1. Double-click the gear icon

   ![](../Image/1B-image-54.png)

In the upcoming message, check the “**Always Save Modified Project**” box and click **Yes**.

After a couple of seconds, the analysis should be finished.

   ![](../Image/1B-0193d87a-7710-4177-8385-ce21028e237a.png)

## Task 7: Investigate the created mesh cells

1. Open the **Results** branch and double-click on **Mesh/Ports**.

   ![](../Image/1B-image-56.png)

1. You can turn on **View Faces** and add the **Ports** information.

   ![](../Image/1B-4789bed5-50fb-4125-abce-8d3dac0909d2.png)

   ![](../Image/1B-881dde00-67e5-4079-9c3e-793628807a9e.png)

### Unload Mesh/Ports information

1. Click the **Unload** button

   ![](../Image/1B-150f9606-6c65-4779-8fdb-435b694b4022.png)

   ![](../Image/1B-22eefd1c-c880-4889-b962-c43a4c651401.png)

## Task 8: S-Parameters result

1. Under **Results** branch, double-click on **S-Parameters.**

   ![](../Image/1B-image-58.png)

This gives us access to a 12-port dataset. This is because we have 2 ports for input and output but also 5 components, with 2-ports each.

   ![](../Image/1B-4f58ff2b-44e8-4112-a23d-fd921cfa9512.png)

## You have successfully completed Lab 1B - Module 4.
