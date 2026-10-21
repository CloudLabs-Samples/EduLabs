# Lab 01 - Module 9: Tuning parameter values

**Learning Objectives:** In this module, you will complete the following tasks:

- Start the tuner
- Enable parameter for tuning
- Tune the response
- Component parameter update
- Undo the parameter updates
- Run the simulation
- Folder view
- Library view

This step introduces the ADS tuning feature that allows you to tune parameter values and see the simulation results in the data display in real time.

## Task 1: Start the tuner

   ![](../Image/01-d60b44b0-a2da-451c-940e-a960290e29f0.png)

1. Position and resize the data display and schematic windows, so you can see them both on the screen easily.

1. Use **View All** (“**F**” hotkey) to show all contents.

1. Make the schematic window active.

1. Click the **Tuning** icon ![](../Image/01-23bc5815-2e87-48d4-aa87-62a36c77f137.png)

The status window will appear along with the Tune Parameters dialog.

## Task 2: Enable parameter for tuning

1. Click on the **C =1 pF** parameter for capacitor C1 on the schematic.

   ![](../Image/01-5bf2397f-0264-441e-b0d3-d94bac2cf47c.png)

> **Note:** When you do, the tunable parameter will appear in the Tuner and you will see the string {**t**} next to the parameter value that indicates it is enabled for tuning.

1. Add the other capacitor value

1. Add the inductor so that all three component parameters are tunable.

   ![](../Image/01-69ad5d38-c8a6-40ca-8b9c-0be31e9f3cf4.png)

## Task 3: Tune the response

   ![](../Image/01-9df0d828-ed85-4c02-a4d8-1a739f7409b6.png)

1. Shift the marker to **9 GHz**

1. Tune the response to get -3 dB @ 9 GHz

1. In Tune Parameter window, click ![](../Image/01-80ff5e2f-03a3-4fe4-9919-932cf97c6788.png)

## Task 4: Component parameter update

Those values will appear on the schematic components.

   ![](../Image/01-429d6c10-d121-4537-aecd-0c6166881738.png)

## Task 5: Undo the parameter updates

Take a few moments to experiment with the Tuner and watch the data display and schematic as you do. After experimenting with the tuner, click **Close**.

In the schematic, use **Ctrl+Z** to undo the component parameter updates.

## Task 6: Run the simulation

1. Change **C1** = **0.5 pF**

1. Simulate ![](../Image/01-40f84716-fcc2-4418-85e9-04addb659c89.png)

   ![](../Image/01-96aa0561-4f03-48fc-a58c-8d60ed393df1.png)

   ![](../Image/01-275b328f-0085-4895-9f04-bd3089456dcd.png)

## Task 7: Folder view

The Main window should appear with one cell, one schematic, and one Data Display in the Folder View. Verify this.

   ![](../Image/01-2cdc91e1-fcbf-4f63-b86e-982f420c2930.png)

## Task 8: Library view

Look at the Library View which shows all the files for the workspace, including datasets.

   ![](../Image/01-494c000d-0fad-4cb1-93c9-70db3c6e8cd5.png)

## You have successfully completed Lab 01.
