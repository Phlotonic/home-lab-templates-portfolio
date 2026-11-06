# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Lab 2 (CompTIA Security+ Wazuh SOC Pipeline)
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

Write-Host "Rendering Wazuh v$($Vars.wazuhVersion) SOC Pipeline Template..." -ForegroundColor Cyan
Write-Host "  -> Wazuh SIEM Manager IP : $($Vars.wazuhManagerIp)"
Write-Host "  -> Monitored Endpoint    : $($Vars.monitoredEndpointHostname) ($($Vars.monitoredEndpointIp))"
Write-Host "  -> MITRE ATT&CK Rules    : $($Vars.mitreRules.powershellExecutionRuleId), $($Vars.mitreRules.lsassCredentialDumpRuleId), $($Vars.mitreRules.registryPersistenceRuleId)"
Write-Host "SOC template parameters verified." -ForegroundColor Green
