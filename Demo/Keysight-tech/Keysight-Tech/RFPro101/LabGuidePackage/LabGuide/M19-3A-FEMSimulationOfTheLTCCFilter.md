# Lab 3A - Module 3: FEM simulation of the LTCC-filter

**Learning Objectives:** In this module, you will complete the following tasks:

- LTCC filter design
- Generate and update layout
- Add ground layer and confine substrate
- Assign ports to ground layer
- Create RFPro view
- Change component role to layout
- Create ports
- Frequency plans setup
- FEM Simulator
- Run the analysis
- Inspect the Insertion loss

## Task 1: LTCC filter design

Open the schematic view of the cell **`a2_LTCC_Filter_Design`**.

   ![](../Image/3A-54f7fc0a-5387-4c91-85ac-86157fab13a6.png)

   ![](../Image/3A-image-14.png)

1. Push into the symbols of the **spiral**, **connect** and **cap** ![](../Image/3A-abe109aa-131a-416d-9168-e6e217bed0c1.png)

Quickly check the layout representations, from which the LTCC filter has been made of. Use the hot key “3” to get a 3D View.

   ![](../Image/3A-image-13-1.png)

   ![](../Image/3A-image-14-1.png)

   ![](../Image/3A-image-15.png)

This modular approach allows the designer to optimize each component for a specific inductance/capacitance and combine them as needed.

Close the layouts.

## Task 2: Generate and update layout

1. Back in the **`a2_LTCC_Filter_Design`** schematic

1. Use the command **Layout > Generate/Update Layout** to Sync the entire design.

   ![](../Image/3A-409aff81-320e-4343-adc9-fdda4ec83da9.png)

### Check the connections

Use the 3D View (3) to check the proper connections of all parts.

   ![](../Image/3A-image-16.png)

Press “2” to come back in the 2D View.

   ![](../Image/3A-image-17.png)

## Task 3: Add ground layer and confine substrate

1. Select **`ltcc_gnd`** as insert layer.

1. Click Insert Rectangle icon

1. Click **Insert > Coordinate Entry.** Enter the following coordinates:

   - **Lower left**: (X: -1125, Y: -1800), **Apply.**

   - **Upper right**: (X: 1750, Y: 600), **OK.**

   ![](../Image/3A-a2852d92-c37d-4e6e-89cc-a8886ac1e509.jpeg)

   ![](../Image/3A-9d686f49-fef3-481c-a47a-b40131e1d2be.jpeg)

   ![](../Image/3A-image-17-1.png)

1. Select the **`bound` (not bond!)** as insert layer

1. Draw a rectangle directly over the ground layer.

1. Use the 3D-View (3) to check the proper drawing and return with “2”.

![](../Image/3A-image-18.png)

### Set Origin

To simplify the positioning of the LTCC-filter on the board later on, we will set the origin to the lower left corner of the ground plane by the command **Edit > Modify > Set Origin**.

   ![](../Image/3A-368a7b41-e410-4b95-b092-9e7334105b1b.png)

## Task 4: Assign ports to ground layer

   ![](../Image/3A-image-21.png)

1. Open the Port Editor (Port Editor icon or **EM > Port Editor**)

1. Assign **`ltcc_gnd`** as Gnd Layer for both ports.

1. **Save** your layout.

## Task 5: Create RFPro view

   ![](../Image/3A-image-23.png)

1. Use **Tools > RFPro > New**.

1. Click OK

## Task 6: Change component role to layout

1. In the **Project** panel, under the **Components** branch, select **cap** and **connect**

1. Right-click and **Change Component Role > To Layout.**

   ![](../Image/3A-1cfa2f70-4c0f-4e3b-bc92-631794954cf5.png)

   ![](../Image/3A-image-24.png)

## Task 7: Create ports

Next, select **both Pins** and right click to **Create Ports** for **Full EM Analysis**

   ![](../Image/3A-bffd4690-4774-43ca-84cf-d7c027380b96.png)

   ![](../Image/3A-f6a925c3-e36e-47d6-a4d0-16089cf96c89.png)

### Setup a full EM analysis

   ![](../Image/3A-db5594ed-00ec-4da3-ae74-f510dc57e33d.png)

   ![](../Image/3A-3291d531-bfb4-465a-8b7a-9eb7096372bc.png)

1. Right-click on the **Ports** branch and select **All Properties** to open the Ports Editor.

1. Change the **Feed Type** for both ports to **TML**.

1. Click **Done**.

## Task 8: Frequency plans setup

1. Double-click on **Options**

   ![](../Image/3A-412d791e-de4d-418b-be29-5425b542157b.png)

1. Add the **Frequency Plans** as shown here.

   ![](../Image/3A-3d4869a4-ebb3-4945-93df-74b316aef344.png)

## Task 9: FEM Simulator

   ![](../Image/3A-d9ce9b63-d50e-47dd-a4b7-267d700a4fbe.jpeg)

1. Make sure that the **FEM** simulator has been selected, leave all default settings

1. Click **Done**.

## Task 10: Run the analysis

**Run** the analysis.

   ![](../Image/3A-de58864c-d30b-487a-bd20-c3da2baf3cdf.png)

In about 40 seconds the simulation should be finished.

&lt;![](../Image/3A-265837a6-7697-4477-8378-55f8850cdae6.png)

## Task 11: Inspect the Insertion loss

1. In the Results branch, double-click **S-Parameters**.

   ![](../Image/3A-b5a38c9a-a5ff-460c-bae7-e839c969e069.png)

### Inspect the Insertion loss at 1.8 GHz

1. Select S21 and S11 in the **Matrix Selector** panel

1. Use the **Crosshairs Tool** to inspect the insertion loss at 1.8 GHz.

The purpose of this low-pass filter is also to reduce the harmonics of the LNA.

   ![](../Image/3A-f8995e2c-a45e-4709-981c-c8b031592b67.jpeg)

### Save and close

**Save** your work and close RFPro and all open windows.

## You have successfully completed Lab 3A - Module 3.
