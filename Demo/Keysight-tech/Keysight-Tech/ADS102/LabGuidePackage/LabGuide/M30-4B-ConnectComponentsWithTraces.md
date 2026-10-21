# Lab 4B - Module 3: Connect components with traces

**Learning Objectives:** In this module, you will complete the following tasks:

- Create layout
- Connect RF components with traces
- Connect bias components with traces
- Set origin
- Insert circles on overlapping points (1)

## Task 1: Create layout

   ![](../Image/4B-image-22.png)

1. Press “**F2**” or use (File > Save As)

1. Set **Cell** = **`c_connect_components`**

1. Turn on **Save the entire cell**

1. Click **OK**

## Task 2: Connect RF components with traces

   ![](../Image/4B-3650f84d-9950-405c-9e9a-bcfa068fc76c.png)

1. Press **“t”** (or **Trace** icon).

1. Set **Layer** = **`cond`**

1. Set **Width**=**20 mil**

1. Turn **off** Auto layer snap.

1. Connect all RF components on the topside using the layer **`cond`**.

   ![](../Image/4B-eeb68504-75c9-4616-bda7-7f8df661e789.png)

> **Tip:** Use “9” (Options > 90 Degree Entry) to force orthogonal routes.
>
> To close the trace, click the spacebar.
>
> The dashed flight lines between components will disappear as you make valid pin-to-pin connections.

## Task 3: Connect bias components with traces

1. Change layer to **`cond_bottom`**

   ![](../Image/4B-image-25.png)

1. Connect the bias resistors (bottom side of the board) using the layer **`cond_bottom`**.

When traces cross, you must connect the midpoints manually to get a valid connection.

   ![](../Image/4B-eba40c2f-fadf-467d-9bd0-5e043cd3bb1e.png)

> **Tip:** Create enough overlap to the top traces, so that you can later place via holes there.

### It should look like this

   ![](../Image/4B-6d492aad-9985-4d1d-9ec3-3f2d7e098607.png)

## Task 4: Set origin

Use **Edit > Modify > Set Origin** and click on **P1**.

## Task 5: Insert circles on overlapping points (1)

   ![](../Image/4B-c47858b8-de23-41ba-8afe-7ba8dc5b5b08.png)

1. Type “**p**”, select Grid/Snap tab, set the **Snap Grid Distance** to **1 mil**.

1. Click **OK**

### Insert circles on overlapping points (2)

1. Make the layer **`via`** the new insert layer.

   ![](../Image/4B-image-31.png)

1. Turn on **Edge snap**

   ![](../Image/4B-image-27-1.png)

### Insert circles on overlapping points (3)

1. Click on the **Circle** icon. ![](../Image/4B-c54f8fed-4bf9-450b-8dc7-b8bb30d487d5.png)

1. Place the cursor at the center of the traces where **`cond`** traces overlap with **`cond_bottom`** traces.

1. Click once to **define the circle center**.

1. Drag the outline **8 mils** to define the radius. or use "K" (Coordinate Entry)

| ![](../Image/4B-image-29.png) | ![](../Image/4B-image-30.png) |
|---|---|

   ![](../Image/4B-image-29-1.png)

**Save** the layout.

## You have successfully completed Lab 4B - Module 3.
