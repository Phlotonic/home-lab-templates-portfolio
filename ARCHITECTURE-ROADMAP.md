# Enterprise Reference Architecture Roadmap & Verification Matrix

**Copyright (c) 2026 Adam Dryden (`Phlotonic`) — Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.**

This document tracks the release status, automated compliance coverage, and deliverable inventory across all nine production infrastructure and security modules.

---

## 1. Module Release & Compliance Matrix (`v2.0.0` — 65/65 Checks Passing)

| Module ID | Directory | Target Platform & Standards | Automated Audit Coverage | Deliverable Inventory | Architecture Documentation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **MOD-01** | [`01-ccna-corporate-network`](./01-ccna-corporate-network) | Cisco IOS XE / OSPF Area 0 / Catalyst L3 Switching | **9/9 Passing** | `template-variables.json`, `render-template.ps1`, `configs/site-a-hq.txt`, `configs/site-b-branch.txt`, `validate-lab.ps1` | [`README.md`](./01-ccna-corporate-network/README.md) |
| **MOD-02** | [`02-security-plus-wazuh-soc`](./02-security-plus-wazuh-soc) | Wazuh SIEM 4.9 / Microsoft Sysmon / MITRE ATT&CK | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `deploy-soc.sh`, `install-sysmon-agent.ps1`, `rules/local_rules.xml`, `run-atomic-tests.ps1`, `reports/INC-2026-1104-Triage-Report.md`, `validate-lab.ps1` | [`README.md`](./02-security-plus-wazuh-soc/README.md) |
| **MOD-03** | [`03-azure-az104-hybrid-vnet`](./03-azure-az104-hybrid-vnet) | Azure Resource Manager (Bicep) / Entra ID / Key Vault | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `main.bicep`, `configure-entra-and-secrets.sh`, `validate-lab.ps1` | [`README.md`](./03-azure-az104-hybrid-vnet/README.md) |
| **MOD-04** | [`04-aws-saa-three-tier-ha`](./04-aws-saa-three-tier-ha) | AWS CloudFormation / ALB / EC2 Auto Scaling / RDS | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `aws-three-tier-ha.yaml`, `run-failover-drill.sh`, `validate-lab.ps1` | [`README.md`](./04-aws-saa-three-tier-ha/README.md) |
| **MOD-05** | [`05-terraform-modular-pipeline`](./05-terraform-modular-pipeline) | HashiCorp Terraform 1.8+ / AWS S3+DynamoDB / GitHub OIDC | **7/7 Passing** | `terraform.tfvars.example`, `template-variables.json`, `render-template.ps1`, `main.tf`, `modules/{networking,security,compute}`, `.github/workflows/terraform-pr.yml`, `validate-lab.ps1` | [`README.md`](./05-terraform-modular-pipeline/README.md) |
| **MOD-06** | [`06-cka-kubernetes-chaos-cluster`](./06-cka-kubernetes-chaos-cluster) | Kubernetes v1.31 (`kubeadm`) / `containerd` / Calico CNI | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `bootstrap-kubeadm.sh`, `cluster-workloads.yaml`, `CKA-Break-Fix-Runbook.md`, `validate-lab.ps1` | [`README.md`](./06-cka-kubernetes-chaos-cluster/README.md) |
| **MOD-07** | [`07-sre-observability-golden-signals`](./07-sre-observability-golden-signals) | Prometheus / Alertmanager / Grafana 11 / Loki / SRE SLOs | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `prometheus.yml`, `slo-recording-rules.yml`, `docker-compose-observability.yml`, `validate-lab.ps1` | [`README.md`](./07-sre-observability-golden-signals/README.md) |
| **MOD-08** | [`08-cks-devsecops-gitops-supply-chain`](./08-cks-devsecops-gitops-supply-chain) | ArgoCD / Kyverno / Aqua Trivy SBOM / Sigstore Cosign | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `argocd-application.yaml`, `kyverno-cluster-policies.yaml`, `supply-chain-ci.yml`, `validate-lab.ps1` | [`README.md`](./08-cks-devsecops-gitops-supply-chain/README.md) |
| **MOD-09** | [`09-zero-trust-secops-vault-autoremediation-ot`](./09-zero-trust-secops-vault-autoremediation-ot) | Ansible CIS / HashiCorp Vault / AWS EventBridge / IEC 62443 | **7/7 Passing** | `template-variables.json`, `render-template.ps1`, `ansible-cis-hardening.yml`, `vault-dynamic-db.hcl`, `aws-s3-autoremediation.py`, `ot-dmz-conduit.conf`, `validate-lab.ps1` | [`README.md`](./09-zero-trust-secops-vault-autoremediation-ot/README.md) |

---

## 2. Continuous Integration & Validation Standards

Every module in this repository adheres to five baseline engineering invariants verified automatically on every push via [`.github/workflows/compliance-audit.yml`](./.github/workflows/compliance-audit.yml) and locally via [`validate-all.ps1`](./validate-all.ps1):
1. **Zero Hardcoded Credentials:** Secrets and sensitive connection strings are externalized to managed secret stores (HashiCorp Vault dynamic leases, Azure Key Vault RBAC, AWS SSM/NoEcho parameters, or `.gitignore`-excluded environment inputs).
2. **Least-Privilege Network & Admission Segmentation:** Every topology enforces explicit ingress/egress and admission filtering (Cisco Extended ACLs, Azure NSGs, chained AWS Security Groups, Calico `NetworkPolicy`, Kyverno `ClusterPolicy`, and IEC 62443 IDMZ mTLS brokers).
3. **Dynamic Template Code Generation:** Environment-specific values are decoupled into `template-variables.json` and interpolated via [`render-all.ps1`](./render-all.ps1).
4. **FinOps Cost & Sizing Transparency:** Each module documents its monthly cloud/hardware cost profile and right-sizing levers inside its `README.md`.
5. **Commercial IP Attribution:** All source files carry explicit copyright and dual-license attribution headers.

---

## 3. Planned Engineering Enhancements Backlog
- *(No pending backlog items — all `v2.0.0` 9-module reference architectures are verified and released.)*
