# Getting started with Data Science on Jupyter Notebook

## Exercises Included

In this hands-on lab you will perform the following tasks:

- **Exercise 1: Instruction with the Lab environment**
- **Exercise 2: Log in to JupyterLab Portal**
- **Exercise 3: Execute Jupyter Notebooks with Python**

# Overview

## Automatic Differentiation with TORCH.AUTOGRAD

When training neural networks, the most frequently used algorithm is **back propagation**. In this algorithm, parameters (model weights) are adjusted according to the gradient of the loss function concerning the given parameter. To compute those gradients, PyTorch has a built-in differentiation engine called torch.autograd. It supports the automatic computation of gradients for any computational graph. We apply a function to tensors to construct a computational graph that is an object of class Function. This object knows how to compute the function in the forward direction, and also how to compute its derivative during the backward propagation step. A reference to the backward propagation function is stored in the grad_fn property of a tensor. You can find more information on Function [in the documentation.](https://pytorch.org/docs/stable/autograd.html#function)

### JupyterLab
JupyterLab is a next-generation web-based user interface for Project Jupyter. It is the latest web-based interactive development environment for notebooks, code, and data. Its flexible interface allows users to configure and arrange workflows in data science, scientific computing, computational journalism, and machine learning. A modular design invites extensions to expand and enrich functionality.

### Jupyter Notebook
The Jupyter Notebook is an open-source web application that allows you to create and share documents that contain live code, equations, visualizations, and narrative text. Its uses include data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more.

## Task 1: Getting started with the environment

In the following task, you will view the pre-deployed resources provided in the environment.

1. In this lab environment, you will be able to access the Ubuntu VM which has several popular tools for data exploration, analysis, modeling & development pre-installed.

1. Refer to the **Environment Details** tab for any other lab credentials/details.

1. Click on **Next** from the bottom right corner and follow the instructions to perform the lab 
