# Validations - Azure VM Troubleshooting Lab

Two validation scripts, one per hands-on lab. Lab 3 (Knowledge Check) is assessed by 10 inline questions and has no validator.

| Step UUID | Script | Task | Lab page | Runs in-VM on |
|---|---|---|---|---|
| `4eb65796-8985-4f91-9016-43ae28f7b8fc` | `validate-task1-vm-connectivity.sh` | Restore connectivity from the jump host to the Orders API | `M01-VMConnectivity.md` | `labvm-<id>` |
| `1514befa-558a-41b9-9400-bc0374c734e3` | `validate-task2-managed-identity.sh` | Restore VM access to storage using managed identity | `M02-ManagedIdentityStorage.md` | `appvm-<id>` |

**The UUIDs above are the ones embedded in the lab guide pages.** Each lab page carries exactly one `<validation step="..." />` tag, matching this table row for row. If a UUID is regenerated, change both files together.

Each file is PowerShell despite the `.sh` extension, following the CloudLabs convention. Each imports only `Az.Accounts`, `Az.Compute` and `Az.Resources`, reads control-plane state with `Invoke-AzRestMethod` (so no `Az.Network` or `Az.Storage` module is needed in the validator runtime), runs its in-VM half with `Invoke-AzVMRunCommand`, retries three times, and always pushes a `{Status, Message}` JSON body.

## What each validator checks

### Validator 1 - VM connectivity

| Check | Half | Passes when |
|---|---|---|
| 1a Route | Control plane | `rt-app-<id>` has no `VirtualAppliance` route to `10.0.254.4` or for `10.0.1.0/24`. Disassociating the route table from `app-subnet` is also accepted |
| 1b NSG order | Control plane | The **first** inbound rule on `appvm-<id>-nsg`, by priority, that matches TCP/80 from `10.0.1.10` is an **Allow**. No matching custom rule is also fine, because default rule 65000 AllowVnetInBound then admits it |
| 1b NSG exposure | Control plane | No **Allow** rule for port 80 has source `*`, `Any`, `Internet` or `0.0.0.0/0`. Opening HTTP to the internet fails the task even though curl would work |
| 1c End to end | In-VM, `labvm` | `curl http://10.0.2.10/health` returns HTTP 200 with body `orders-api: healthy` |

The in-VM half reads curl's exit code, so the failure message names the layer: **28 (timeout)** means the route or the NSG is still dropping traffic, and **7 (refused)** means the network is open but nginx is still on loopback.

### Validator 2 - Managed identity to storage

| Check | Half | Passes when |
|---|---|---|
| 2a Identity | Control plane | `appvm-<id>` has `identity.type` containing `SystemAssigned` and a `principalId` |
| 2b Firewall | Control plane | `stapp<id>` still has `networkAcls.defaultAction = Deny`, has a virtual network rule for `.../subnets/app-subnet`, and `publicNetworkAccess` is not `Disabled` |
| 2c RBAC | Control plane | The principal holds **Storage Blob Data Contributor** (`ba92f5b4-...`) or **Storage Blob Data Owner** (`b7e6dc6d-...`) at the `reports` container scope or the account scope. Listed at resource-group scope with `$filter=principalId eq '...'`, which returns assignments at, above and below the group |
| 2d End to end | In-VM, `appvm` | A **fresh** IMDS token can `GET reports/orders-report-latest.txt`, and the blob starts with `orders-report` |

2d can only pass after the learner actually ran `/opt/app/sync-reports.sh` successfully, because that is what creates the blob. The in-VM half maps the storage error code to the missing piece: `AuthorizationFailure` is the firewall, `AuthorizationPermissionMismatch` is RBAC or propagation delay, and `BlobNotFound` means the job has not been run yet.

## Names and values the validators depend on

| Thing | Value | Set by |
|---|---|---|
| Jump host | `labvm-<DeploymentID>`, `10.0.1.10` | `deploy-01.json` |
| App VM | `appvm-<DeploymentID>`, `10.0.2.10` | `deploy-01.json` |
| App NSG | `appvm-<DeploymentID>-nsg` | `deploy-01.json` |
| Route table / leftover route | `rt-app-<DeploymentID>` / `to-lab-subnet-via-nva` to `10.0.254.4` | `deploy-01.json` |
| VNet / subnets | `lab-vnet-<DeploymentID>`, `lab-subnet` 10.0.1.0/24, `app-subnet` 10.0.2.0/24 | `deploy-01.json` |
| Storage account / container | `stapp<DeploymentID>` / `reports` | `deploy-01.json` |
| Report blob | `orders-report-latest.txt` | `bootstrap-02.sh` (`/opt/app/app.env`) |
| Health endpoint | `GET /health` returns `orders-api: healthy` | `bootstrap-02.sh` (nginx site `orders-api`) |

## Facilitator tooling

| Script | Where to run | What it does |
|---|---|---|
| `manual-checkScripts/verify-bootstrap.sh` | `labvm`, as root | Confirms both CSEs finished, the tooling and `lab-env.sh` are in place, and **every planted fault is still present** at hand-over |
| `manual-checkScripts/run-solution.sh [--partial]` | `labvm`, as root | Applies every fix from both guides. `--partial` stops after Lab 1 |
| `manual-checkScripts/run-validators.sh` | `labvm`, as root | Runs both validators' in-VM blocks (**byte-identical**, generated from the files here) plus az CLI equivalents of their control-plane halves |

Recommended release test: `verify-bootstrap.sh`, then `run-solution.sh --partial`, then Validate (expect 1 pass and 1 fail), then `run-solution.sh`, then Validate (expect 2 passes).
