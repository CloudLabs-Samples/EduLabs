# Lab 3C - Module 1: Optimization controller and goals

**Learning Objectives:** In this module, you will complete the following tasks:

- Open an example workspace

- a2_match_opt

- Optim/Stat/DOE palette

- Goal setup

- Optimizer setup

## Task 1: Open an example workspace

1. Use the icon to open an example workspace

   ![](../Image/3C-c9c18c90-ee06-4af2-864c-c44326110622.png)

1. Type the string **My**

   ![](../Image/3C-70831e59-93ae-4741-bebc-d7fae84a6d8a.png)

1. Click link Open workspace: My_Sys_AMP_wrk.7zads

1. Unarchive it to C:\ADS_Home

1. Click **Finish**

## Task 2: a2_match_opt

1. Open the schematic view for cell **`a2_match_opt`**.

   ![](../Image/3C-4f7f510a-2496-4968-b8d4-9b80db1be61d.png)

1. This is the same stable amplifier with an added output match circuit formed by L3 and C3. The input match is formed by C1 and L2.

   ![](../Image/3C-73ca8cb0-9166-43ac-874e-d16c2575f723.png)

## Task 3: Optim/Stat/DOE palette

In this schematic, the optimization controller and the goals have been set up for you to save time. These components are located on the Optim/Stat/DOE palette.

1. Select Optim/Stat/DOE palette

   ![](../Image/3C-5f4cd204-bab3-42f6-911c-8c3176708bd9.png)

## Task 4: Goal setup

1. Double click **OptimGoal1**

   ![](../Image/3C-88cbe6bb-1de0-4eb5-8ea4-4fca34be6872.png)

1. The expression **dB(S11)** is evaluated during the simulation and is used for evaluating the limit lines. The analysis is set to **SP1**

1. The checkmark next to the variable **freq** adds it as columns to the limit lines, so that the goal can be specified differently over different frequency ranges (e.g., for filters). **freq min & freq max** are set to 6.5G and 7.5G. This means that this optimization goal will only be evaluated from 6.5 GHz to 7.5 GHz. **G** is equivalent to **e9**, as ADS only parses the units.

1. In the limit lines, the type has been set to &lt; (less than). This tells the optimizer that this goal must be -15 dB (max value) or less for a successful optimization.

   ![](../Image/3C-cf3601f9-fe52-433c-a790-21859163b63a.png)

1. Click **OK**.

## Task 5: Optimizer setup

   >**Note:** The **optimizer type** has been changed to Gradient because it is much more efficient for this problem than Random.

1. **MaxIter = 50** means that the optimizer will run for up to 50 iterations to achieve the goals.

   ![](../Image/3C-e8481387-2f5f-4d26-a384-3750d9e613aa.png)


1. The **Normalize goals** setting means that all goals will have equal weighting.

1. The **‘Save’ parameters** are set to ‘no’, means that those values will not be written into the dataset.

## You have successfully completed Lab 3C - Module 1.