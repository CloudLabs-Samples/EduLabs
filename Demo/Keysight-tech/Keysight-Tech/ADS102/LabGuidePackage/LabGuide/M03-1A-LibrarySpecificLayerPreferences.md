# Lab 1A - Module 3: Library specific layer preferences

**Learning Objectives:** In this module, you will complete the following tasks:

- Create layout
- Open layers window
- Draw rectangle
- Origin crosshair
- Grid display
- Coordinate readout
- Layer display properties
- *layerprf
- Reset all layers to default

This module contains the following lessons:

## Task 1: Create layout

   ![](../Image/1A-7d2dae48-fc71-463d-b62c-76601e24dec4.png)

1. Using the ![](../Image/1A-image-10.png) icon or **Window > New Layout**

1. Set Cell = **`cell_defaults`**

1. Click **Create Layout**

## Task 2: Open layers window

Execute **Options > Layer Preferences.** This opens a docking window.

   ![](../Image/1A-66843c6c-c51b-42eb-94c8-02b6f4ce980d.png)

The command **View > Docking Windows** shows all that are available.

   ![](../Image/1A-image-11.png)

### Layers window

Docking windows can be detached from the main layout window by double-clicking on the top border. Dragging the top border on top of another docking window (color turns bluish) stacks them one behind the other.

   ![](../Image/1A-image-11-1.png)

### Layers window

They can then be selected by tabs at the bottom.

   ![](../Image/1A-image-12.png)

## Task 3: Draw rectangle

1. Click the **Insert Rectangle** icon on default insert layer **`cond`**. Tap the **ESC** key

   ![](../Image/1A-image-13-1.png)

   ![](../Image/1A-image-14.png)

1. **Press** and **hold** the right mouse button in the layout window and move the mouse to **pan** the view.

   ![](../Image/1A-image-15.png)

1. With a wheel mouse, **move the cursor to a point around which you want to zoom** and scroll in and out.

## Task 4: Origin crosshair

Toggle the Origin Crosshair off/on with **Shift+O**.

   ![](../Image/1A-image-15-1.png)

## Task 5: Grid display

Toggle the **major grid display** off/on with **Shift+G.**

   ![](../Image/1A-image-16.png)

Toggle the **minor grid display** off/on with **Ctrl+G.**

   ![](../Image/1A-image-17.png)

## Task 6: Coordinate readout

Click the lower left vertex.

   ![](../Image/1A-image-16-1.png)

Check the coordinate readout at the bottom right of the window and compare with the values in the Properties window.

   ![](../Image/1A-image-17-1.png)

   ![](../Image/1A-image-18.png)

1. **Move** the mouse cursor to upper right vertex

   ![](../Image/1A-aaea8ce9-bedb-4a95-8e63-2edf6ea7a702.png)

1. Check the absolute and relative readouts

   ![](../Image/1A-1d09a49a-8259-4e40-8916-ed347c0d1011.png)

## Task 7: Layer display properties

Double-click on the fill field for the layer **`cond`**.

   ![](../Image/1A-image-20.png)

Lower the transparency to make it more opaque.

   ![](../Image/1A-image-21.png)

### Change the color and pattern

Change the **color** and **pattern** and notice the effect on the rectangle.

   ![](../Image/1A-5b617c12-b460-486c-b7e5-860cbf353a26.png)

## Task 8: *layerprf

The layer properties you set using the *Layer Preferences* window are stored dynamically in a file with syntax **&lt;libName>.layerprf** inside the workspace folder C:\ADS_Home\Layout_Lab1_wrk. Here it is called *ads_standard_layers.layerprf* .

   ![](../Image/1A-image-22.png)

Every layout that you create in this workspace and whose library references the ADS library *ads_standard_layers* will use these custom properties.

If you want to use them in another workspace, you would need to copy the *layerprf file into it.

## Task 9: Reset all layers to default

In the **Layers** palette, select the gear icon. Click on **Reset All Layers to Default.** Click **Yes** to continue.

   ![](../Image/1A-image-23.png)

   ![](../Image/1A-image-25.png)

> **Note:** This deletes the * ***layerprf*** file in the file system.

## You have successfully completed Lab 1A - Module 3.
