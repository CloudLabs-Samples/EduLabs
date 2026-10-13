# Lab 3B - Module 7: Variable equation and parameter sweep for simulation

**Learning Objectives:** In this module, you will complete the following tasks:

- Deactivate the DC simulation controller
- Use variable equation
- Parameter sweep setup
- Run the simulation
- Notice the changes

## Task 1: Deactivate the DC simulation controller

1. Click DC simulation controller

1. Click ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-39.png)

![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-40.png)

This is something that you can also do with components if you want them available but not used for a specific simulation.

## Task 2: Use variable equation

1. Insert a VAR ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-41-1.png) into schematic

1. Change the name (left side of the equation) to: **L_val**.

Use your cursor directly on-screen or edit (double-click) the VAR

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/abdc0721-b16c-4c5c-bd51-b8f9b7008f6c.png)

### Push into subcircuit

1. Push into the **AMP_7GHz** amplifier subcircuit ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-41.png)

![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/c2c6720b-844f-42f6-859d-f95cd67bbdf6.png)

1. Change the drain inductor L2 from 1.5 nH to **L_val nH**.

![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/2e46f118-3588-4518-984d-5797286f9036.png)

>**Note:** Now, the inductor initial value comes from the variable and has a value of 1.0 nH. It is important to keep the units as nH. Otherwise, the value would be in Henrys, which are the default units for inductance.

### Pop out

1. Pop out to the top level schematic. ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-42.png)

## Task 3: Parameter sweep setup

To sweep a variable for AC analysis, you need a Parameter Sweep component, available in any simulation palette.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-46.png)

1. Choose **Simulation-AC** palette

1. Insert a **ParamSweep** component.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/b9608f6f-ffb9-42e2-be7c-38dc8bb534ed.png)

1. Double click the **Parameter Sweep** component.

1. Go to **Sweep tab**

1. Set **Parameter to sweep** = **L_val**

1. Set **Start** = **1.5,** **Stop** = **4.5,** **Step** = **1.5** increments

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/f5e481d1-418c-4898-b363-80c56a118fa6.png)

1. Go to the **Simulations tab**

1. Set **Simulation 1** = **AC1** (AC controller name)

1. Click **OK**.

### It should look like this

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/8c1b3505-8283-4fed-a3ff-736a5dac45fe.png)

>**Note:** Notice that the quotes are automatically applied. The parameter sweep is now ready. If you typed in the names on screen, you would have to type quotes.

## Task 4: Run the simulation

1. Click **F7** or the icon ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-45.png).

## Task 5: Notice the changes

Your list now shows the swept values. Select the lists and stretch the corner to make them wider.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-50.png)

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-51.png)

## You have successfully completed Lab 3B.

Now, click on **Next >>** from the lower right corner to move on to **Lab 4A**.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/nxt.png)
