# Lab 3B - Module 3: Connecting GND to capacitor

**Learning Objectives:** In this module, you will complete the following tasks:

- Insert a capacitor
- Insert a trace segment
- Create ground plane with clearance
- Connecting GND to capacitor
- Validate net names
- A thermal relief has been created
- Thermal clearance

## Task 1: Insert a capacitor

1. Insert a capacitor ![](../Image/3B-adca2e1f-8647-4726-81d3-dea03d526f95.png)from the Board Design Kit palette

1. Set the **PadLayer** to **`cond`**.

   ![](../Image/3B-image-68-1.png)

1. Place it somewhere next to the trace endpoint and connect the right component pin to the trace pin.

   ![](../Image/3B-cc76a53f-cc99-4a31-8e56-6d74c2ea229e.png)

## Task 2: Insert a trace segment

   ![](../Image/3B-e1d48c79-a4b8-4e32-8120-cec9c5d734e1.png)

1. Use ![](../Image/3B-bf8a5c65-e612-44c7-ad46-c5db14efc494.png)insert a trace segment on **`cond`** attached to the left pin of the capacitor, left-click

1. Press **"."** twice to change to layer **`M3`**

1. Press the **spacebar** to finish.

## Task 3: Create ground plane with clearance

Use **Insert > Plane** command to define a ground plane with a **clearance** of **30** (mil) around the network.

   ![](../Image/3B-dde8a8e2-2947-4015-a8a9-c32ccfe684f3.png)

### Draw rectangle

Note that all shapes on **`M3`** are being cleared.

   ![](../Image/3B-620a7d98-dbd0-4807-8947-41a25a9cce3f.png)

## Task 4: Connecting GND to capacitor

To ground the left side of the capacitor, one has to name the net “**gnd!**” (the exclamation mark defines a forced net).

   ![](../Image/3B-image-73.png)

   ![](../Image/3B-c82adb04-e71d-4c04-adc5-e43c143afc5c.png)

1. Click the Ground icon

1. Snap to the pin on the left via.

1. Click ![](../Image/3B-image-75.png)

## Task 5: Validate net names

Select the trace and the capacitor and note in the **Info** or **Properties** window that the net names are now **gnd!** for the trace/vias and for the left pin of the capacitor.

   ![](../Image/3B-e32beec6-2d0d-40ae-b096-c1c55586cf5b.png)

   ![](../Image/3B-image-77.png)

1. Double-click on the plane

1. Make sure that Ground (gnd!) has been assigned as Net

1. Click OK.

   ![](../Image/3B-f0ec66bc-f8c7-4fa9-85c9-b7bd57b35b42.png)

## Task 6: A thermal relief has been created

1. Click the “3” key (View > 3D View)

   ![](../Image/3B-image-79.png)

Now, the **`M3`** shape of Via **`M2_M3`** is no longer cleared because the net names of both plane and trace network are **gnd!** and this connection is respected in the clearance algorithm.

> **Note:** A thermal relief has been created instead.

## Task 7: Thermal clearance

   ![](../Image/3B-db99d7e6-0eab-4403-b40d-cb88cdaf2124.png)

   ![](../Image/3B-1e92540e-b732-4345-b283-c9df683f95cd.png)

1. Execute **Options > Technology > Padstack Definitions...**

1. Double-click **MyVia**.

1. Set **Thermal Clearance** = **0 mil**.

1. Click OK

1. Close the first dialog.

1. Double-click the plane object

1. Click OK

   ![](../Image/3B-image-82.png)

> **Note:** Note that there is no longer any thermal relief.

## You have successfully completed Lab 3B.
