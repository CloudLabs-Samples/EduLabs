# Lab 4B - Module 2: Automatic placement of wire-connected components

**Learning Objectives:** In this module, you will complete the following tasks:

- Create new cell
- Generate and update layout
- Force to grid
- Move the components around
- Disable display net overlap zones
- Arrange components
- Assign pins to layers

## Task 1: Create new cell

   ![](../Image/4B-image-12.png)

1. Use **File > Save As** to create the cell **`b_layout_creation`**.

## Task 2: Generate and update layout

   ![](../Image/4B-916d06b8-30e4-45e4-bc0e-d657eac0fe4a.png)

1. In schematic window, execute **Layout > Generate/Update Layout**.

1. Click the button **Sync only the section starting with**

1. Choose **P2**.

1. Click on **Preferences**.

   ![](../Image/4B-6647f3b3-be70-409f-ba6c-50292f9520dc.png)

1. Set **Length in X-Direction** = **150**.

1. Set **Length in Y-Direction** = **150**.

1. Click **OK** twice

### Components have been placed in layout

   ![](../Image/4B-227617e3-033e-4a6b-a4d8-512913d63632.png)

> **Note:** Components from schematic placed automatically in the layout.

## Task 3: Force to grid

Hover the mouse over the various pin locations, you can see (bottom right absolute coordinate readout) that not all got placed on grid points.

   ![](../Image/4B-f510346c-bba5-4fa3-abd4-64578bab968f.png)

   ![](../Image/4B-e8997bf8-8346-46cd-8a14-6375e3c8cb72.png)

1. Press **Ctrl+A** (Select > Select All)

1. Execute **Edit > Modify > Force** **To Grid**

1. Choose the **Snap Grid**.

1. Click **OK**

Move the mouse over the pins and note how they are now on grid (pin 1 and the other pins where possible).

   ![](../Image/4B-920584b1-48db-4442-9b55-7c6a1a017aeb.png)

## Task 4: Move the components around

1. Move R3 on top of the transistor and L2 below it to the right.

   ![](../Image/4B-0192cb1b-d99f-4f8c-97f8-3c61c6e0857b.png)

## Task 5: Disable display net overlap zones

   ![](../Image/4B-image-20-1.png)

1. Execute **Tools > Set Connectivity Options**

1. Uncheck the option “Display net overlap zones”.

1. Click OK

## Task 6: Arrange components

1. Arrange and align the components similar to the layout shown here:

1. Move the GND symbols to the pins they belong to.

   ![](../Image/4B-c82bf5ee-f9ae-4e9c-b4b5-dfb7c3f3d9b7.png)

> **Tip:** Using “**r**”, “**m**” and “**x**” and “**y**” keys (rotate, move, constrained move). This will allow for easier orthogonal routing of the interconnect.
>
> You can use **Layout** **> Show Equivalent Component** in schematic to find the corresponding components in the layout window.

## Task 7: Assign pins to layers

   ![](../Image/4B-412ddd1a-79c3-4647-8d43-af65c07816ad.png)

1. Right-click on pin **P1** and choose Properties to change its layer to **`cond`**.

1. Assign **P2** to layer **`cond`**.

1. Assign **P3** to layer **`cond_bottom`**.

1. **Save** the layout.

### It should look like this

![](../Image/4B-af7b8fff-4b52-45b1-acfd-13b2a21d8c49.png)

## You have successfully completed Lab 4B - Module 2.
