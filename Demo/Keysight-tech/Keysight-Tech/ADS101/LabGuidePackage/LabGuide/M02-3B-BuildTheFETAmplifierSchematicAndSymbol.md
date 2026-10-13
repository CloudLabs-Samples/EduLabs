# Lab 3B - Module 2: Build the FET amplifier schematic and symbol

**Learning Objectives:** In this module, you will complete the following tasks:

- Build amplifier schematic
- Create amplifier symbol

## Task 1: Build amplifier schematic

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/544f6340-42fe-4cd8-a610-6c646ef34c3c.png)

1. In the Main window, click on the ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/dd5155cd-86ca-4ec8-9470-e7901675d49d.png) icon

1. Name the new cell **AMP_7GHz**

1. Click **Create Schematic**

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/4e96af77-4090-46a8-be17-bb4427e5e726.png)

1. Insert **DEMO_NETLIST_INCLUDE**![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-16.png)

1. Insert **demo_fet1**![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-17.png)

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/a98b8c01-d4eb-41af-a73a-1eba989dae8f.png)

1. Change to **Lumped Components** palette

1. Insert **L1, L2** components ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-18.png).

    - Set **L1** = **12 nH**

    - Set **L2** = **1.5 nH**

1. Insert **C1, C2** components ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-19.png).

    - Set **C1** = **10 pF**

    - Set **C2** = **10 pF**

1. Insert pins (P1, P2)![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-21.png) on the input and output

1. Move component text using “**F5**” and clicking the symbols.

### It should look like this

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-15-1.png)

1. Change to **Sources-Freq Domain** palette

1. Insert **SRC1, SRC2**![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-20.png)

    - Set **SRC1** = -**0.5 V**

    - Set **SRC2** = **3.0 V**

1. Insert grounds ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-22.png) as needed.

1. Insert wires ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-23.png) as needed.

1. **Save** the design.

Because ADS supports hierarchical designs, a schematic created as a sub-circuit can be placed inside another schematic. The pins were added to establish connectivity for the sub-circuit schematic.

## Task 2: Create amplifier symbol

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-16-1.png)

1. Select **Window > Symbol**

1. Click Create Symbol

### Symbol generator

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/image-24.png)

1. Go to the Copy/Modify tab

1. Find **System-Amps & Mixers** (type “**sy**” in the pull-down widget).

1. Select the **Amp** symbol

1. Click **OK**.

### ADS cell AMP_7GHz is now setup

ADS cell `AMP_7GHz` is now setup to be used in another schematic as a subcircuit.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Keysight-tech/Keysight-Tech/ADS101-3B/LabGuidePackage/Image/a802f72f-e927-447d-a185-b74407709f64.png)

### Save and close

1. **Save** and **close** the **symbol** window.

## You have successfully completed Lab 3B - Module 2.

Now, click on **Next >>** from the lower right corner to move on to the next page.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/nxt.png)
