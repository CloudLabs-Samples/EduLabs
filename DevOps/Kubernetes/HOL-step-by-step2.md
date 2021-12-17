# Exercise 2: Creating an nginx deployment 

We are going to create a sample deployment of nginx using the nginx image in this exercise. Run each command and observe the output before proceeding to next steps.

1. Run the below command to get the list of nodes inside the kubernetes cluster using **kubectl get nodes** commands.

   ```
   kubectl get nodes
   ```
   ![](./media/minikube-node.png)
   
1. Execute the below query to to get the details about the node inside the cluster **minikube** and observe the node details from the output section.

   ```
   kubectl describe node minikube
   ```
   ![](./media/minikube-describe.png)
   
1. Run the below command to check the pods inside the cluster. **kubectl get pods** command is used to get all the pods inside the kubernetes.

   ```
   kubectl get pods
   ```
   After running the above command you will recieve an output message **No resources found in default namespace** as there are no pods created.

1. Execute the below command to create a deployment of nginx using the nginx image. Once the command ran successfully, you will prompted with an output message saying **deployment.apps/nginx created**
  
   ```
   kubectl create deployment nginx --image=nginx
   ```
   ![](./media/minikube-deployment.png)
   
1. Run the below query to expose the deployments inside the kubernetes. You will be prompted with an output message **service/nginx exposed** after running the command successfully.

   ```
   kubectl expose deployment nginx --port 80 --type=NodePort
   ```
   ![](./media/minikube-expose.png)
   
1. By executing the following query you can now see the state of your deployment. Make sure that the deployment is in running state before proceeding to further steps.
   
   ```
   kubectl get deployments
   ```
   ![](./media/minikube-deployment1.png)
   
1. Execute the below command to get display information about the deployment and observe the output.

   ```
   kubectl describe deployment nginx
   ```
   ![](./media/minikube-deployment.nginx.png)
   
1. Run the below command to check the pods inside the cluster. You can see that a new pod has been created and is currently running.

    ```
   kubectl get pods
   ```
   ![](./media/minikube-podstatus.png)
   
1. Execute the below command to list the Pods created by the **nginx** deployment.

   ```
   kubectl get pods -l app=nginx
   ```
   ![](./media/minikube-nginx.deploy.png)
   
1. Run the folloiwng command and observe the pod details from output. **kubectl describe pod** displays information about a pod.

   ```
   kubectl describe pod
   ```
   ![](./media/minikube-podrunning.png)
   
1. Run the **get svc** command to see a summary of the service and the ports exposed.

   ```
   kubectl get svc
   ```
   ![](./media/minikube-getsvc.png)
   
### Summary

In this exercise, we created a sample deployment and explored on checking the status of the nodes and pods inside kubernetes.
