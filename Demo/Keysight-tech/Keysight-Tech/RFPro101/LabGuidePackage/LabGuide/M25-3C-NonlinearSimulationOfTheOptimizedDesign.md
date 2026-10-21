# Lab 3C - Module 2: Nonlinear simulation of the optimized design

**Learning Objectives:** In this module, you will complete the following tasks:

- Non linear simulation setup
- Simulate the design
- Examine result

You will be using the optimized component values to get back the desired amplifier performance and will investigate the nonlinear behavior of our design.

## Task 1: Non linear simulation setup

Back in the schematic **`a4_Final_Opt_Design`** use *File > Save As…* **`a5_Final_Design_HB`**.

   ![](../Image/3C-5d0c0038-5be4-42aa-86f4-9346500f21a0.png)

1. **Delete** the **S-Parameter** controller and the Input Termination **P1**

   ![](../Image/3C-image-71.png)

   ![](../Image/3C-image-69.png) ![](../Image/3C-image-70.png)

1. Pick from the **Parts** window the **Harmonic Balance** controller and the **P_1Tone** source.

1. **Change** the **Freq**-parameters to **1.8 GHz**

1. **Change** the **Power** to **-30 dBm**.

## Task 2: Simulate the design

**Simulate** the design

   ![](../Image/3C-image-65.png)

## Task 3: Examine result

1. Create a rectangular plot to display the **Spectrum in dBm** for the amplifier output **(P2)**.

   ![](../Image/3C-0d27381d-f80a-4513-9bbd-2cc6fd7477ef.png)

1. **Rescale** the **Y-Axis** as shown here

1. Place **Markers** ![](../Image/3C-a561bc82-c470-4aae-8206-17f518ba8037.png) on the spectral frequencies.

As you can see the 2<sup>nd</sup> and 3<sup>rd</sup> harmonics are very well suppressed.

   ![](../Image/3C-382870f7-52fb-4613-b3e0-155e688bb10d.jpeg)

## You have successfully completed Lab 3C.
