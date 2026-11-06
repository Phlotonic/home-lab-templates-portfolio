# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 03 (Azure AZ-104 Hybrid VNet)
# Dynamically synchronizes template-variables.json into main.bicep
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$BicepFile = Join-Path $PSScriptRoot "main.bicep"
if (Test-Path $BicepFile) {
    $Raw = Get-Content $BicepFile -Raw
    $Updated = $Raw -replace "param primaryLocation string = '\S+'", "param primaryLocation string = '$($Vars.primaryLocation)'" `
                    -replace "param secondaryLocation string = '\S+'", "param secondaryLocation string = '$($Vars.secondaryLocation)'" `
                    -replace "param adminUsername string = '\S+'", "param adminUsername string = '$($Vars.adminUsername)'" `
                    -replace "vmSize: '\S+'", "vmSize: '$($Vars.vmSize)'"
    Set-Content -Path $BicepFile -Value $Updated -NoNewline
}

Write-Host "[MOD-03] Rendered Azure Bicep template for regions '$($Vars.primaryLocation)' <-> '$($Vars.secondaryLocation)'." -ForegroundColor Green
