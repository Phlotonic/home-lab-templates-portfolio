# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 07 (SRE Golden-Signal Observability)
# Dynamically interpolates template-variables.json into Prometheus configs
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$PromFile = Join-Path $PSScriptRoot "prometheus.yml"
if (Test-Path $PromFile) {
    $Raw = Get-Content $PromFile -Raw
    $Updated = $Raw -replace "scrape_interval: \S+", "scrape_interval: $($Vars.scrapeInterval)" `
                    -replace "evaluation_interval: \S+", "evaluation_interval: $($Vars.evaluationInterval)" `
                    -replace "service: '\S+'", "service: '$($Vars.serviceName)'"
    Set-Content -Path $PromFile -Value $Updated -NoNewline
}

Write-Host "[MOD-07] Rendered SRE Observability & SLO configs for service '$($Vars.serviceName)' (SLO Target: $($Vars.sloAvailabilityTarget))." -ForegroundColor Green
