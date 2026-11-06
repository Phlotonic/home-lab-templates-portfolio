# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Lab 2 (Sec+)
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile   = Join-Path $PSScriptRoot "template-variables.json"
$DeploySh   = Join-Path $PSScriptRoot "deploy-soc.sh"
$SysmonPs1  = Join-Path $PSScriptRoot "install-sysmon-agent.ps1"
$RulesXml   = Join-Path $PSScriptRoot "rules\local_rules.xml"
$AtomicPs1  = Join-Path $PSScriptRoot "run-atomic-tests.ps1"
$ReportMd   = Join-Path $PSScriptRoot "reports\INC-2026-1104-Triage-Report.md"

$RulesContent  = Get-Content $RulesXml -Raw
$ReportContent = Get-Content $ReportMd -Raw
[xml]$ParsedXml = $RulesContent

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present"; Passed = (($RulesContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($ReportContent -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable SOC Template Parameters (template-variables.json)"; Passed = (Test-Path $VarsFile) },
    @{ Name = "Wazuh Server & Sysmon Endpoint Provisioning Scripts Present"; Passed = ((Test-Path $DeploySh) -and (Test-Path $SysmonPs1)) },
    @{ Name = "Valid Wazuh XML Detection Rules Syntax (local_rules.xml)"; Passed = ($null -ne $ParsedXml.group.rule -and $ParsedXml.group.rule.Count -eq 3) },
    @{ Name = "MITRE ATT&CK Rules Mapped (T1059.001, T1003.001, T1547.001)"; Passed = (($RulesContent -match "T1059\.001") -and ($RulesContent -match "T1003\.001") -and ($RulesContent -match "T1547\.001")) },
    @{ Name = "Atomic Red Team Emulation & Cleanup Script Present"; Passed = ((Test-Path $AtomicPs1) -and ((Get-Content $AtomicPs1 -Raw) -match "-Cleanup")) },
    @{ Name = "SOC Incident Triage Report Includes Containment & Eradication Playbook"; Passed = ($ReportContent -match "Immediate Network Containment" -and $ReportContent -match "Credential Guard") }
)

Write-Host "`n=== Lab 2 (CompTIA Security+) Wazuh SOC & MITRE ATT&CK Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Lab 2 SOC checks failed."
    exit 1
}
Write-Host "`nAll 7 Wazuh SIEM, Sysmon, and MITRE ATT&CK validation checks passed!" -ForegroundColor Green
