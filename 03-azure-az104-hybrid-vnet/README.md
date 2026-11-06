# Module 03 (Microsoft Azure AZ-104): Multi-Region Hub-Spoke Landing Zone with Azure Bastion & Key Vault RBAC

**Required Notice:** Copyright (c) 2026 Adam Dryden (`Phlotonic`) — Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.

## 1. Executive Architecture Summary
This module provisions a multi-region Azure Hub-and-Spoke landing zone in **Bicep** spanning `eastus` (Hub) and `westus2` (Spoke) connected via bidirectional Global VNet Peering. To eliminate public IP exposure on compute workloads, the Linux VM in `westus2` is deployed with **zero public IP addresses** behind a restrictive Network Security Group (NSG) that permits inbound SSH (`TCP 22`) exclusively from the **Azure Bastion Standard** subnet (`10.10.0.0/26`) in the Hub VNet. Operational secrets are stored in **Azure Key Vault** using role-based access control (`enableRbacAuthorization: true`) and consumed via a **System-Assigned Managed Identity**, while administrative access to Azure Resource Manager is protected by **Microsoft Entra ID Conditional Access MFA**.

---

## 2. Multi-Region Hub-Spoke Topology

```mermaid
flowchart LR
    Admin["Administrator Session<br/>(Entra ID Conditional Access MFA)"] -- "TLS 443" --> Bastion["Azure Bastion (Standard SKU)<br/>10.10.0.0/26"]

    subgraph Hub["Primary Hub Region: East US (vnet-hub-eastus 10.10.0.0/16)"]
        Bastion
        KV["Azure Key Vault<br/>(RBAC Enabled, 90-Day Soft Delete)"]
    end

    Hub <-- "Global VNet Peering (Azure Backbone)" --> Spoke

    subgraph Spoke["Secondary Spoke Region: West US 2 (vnet-spoke-westus2 10.20.0.0/16)"]
        NSG["NSG: Allow TCP 22 ONLY<br/>from 10.10.0.0/26"] --> VM["Private Linux VM (Zero Public IP)<br/>System-Assigned Managed Identity"]
    end

    VM -. "Key Vault Secrets User Role" .-> KV
```

---

## 3. Component & Configuration Specification

| Artifact | Functional Role | Production Engineering Rationale |
| :--- | :--- | :--- |
| [`main.bicep`](./main.bicep) | Declarative Azure Bicep template provisioning Hub/Spoke VNets, Global Peering, NSG, Azure Bastion, Private VM, Key Vault, and RBAC role assignments. | Enforces repeatable multi-region infrastructure deployment with compile-time type safety and idempotent resource definitions. |
| [`configure-entra-and-secrets.sh`](./configure-entra-and-secrets.sh) | Deployment orchestrator that provisions the Bicep stack, injects connection strings into Key Vault, and creates an Entra ID Conditional Access MFA policy via Microsoft Graph. | Secures both the network data plane (Bastion + NSG) and the identity control plane (Conditional Access + Managed Identity). |
| [`template-variables.json`](./template-variables.json) | Parameterized configuration for Azure regions, VNet address spaces, and VM SKUs. | Enables rapid adaptation across enterprise subscriptions and regional topologies. |

---

## 4. FinOps & Cloud Resource Cost Profile

| Azure Resource | SKU / Configuration | Estimated Monthly Cost (24x7) | FinOps Optimization Strategy |
| :--- | :--- | :--- | :--- |
| **Azure Bastion** | `Standard` SKU (`bas-hub-eastus`) | `~\$138.70 / mo` (`\$0.19/hr`) | Deploy on-demand via Bicep during maintenance windows or share a single Hub Bastion across all peered Spoke VNets. |
| **Private Workload VM** | `Standard_B1s` + `Standard_LRS` Disk | `~\$9.10 / mo` | Eligible for 12-month Azure Free Tier (`750 hrs/mo`); apply 1- or 3-year Azure Savings Plans in production. |
| **Azure Key Vault & VNet Peering** | `Standard` Vault + Cross-Region Peering | `< \$1.50 / mo` (`\$0.03 / 10k ops`) | Cache secrets in memory via Managed Identity token refresh to minimize Key Vault API calls. |

---

## 5. Deployment & Verification Runbook

```powershell
# 1. Render parameterized Azure landing zone inputs
powershell -NoProfile -ExecutionPolicy Bypass -File .\render-template.ps1

# 2. Execute automated Bicep security, peering & RBAC compliance checks
powershell -NoProfile -ExecutionPolicy Bypass -File .\validate-lab.ps1
```
