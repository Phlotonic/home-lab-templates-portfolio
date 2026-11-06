# Enterprise Reference Architecture Roadmap & Verification Matrix

**Copyright (c) 2026 Adam Dryden (`Phlotonic`) — Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.**

This document tracks the release status, automated compliance coverage, and deliverable inventory across all six production infrastructure modules.

---

## 1. Module Release & Compliance Matrix (`v1.0.0` — 44/44 Checks Passing)

| Module ID | Directory | Target Platform & Standards | Automated Audit Coverage | Deliverable Inventory | Architecture Documentation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **MOD-01** | [`01-ccna-corporate-network`](./01-ccna-corporate-network) | Cisco IOS XE / OSPF Area 0 / Catalyst L3 Switching | **9/9 Passing** | `template-variables.json`, `render-template.ps1`, `configs/site-a-hq.txt`, `configs/site-b-branch.txt`, `validate-lab.ps1` | [`EXPLAIN-IT-SIMPLY.md`](./01-ccna-corporate-network/EXPLAIN-IT-SIMPLY.md) |
| **MOD-02** | [`02-security-plus-wazuh-soc`](./02-security-plus-wazuh-soc) | Wazuh SIEM 4.9 / Microsoft Sysmon / MITRE ATT&CK | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `deploy-soc.sh`, `install-sysmon-agent.ps1`, `rules/local_rules.xml`, `run-atomic-tests.ps1`, `reports/INC-2026-1104-Triage-Report.md`, `validate-lab.ps1` | [`EXPLAIN-IT-SIMPLY.md`](./02-security-plus-wazuh-soc/EXPLAIN-IT-SIMPLY.md) |
| **MOD-03** | [`03-azure-az104-hybrid-vnet`](./03-azure-az104-hybrid-vnet) | Azure Resource Manager (Bicep) / Entra ID / Key Vault | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `main.bicep`, `configure-entra-and-secrets.sh`, `validate-lab.ps1` | [`EXPLAIN-IT-SIMPLY.md`](./03-azure-az104-hybrid-vnet/EXPLAIN-IT-SIMPLY.md) |
| **MOD-04** | [`04-aws-saa-three-tier-ha`](./04-aws-saa-three-tier-ha) | AWS CloudFormation / ALB / EC2 Auto Scaling / RDS | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `aws-three-tier-ha.yaml`, `run-failover-drill.sh`, `validate-lab.ps1` | [`EXPLAIN-IT-SIMPLY.md`](./04-aws-saa-three-tier-ha/EXPLAIN-IT-SIMPLY.md) |
| **MOD-05** | [`05-terraform-modular-pipeline`](./05-terraform-modular-pipeline) | HashiCorp Terraform 1.8+ / AWS S3+DynamoDB / GitHub OIDC | **7/7 Passing** | `terraform.tfvars.example`, `template-variables.json`, `render-template.ps1`, `main.tf`, `modules/{networking,security,compute}`, `.github/workflows/terraform-pr.yml`, `validate-lab.ps1` | [`EXPLAIN-IT-SIMPLY.md`](./05-terraform-modular-pipeline/EXPLAIN-IT-SIMPLY.md) |
| **MOD-06** | [`06-cka-kubernetes-chaos-cluster`](./06-cka-kubernetes-chaos-cluster) | Kubernetes v1.31 (`kubeadm`) / `containerd` / Calico CNI | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `bootstrap-kubeadm.sh`, `cluster-workloads.yaml`, `CKA-Break-Fix-Runbook.md`, `validate-lab.ps1` | [`EXPLAIN-IT-SIMPLY.md`](./06-cka-kubernetes-chaos-cluster/EXPLAIN-IT-SIMPLY.md) |

---

## 2. Continuous Integration & Validation Standards

Every module in this repository adheres to four baseline engineering invariants verified by [`validate-all.ps1`](./validate-all.ps1):
1. **Zero Hardcoded Credentials:** Secrets and sensitive connection strings are externalized to managed secret stores (Azure Key Vault RBAC, AWS SSM/NoEcho parameters, or local `.gitignore`-excluded environment inputs).
2. **Least-Privilege Network Segmentation:** Every topology enforces explicit ingress/egress filtering (Cisco Extended ACLs, Azure NSGs, chained AWS Security Groups, and Calico Kubernetes `NetworkPolicy` manifests).
3. **Declarative Parameterization:** Environment-specific values (CIDRs, regions, hostnames, and instance sizing) are decoupled into `template-variables.json` and `terraform.tfvars.example`.
4. **Commercial IP Attribution:** All source files carry explicit copyright and dual-license attribution headers.

---

## 3. Planned Engineering Enhancements Backlog
- *(No pending backlog items — all `v1.0.0` core reference modules are verified and released.)*
