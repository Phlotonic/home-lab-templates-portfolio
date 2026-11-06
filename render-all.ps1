# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Master Template Renderer — Interpolates template-variables.json Across All 9 Modules
# =====================================================================
$ErrorActionPreference = 'Stop'

$Modules = @(
    "01-ccna-corporate-network",
    "02-security-plus-wazuh-soc",
    "03-azure-az104-hybrid-vnet",
    "04-aws-saa-three-tier-ha",
    "05-terraform-modular-pipeline",
    "06-cka-kubernetes-chaos-cluster",
    "07-sre-observability-golden-signals",
    "08-cks-devsecops-gitops-supply-chain",
    "09-zero-trust-secops-vault-autoremediation-ot"
)

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "  RENDERING PARAMETERIZED TEMPLATES ACROSS ALL 9 ENTERPRISE MODULES  " -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan

foreach ($Mod in $Modules) {
    $RenderScript = Join-Path $PSScriptRoot "$Mod\render-template.ps1"
    & $RenderScript
}

Write-Host "`nAll 9 enterprise modules rendered from template-variables.json!" -ForegroundColor Green
