# Lab 3B - Module 4: AC and DC simulation setup

**Learning Objectives:** In this module, you will complete the following tasks:

- DC controller setup

- AC controller setup

## Task 1: DC controller setup

1. Select the **Simulation-DC** palette

   ![](../Image/3B-eba7d7f9-ea9e-41ac-bf83-323fcec160be.png)

1. Insert **DC** simulation controller 

   ![](../Image/3B-a87365d6-b38b-4989-a906-4f1c185c1307.png)

>**Note:** The DC controller requires no further setup.

## Task 2: AC controller setup

1. Select the **Simulation-AC** palette

   ![](../Image/3B-82dd5066-de94-4bae-b5a5-cc0173657c90.png)

1. Insert **AC** simulation controller 

   ![](../Image/3B-514991a0-c3d4-4f53-9de9-12f544243ca1.png)

1. Although the simulation is set-up with a sweep by default, the next step is to change the frequency to exactly 7 GHz and then run the simulation.

   ![](../Image/3B-2a977d97-6337-41f7-83a4-76f5d0784214.png)

1. Edit the AC controller (double click)

1. Go to **Frequency tab**

1. Set **Sweep type** = **Single point**

1. Set **Frequency** = **7 GHz**

1. Click **Apply**

All ADS simulation controllers have default setup values. But you usually have to specify the settings you want. Also, it is OK to combine different simulation controllers on one schematic as long as the sources and circuits are valid for all the controllers, as is the case here with the AC and DC controllers.

### **Total noise at input and output**

1. Go to the Noise Tab

   ![](../Image/3B-e02b595f-72c9-4142-b48d-cd580523feeb.png)

1. Check the **Calculate noise** box

1. Use the **Edit** field to select **Vin,** click **Add**

1. Use the **Edit** field to select **Vout**, click **Add**

1. Click **Apply**

1. This will give the total noise at the input and output.

   ![](../Image/3B-image-26-1.png)

1. Go to the Display tab, Scroll down

1. Turn **off** the Start, Stop, and Step boxes.

1. Turn **on** the Freq and CalcNoise.

1. Click **Apply**

1. If you always display the parameters you are using, you can edit them on screen. For example, Noise calculations can be easily turned ON or OFF this way.

1. It should look like this. Click OK to close the AC controller dialog when you have the correct settings.

   ![](../Image/3B-12cf7d00-b4e9-43c1-92b7-b1f9833e45d4.png)

## You have successfully completed Lab 3B - Module 4.

Now, click on **Next >>** from the lower right corner to move on to the next page.

   ![](../Image/nxt.png)