# Lab 3A - Module 1: Unarchiving the workspace and examining the libraries

**Learning Objectives:** In this module, you will complete the following tasks:

- Load workspace
- Library view
- Board_lib
- LTCC_lib

## Task 1: Load workspace

   ![](../Image/3A-image-4.png)

   ![](../Image/3A-2215c9be-54dd-4329-b119-6ef4b74667d1.png)

1. Click **Open Example**

1. Navigate to **Training Examples** and then **RFPro**.

1. Open the workspace **RFPro_ Lab3_wrk.7zads**

1. Set Destination path: C:\ADS_Home

1. Click **Finish**.

## Task 2: Library view

After closing the Readme schematic, select the **Library View.** Take a look at the different libraries, which we’ll use for this lab.

   ![](../Image/3A-image-7.png)

## Task 3: Board_lib

The **Board_lib** contains cells for the **LNA**-design including the **SMD**-components.

   ![](../Image/3A-332be737-fff7-4122-9198-22934118f276.jpeg)

1. Open the substrate definition **tech.subst**, read the upcoming message, click OK.

   ![](../Image/3A-8b135f9d-b699-41a5-ba3d-1ecea737de62.png)

1. Open in the ADS Main Window > Options > Technology > **Technology Setup** > Referenced Libraries.

   ![](../Image/3A-image-2-1.png)

   ![](../Image/3A-image-3-1.png)

> **Note:** Note that just the *ads_schematic_layers* are referenced although checkmarks for the layout exist too.

Click on *Layout Units* tab to find the used units (**millimeter**) and resolution information.

Click on **Show Other Technology Tabs > Layers**

   ![](../Image/3A-f89807ab-97a4-4b79-be14-22f6a60d3559.png)

Try to arrange the Substrate and the Layers windows side by side to see which layers are used later in the simulation.

   ![](../Image/3A-image-6.png)

> **Note:** Note that a **`boardBound`**layer will be used to limit the substrate.

Close all windows.

## Task 4: LTCC_lib

The **LTCC_lib** includes the sub designs (**cap,connect and spiral**) and the final **LTCC_Filter_Design**, which we’ll mount later on the Circuit-Board.

   ![](../Image/3A-42a4314c-cc83-4e6c-b71c-3625f3b0b44e.jpeg)

1. Open up the substrate definition **tech.subst**, read the upcoming message, click OK.

   ![](../Image/3A-83cae714-a296-4c79-ba87-38d5ca634e1a.png)

1. Open in the ADS Main Window > Options > Technology > **Technology Setup** > Referenced Libraries.

   ![](../Image/3A-779fef47-2471-4daf-a07b-cb3e703d3aa9.png)

   ![](../Image/3A-image-9.png)

Click on the Layout Units tab to find the used units are in **micron**.

Scroll down in the Layers table to find that almost all layers are defined by the **ads_standard_layers** but some directly in the **LTCC_lib**. Physical Connectivity is set through Layer Bindings.

   ![](../Image/3A-image-10.png)

Close all windows.

## You have successfully completed Lab 3A - Module 1.
