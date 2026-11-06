# Cascading R&D Portfolio Autopilot — Control Center

> [!TIP]
> **Morning Wake-Up Brief (Latest Run: Stage 1 + Commercial Dual-License Completed)**
> - **What Was Built & Protected:**
>   - **Commercial Dual-Licensing:** [`LICENSE`](file:///c:/Users/adryd/OneDrive/Documents/Adam/Work/Home%20Lab%20Templates%20Portfolio/LICENSE) (PolyForm Noncommercial 1.0.0 for recruiters/personal evaluation) + [`COMMERCIAL-LICENSE.md`](file:///c:/Users/adryd/OneDrive/Documents/Adam/Work/Home%20Lab%20Templates%20Portfolio/COMMERCIAL-LICENSE.md) (3 paid tiers: \$299 Single-Company, \$999 MSP Multi-Client, and Custom Enterprise/Consulting Retainer).
>   - **Stage 1 Reusable Template (`01-ccna-corporate-network`):** Parameterized via [`template-variables.json`](file:///c:/Users/adryd/OneDrive/Documents/Adam/Work/Home%20Lab%20Templates%20Portfolio/01-ccna-corporate-network/template-variables.json) and [`render-template.ps1`](file:///c:/Users/adryd/OneDrive/Documents/Adam/Work/Home%20Lab%20Templates%20Portfolio/01-ccna-corporate-network/render-template.ps1), stamped with copyright headers, and verified (`9/9` checks passing in [`validate-lab.ps1`](file:///c:/Users/adryd/OneDrive/Documents/Adam/Work/Home%20Lab%20Templates%20Portfolio/01-ccna-corporate-network/validate-lab.ps1)).
>   - **Plain-English Interview Guide:** [`01-ccna-corporate-network/EXPLAIN-IT-SIMPLY.md`](file:///c:/Users/adryd/OneDrive/Documents/Adam/Work/Home%20Lab%20Templates%20Portfolio/01-ccna-corporate-network/EXPLAIN-IT-SIMPLY.md)
> - **Up Next (Next 2:00 AM Run):** Stage 2 (`02-security-plus-wazuh-soc` — CompTIA Security+ Wazuh SIEM, Sysmon Telemetry, Atomic Red Team scripts, Incident Triage Report, reusable template parameters, and automatic GitHub push).

---

## 1. Cascading 6-Lab R&D Status Matrix

| Stage | Folder | Certification & Target Role | Status | Key Reusable Deliverables | Plain-English Guide |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Stage 1** | `01-ccna-corporate-network` | **Cisco CCNA (200-301)**<br/>Remote Network / NOC Engineer | **Completed & Verified** | `template-variables.json`, `render-template.ps1`, `configs/site-a-hq.txt`, `configs/site-b-branch.txt`, `validate-lab.ps1` | [`EXPLAIN-IT-SIMPLY.md`](file:///c:/Users/adryd/OneDrive/Documents/Adam/Work/Home%20Lab%20Templates%20Portfolio/01-ccna-corporate-network/EXPLAIN-IT-SIMPLY.md) |
| **Stage 2** | `02-security-plus-wazuh-soc` | **CompTIA Security+**<br/>Remote SOC Analyst Tier 1 | **Next Up (Queued for 2:00 AM)** | `template-variables.json`, `render-template.ps1`, `deploy-soc.sh`, `local_rules.xml`, `run-atomic-tests.ps1`, `INC-2026-1104-Triage-Report.md`, `validate-lab.ps1` | *Will be generated next run* |
| **Stage 3** | `03-azure-az104-hybrid-vnet` | **Microsoft Azure AZ-104**<br/>Remote Azure Administrator | **Pending Cascade** | `template-variables.json`, `main.bicep`, `configure-entra-and-secrets.sh`, `validate-lab.ps1` | *Pending* |
| **Stage 4** | `04-aws-saa-three-tier-ha` | **AWS SAA-C03**<br/>Remote Cloud Solutions Architect | **Pending Cascade** | `template-variables.json`, `aws-three-tier-ha.yaml`, `run-failover-drill.sh`, `validate-lab.ps1` | *Pending* |
| **Stage 5** | `05-terraform-modular-pipeline` | **HashiCorp Terraform Associate**<br/>Remote Jr. DevOps / IaC Engineer | **Pending Cascade** | `terraform.tfvars.example`, `main.tf`, `modules/{networking,security,compute}`, `.github/workflows/terraform-pr.yml`, `validate-lab.ps1` | *Pending* |
| **Stage 6** | `06-cka-kubernetes-chaos-cluster` | **Kubernetes CKA**<br/>Remote Platform / SRE Engineer | **Pending Cascade** | `template-variables.json`, `bootstrap-kubeadm.sh`, `cluster-workloads.yaml`, `CKA-Break-Fix-Runbook.md`, `validate-lab.ps1` | *Pending* |

---

## 2. How Your Overnight Autopilot Works

1. **Zero-Effort Overnight Building & GitHub Sync (2:00 AM CST):**
   - While you sleep, the **Cascading R&D Portfolio Autopilot** checks this file.
   - Each night, it advances **one stage** in the table above—writing the parameterized template files, stamping your commercial copyright header, running `validate-lab.ps1`, generating `EXPLAIN-IT-SIMPLY.md`, updating `README.md`, and **automatically committing & pushing to `https://github.com/Phlotonic/home-lab-templates-portfolio`**.
   - Once all 6 stages reach **Completed & Verified**, the automation enters **Zero-Waste Standby Mode** (stopping immediately unless you write a request below or edit a file).
2. **Complementary to Your Work Schedule:**
   - **Sun–Wed (Work Days, 7:30 AM – 6:00 PM):** Zero action needed during your shift. After 6:00 PM, you can spend just 5–10 minutes reading the new `EXPLAIN-IT-SIMPLY.md` pitch built and pushed the night before.
   - **Thu–Sat (Off Days):** Your completed labs, dry-run validation scripts (`validate-lab.ps1`), and step-by-step guides are ready whenever you want to explore or test them hands-on.

---

## 3. My R&D Notes & Requests (Optional Input for Next Overnight Run)
*(Drop any bullet point, question, or customization request below before going to sleep—the 2:00 AM Autopilot will read this section first and build what you asked for!)*

- *(No custom requests currently queued — proceed with cascading Stage 2: `02-security-plus-wazuh-soc` on the next run.)*
