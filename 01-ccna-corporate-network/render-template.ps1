# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 01 (Cisco CCNA Dual-Site OSPF WAN)
# Dynamically interpolates template-variables.json into IOS configs
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json"),
    [string]$OutputDir = (Join-Path $PSScriptRoot "configs")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

foreach ($CfgFile in @("site-a-hq.txt", "site-b-branch.txt")) {
    $Target = Join-Path $OutputDir $CfgFile
    if (Test-Path $Target) {
        $Raw = Get-Content $Target -Raw
        $Updated = $Raw -replace 'ip domain-name \S+', "ip domain-name $($Vars.organizationDomain)" `
                        -replace 'username \S+ privilege 15', "username $($Vars.adminUsername) privilege 15"
        Set-Content -Path $Target -Value $Updated -NoNewline
    }
}

Write-Host "[MOD-01] Rendered Cisco IOS configurations for domain '$($Vars.organizationDomain)' in '$OutputDir'." -ForegroundColor Green
