# Lab 02 - Module 8: Boolean operations, subcircuits, mirror

**Learning Objectives:** In this module, you will complete the following tasks:

- Subtract objects
- Create new subcircuit cell
- Examine the subcircuit cell
- Copy using reference point
- Mirror about Y axis

This module contains the following lessons:

## Task 1: Subtract objects

Use **Edit > Boolean Logical** and subtract **All Objects** on **`bond`** from layer **`hole`** using **DIFF**.

   ![](../Image/02-1fc71cf7-af13-4e73-86e5-99503ef023c8.png)

   ![](../Image/02-image-107.png)

### Undo

> **Warning:** If you move any shapes to check the result, undo to just after the Boolean before continuing.
>
>    ![](../Image/02-f2091b4b-1dfe-4f58-b7f4-2b891ca9d27d.png)

## Task 2: Create new subcircuit cell

1. **Select > Select All On Layer** click **Clear**, select the **`bond`** layer and **OK**

   ![](../Image/02-61595854-d359-412d-b912-e7cba6405e9e.png)

1. Choose **Edit > Component > Create Hierarchy**

1. Type a name for the new subcircuit cell called **`Windows`**.

   ![](../Image/02-image-108.png)

## Task 3: Examine the subcircuit cell

1. Select one of the **`bond`** shapes

Notice that you now get a large bounding box.

   ![](../Image/02-f9553b93-3b78-46b8-95b7-fd67ad2f422c.png)

If you delete it, you see the cutouts from the Boolean.

   ![](../Image/02-fa187592-bae5-4e68-87d8-6e3c4f2840f2.png)

Ctrl+Z to undo

### Push into hierarchy

Use the **Push Into Hierarchy** icon to take a look at the new cell that was created.

   ![](../Image/02-81cc2145-6466-414a-803c-aaffdb6200c4.png)

   ![](../Image/02-73d0ce8e-6a7c-4d06-b276-c585931f3755.png)

   ![](../Image/02-image-109-1.png)

### Pop out

Then use the icon next to it to **push back out** of the cell.

   ![](../Image/02-8157b3b9-1a2d-4eef-a727-6c03812a09b9.png)

## Task 4: Copy using reference point

Select everything using “**`Ctrl` + `A`**” and **Copy Using Reference Point** to the left.

   ![](../Image/02-72b9b07d-466c-4f74-aecc-e99ce1a22789.png)

   ![](../Image/02-image-111.png)

## Task 5: Mirror about Y axis

Use the **Mirror About Y Axis** icon and experiment with different snap points around which to mirror (undo and repeat the mirror command).

   ![](../Image/02-image-112.png)

   ![](../Image/02-38473169-33b4-44f0-b41a-96ff3d0c176b.png)

   ![](../Image/02-image-113.png)

## You have successfully completed Lab 02.
