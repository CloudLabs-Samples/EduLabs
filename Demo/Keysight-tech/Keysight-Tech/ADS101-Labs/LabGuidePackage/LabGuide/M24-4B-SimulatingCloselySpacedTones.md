# Lab 4B - Module 2: Simulating closely spaced tones

**Learning Objectives:** In this module, you will complete the following tasks:

- Run the simulation
- Spectrum of V_out in dBm
- Mixing table
- tones equation
- spec_zoom equation
- Plot spec_zoom equation
- Change trace type to spectral
- Now you can clearly see the tones

## Task 1: Run the simulation

   ![](../Image/4B-84bbe3b7-ac92-43e2-a660-76c881423249.png)

1. Click on **Simulate > Simulation Settings**

1. Check the flag **Use cell name**.

1. Click **Apply**

1. Click **Simulate**.

1. Click Yes on the upcoming message

## Task 2: Spectrum of V_out in dBm

1. **Plot** the spectrum of **V_out** in **dBm**. ![](../Image/4B-ca19d80f-f9ef-4fc2-a47b-d557c500276b-1.png)

Notice that you must zoom in on the plot or change the X axis scaling to see the closely spaced tones.

   ![](../Image/4B-image-30-1.png)

Try both methods quickly because the next steps show a better technique using equations.

## Task 3: Mixing table

1. Insert a List ![](../Image/4B-image-10-1.png)of the **Mix** variable as shown here.

Notice that with two tones, you get two Mix columns and the resulting products. On this list, you can see how the index values correspond to the frequencies.

   ![](../Image/4B-c032d501-3119-4dfb-ac17-0ce6b847f18c.png)

1. Increase Significant Digits from 3 to 5 in order to show freq data more accurately.

   ![](../Image/4B-image-32.png)

   ![](../Image/4B-61287588-ec49-4402-b399-4f12dd28d3a3.png)

Next, let's create a matrix with vectors (index values) for the desired tones: 4 shown shaded in the list. These are the two fundamental tones plus the 3rd intermod products.

   ![](../Image/4B-image-31.png)

## Task 4: tones equation

   ![](../Image/4B-image-33.png)

1. On the data display, select the **Eqn** icon ![](../Image/4B-4bec70b1-9bc6-469e-b75c-42601d7d9cba.png)

1. Enter equation: tones=[{-1,2},{0,1},{1,0},{2,-1}]

1. Click **OK**

   ![](../Image/4B-image-33-1.png)

This equation creates a matrix using the square brackets. Within the brackets are curly braces with index values for the mix table.

In this case, the number 1 represents the RF tone with spacing. Zero means that no other tone is desired, and 2 represents two times the RF tone.

## Task 5: spec_zoom equation

   ![](../Image/4B-image-34.png)

1. Insert **Eqn** icon

1. Enter equation: spec_zoom=dBm(mix(Vout,tones))

1. Click **OK**

Using the mix function and the tones variable you just created the 4 tones will be selected from the list shown. The mix function would be applied to Vout voltage like mix(Vout, tones). Usually the output is required to be in dBm so the dBm() function will also be used as seen here.

## Task 6: Plot spec_zoom equation

   ![](../Image/4B-c67a97e0-efa6-41a3-9f3b-7c23d35a86d9.png)

1. Place a new rectangular plot

1. Change *Datasets and Equations* to **Equations**

1. Add **spec_zoom**.

1. Click OK

### Initially it will look like this

Initially it will look like this:

   ![](../Image/4B-image-35-1.png)

> **Note:** This data is better appreciated in spectral form but because ADS is plotting this from an equation it no longer identifies the type of data so we must change the **trace type**.

## Task 7: Change trace type to spectral

   ![](../Image/4B-image-36.png)

1. Double click on the spec_zoom trace inside the plot.

1. Go to **Trace Options > Trace Type**

1. Change the **Trace Type** to **Spectral**

## Task 8: Now you can clearly see the tones

Now you can clearly see the tones you specified.

   ![](../Image/4B-d93d6507-5051-4d43-8e61-2531186ba74b.png)

Save the Data Display and the schematic.

## You have successfully completed Lab 4B - Module 2.
