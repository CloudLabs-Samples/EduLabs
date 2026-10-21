# Lab 1B - Module 3: Transfer the layout to RFPro

**Learning Objectives:** In this module, you will complete the following tasks:

- Create an RFPro view
- Change component role to circuit
- Setup auto detect of lumped components (circuit role)
- Highlight nets and pins

This module contains the following lessons:

## Task 1: Create an RFPro view

   ![](../Image/1B-image-47.png)

1. In your layout window, go to **Tools > RFPro > New**.

1. Click **OK**

### Why doesn't show any lumped components?

The initial RFPro-layout does not show any lumped components. Why?

   ![](../Image/1B-image-41.png)

## Task 2: Change component role to circuit

   ![](../Image/1B-717fa74a-85a7-46e1-8ad7-ecf793a12c9a.png)

1. In the **Project** panel, open the **Components** branch.

1. Select both component groups (**Ctrl** key)

1. Right-click to **Change** **Component Role > To Circuit**.

1. Read and accept the message

   ![](../Image/1B-f45d6ede-ec9e-41c9-b3ec-e907601188ed.png)

## Task 3: Setup auto detect of lumped components (circuit role)

To recognize the Circuit Role for the lumped components automatically next time

1. Go to **Tools > Options > Components,** add “**sc|sl|”** as another **Circuit Role** in the list.

   ![](../Image/1B-f8f2fa6e-6657-44de-8954-e803c773a1f3.png)

1. Enter `sc_avx`, click **Test.**

   ![](../Image/1B-image-44.png)

1. Enter `sl_avx`, click **Test**

   ![](../Image/1B-image-45.png)

1. Click **OK**.

## Task 4: Highlight nets and pins

In the **Visibility** panel, click on **Wireframe** for Conductors. Make sure that all Nets are highlighted.

   ![](../Image/1B-image-45-1.png)

In the **Project** panel, select the **RF_In** and **P1 :: RF_In** to be highlighted in the layout. Use the Ctrl key to select more than one item.

   ![](../Image/1B-image-46.png)

## You have successfully completed Lab 1B - Module 3.
