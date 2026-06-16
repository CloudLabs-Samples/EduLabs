# Exercise 1 - Configure the VM

## Task 1: Open PowerShell
1. Sign in to the VM.
2. Launch PowerShell as Administrator.

![Step](./images/m1-ex1-st-10.png)

## Task 2: Install Git

```powershell
winget install --id Git.Git -e --source winget
```

![Git Install](./images/m1-ex1-st-20.png)

## Task 3: Install Azure CLI

```powershell
winget install Microsoft.AzureCLI
```

![Azure CLI](./images/m1-ex1-st-30.png)

## Task 4: Validate Installation

```powershell
git --version
az version
whoami
hostname
```

Expected result: Commands return installed versions and VM details.

![Validation](./images/m1-ex1-st-40.png)
