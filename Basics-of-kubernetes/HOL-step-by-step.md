
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
  
## Summary

In this exercise, we explored on Kubectl commands which are used to interact and manage Kubernetes objects and the cluster.
  

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
1. Run the below query to expose the deployments.

   ```
   kubectl expose deployment nginx --port 80 --type=NodePort
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
   
# Exercise 3: Using a Service to Expose Your App

1. let’s list the current Services from our cluster:

   ```
   kubectl get services
   ```
1. We have a Service called kubernetes that is created by default when minikube starts the cluster. To create a new service and expose it to external traffic we’ll use the expose command with NodePort as parameter.

   ```
   ```
   
1. To find out what port was opened externally (by the NodePort option) we’ll run the describe service command:

   ```
   kubectl describe services/nginx
   ```
1. Create an environment variable called NODE_PORT that has the value of the Node port assigned:

   ```
   export NODE_PORT=$(kubectl get services/nginx -o go-template='{{(index .spec.ports 0).nodePort}}')
   echo NODE_PORT=$NODE_PORT
   ```
1. Now we can test that the app is exposed outside of the cluster using curl, the IP of the Node and the externally exposed port:

   ```
   curl $(minikube ip):$NODE_PORT
   ```
1. Get the name of the Pod and store it in the POD_NAME environment variable:

   ```
   export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
   echo Name of the Pod: $POD_NAME
   ```
1. To apply a new label we use the label command followed by the object type, object name and the new label:

   ```
   kubectl label pods $POD_NAME version=v1
   ```
1. This will apply a new label to our Pod (we pinned the application version to the Pod), and we can check it with the describe pod command:

   ```
   kubectl describe pods $POD_NAME
   ```
   
1. You can confirm that the app is still running with a curl inside the pod:

   ```
   kubectl exec -ti $POD_NAME -- curl localhost:8080
   ```
   
# Exercise 4: Scaling the App.

1. To list your deployments use the get deployments command:

   ```
   kubectl get deployments
   ```
1. To see the ReplicaSet created by the Deployment, run

   ```
   kubectl get rs
   ```
1. let’s scale the Deployment to 4 replicas. We’ll use the kubectl scale command, followed by the deployment type, name and desired number of instances:

   ```
   kubectl scale deployments/nginx --replicas=4
   ```
1. The change was applied, and we have 4 instances of the application available. Next, let’s check if the number of Pods changed:

   ```
   kubectl get pods
   ```
1. To scale down the Service to 2 replicas, run again the scale command:

   ```
   kubectl scale deployments/nginx --replicas=2
   ```
1. List the Deployments to check if the change was applied with the get deployments command:

   ```
   kubectl get deployments
   ```
1. The number of replicas decreased to 2. List the number of Pods, with get pods:

   ```
   kubectl get pods -o wide
   ```
   
# Exercise 5: Perform a rolling update on App

1. To list the running Pods, run the get pods command:

   ```
   kubectl get pods
   ```
1. To view the current image version of the app, run the describe pods command and look for the Image field:

   ```
   kubectl set image deployments/nginx nginx=jocatalin/kubernetes-bootcamp:v2
   ```
1. First, check that the app is running. To find the exposed IP and Port, run the describe service command:

   ```
   kubectl describe services/nginx
   ```
1. Notice that all Pods are running the latest version (v2).You can also confirm the update by running the rollout status command:

   ```
   kubectl rollout status deployments/nginx
   ```
1. To view the current image version of the app, run the describe pods command:

   ```
   kubectl describe pods
   ```
1. To roll back the deployment to your last working version, use the rollout undo command:

   ```
   kubectl rollout undo deployments/nginx
   ```
