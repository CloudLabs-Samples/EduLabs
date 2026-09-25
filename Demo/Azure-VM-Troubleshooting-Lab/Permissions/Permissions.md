# Permissions - Azure VM Troubleshooting Lab

Two layers, applied together:

| File | Layer | What it does |
|---|---|---|
| `rbac.json` | Custom role, assigned **instead of** Contributor | Allow-only: read everything, change only what the two labs fix |
| `policy.json` | Azure Policy `deny` at resource-group scope | Blocks resource types the lab does not use, pins VM, disk and storage SKUs, and **keeps the storage firewall at default-deny** |

**Assign the role to BOTH principals: the learner's Azure user and the lab service principal.** The learner does every lab step as the service principal from the jump host. The Azure user is only used for the read-only portal checkpoints.

**Do not also assign Contributor.** Role assignments are additive, so Contributor would restore everything the custom role withholds.

## What the role grants

| Entry | Why it is there |
|---|---|
| `*/read` | See every resource, its settings and its effective configuration. Read alone changes nothing |
| `Microsoft.Resources/deployments/*` | Several `az` commands write a deployment object and fail with a misleading authorization error without it |
| `Microsoft.Network/networkInterfaces/effectiveRouteTable/action` | **Lab 1.** `az network nic show-effective-route-table` and the portal's *Effective routes* blade. This is a POST action, **not** covered by `*/read` |
| `Microsoft.Network/networkInterfaces/effectiveNetworkSecurityGroups/action` | The portal's *Effective security rules* view. This is a POST action, not covered by `*/read` |
| `Microsoft.Network/routeTables/routes/*` | **Lab 1.** Delete the leftover route |
| `Microsoft.Network/networkSecurityGroups/securityRules/*` | **Lab 1.** Change the priority of `Allow-HTTP-From-LabSubnet` |
| `Microsoft.Compute/virtualMachines/write` | **Lab 2.** `az vm identity assign` is a VM update |
| `Microsoft.Compute/virtualMachines/start/action`, `restart/action` | Lets the learner recover a stopped or hung VM without a support call |
| `Microsoft.Compute/virtualMachines/runCommand/action` | A fallback for reaching the app VM if the learner breaks SSH, and used by `run-solution.sh` |
| `Microsoft.Network/virtualNetworks/subnets/write` | **Lab 2.** Add the `Microsoft.Storage` service endpoint to `app-subnet` |
| `Microsoft.Network/routeTables/join/action`, `networkSecurityGroups/join/action`, `virtualNetworks/subnets/join/action` | A subnet PUT re-asserts its route table association, and Azure checks `join` on the associated resources. Without these, the service endpoint update fails with an error that names the route table, not the subnet |
| `Microsoft.Network/virtualNetworks/subnets/joinViaServiceEndpoint/action` | **Lab 2.** `az storage account network-rule add --subnet` requires this on the subnet |
| `Microsoft.Storage/storageAccounts/write` | **Lab 2.** Add the virtual network rule to the storage firewall |
| `Microsoft.Authorization/roleAssignments/write`, `delete` | **Lab 2.** Grant the VM's identity Storage Blob Data Contributor. **Constrain this with a condition. See below** |

### What the role withholds

Everything not listed, including deleting the VMs, VNet, NSGs, route table or storage account, creating any new resource, reading storage account keys (`listKeys`, which is also pointless here because shared key access is disabled), and every data-plane action. The learner never needs blob data access themselves. The VM's managed identity does.

## Constrain the role assignment permission (strongly recommended)

`roleAssignments/write` would, on its own, let the learner or the service principal grant **any** role, including Owner, to **any** principal at the resource group. Close this with an Azure ABAC condition on the assignment of the custom role. The condition only allows assigning or removing the two Storage Blob Data roles:

```bash
RG="<lab resource group>"
SUB=$(az account show --query id -o tsv)
BLOB_ROLES="ba92f5b4-2d11-453d-a403-e96b0029c9fe, 2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"   # Blob Data Contributor, Blob Data Reader

CONDITION="((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {$BLOB_ROLES})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {$BLOB_ROLES}))"
```

Pass `--condition "$CONDITION" --condition-version 2.0` on both role assignments below. With the condition in place, the worst a learner can do is grant a blob data role to the wrong principal, which is one command to undo.

## What the policy denies

| Condition | Effect |
|---|---|
| Any resource type other than VMs and their children, disks, NICs, NSGs, public IPs, VNets, route tables, storage accounts and their children, role assignments, or deployments | Denied |
| A VM size other than `Standard_D2as_v7`, `Standard_D2as_v5` or `Standard_B2s` | Denied |
| A disk SKU other than `Standard_LRS` or `StandardSSD_LRS` | Denied |
| A storage account that is not `Standard_LRS` `StorageV2` | Denied |
| **A storage account whose firewall default action is not `Deny`** | **Denied.** This blocks the tempting shortcut of "Enable from all networks" in Lab 2, so the learner has to fix the network path properly. The validator also checks it, but the policy stops it happening at all |

## Applying them

**Order matters.** Deploy the ARM template first, then assign the roles, then apply the policy. Azure Policy `deny` is not retroactive, but a policy applied first can block parts of the deployment.

```bash
RG="<lab resource group>"
SUB=$(az account show --query id -o tsv)

# 1. Role - needs Microsoft.Authorization/roleDefinitions/write at subscription scope (Owner)
az role definition create --role-definition @rbac.json

# 2. Assign to BOTH principals, with the condition from the section above
az role assignment create --role "Azure VM Troubleshooting Lab - Learner" \
  --assignee "<learner-user-object-id>" --scope "/subscriptions/$SUB/resourceGroups/$RG" \
  --condition "$CONDITION" --condition-version 2.0
az role assignment create --role "Azure VM Troubleshooting Lab - Learner" \
  --assignee "<ApplicationID from the ARM output>" --scope "/subscriptions/$SUB/resourceGroups/$RG" \
  --condition "$CONDITION" --condition-version 2.0

# 3. Policy - AFTER the ARM deployment completes
az policy definition create --name azvm-troubleshooting-guardrails \
  --display-name "Azure VM Troubleshooting Lab Guardrails" --mode All --rules @policy.json
az policy assignment create --name azvm-troubleshooting-guardrails \
  --policy azvm-troubleshooting-guardrails --scope "/subscriptions/$SUB/resourceGroups/$RG"
```

## What neither layer restricts

- **Anything inside the VMs.** The learner is `azureuser` with sudo on both VMs. The only guest change the labs make is the nginx `listen` line.
- **The jump host NSG and route path.** The labs never touch `labvm-<id>-nsg` or `lab-subnet`, so the learner's SSH access is never at risk. The role *could* edit that NSG's rules, since `securityRules/*` is not scoped to one NSG. If that matters, add a `NotActions` entry, or move the jump host into a separate resource group.

## Checks before release

| Check | Command | Expected |
|---|---|---|
| The role creates cleanly | `az role definition create --role-definition @rbac.json` | No `InvalidActionOrNotAction` |
| The SPN can read effective routes | `az network nic show-effective-route-table -g $RG -n appvm-<id>-nic -o table` | A route table, not `AuthorizationFailed` |
| The SPN cannot assign Owner | `az role assignment create --assignee <any-object-id> --role Owner --scope <rg id>` | `AuthorizationFailed` (condition) |
| The policy blocks opening storage | `az storage account update -g $RG -n stapp<id> --default-action Allow` | `RequestDisallowedByPolicy` |
| The SPN cannot delete the VM | `az vm delete -g $RG -n appvm-<id> --yes` | `AuthorizationFailed` |

Then run `manual-checkScripts/run-solution.sh` followed by `run-validators.sh` **with the custom role assigned instead of Contributor**. That is the only test that proves the model is neither too tight nor too loose.
