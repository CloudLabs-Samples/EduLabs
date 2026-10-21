# Lab 3A - Module 4: Non-orthogonal Interconnects

**Learning Objectives:** In this module, you will complete the following tasks:

- Create layout view
- Insert PDK parts
- Highlight color
- Open trace window
- Insert traces
- Align segment
- Align component
- Delete last segment
- Delete segment
- Save layout

## Task 1: Create layout view

Create a layout view in a new cell called **`Lab3_RouteB`** in the library **`Lab3_lib`**.

   ![](../Image/3A-image-33.png)

## Task 2: Insert PDK parts

1. From Board design kit palette, insert PDK parts similar to what is shown here.

   ![](../Image/3A-08e92c6f-0f68-4114-aacd-b8bdb9f459e2.png)

## Task 3: Highlight color

1. Click “**p**” and **Color** tab, change the Highlight color to red.

1. Click OK

This color is used to indicate unconnected pins.

   ![](../Image/3A-image-33-1.png)

   ![](../Image/3A-e2f9ce43-c840-4e3e-a29f-f326d3d387d9.png)

## Task 4: Open trace window

   ![](../Image/3A-image-35.png)

1. Press “**t**” (or the **Trace** icon ![](../Image/3A-image-18-2.png))

1. Set Layer = **`cond`**

1. Set Width = **20**

1. Set End style = **Truncate**

1. Set Corner Type = **Curve**

1. Set Curve Radius = **30**

## Task 5: Insert traces

Using arbitrary-angle routing (hotkeys **“4”** is **45 degrees**, **“9”** is **90 degrees**, and **“0”** is **any angle**) to insert traces as shown.

   ![](../Image/3A-a7483858-bd60-4f98-84ec-27ec7f4527e4.png)

Using arbitrary-angle routing (hotkeys **“4”** is **45 degrees**, **“9”** is **90 degrees**, and **“0”** is **any angle**) to insert traces as shown.

   ![](../Image/3A-fdfc5f57-f712-4134-9c0c-cbbd2ad1957a.png)

## Task 6: Align segment

1. Preselect the trace, then select a vertex.

   ![](../Image/3A-image-35-1.png)

1. Type “**x**” to constrain the move along the x-axis.

1. Click the pin you want to align to.

   ![](../Image/3A-image-36-1.png)

> **Note:** You don’t usually need such alignment operations if you remember to turn 90 degree constraint back on before routing the last TWO segments.

## Task 7: Align component

Try the **Edit > Align** commands on some components.

   ![](../Image/3A-image-38.png)

## Task 8: Delete last segment

1. Click the endpoint handle

1. Move it back to the previous midpoint.

   ![](../Image/3A-0f4aadd8-9370-4536-b29f-086cb5120120.png) ![](../Image/3A-c8b21770-b4a6-4bde-acfe-79cf17b875fe.png)

## Task 9: Delete segment

You can also area select 2 vertex points at once and delete 2 segments that way.

| ![](../Image/3A-90f23fae-d6c4-438e-8340-d5bb0119a944.png) | ![](../Image/3A-fd3cc7d5-d8db-433e-9800-0eabed7a7fb4.png) |
|---|---|

## Task 10: Save layout

> **Warning:** When you add new trace segments to existing traces, they will only be correctly merged if all trace properties match *exactly* . Otherwise, you may see small gaps at corners or multiple colinear segments.

Save the layout.

## You have successfully completed Lab 3A - Module 4.
