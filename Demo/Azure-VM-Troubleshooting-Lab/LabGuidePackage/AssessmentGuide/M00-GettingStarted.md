# Troubleshooting Azure VM Connectivity and Managed Identity Access Assessment

You are the **cloud operations engineer** on call for Contoso Retail. Last night's change window broke two things on the Orders platform. The Orders API on the application server can no longer be reached from the operations jump host, and the nightly job that uploads the orders report to Azure Blob Storage has stopped working.

Nothing has been deleted. Every fault is a small, realistic misconfiguration of the kind that causes most real incidents, and each one sits at a **different layer**: routing, network security, the guest operating system, identity, the storage firewall and data-plane authorisation. Fixing one layer does not fix the next. It only changes the symptom, and reading that change is the skill this assessment measures.

You are not given the commands. You are given the symptoms, the change log, and the outcome the platform needs. Across three modules you will restore the Orders API, restore the report upload without storing a single secret on the VM, and then explain why each fix worked. **Modules 1 and 2 each carry a task with a Validate button; Module 3 carries ten questions.**

## Assessment Structure

Three modules, one per page. Work through them in order.

| Module | You will | Assessed by |
|---|---|---|
| **M1** - VM connectivity | Restore HTTP from the jump host to the Orders API without weakening the hardening change | Task 1 |
| **M2** - Managed identity to storage | Restore the report upload using the VM's managed identity, with least privilege at every layer | Task 2 |
| **M3** - Knowledge check | Explain why each fix worked and what each symptom meant | 10 questions |

> **Module 2 depends on Module 1.** You reach the application server over SSH in Module 2, and that path only exists once the routing fault in Module 1 is fixed.

## Pre-requisites

Comfort with the Linux command line, SSH, `curl`, and reading JSON output. Working knowledge of Azure virtual networks, network security groups, managed identities and Azure RBAC. You do not need to memorise Azure CLI syntax - `az --help` and `az <group> --help` are available throughout.

## Accessing Your Environment

Your virtual machine and this assessment **Guide** are available within your web browser.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/guide1.png)

## How you will work

Everything happens on the **Lab VM** (the jump host) over SSH, and every Azure action is an Azure CLI call you write. Connect using the **LabVM SSH Command**, **LabVM Admin Username** and **LabVM Admin Password** on the **Environment** tab, then sign in as the lab service principal:

```bash
az login --service-principal -u "$AZ_CLIENT_ID" -p "$AZ_CLIENT_SECRET" --tenant "$AZ_TENANT_ID" --output none
az account set --subscription "$AZ_SUBSCRIPTION_ID"
```

Every name and credential the assessment needs is exported into your shell from **`/opt/lab/lab-env.sh`** when you log in, so nothing has to be hard-coded. To see them:

```bash
env | grep -E '^(RG|APP_|ROUTE_|VNET_|STORAGE_)' | sort
```

> **Read the incident brief first.** `~/LabFiles/scenario-brief.txt` describes what broke and lists the change tickets raised in the window (CHG-4471 to CHG-4481). Each ticket tells you what was **intended**. A fix that undoes the intent of a legitimate change is not a fix, and the validators reject the most common ways of doing that.

## Names You Must Use Verbatim

| Setting | Value |
|---|---|
| Jump host (you work here) | **labvm-<inject key="DeploymentID" enableCopy="false"/>** - `10.0.1.10`, in `lab-subnet` (`10.0.1.0/24`) |
| Application server | **appvm-<inject key="DeploymentID" enableCopy="false"/>** - `10.0.2.10`, in `app-subnet` (`10.0.2.0/24`) |
| Storage account | <inject key="Storage Account Name" enableCopy="true"/> |
| Report container | `reports` |
| Resource group (exists - do **not** delete it) | <inject key="Resource Group Name" enableCopy="true"/> |
| Application (client) ID | <inject key="ApplicationID" enableCopy="true"/> |
| Tenant ID | <inject key="TenantID" enableCopy="true"/> |
| Subscription ID | <inject key="SubscriptionID" enableCopy="true"/> |

Both VMs use the same admin username and password.

## Environment Reference

| Component | Details |
|---|---|
| Tooling on the jump host | `az`, `jq`, `curl`, `nc`, `ssh`, `ssh-keygen`, `ssh-copy-id` |
| Environment file | `/opt/lab/lab-env.sh` (mode 600 - source it, never copy from it) |
| Incident brief and change log | `~/LabFiles/scenario-brief.txt` |
| Orders API health endpoint | `GET http://10.0.2.10/health` returns `orders-api: healthy` when working |
| Report job (on the application server) | `/opt/app/sync-reports.sh` |
| Report job configuration | `/opt/app/app.env` |
| Report blob the job writes | `reports/orders-report-latest.txt` |
| Lab identity | A service principal scoped to your resource group |

> **The validators check outcomes and side effects, not commands.** There is more than one correct way to fix most faults here, and any of them passes. What fails is a fix that works by widening exposure - opening a port to the internet, switching a firewall to allow all networks, or granting a broader role than the job needs.

## Exploring Your Resources

To review your resources and credentials, navigate to the **Environment** tab.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/env.png)

## Utilizing the Split Window Feature

For convenience, you can open the assessment guide in a separate window by selecting the **Split Window** button from the top right corner.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/split.png)

## Managing Your Virtual Machine

You can **Start, Restart,** or **Stop** your virtual machine as needed from the **Resources** tab.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/resources.png)

## Guide Zoom In/Zoom Out

To adjust the zoom level for the environment page, click the **A↕: 100%** icon located next to the timer in the environment.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/zoom.png)

## Validation

Modules 1 and 2 each end with a **Validate** button. When you have met every required outcome for the task, hit **Validate** under the Validation tab integrated within your guide. If you receive a success message, proceed to the next module; if not, read the error message carefully - it names the layer that is still failing - and revisit the required outcomes.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/val.png)

## Track Your Progress

The **Progress** tab shows your validation score. It reaches 100% when both task validations pass.

   ![](https://raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/progress.png)

## Support Contact

The CloudLabs support team is available 24/7 via email and live chat.

- Email Support: labs-support@spektrasystems.com
- Live Chat Support: https://support.cloudlabs.ai/isv

Click **Next** to begin **Module 1: Troubleshoot Azure VM Connectivity**.

## Happy Assessing !!
