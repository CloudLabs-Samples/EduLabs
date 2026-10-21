# Lab 1A - Module 4: Creating custom layer

**Learning Objectives:** In this module, you will complete the following tasks:

- Add new layer
- Layer drawing order
- Brighten Current Layer
- Experiment with the order
- Sort layers by library

This module contains the following lessons:

## Task 1: Add new layer

   ![](../Image/1A-image-26.png)

1. Use **Options > Technology > Layer Definitions**

1. Select **Layer Display Properties** tab

1. Click the button at the bottom **Add Layer / Display Property**

Dismiss any info dialogs after checking the flag “Don’t show this message again”.

   ![](../Image/1A-image-27.png)

1. Click **OK**

### layer_39 has been created

   ![](../Image/1A-image-28.png)

Note that library **Use_ADS_Defaults_lib** is being used.

The number the UI chooses by default is the first undefined layer number. It cannot be any number that is already defined.

### Select a color

   ![](../Image/1A-image-29.png)

1. Select a color for **`layer_39`**

## Task 2: Layer drawing order

   ![](../Image/1A-image-26-1.png)

Go to the **Display Order** tab. Notice **`layer_39`** is 1<sup>st</sup> in the list. This means that shapes on that layer are drawn first followed by the other layers potentially drawing on top of the shapes on **`layer_39`**.

Click OK to close the dialog.

In the layout window, select **`layer_39`** as the insert layer.

   ![](../Image/1A-image-27-1.png)

Draw another rectangle that partially overlaps the first one.

   ![](../Image/1A-image-28-1.png)

In Layers window, change the transparency to 0% for layers **`cond`** and **`layer_39`**. Change the **patterns** to be **solid.**

   ![](../Image/1A-image-29-1.png)

   ![](../Image/1A-image-30.png)

   ![](../Image/1A-image-31.png)

## Task 3: Brighten Current Layer

In the Layers window, select the gear icon and **turn on** the flag Brighten Current Layer.

   ![](../Image/1A-image-35.png)

   ![](../Image/1A-image-32.png)

1. Click on **`cond`** to see the effect.

   ![](../Image/1A-image-33.png)

1. Click on **`layer_39`**to see the effect.

   ![](../Image/1A-image-34.png)

> **Note:** This flag overrides the transparency settings. Turn the flag **OFF**

## Task 4: Experiment with the order

1. Using **Options > Technology > Layer Definitions**

1. Select **Display Order** tab

1. Drag **`layer_39`** below **`cond`** in the list.

1. Click **Apply**

   ![](../Image/1A-image-32-1.png)

If your layout window is not covered by the Layer Definitions dialog, you can see the changes as soon as you click Apply.

   ![](../Image/1A-image-33-1.png)

Try reversing the display order and see the changes.

   ![](../Image/1A-75c2593f-7e58-4859-b335-8ebc50bb5d1d.png)

## Task 5: Sort layers by library

Under the **Layers** tab, click on the column name **Library** so `layer_39` is on top. Most column headings can be used for sorting.

   ![](../Image/1A-9340e157-e05e-4529-916c-2d6130255b43.png)

**Close** the *Layer Definitions* dialog and layout window.

## You have successfully completed Lab 1A.
