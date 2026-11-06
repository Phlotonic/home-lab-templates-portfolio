# Enterprise Infrastructure, Cloud Security & Platform Engineering Blueprints

[![GitHub Repository](https://img.shields.io/badge/GitHub-Phlotonic%2Fhome--lab--templates--portfolio-blue?logo=github)](https://github.com/Phlotonic/home-lab-templates-portfolio)
[![Compliance Audit](https://github.com/Phlotonic/home-lab-templates-portfolio/actions/workflows/compliance-audit.yml/badge.svg)](https://github.com/Phlotonic/home-lab-templates-portfolio/actions/workflows/compliance-audit.yml)
[![License: Commercial / PolyForm Noncommercial](https://img.shields.io/badge/License-Commercial%20%7C%20PolyForm%20Noncommercial%201.0.0-amber)](./COMMERCIAL-LICENSE.md)
[![Automated Checks](https://img.shields.io/badge/Compliance%20Suite-65%2F65%20Passing-brightgreen)](./validate-all.ps1)
[![Release](https://img.shields.io/badge/Release-v2.0.0-informational)](./ARCHITECTURE-ROADMAP.md)

A production-grade suite of **9 parameterized Infrastructure-as-Code (IaC), Enterprise Routing, SIEM Threat Detection, Hybrid Cloud, Kubernetes Platform, SRE Observability, DevSecOps Supply-Chain, and Zero-Trust IT/OT Security blueprints** architected by **Adam Dryden ([`@Phlotonic`](https://github.com/Phlotonic))**.

Every module is engineered as a **self-validating, reusable reference architecture** comprising:
1. **Declarative Parameterization & Code Generation** (`template-variables.json`, `render-template.ps1`, and root orchestrator [`render-all.ps1`](./render-all.ps1))
2. **Automated Security & Compliance Verification** (`validate-lab.ps1` per module, root [`validate-all.ps1`](./validate-all.ps1), and continuous GitHub Actions verification via [`compliance-audit.yml`](./.github/workflows/compliance-audit.yml))
3. **Executive Architecture & FinOps Documentation** (`README.md` with Mermaid topology diagrams, design rationale, FinOps cost profiles, and operational runbooks)

---

## Reference Architecture Matrix (`v2.0.0` — 9 Modules)

| Module | Engineering Domain | Core Architecture & Security Controls | Audit Status | Architecture Guide |
| :--- | :--- | :--- | :--- | :--- |
| [`01-ccna-corporate-network`](./01-ccna-corporate-network) | **Enterprise WAN & Campus Routing**<br/>Cisco IOS / OSPF / L3 Switching | Dual-site OSPF Area 0 point-to-point WAN, Catalyst L3 Switch SVIs (4 segmented VLANs), inbound extended Guest Wi-Fi isolation ACLs, SSHv2-only control plane | **Verified (`9/9`)** | [`README.md`](./01-ccna-corporate-network/README.md) |
| [`02-security-plus-wazuh-soc`](./02-security-plus-wazuh-soc) | **SIEM Detection Engineering & SOC**<br/>Wazuh / Sysmon / MITRE ATT&CK | Wazuh 4.9 SIEM + Windows Sysmon EventChannel ingestion, custom PCRE2 detection rules (`T1059.001`, `T1003.001`, `T1547.001`), Atomic Red Team validation harness, Incident Triage Playbook | **Verified (`7/7`)** | [`README.md`](./02-security-plus-wazuh-soc/README.md) |
| [`03-azure-az104-hybrid-vnet`](./03-azure-az104-hybrid-vnet) | **Multi-Region Azure Landing Zone**<br/>Azure Bicep / Entra ID / Key Vault | Global VNet Peering (`eastus` <-> `westus2`), zero-public-IP workload VM behind Azure Bastion Standard, Key Vault RBAC with Managed Identity, Entra ID Conditional Access MFA | **Verified (`7/7`)** | [`README.md`](./03-azure-az104-hybrid-vnet/README.md) |
| [`04-aws-saa-three-tier-ha`](./04-aws-saa-three-tier-ha) | **High-Availability Cloud Architecture**<br/>AWS CloudFormation / ALB / ASG / RDS | 2-AZ, 3-Tier VPC (Public ALB, Private NGINX Auto Scaling Group with `/healthz` ELB checks, Isolated Multi-AZ RDS MySQL) + automated EC2 termination chaos failover drill | **Verified (`7/7`)** | [`README.md`](./04-aws-saa-three-tier-ha/README.md) |
| [`05-terraform-modular-pipeline`](./05-terraform-modular-pipeline) | **Modular IaC & Keyless CI/CD**<br/>HashiCorp Terraform / GitHub Actions | Reusable `networking`, `security`, and `compute` modules, encrypted S3 + DynamoDB state locking, IMDSv2 enforcement, and GitHub Actions OIDC speculative plan pipeline | **Verified (`7/7`)** | [`README.md`](./05-terraform-modular-pipeline/README.md) |
| [`06-cka-kubernetes-chaos-cluster`](./06-cka-kubernetes-chaos-cluster) | **Bare-Metal Kubernetes & SRE**<br/>`kubeadm` v1.31 / Calico CNI / `crictl` | 3-node cluster bootstrap (`SystemdCgroup = true`), Calico CNI zero-trust `NetworkPolicy` micro-segmentation, NGINX Ingress, PersistentVolume, and 3 control-plane/PKI recovery runbooks | **Verified (`7/7`)** | [`README.md`](./06-cka-kubernetes-chaos-cluster/README.md) |
| [`07-sre-observability-golden-signals`](./07-sre-observability-golden-signals) | **Full-Stack SRE Observability & SLOs**<br/>Prometheus / Grafana / Loki / Alertmanager | Pre-computed Four Golden Signals (`p99` Latency, Traffic, Errors, Saturation) and Google SRE multi-window, multi-burn-rate (`14.4x` / `6.0x`) 99.9% SLO alerting | **Verified (`7/7`)** | [`README.md`](./07-sre-observability-golden-signals/README.md) |
| [`08-cks-devsecops-gitops-supply-chain`](./08-cks-devsecops-gitops-supply-chain) | **Kubernetes Security (CKS) & GitOps**<br/>ArgoCD / Kyverno / Trivy SBOM / Cosign | ArgoCD automated self-healing GitOps (`selfHeal: true`, `prune: true`), Trivy CVE gate + CycloneDX SBOM, Sigstore Cosign keyless OIDC signing, and Kyverno non-root admission enforcement | **Verified (`7/7`)** | [`README.md`](./08-cks-devsecops-gitops-supply-chain/README.md) |
| [`09-zero-trust-secops-vault-autoremediation-ot`](./09-zero-trust-secops-vault-autoremediation-ot) | **Zero-Trust SecOps & IT/OT Conduit**<br/>Ansible CIS / Vault / AWS CSPM / IEC 62443 | Ansible CIS Level 1 Linux hardening, HashiCorp Vault 1h ephemeral DB leases, `<5s` EventBridge/Lambda S3 public-access auto-remediation, and WireGuard + MQTT TLS 1.3 mTLS OT DMZ conduit | **Verified (`7/7`)** | [`README.md`](./09-zero-trust-secops-vault-autoremediation-ot/README.md) |

---

## Automated Code Generation & Compliance Suite

Render customized templates from `template-variables.json` and execute the 65-check verification suite across all nine modules in two commands:

```powershell
# 1. Interpolate template-variables.json across all 9 modules
powershell -NoProfile -ExecutionPolicy Bypass -File .\render-all.ps1

# 2. Run the 65-check security, syntax, and commercial IP compliance audit
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
