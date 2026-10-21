# Lab 3B - Module 2: Multilayer Routing using Automatic Via Stitching

**Learning Objectives:** In this module, you will complete the following tasks:

- Create library
- PCB layout technology setup
- Open tech.subst
- VIA definition
- Create layout
- Open trace window
- Drawing multilayer traces
- Create stackable via
- Update corner type
- Convert trace into individual pieces

## Task 1: Create library

   ![](../Image/3B-8d1396d4-3c50-48b4-8ab3-246545ef2016.png)

1. Use **File > New > Library** command

1. Set Name = **`Lab3_Via_lib`**

1. Select “Set up layout technology immediately after creating the library ”

1. Click **Create Library**.

## Task 2: PCB layout technology setup

   ![](../Image/3B-a4d5826a-0c6a-4bc0-8f12-5718799d14fe.png)

1. Choose **Create PCB Technology.**

1. Click **Next**.

   ![](../Image/3B-cad7fb5a-38d4-45a3-b5f0-dbd25d4b88f2.png)

1. Choose units of **mil** and resolution of **1000.**

1. Click **Next**.

   ![](../Image/3B-2af8f14d-47a1-4e78-8c9e-36b05f264ad6.png)

1. Keep the default materials.

1. Click **Next**.

   ![](../Image/3B-5f07789b-0f4b-477e-b3af-aaa4762554b8.png)

1. Set **Via template name** = **MyVia**

1. Select **Make EM-style stackable drills.**

1. Click **Finish**

## Task 3: Open tech.subst

In Library View tab, open the newly created tech.subst

   ![](../Image/3B-56db1b43-8bd8-45cc-a8c2-699ae3f2de1a.png)

## Task 4: VIA definition

Investigate the layers that were created and mapped as strip conductors and via holes.

   ![](../Image/3B-image-54-1.png)

> **Note:** The via definitions determine how vias are drawn. If multiple vias are defined through layers, the routing tool will draw the shortest possible via between two traces on different layers.
>
> 1. Close window

## Task 5: Create layout

Create a **New Layout** called **`Lab3_Via_Stitching`** in the library **`Lab3_Via_lib`**.

   ![](../Image/3B-510c8927-bfe9-451d-8403-3cab74eec125.png)

## Task 6: Open trace window

   ![](../Image/3B-image-56.png)

1. Press **“t”** or ![](../Image/3B-abcf11e3-a42e-4dc0-b522-fd54b1b37fb8.png)

1. Set Layer = **`cond`**

1. Set Width =**30**

1. Set End style = **Truncate**

1. Set Corner type =**Mitered**

## Task 7: Drawing multilayer traces

   ![](../Image/3B-image-62.png)

1. Starting at Origin(0,0), begin drawing a 240 length trace

1. Press **hotkey “.” (period)** to **scroll down** to layers **`M2`** and **`M3`**.

1. Press **hotkey “,” (comma)** to **scroll up** twice back to layer **`cond`**.

   ![](../Image/3B-image-63.png)

1. On **`cond`**, insert a segment of trace (**left-click**).

> **Note:** Notice how the trace segment layer changes dynamically.

1. Press **“.”** to change to layer **`M2`**.

1. Move some distance below the 2<sup>nd</sup> point of the **`cond`** trace.

1. Press the **spacebar** to finish the route.

1. Close trace window

### via has been created

Select the trace, and use the Info docking window to validate :

   ![](../Image/3B-de052501-c433-4100-94c6-38c2111571ce.png)

> **Note:** A trace segment is drawn on **`M2`** and an instance of the via **`cond_M2`** is automatically inserted.

   ![](../Image/3B-c77eee26-7b07-44ee-b799-a830eb3538fe.png)

1. Press “**t**” (or the **Trace** icon ![](../Image/3B-image-18-4.png))

1. Add a new trace segment on **`M2`** starting at the bottom endpoint going to the right, left-click.

1. Press **“.”** to change to layer **`M3`**. Add a segment of trace, left-click.

1. Press **spacebar**.

1. Close the trace window.

### Examine the segment

> **Note:** Notice how the segments are automatically merged with the right corner type when you finish the route (as long as you don’t change the trace properties).

   ![](../Image/3B-a4de3dde-79c0-414f-bc41-cec60b2c7b1f.png)

   ![](../Image/3B-444892b2-996c-4fff-bcf2-54dc8869e6a9.png)

### 3D View

Click the “3” key (View > 3D View). Click the flag for Don't show this message again to he dialog and then OK.

   ![](../Image/3B-image-60.png)

## Task 8: Create stackable via

Double-click the trace. Edit the **`M3`** segment to **`cond2`**. Edit **`M2`** segment to **`M3`**. Click **OK**.

   ![](../Image/3B-83321ef5-79fd-4e1e-aab2-a11b066ed40c.png)

Then click away from the via to unselect it.

   ![](../Image/3B-386ce208-0f16-43c7-b73e-4fee3bdfba31.png)

> **Note:** Note that a stackable via is created using both vias - **`cond_M2`** and **`M2_M3`** from **`cond`** to **`M3`**

## Task 9: Update corner type

Double-click the trace. Change the 2<sup>nd</sup> segment **Corner type** to **Square**. Click **OK**.

   ![](../Image/3B-722897ec-3727-431f-a358-137630098942.png)

   ![](../Image/3B-289ca374-18d9-44a6-ad55-c6cd10a0dd48.png)

Press the “2” key to return to 2D View

   ![](../Image/3B-941ad71e-0004-4703-afa6-9b662888b24d.png)

## Task 10: Convert trace into individual pieces

Right-click on the trace, Use **Break Trace At Vias** to convert the trace into individual pieces.

   ![](../Image/3B-d67aeffd-d974-49e7-919b-fcc8bbbb5187.png)

Play around with the pieces using **Ctrl+left-click** and drag to break the connections.

   ![](../Image/3B-image-69.png)

**Undo** (Ctrl+Z) to get back the trace object.

## You have successfully completed Lab 3B - Module 2.
