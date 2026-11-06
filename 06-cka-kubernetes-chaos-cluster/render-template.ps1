# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 06 (Kubernetes CKA Cluster)
# Dynamically synchronizes template-variables.json into K8s manifests
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$WorkloadsFile = Join-Path $PSScriptRoot "cluster-workloads.yaml"
if (Test-Path $WorkloadsFile) {
    $Raw = Get-Content $WorkloadsFile -Raw
    $Updated = $Raw -replace "storage: \d+Gi", "storage: $($Vars.persistentVolumeSize)" `
                    -replace "- host: \S+", "- host: $($Vars.ingressHost)"
    Set-Content -Path $WorkloadsFile -Value $Updated -NoNewline
}

Write-Host "[MOD-06] Rendered Kubernetes CKA manifests for host '$($Vars.ingressHost)' and storage '$($Vars.persistentVolumeSize)'." -ForegroundColor Green
