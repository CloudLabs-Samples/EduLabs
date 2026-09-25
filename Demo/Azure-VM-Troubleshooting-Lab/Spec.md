# Spec Sheet - Troubleshooting Azure VM Connectivity and Managed Identity Access

## Identification

| Field | Value |
|---|---|
| Lab name | Troubleshooting Azure VM Connectivity and Managed Identity Access |
| Lab type | **Guided lab.** Every command and its expected output is in the guide |
| Level | Junior to intermediate |
| Role | Cloud operations / support engineer |
| Duration | 60 minutes |
| Cloud | Azure |
| Labs | 3 (2 hands-on, 1 knowledge check) |
| Validated tasks | 2 |
| Inline questions | 10 (7 single choice, 2 multiple choice, 1 text input, 1 point each, 1 retry) |
| Package slug | `azure-vm-troubleshooting` |

## What the learner does

- **Lab 1 - Troubleshoot Azure VM Connectivity (25 min).** From an SSH jump host, signed in to the Azure CLI as a service principal, the learner restores HTTP access to an application VM by fixing three faults at three layers, re-testing after each one:
  1. **Routing:** a leftover user-defined route sends replies for the jump host subnet to a decommissioned NVA (`10.0.254.4`), so even SSH times out. The learner finds it in the NIC's effective routes and deletes it.
  2. **NSG:** `Allow-HTTP-From-LabSubnet` (300) is shadowed by `Deny-HTTP-Inbound` (200). The learner moves it to 150 and keeps the deny.
  3. **Guest OS:** nginx listens on `127.0.0.1:80`. The symptom is now *Connection refused*. The learner SSHes in, confirms with `ss`, and fixes the `listen` line.
- **Lab 2 - Restore VM Access to Azure Storage Using Managed Identity (25 min).** The report job on the app VM uses IMDS and a bearer token, with no keys. It fails three times in three distinguishable ways:
  1. **No identity:** IMDS returns `Identity not found`. The learner enables a system-assigned identity.
  2. **Storage firewall:** `403 AuthorizationFailure`. The learner adds a `Microsoft.Storage` service endpoint to `app-subnet` and a VNet rule, and keeps default-deny.
  3. **RBAC:** `403 AuthorizationPermissionMismatch`. The learner grants Storage Blob Data Contributor at **container** scope and retries through propagation delay.
- **Lab 3 - Knowledge check (10 min).** Ten questions on the concepts behind each fix.

## Delivery configuration

| Component | Setting |
|---|---|
| ARM stages | 1 (`deploy-01.json`) |
| CSE, jump host | `bootstrap-01.sh`, 12 arguments. Installs `az`, `jq`, `nc`, and writes `/opt/lab/lab-env.sh` (SPN credentials, mode 600). **No Azure calls** |
| CSE, app VM | `bootstrap-02.sh`, 3 arguments. Installs nginx (bound to loopback) and `/opt/app/sync-reports.sh`. **No Azure calls** |
| Jump host | `labvm-<id>`, Ubuntu 22.04 LTS, Standard_D2as_v7, public IP + DNS, SSH 22 only, `10.0.1.10` |
| App VM | `appvm-<id>`, Ubuntu 22.04 LTS, Standard_D2as_v7, `10.0.2.10`, public IP for **outbound only** (apt, storage), no managed identity |
| Storage | `stapp<id>`, StorageV2 Standard_LRS, shared key **disabled**, firewall default **Deny** with no rules, container `reports` |
| Authentication | Lab service principal (`ApplicationID` / `SecretKey`), CLI sign-in from the jump host. The Azure user is for read-only portal checkpoints |
| Validators | 2, hybrid (control plane plus in-VM), in `Validations/` |
| Permissions | Custom role plus RG-scoped deny policy, in `Permissions/` |

## Planted faults

| # | Fault | Where it is planted | Found with | Fixed with |
|---|---|---|---|---|
| 1 | UDR `10.0.1.0/24` to VirtualAppliance `10.0.254.4` on `app-subnet` | `deploy-01.json` route table | `az network nic show-effective-route-table` | `az network route-table route delete` |
| 2 | Allow rule shadowed by a higher-priority deny | `deploy-01.json` app NSG | `az network nsg rule list` sorted by priority | `az network nsg rule update --priority 150` |
| 3 | nginx `listen 127.0.0.1:80;` | `bootstrap-02.sh` | `ss -tlnp` | `sed` + `nginx -t` + restart |
| 4 | No managed identity on `appvm` | `deploy-01.json` (no `identity` block) | `sync-reports.sh` step 1 / `az vm identity show` | `az vm identity assign` |
| 5 | Storage firewall Deny with an empty allow list, no service endpoint | `deploy-01.json` storage + VNet | `sync-reports.sh` step 2 (`AuthorizationFailure`) | `subnet update --service-endpoints` + `network-rule add` |
| 6 | No data-plane role | Nothing is assigned | `sync-reports.sh` step 2 (`AuthorizationPermissionMismatch`) | `az role assignment create` at container scope |

## Before the first deployment

| Item | Action |
|---|---|
| **Script hosting** | Upload `bootstrap-01.sh` and `bootstrap-02.sh` to a blob container, then set the two full URLs in `deploy-01.json`: `labScriptUrl` (jump host, `bootstrap-01.sh`) and `appScriptUrl` (app VM, `bootstrap-02.sh`). Both currently start with `https://REPLACE-WITH-TEMPLATE-STORAGE...` |
| **Guide hosting** | `masterdoc.json` and `M03-KnowledgeCheck.md` use `https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-Samples/EduLabs/refs/heads/main/Demo/Azure-VM-Troubleshooting-Lab/`. This matches the folder `Demo/Azure-VM-Troubleshooting-Lab` in `CloudLabs-Samples/EduLabs`. Find and replace it if the folder is renamed |
| **Screenshots** | Upload every image to `Demo/Azure-VM-Troubleshooting-Lab/LabGuidePackage/Image/` in the EduLabs repo. The guides reference them by absolute docs-api URL. Generic ones are reused from the standard CloudLabs set (`guide1`, `env`, `split`, `resources`, `zoom`, `val`, `progress`, `next1`). Lab-specific ones: `portal-signin`, `m01-portal-nsg-rules`, `m01-portal-effective-routes`, `m01-portal-route-deleted`, `m01-portal-nsg-fixed`, `m02-portal-vm-identity`, `m02-portal-storage-firewall-before`, `m02-portal-storage-firewall-after`, `m02-portal-identity-no-roles`, `m02-portal-container-iam` |
| **Permissions** | Apply `Permissions/` as described in `Permissions.md`, **including the ABAC condition** on role assignments |

## Known environment dependencies

| Dependency | Note |
|---|---|
| Deployment ID length | `stapp` + ID must be 24 characters or fewer, lowercase alphanumeric, so the ID is limited to 19 characters. `StorageAccountAlreadyTaken` usually means a previous environment with the same ID has not finished deleting |
| App VM outbound internet | `bootstrap-02.sh` installs nginx with apt. The app VM has a Standard public IP purely for outbound access. The NSG admits nothing from the internet. Do not remove it unless you add a NAT gateway |
| CSE ordering | The jump host CSE depends on the app VM CSE, so when the learner's jump host is ready, nginx is already running |
| RBAC propagation | New role assignments can take 1-5 minutes to reach storage. The guide's retry loop covers 4 minutes, and validator 2 retries as well |
| Service principal role | The custom role must be assigned to the SPN, because every lab step runs as the SPN. It must include the two `effective*` NIC actions, or Lab 1's effective-routes step fails with `AuthorizationFailed` |
| Policy after deployment | Apply `policy.json` only after the ARM deployment completes |

## Cost profile

Two Standard_D2as_v7 VMs, two Standard public IPs, one Standard_LRS storage account holding a single small blob. No gateways, firewalls, private endpoints or NAT gateways.
