# Lab 1B - Module 2: Open the layout and substrate

**Learning Objectives:** In this module, you will complete the following tasks:

- Open the layout view
- Create new substrate
- Update substrate layer
- Update conductor layer
- Map conductor Via
- Final substrate should look like this

This module contains the following lessons:

## Task 1: Open the layout view

Back in the ADS main window, expand the cell **a3_LP_Filter_RFPro_Mom** and open the **layout** view.

   ![](../Image/1B-b2456b42-2d50-4b6d-ae13-0c15492186a6.png)

### Examine the layout

This layout contains in addition to the lumped components also the interconnects, via-holes to the ground layer and input/output pins.

![](../Image/1B-f7e06fe1-ec03-465b-ae4c-8d4933fce4ff.png)

## Task 2: Create new substrate

   ![](../Image/1B-image-16.png)

   ![](../Image/1B-image-23.png)

1. Click on the **Substrate Editor** icon, click **OK** on the upcoming message.

1. Set **File name** = **`RO4003`**

1. Keep the 25milAlumina template

1. Click **Create Substrate**

### The template substrate will be opened

   ![](../Image/1B-image-10-1.png)

## Task 3: Update substrate layer

1. Click on the **Alumina** Substrate Layer

   ![](../Image/1B-737e81e9-cbf0-4750-bc41-6f5c59db8849.png)

1. Select Material = **Roger_RO4003 (3.55)**

1. Enter a **Thickness** of **20 mil**

   ![](../Image/1B-5605a33a-b2af-4fb8-b422-a68c49959100.png)

It should look like this

   ![](../Image/1B-2f3f9e0c-198e-4190-88b9-fd9ac4a52320.png)

## Task 4: Update conductor layer

1. Click on the **cond** layer

   ![](../Image/1B-b3caf933-9218-4ba7-985b-5969f41539ff.png)

1. Substitute **Material** with **Copper**

1. Define a **1.4 mil thick** layer which is **intruded into the substrate** and located **above the interface**

   ![](../Image/1B-d6dcace7-a786-40f2-9973-dbd84b84249b.png)

It should look like this

   ![](../Image/1B-e4e16033-5043-4208-a6f5-07c587bf76a8.png)

## Task 5: Map conductor Via

1. Right-click on the blue **RO4003** substrate layer

1. Map a **Conductor Via** on layer **pcvia1 (24)**

   ![](../Image/1B-image-19.png)

   ![](../Image/1B-image-20.png)

It should look like this

   ![](../Image/1B-877e2730-f1af-4d1a-ae0e-2b7aa1bfd45e.png)

## Task 6: Final substrate should look like this

   ![](../Image/1B-image-21.png)

### Save and close

**Save** and close the substrate editor.

## You have successfully completed Lab 1B - Module 2.
