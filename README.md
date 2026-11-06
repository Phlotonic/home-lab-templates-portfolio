# Enterprise Infrastructure, Cloud Security & Platform Engineering Blueprints

[![GitHub Repository](https://img.shields.io/badge/GitHub-Phlotonic%2Fhome--lab--templates--portfolio-blue?logo=github)](https://github.com/Phlotonic/home-lab-templates-portfolio)
[![License: Commercial / PolyForm Noncommercial](https://img.shields.io/badge/License-Commercial%20%7C%20PolyForm%20Noncommercial%201.0.0-amber)](./COMMERCIAL-LICENSE.md)
[![Compliance Audit](https://img.shields.io/badge/Automated%20Audit-44%2F44%20Passing-brightgreen)](./validate-all.ps1)
[![Release](https://img.shields.io/badge/Release-v1.0.0-informational)](./ARCHITECTURE-ROADMAP.md)

Production-grade **Infrastructure-as-Code (IaC), Enterprise Routing, SIEM Threat Detection, Hybrid Cloud Networking, and Kubernetes Platform Engineering templates** architected by **Adam Dryden ([`@Phlotonic`](https://github.com/Phlotonic))**.

Every module is engineered as a **parameterized, self-validating reference blueprint** comprising:
1. **Declarative Parameterization** (`template-variables.json`, `render-template.ps1`, Bicep parameters, CloudFormation parameters, and `terraform.tfvars.example`)
2. **Automated Security & Compliance Verification** (`validate-lab.ps1` per module and master suite [`validate-all.ps1`](./validate-all.ps1))
3. **Executive Architecture & Operations Documentation** (`EXPLAIN-IT-SIMPLY.md` with Mermaid topology diagrams, design rationale, and operational runbooks)

---

## Reference Architecture Matrix

| Module | Engineering Domain | Core Architecture & Security Controls | Audit Status | Architecture Guide |
| :--- | :--- | :--- | :--- | :--- |
| [`01-ccna-corporate-network`](./01-ccna-corporate-network) | **Enterprise WAN & Campus Routing**<br/>Cisco IOS / OSPF / L3 Switching | Dual-site OSPF Area 0 point-to-point WAN, Catalyst L3 Switch SVIs (4 segmented VLANs), inbound extended Guest Wi-Fi isolation ACLs, SSHv2-only control plane | **Verified (`9/9`)** | [`EXPLAIN-IT-SIMPLY.md`](./01-ccna-corporate-network/EXPLAIN-IT-SIMPLY.md) |
| [`02-security-plus-wazuh-soc`](./02-security-plus-wazuh-soc) | **SIEM Detection Engineering & SOC**<br/>Wazuh / Sysmon / MITRE ATT&CK | Wazuh 4.9 SIEM + Windows Sysmon EventChannel ingestion, custom PCRE2 detection rules (`T1059.001`, `T1003.001`, `T1547.001`), Atomic Red Team validation harness, Incident Triage Playbook | **Verified (`7/7`)** | [`EXPLAIN-IT-SIMPLY.md`](./02-security-plus-wazuh-soc/EXPLAIN-IT-SIMPLY.md) |
| [`03-azure-az104-hybrid-vnet`](./03-azure-az104-hybrid-vnet) | **Multi-Region Azure Landing Zone**<br/>Azure Bicep / Entra ID / Key Vault | Global VNet Peering (`eastus` <-> `westus2`), zero-public-IP workload VM behind Azure Bastion Standard, Key Vault RBAC with Managed Identity, Entra ID Conditional Access MFA | **Verified (`7/7`)** | [`EXPLAIN-IT-SIMPLY.md`](./03-azure-az104-hybrid-vnet/EXPLAIN-IT-SIMPLY.md) |
| [`04-aws-saa-three-tier-ha`](./04-aws-saa-three-tier-ha) | **High-Availability Cloud Architecture**<br/>AWS CloudFormation / ALB / ASG / RDS | 2-AZ, 3-Tier VPC (Public ALB, Private NGINX Auto Scaling Group with `/healthz` ELB checks, Isolated Multi-AZ RDS MySQL) + automated EC2 termination chaos failover drill | **Verified (`7/7`)** | [`EXPLAIN-IT-SIMPLY.md`](./04-aws-saa-three-tier-ha/EXPLAIN-IT-SIMPLY.md) |
| [`05-terraform-modular-pipeline`](./05-terraform-modular-pipeline) | **Modular IaC & Keyless CI/CD**<br/>HashiCorp Terraform / GitHub Actions | Reusable `networking`, `security`, and `compute` modules, encrypted S3 + DynamoDB state locking, IMDSv2 enforcement, and GitHub Actions OIDC speculative plan pipeline | **Verified (`7/7`)** | [`EXPLAIN-IT-SIMPLY.md`](./05-terraform-modular-pipeline/EXPLAIN-IT-SIMPLY.md) |
| [`06-cka-kubernetes-chaos-cluster`](./06-cka-kubernetes-chaos-cluster) | **Bare-Metal Kubernetes & SRE**<br/>`kubeadm` v1.31 / Calico CNI / `crictl` | 3-node cluster bootstrap (`SystemdCgroup = true`), Calico CNI zero-trust `NetworkPolicy` micro-segmentation, NGINX Ingress, PersistentVolume, and 3 control-plane/PKI recovery runbooks | **Verified (`7/7`)** | [`EXPLAIN-IT-SIMPLY.md`](./06-cka-kubernetes-chaos-cluster/EXPLAIN-IT-SIMPLY.md) |

---

## Automated Compliance & Security Verification

Execute the master verification suite from the repository root to validate template parameterization, security policy enforcement, XML/IaC structure, and commercial license headers across all six modules:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\validate-all.ps1
```

See [`ARCHITECTURE-ROADMAP.md`](./ARCHITECTURE-ROADMAP.md) for module specifications and release milestones.

---

## Commercial Licensing & Enterprise Advisory

**Copyright (c) 2026 Adam Dryden (`Phlotonic`). All Rights Reserved.**

- **Noncommercial Evaluation Grant:** Non-commercial evaluation and technical inspection are permitted under the [PolyForm Noncommercial License 1.0.0](./LICENSE).
- **Commercial Production & MSP Licensing:** Deploying these architectures in commercial operations, client environments, or paid training requires a commercial license:
  - **Tier 1 — Single-Organization Production License (\$299)**
  - **Tier 2 — MSP / Consultancy Multi-Client License (\$999)**
  - **Tier 3 — Enterprise Custom Architecture & Deployment Retainer (Custom Scope)**
- Full licensing terms and engagement details are documented in [`COMMERCIAL-LICENSE.md`](./COMMERCIAL-LICENSE.md).
