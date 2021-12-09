
## Overview

Kubernetes is an open-source system for managing containerized applications across multiple hosts in a cluster. Kubernetes provides mechanisms for application deployment, scheduling, updating, maintenance, and scaling.

The following are the core concepts of Kubernetes:
   - **Containers** - A container image is a ready-to-run software package, containing everything needed to run an application.
   - **Nodes** - A Node is a worker machine in Kubernetes and may be either a virtual or a physical machine, depending on the cluster.
   - **Pods** - A Pod is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers. 
   - **Labels** - Labels are key/value pairs that are attached to objects, such as pods.
   - **Services** - Service is an abstraction which defines a logical set of Pods and a policy by which to access them.


Kubernetes aids in ensuring that containerized applications execute where and when you want them to, as well as assisting them in locating the resources and tools they require.

# Exercise 1: Creating a Cluster using Minikube

In this Exercise, we will look at the cluster's nodes that can be used to host our applications. We will be using the Kubernetes command-line tool, kubectl, which allows to run commands against Kubernetes clusters.

1. Run the following command to start the preinstalled minikube inside lab VM.
   
   ```
   minikube start
   ```
1. Execute the following command to check the pre-installed version of **kubectl**.
   
   ```
   kubectl version
   ```
   
1. Run the below command to get the minikube cluster information. **kubectl cluster-info** command is used to display the cluster Info.
   
   ```
   kubectl cluster-info
   ```
   
1. Execute the following command to pause the kubernetes inside minikube without affecting deployed applications.
   
   ```
   minikube pause
   ```
1. Run the below command to start the kubernetes inside minikube.
    
    ```
    minikube unpause
    ```
  
1. Execute the beow command to halt the cluster.
   
   ```
   minikube stop
   ```
   Please run the minikube start command before going to further steps.
   
   ```
   minikube start
   ```
   
1. Run the below command and observe the catlog of easily installed Kubernetes services.
   
   ```
   minikube addons list
   ```
   
1. **minikube delete --all** command is used to delete all the clusters inside kubernetes. We are not using this command in the lab as we are using the cluster for further exercises.
  

# Exercise 2: Creating an nginx deployment 

1. Run the below command to get the list of nodes inside the kubernetes cluster.

   ```
   kubectl get nodes
   ```
1. Execute the below query to to get the details about the node **minikube**.

   ```
   kubectl describe node minikube
   ```
   
1. Check the pods inside the cluster.

   ```
   kubectl get pods
   ```

1. We create a deployment of NGINX using the NGINX image.
  
   ```
   kubectl create deployment nginx --image=nginx
   ```
1. You can now see the state of your deployment.
   
   ```
   kubectl get deployments
   ```
   
1. Display information about the Deployment:

   ```
   kubectl describe deployment nginx
   ```
1. List the Pods created by the deployment:

   ```
   kubectl get pods -l app=nginx
   ```
1. Display information about a Pod:

   ```
   kubectl describe pod
   ```
1. Run the following query to get the service details of kubernetes cluster.

   ```
   kubectl get svc
   ```
   


