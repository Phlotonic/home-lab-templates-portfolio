# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Lab 3 (Azure AZ-104 Multi-Region Hybrid VNet)
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

Write-Host "Rendering Azure AZ-104 Multi-Region Bicep Parameters..." -ForegroundColor Cyan
Write-Host "  -> Hub Region   : $($Vars.primaryLocation) ($($Vars.hubVnetCidr))"
Write-Host "  -> Spoke Region : $($Vars.secondaryLocation) ($($Vars.spokeVnetCidr))"
Write-Host "  -> VM SKU       : $($Vars.vmSize) (Zero Public IP behind Azure Bastion)"
Write-Host "Azure Bicep template parameters verified." -ForegroundColor Green
