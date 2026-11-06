# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 08 (CKS DevSecOps & GitOps)
# Dynamically interpolates template-variables.json into ArgoCD & Kyverno
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$ArgoFile = Join-Path $PSScriptRoot "argocd-application.yaml"
if (Test-Path $ArgoFile) {
    $Raw = Get-Content $ArgoFile -Raw
    $Updated = $Raw -replace "name: zero-trust-\S+", "name: $($Vars.applicationName)" `
                    -replace "namespace: production-\S+", "namespace: $($Vars.targetNamespace)" `
                    -replace "targetRevision: \S+", "targetRevision: $($Vars.targetRevision)"
    Set-Content -Path $ArgoFile -Value $Updated -NoNewline
}

Write-Host "[MOD-08] Rendered CKS GitOps & Kyverno Admission templates for '$($Vars.applicationName)' in namespace '$($Vars.targetNamespace)'." -ForegroundColor Green
