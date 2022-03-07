# Getting started with Data Science Lab Environment


## Overview

In this lab environment, you will access the **Ubuntu VM** which has several popular tools for Data Exploration, Analysis, Modeling & Development Pre-Installed.

### JupyterLab
JupyterLab is a next-generation web-based user interface for Project Jupyter.It is the latest web-based interactive development environment for notebooks, code, and data. Its flexible interface allows users to configure and arrange workflows in data science, scientific computing, computational journalism, and machine learning. A modular design invites extensions to expand and enrich functionality.

### Jupyter Notebook
The Jupyter Notebook is an open-source web application that allows you to create and share documents that contain live code, equations, visualizations, and narrative text. Its uses include data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more.

After completing this, you will learn how to:

- Log in to JupyterLab Portal
- Execute Notebooks

## Instructions

### Getting started with the Lab environment

1. Once the environment is provisioned, an SSH session to the Linux virtual machine and lab guide will get loaded in your browser tab. 
   
   ![](../images/vmandguidelinux.png)

2. To get the lab environment details, you can select the **Environment Details** tab. Additionally, the credentials will also be sent to your email address provided during registration.

   ![](../images/envdetailslinux.png)
   
3. You can also open the Lab Guide on a separate full window by selecting the **Split Window** button on the bottom right corner.

   ![](../images/splitwindowlinux.png)

4. You can **start(1)** or **stop(2)** the Virtual Machine from the **Resources** tab.

   ![](../images/resourcestablinux.png)
   
   
## Task 1: Log in to JupyterLab Portal

1. Let us start by logging into the JupyterLab Portal to check the resources deployed for the lab environment. Copy and paste the link below into a new tab in your browser.

   <inject key="Jupyter Lab Environment" enableCopy="true" />

1. On the page, you will see the warning Your connection isn't private, you can proceed by clicking on **Advanced** and then proceed to the URL mentioned.

   ![](../images/url.png)

1. On the page that loads up, enter the following username, password and click on **Sign in**. 

   * Username: <inject key="Jupyter Lab Username"></inject>

   * Password: <inject key="Jupyter Lab Password"></inject>

   ![](../images/signin.png)

1. First-time users will be prompted **Server not running**, click on **Launch Server** and wait for 1-2 minutes for the server to start up.

1. Once the Jupyter Lab loads up, you will see the File System on the left and Launcher on the right. There are a lot of samples loaded up for the various technologies.

   ![](../images/jupyterlab-browserlinux.png)

## Task 2: Execute Notebooks

Here, When training neural networks, the most frequently used algorithm is back propagation. In this algorithm, parameters (model weights) are adjusted according to the gradient of the loss function with respect to the given parameter.To compute those gradients, PyTorch has a built-in differentiation engine called torch.autograd. It supports automatic computation of gradient for any computational graph. 

1. In the Jupyter lab, in the left pane, select to **Pytorch** folder and double-click on it to open.

   ![](../images/pytorch.png)

1. Inside the Pytorch folder, select the **Beginner** folder and double-click on it to open and select the **Basics** folder inside it.

   ![](../images/beginnerfolder.png)
   
   ![](../images/basicfolder.png)

1. In the **Basics** folder, Select **autograd_tutorial.html** file and double-click to open it on the right side of the Jupyter lab portal. <br>In this file you will learn about:

   - Torch.Autograd
   - Tensors, Functions and Computational graph
   - Computing Gradients
   - Disabling Gradient Tracking
   - More on Computational Graphs
   - Optional Reading: Tensor Gradients and Jacobian Products

   ![](../images/auto.png)
   
1. Execute each cell one at a time by clicking on it and selecting the execute button.

   ![](../images/execute.png)
   
   **Note** : You can run the notebook document step-by-step (one cell a time) by pressing crtl + enter for running the particular cell or shift + enter to run the current cell.


## Summary

In this exercise, you signed in to the JupyterLab Portal, explored the JupyterLab Portal, We have understood some of the details and in-depth mechanisms of Jupyter Notebooks. We can conclude that these Notebooks are absolutely amazing in performing tasks related to visualizations, cleansing of data, and any projects related to data science or Python in general.
