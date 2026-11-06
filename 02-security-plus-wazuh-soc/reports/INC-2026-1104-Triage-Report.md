# SOC Incident Triage Report: `INC-2026-1104`

**Required Notice:** Copyright (c) 2026 Adam Dryden (`Phlotonic`) — Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.

| Field | Value |
| :--- | :--- |
| **Incident ID** | `INC-2026-1104` |
| **Severity Classification** | **CRITICAL (Severity 15 — Credential Access & Persistence)** |
| **Affected Endpoint** | `WKSTN-FIN-04` (`10.10.10.42`, Wazuh Agent ID `004`) |
| **Compromised Account** | `CORP\jdoe` |
| **Detection Window** | `2026-11-04 14:12:04 UTC` – `14:16:49 UTC` |
| **Telemetry Source** | `Microsoft-Windows-Sysmon/Operational` -> Wazuh SIEM Manager (`10.10.99.10`) |

---

## 1. Executive Summary
On `2026-11-04` between `14:12:04 UTC` and `14:16:49 UTC`, the Wazuh SIEM correlation engine generated three high-severity alerts (`Rule 100101`, `Rule 100102`, and `Rule 100103`) originating from monitored Windows endpoint `WKSTN-FIN-04` (`10.10.10.42`, Agent ID `004`). Telemetry ingested from `Microsoft-Windows-Sysmon/Operational` confirmed a multi-stage intrusion sequence beginning with obfuscated PowerShell command execution, escalating to an LSASS process memory dump via `rundll32.exe` and `comsvcs.dll`, and culminating in user-level Registry Run key persistence.

---

## 2. Alert Telemetry & MITRE ATT&CK Correlation Matrix

| Stage | Timestamp (UTC) | Wazuh Rule & Level | MITRE ATT&CK Technique | Sysmon Event Evidence |
| :--- | :--- | :--- | :--- | :--- |
| **1. Execution** | `14:12:04 UTC` | `Rule 100101` (Level 12) | **T1059.001** — PowerShell | **Sysmon Event ID 1 (ProcessCreate):** `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` spawned with `-EncodedCommand` flags executing an in-memory script under `CORP\jdoe`. |
| **2. Credential Access** | `14:14:22 UTC` | `Rule 100102` (Level 15) | **T1003.001** — OS Credential Dumping: LSASS Memory | **Sysmon Event ID 1 & 10 (ProcessAccess `0x1fffff`):** `rundll32.exe C:\windows\System32\comsvcs.dll, MiniDump 684 C:\Windows\Temp\lsass-dump.bin full` targeting `lsass.exe`. |
| **3. Persistence** | `14:16:49 UTC` | `Rule 100103` (Level 13) | **T1547.001** — Boot/Logon Autostart: Registry Run Keys | **Sysmon Event ID 13 (RegistryEvent Value Set):** `reg.exe` wrote payload path `C:\Users\Public\updater.exe` into `HKCU\Software\Microsoft\Windows\CurrentVersion\Run\AtomicRedTeam`. |

---

## 3. Production Containment, Eradication, and Recovery Playbook

1. **Immediate Network Containment (0–15 Minutes):**
   - Isolate `WKSTN-FIN-04` (`10.10.10.42`) at the switch port or Wazuh active-response firewall layer while preserving TCP port `1514/1515` management communication to the Wazuh Manager (`10.10.99.10`) for live forensics.
2. **Identity & Credential Containment (15–30 Minutes):**
   - Because `lsass.exe` memory was targeted (`T1003.001`), immediately revoke active Kerberos TGTs and Microsoft Entra ID refresh tokens for `CORP\jdoe` and any local administrator accounts cached on `WKSTN-FIN-04`.
   - Force password resets and audit lateral authentication events (`Event ID 4624` Logon Type `3` and `10`) across all domain controllers.
3. **Eradication & Hardening:**
   - Remove the rogue Registry Run value (`HKCU\...\CurrentVersion\Run\AtomicRedTeam`).
   - Acquire SHA-256 hashes of `C:\Windows\Temp\lsass-dump.bin` and `C:\Users\Public\updater.exe`, then securely delete both artifacts.
   - Enable **Windows Credential Guard** (`LsaCfgFlags = 1`) and Microsoft Defender ASR rule `9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2` to block credential stealing from `lsass.exe`.
   - Enforce **PowerShell Constrained Language Mode** and enable Script Block Logging (`Event ID 4104`).
