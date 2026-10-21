# Lab 3A - Module 5: Use of avoidance routing

**Learning Objectives:** In this module, you will complete the following tasks:

- Rearrange components
- Define a clearance rule for avoidance routing
- Open trace window
- Turn off Avoid obstacles when routing
- Turn on Avoid obstacles when routing
- Connect the 2nd component pin

## Task 1: Rearrange components

   ![](../Image/3A-3c4b3996-f0d2-42c8-af4c-7c66c342e0f3.png)

## Task 2: Define a clearance rule for avoidance routing

   ![](../Image/3A-9ae4c9d9-ce4f-4b9f-93b5-9156b2080dc2.png)

1. Use **Options > Technology > Constraints Manager** command

1. Select **Library** = **`Lab3_lib`**

1. Click **Add Rule**, then select **Clearance Rule**

1. Define a simple rule to avoid objects by **20** layout units.

1. Click **OK**.

## Task 3: Open trace window

1. Press “**t**” (or the **Trace** icon ![](../Image/3A-image-18-3.png)).

1. Change insertion layer to **`bond`**

   ![](../Image/3A-image-37.png)

> **Note:** Avoidance routing currently only works for traces that are on the same layer as the connected pin.

## Task 4: Turn off Avoid obstacles when routing

1. Make sure **Avoid obstacles when routing** is turned **off**

   ![](../Image/3A-ccccab54-8936-4595-8966-b10033ad5724.png)

1. Route a trace from one component pin to another crossing some other component along the way.

   ![](../Image/3A-image-43.png)

> **Note:** The trace will cut right through the part that is in the way.

## Task 5: Turn on Avoid obstacles when routing

1. **Turn on** the flag **Avoid obstacles when routing**.

1. Make sure insertion layer is **`bond`**

   ![](../Image/3A-9769fd7d-cf92-4ba4-908f-7a7691a8ff5f.png)

1. Route the same trace and notice how it automatically avoids the component along the way.

   ![](../Image/3A-image-45.png)

> **Note:** Notice that the trace refuses to connect to the pin of the 2<sup>nd</sup> component.

## Task 6: Connect the 2nd component pin

You can either type “**H**” as you route or **turn off** the flag **Avoid obstacles when routing**.

   ![](../Image/3A-image-46.png)

Then finish the last segment to connect to the 2<sup>nd</sup> component pin.

   ![](../Image/3A-image-47.png)

   ![](../Image/3A-ff343237-d2ce-4a26-96cd-a28eb5f2ac1b.png)

## You have successfully completed Lab 3A.
