# Enterprise Remote IT & Cloud Infrastructure Templates

[![GitHub Repository](https://img.shields.io/badge/GitHub-Phlotonic%2Fhome--lab--templates--portfolio-blue?logo=github)](https://github.com/Phlotonic/home-lab-templates-portfolio)
[![License: Dual Commercial / PolyForm Noncommercial](https://img.shields.io/badge/License-Commercial%20%7C%20PolyForm%20Noncommercial%201.0.0-amber)](./COMMERCIAL-LICENSE.md)
[![Validation Status](https://img.shields.io/badge/Compliance%20Checks-44%2F44%20Passing-brightgreen)](./validate-all.ps1)
[![Author: Adam Dryden (Phlotonic)](https://img.shields.io/badge/Architect-Adam%20Dryden%20(Phlotonic)-success)](https://github.com/Phlotonic)

A production-grade collection of **6 parameterized Infrastructure-as-Code (IaC), Enterprise Networking, SOC Threat Detection, Cloud Security, and Kubernetes blueprints** engineered by **Adam Dryden ([`@Phlotonic`](https://github.com/Phlotonic))**.

Each module is built as a **reusable template** containing:
1. **Parameterized Configuration & IaC Inputs** (`template-variables.json`, `render-template.ps1`, Bicep parameters, CloudFormation parameters, or `terraform.tfvars.example`)
2. **Automated Local Security & Compliance Validator** (`validate-lab.ps1` + root [`validate-all.ps1`](./validate-all.ps1))
3. **Plain-English Executive & Architecture Guide** (`EXPLAIN-IT-SIMPLY.md`)

---

## Architecture & Certification Blueprint Matrix

| Module | Domain & Certification Alignment | Core Reusable Architecture | Status | Architecture & Interview Guide |
| :--- | :--- | :--- | :--- | :--- |
| [`01-ccna-corporate-network`](./01-ccna-corporate-network) | **Enterprise Networking**<br/>Cisco CCNA (`200-301`) | Dual-site OSPF Area 0 WAN, Layer 3 Switch SVIs (4 VLANs), Extended Guest Wi-Fi Isolation ACLs, SSHv2-only VTY control plane | **Completed & Verified (9/9)** | [`EXPLAIN-IT-SIMPLY.md`](./01-ccna-corporate-network/EXPLAIN-IT-SIMPLY.md) |
| [`02-security-plus-wazuh-soc`](./02-security-plus-wazuh-soc) | **SOC Detection & Incident Response**<br/>CompTIA Security+ | Wazuh SIEM + Windows Sysmon EventChannel pipeline, custom MITRE ATT&CK XML rules (`T1059.001`, `T1003.001`, `T1547.001`), Atomic Red Team harness, Incident Triage Report | **Completed & Verified (7/7)** | [`EXPLAIN-IT-SIMPLY.md`](./02-security-plus-wazuh-soc/EXPLAIN-IT-SIMPLY.md) |
| [`03-azure-az104-hybrid-vnet`](./03-azure-az104-hybrid-vnet) | **Hybrid Cloud Administration**<br/>Microsoft Azure (`AZ-104`) | Multi-region Bicep Hub/Spoke VNet Peering (`eastus` <-> `westus2`), zero-public-IP Linux VM, Azure Bastion, Key Vault RBAC, Entra ID MFA | **Completed & Verified (7/7)** | [`EXPLAIN-IT-SIMPLY.md`](./03-azure-az104-hybrid-vnet/EXPLAIN-IT-SIMPLY.md) |
| [`04-aws-saa-three-tier-ha`](./04-aws-saa-three-tier-ha) | **High-Availability Cloud Architecture**<br/>AWS Solutions Architect (`SAA-C03`) | 2-AZ, 3-Tier CloudFormation VPC (Public ALB, Private NGINX Auto Scaling Group, Isolated Multi-AZ RDS) + EC2 termination chaos drill | **Completed & Verified (7/7)** | [`EXPLAIN-IT-SIMPLY.md`](./04-aws-saa-three-tier-ha/EXPLAIN-IT-SIMPLY.md) |
| [`05-terraform-modular-pipeline`](./05-terraform-modular-pipeline) | **Cloud Automation & CI/CD**<br/>HashiCorp Terraform Associate | Reusable `networking`, `security`, and `compute` modules, S3 + DynamoDB state locking, IMDSv2, and GitHub Actions OIDC PR pipeline | **Completed & Verified (7/7)** | [`EXPLAIN-IT-SIMPLY.md`](./05-terraform-modular-pipeline/EXPLAIN-IT-SIMPLY.md) |
| [`06-cka-kubernetes-chaos-cluster`](./06-cka-kubernetes-chaos-cluster) | **Platform Engineering & SRE**<br/>Certified Kubernetes Admin (`CKA`) | 3-node bare-VM `kubeadm` bootstrap, Calico CNI zero-trust `NetworkPolicy`, NGINX Ingress, PersistentVolume, and 3 Break/Fix chaos drills | **Completed & Verified (7/7)** | [`EXPLAIN-IT-SIMPLY.md`](./06-cka-kubernetes-chaos-cluster/EXPLAIN-IT-SIMPLY.md) |

---

## Quick Verification (Run All 44 Compliance & Security Checks in 1 Command)

```powershell
# Run the master compliance audit across all 6 stages
powershell -NoProfile -ExecutionPolicy Bypass -File .\validate-all.ps1
```

See [`PORTFOLIO-RND-TRACKER.md`](./PORTFOLIO-RND-TRACKER.md) for the live R&D cascade status and wake-up briefs.

---

## Commercial Licensing & Done-For-You Architecture Consulting

**Copyright (c) 2026 Adam Dryden (`Phlotonic`). All Rights Reserved.**

- **Free Evaluation & Hiring Review:** Personal, non-commercial study and technical interview evaluation are permitted under the [PolyForm Noncommercial License 1.0.0](./LICENSE).
- **Commercial, Corporate, MSP & Bootcamp Licensing:** Deploying these templates in business operations, client environments, or paid training requires a paid commercial license:
  - **Tier 1 — Practitioner / Single-Company Production License (\$299)**
  - **Tier 2 — MSP / Consultant Multi-Client License (\$999)**
  - **Tier 3 — Enterprise / Academy / Done-For-You Deployment Retainer (Custom Quote)**
- Read the full terms and inquiry instructions in [`COMMERCIAL-LICENSE.md`](./COMMERCIAL-LICENSE.md).
