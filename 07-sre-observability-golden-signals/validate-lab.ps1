# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Module 07
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile = Join-Path $PSScriptRoot "template-variables.json"
$PromFile = Join-Path $PSScriptRoot "prometheus.yml"
$SloFile  = Join-Path $PSScriptRoot "slo-recording-rules.yml"
$CompFile = Join-Path $PSScriptRoot "docker-compose-observability.yml"
$Readme   = Join-Path $PSScriptRoot "README.md"

$PromContent = Get-Content $PromFile -Raw
$SloContent  = Get-Content $SloFile -Raw
$CompContent = Get-Content $CompFile -Raw

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present"; Passed = (($PromContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($SloContent -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable SRE Observability Parameters (template-variables.json & README.md)"; Passed = ((Test-Path $VarsFile) -and (Test-Path $Readme)) },
    @{ Name = "Prometheus Scrape & Alertmanager Integration Configured"; Passed = (($PromContent -match "slo-recording-rules\.yml") -and ($PromContent -match "alertmanager:9093")) },
    @{ Name = "Four Golden Signals Recorded (Latency p99, Traffic, Errors, Saturation)"; Passed = (($SloContent -match "histogram_quantile\(0\.99") -and ($SloContent -match "rate5m") -and ($SloContent -match "node_memory_utilization")) },
    @{ Name = "Multi-Window Fast-Burn Alert (14.4x over 1h & 5m) Configured"; Passed = (($SloContent -match "HighErrorBudgetBurnPage") -and ($SloContent -match "14\.4 \* 0\.001")) },
    @{ Name = "Multi-Window Slow-Burn Alert (6.0x over 6h & 30m) Configured"; Passed = (($SloContent -match "ModerateErrorBudgetBurnTicket") -and ($SloContent -match "6\.0 \* 0\.001")) },
    @{ Name = "Turnkey Prometheus, Grafana, Loki & Alertmanager Stack Defined"; Passed = (($CompContent -match "prom/prometheus") -and ($CompContent -match "grafana/loki") -and ($CompContent -match "grafana/grafana")) }
)

Write-Host "`n=== Module 07 (SRE Golden-Signal Observability & SLOs) Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Module 07 SRE Observability checks failed."
    exit 1
}
Write-Host "`nAll 7 SRE Golden-Signal Observability & Multi-Window SLO checks passed!" -ForegroundColor Green
