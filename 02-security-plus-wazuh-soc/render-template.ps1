# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 02 (Wazuh SIEM & Sysmon SOC)
# Dynamically synchronizes template-variables.json across SOC rules
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$DeployScript = Join-Path $PSScriptRoot "deploy-soc.sh"
if (Test-Path $DeployScript) {
    $Raw = Get-Content $DeployScript -Raw
    $Updated = $Raw -replace 'packages\.wazuh\.com/[0-9.]+/', "packages.wazuh.com/$($Vars.wazuhVersion)/"
    Set-Content -Path $DeployScript -Value $Updated -NoNewline
}

Write-Host "[MOD-02] Rendered Wazuh v$($Vars.wazuhVersion) SOC pipeline artifacts for manager '$($Vars.wazuhManagerIp)'." -ForegroundColor Green
