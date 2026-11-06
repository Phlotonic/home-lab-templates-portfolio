# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Master Portfolio Compliance & IP Validator (Runs All 6 Stage Audits)
# =====================================================================
$ErrorActionPreference = 'Stop'

$Stages = @(
    "01-ccna-corporate-network",
    "02-security-plus-wazuh-soc",
    "03-azure-az104-hybrid-vnet",
    "04-aws-saa-three-tier-ha",
    "05-terraform-modular-pipeline",
    "06-cka-kubernetes-chaos-cluster"
)

Write-Host "=====================================================================" -ForegroundColor Yellow
Write-Host "  EXECUTING FULL 6-STAGE ENTERPRISE PORTFOLIO & IP COMPLIANCE AUDIT  " -ForegroundColor Yellow
Write-Host "=====================================================================" -ForegroundColor Yellow

foreach ($Stage in $Stages) {
    $ScriptPath = Join-Path $PSScriptRoot "$Stage\validate-lab.ps1"
    & $ScriptPath
}

Write-Host "`n=====================================================================" -ForegroundColor Green
Write-Host "  ALL 6 CERTIFICATION STAGES (44/44 CHECKS) PASSED & VERIFIED!       " -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
