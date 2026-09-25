# Troubleshooting Azure VM Connectivity and Managed Identity Access

### Estimated Duration: 90 Minutes

## Overview

In this hands-on lab you act as the **cloud operations engineer** on call for Contoso Retail. Last night's change window broke two things on the Orders platform: the Orders API on the application server can no longer be reached from the operations jump host, and the nightly job that uploads the orders report to Azure Blob Storage has stopped working.

Nothing has been deleted. Every fault is a small, realistic misconfiguration, which is typical of real incidents. You will work through the problem one layer at a time: **routing, network security groups, the guest operating system, managed identity, the storage firewall, and Azure RBAC**. Each lab gives you complete step-by-step instructions with the exact commands to run and the output to expect, so you can confirm every fix as you go. A short knowledge check at the end confirms that you understood why each fix worked.

## Getting started with your lab

Welcome to your Azure VM troubleshooting hands-on lab. This environment gives you a live Ubuntu 22.04 LTS **jump host** that you connect to over SSH. From there you sign in to Azure as the lab **service principal** and use the Azure CLI to investigate and repair a broken application server, its virtual network, and a storage account. You can also follow along in the **Azure portal**, where the same settings are visible on each resource's blade.

## Accessing Your Environment

Your virtual machine and this **Guide** are available within your web browser.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/guide1.png)

## Environment Details

1. Connect to the **Lab VM** (the jump host) over SSH using the values on the **Environment** tab.

    - **SSH command:** see the **LabVM SSH Command** output on the **Environment** tab
    - **Username:** see the **LabVM Admin Username** output on the **Environment** tab
    - **Password:** see the **LabVM Admin Password** output on the **Environment** tab

1. The environment contains two virtual machines in the same virtual network:

    | VM | Role | Private IP | Reachable from |
    |----|------|------------|----------------|
    | **labvm-<inject key="DeploymentID" enableCopy="false"/>** | Jump host. You work here. | 10.0.1.10 | The internet, over SSH |
    | **appvm-<inject key="DeploymentID" enableCopy="false"/>** | Application server running the Orders API | 10.0.2.10 | Only the jump host subnet (once you have fixed it) |

    >**Note:** Both VMs use the same admin username and password. You will SSH from the jump host to the application server in Lab 1.

1. Every resource name used in this guide is already exported as a shell variable when you log in, from **`/opt/lab/lab-env.sh`**. Run the following command to see them.

    ```bash
    env | grep -E '^(RG|APP_|ROUTE_|VNET_|STORAGE_)' | sort
    ```

1. The incident brief describing what broke, and the change log for the window, is waiting at **`~/LabFiles/scenario-brief.txt`**. Read it before you begin.

    ```bash
    cat ~/LabFiles/scenario-brief.txt
    ```

1. Your Deployment ID for this run is **<inject key="DeploymentID" enableCopy="false"/>**. Quote it if you contact support.

## Signing in to Azure as the service principal

The jump host has no Azure identity of its own. Instead, you sign in to the Azure CLI as the lab **service principal**, a non-interactive application identity whose credentials are stored in `/opt/lab/lab-env.sh`. Its values are also on the **Environment** tab:

| Setting | Value |
|---|---|
| Application (client) ID | <inject key="ApplicationID" enableCopy="true"/> |
| Tenant ID | <inject key="TenantID" enableCopy="true"/> |
| Subscription ID | <inject key="SubscriptionID" enableCopy="true"/> |
| Resource group | <inject key="Resource Group Name" enableCopy="true"/> |

You will run the sign-in command at the start of Lab 1. It uses the variables already in your shell, so you never have to paste the secret:

```bash
az login --service-principal -u "$AZ_CLIENT_ID" -p "$AZ_CLIENT_SECRET" --tenant "$AZ_TENANT_ID" --output none
az account set --subscription "$AZ_SUBSCRIPTION_ID"
```

>**Note:** `/opt/lab/lab-env.sh` is mode `600`, so only your account can read it. Treat a service principal secret like a password: source it from a protected file or a secret store and never type it into a script or a command history.

## Using the Azure portal

Some steps include an optional **Azure portal** checkpoint that shows the same setting in the portal. To use them, open **https://portal.azure.com** in the lab browser and sign in with the **Azure Username** and **Azure Password** on the **Environment** tab. Every portal checkpoint is read-only. You make all the changes from the CLI.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/portal-signin.png)

## Exploring Your Resources

To get a better understanding of your resources and credentials, navigate to the **Environment** tab.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/env.png)

## Utilizing the Split Window Feature

For convenience, you can open the guide in a separate window by selecting the **Split Window** button from the top right corner.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/split.png)

## Managing Your Virtual Machine

Feel free to **Start, Restart,** or **Stop** your virtual machine as needed from the **Resources** tab. Your experience is in your hands!

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/resources.png)

## Guide Zoom In/Zoom Out

To adjust the zoom level for the environment page, click the **A↕: 100%** icon located next to the timer in the environment.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/zoom.png)

## Validation

Use the **Validate** button on each task to check your work. After completing the task, hit the **Validate** button under the Validation tab integrated within your guide. If you receive a success message, you can proceed to the next task; if not, carefully read the error message and retry the step, following the instructions in the guide.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/val.png)

## Track Your Progress

The **Progress** tab shows your validation score, it reaches 100% when all task validations pass.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/progress.png)

## Lab Structure

| Lab | Topic | Duration |
|-----|-------|----------|
| Lab 1 | Troubleshoot Azure VM Connectivity: effective routes, NSG rule priority, guest OS listener | 25 Minutes |
| Lab 2 | Restore VM Access to Azure Storage Using Managed Identity: IMDS, storage firewall, data-plane RBAC | 25 Minutes |
| Lab 3 | Knowledge Check: 10 questions | 10 Minutes |

>**Note:** Lab 2 depends on Lab 1. You reach the application server over SSH in Lab 2, and that only works once Lab 1's routing fix is in place. Complete the labs in order.

## Support Contact

The CloudLabs support team is available 24/7 via email and live chat.

- Email Support: labs-support@spektrasystems.com
- Live Chat Support: https://support.cloudlabs.ai/isv

Now, click on **Next >>** from the lower right corner to move on to the next page to begin with Lab 1.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/next1.png)

## Happy Learning !!
