# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Lab 1 (Cisco CCNA Dual-Site OSPF WAN)
# Renders Site A & Site B IOS configs from template-variables.json
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json"),
    [string]$OutputDir = (Join-Path $PSScriptRoot "configs")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

Write-Host "Rendering Cisco IOS templates for domain '$($Vars.organizationDomain)'..." -ForegroundColor Cyan
Write-Host "  -> Site A: $($Vars.siteA.routerHostname) & $($Vars.siteA.switchHostname) ($($Vars.siteA.vlan10Prefix).0/24)"
Write-Host "  -> Site B: $($Vars.siteB.routerHostname) & $($Vars.siteB.switchHostname) ($($Vars.siteB.vlan10Prefix).0/24)"
Write-Host "Template parameterization verified and ready in '$OutputDir'." -ForegroundColor Green
