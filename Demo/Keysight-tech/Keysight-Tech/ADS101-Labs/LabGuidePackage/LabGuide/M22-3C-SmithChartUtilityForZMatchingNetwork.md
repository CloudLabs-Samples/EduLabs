# Lab 3C - Module 4: Smith chart utility for Z matching network

**Learning Objectives:** In this module, you will complete the following tasks:

- Create schematic

- Smith chart utility

- Smith chart palette

- Place matching network component

- Smart component sync

- Enter the amplifier impedance

- Build matching network

- Create the matching circuit

- The matching circuit

## Task 1: Create schematic

   ![](../Image/3C-3e531074-87c7-4f44-889c-96914f885958.png)

1. In the Main window, click on the icon

   ![](../Image/3C-ed75cb92-55a4-4bfe-9906-93987713f206.png)

1. Name the new cell **`Z_match`**

1. Click **Create Schematic**

## Task 2: Smith chart utility

1. Click on **Tools > Smith Chart**…

   ![](../Image/3C-1785f959-23ac-46d3-a557-635811ed9859.png)

## Task 3: Smith chart palette

1. Click the **Palette** icon shown here.

   ![](../Image/3C-image-69.png)

1. This adds the Smith Chart palette with the Smith Chart icon to your schematic.

   ![](../Image/3C-image-63.png)

## Task 4: Place matching network component

1. It is necessary to insert this component in a schematic for the tool to be used.

   ![](../Image/3C-ca48a63e-2b10-4d49-8589-1df00db97a39.png)

1. Insert the **Matching Network** component.![](../Image/3C-dcfbd84f-9e85-4fbe-b8db-eb8ea6bb21ae.png)

1. Click **OK** when a message dialog appears – you can ignore it.

   ![](../Image/3C-8ec4ea60-a8f7-47df-8cc7-c565e18ac57d.png)

   ![](../Image/3C-b72fdea4-a359-4ebe-a20b-ae3557412002.png)

## Task 5: Smart component sync

1. In the Smith Chart Utility (at the top) in the Freq (GHz) field type **7**.

1. Click **Enter**

   ![](../Image/3C-image-71.png)

1. **Ignore** the upcoming error message and click OK.

1. When prompted sync the component from the Smith Chart Utility and click OK.

   ![](../Image/3C-6ec8ee29-32de-4540-8359-84703d7ce429.png)

## Task 6: Enter the amplifier impedance

1. Select the **ZL** component (in Network Schematic)

1. Type in the approximate impedance looking into the amplifier: **13-j*63**

   ![](../Image/3C-image-73.png)

1. Press **Enter**

   >**Note:** Notice that the load symbol (diamond) on the Smith chart has relocated to the lower right.

## Task 7: Build matching network

1. Select the **shunt inductor** from the Smith Chart Utility palette.

   ![](../Image/3C-image-74.png)

1. Move the cursor on the Smith chart as shown

1. Stop when you get to the 50 Ohm circle of constant resistance. **Click** to stop; it does not have to be exact.

1. Select the **series inductor** from the palette.

   ![](../Image/3C-image-64.png)

1. Move the marker along the circle to the center of the Smith chart (approximately) and **click**, as shown.

   ![](../Image/3C-image-75.png)

   ![](../Image/3C-8bc2a124-6710-47b1-b510-b3f7d6cb229a.png)

1. In the lower right in the Network Schematic pane, select either shunt or series L to see the value, see here.

   ![](../Image/3C-ae136f9e-041b-4649-8f62-9354def4f7f6.png)

   ![](../Image/3C-e475fc7e-9bee-4cfe-9820-f5961e8275bc.png)

## Task 8: Create the matching circuit

1. Click the **Build ADS Circuit** button at the bottom of the Smith Chart Utility window.

   ![](../Image/3C-image-77.png)

1. Now you have designed the matching network that was used to obtain the good results in the previous steps.

   ![](../Image/3C-f0190a9c-a945-4f93-9553-7b200d70b499.png)

1. **Close** the utility window.

## Task 9: The matching circuit

1. In the **`Z_match`** schematic push into the Smith Chart symbol to see the matching circuit.

   ![](../Image/3C-image-65.png)

   ![](../Image/3C-image-79.png)

   >**Note:** Notice the values obtain a very close to the rounded value we used in the matching circuit in the lab. Your values may be slightly different.

## You have successfully completed Lab 3C.
