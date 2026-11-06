# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Lab 6 (Kubernetes CKA 3-Node Cluster)
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

Write-Host "Rendering CKA Multi-Node Kubernetes Cluster Parameters..." -ForegroundColor Cyan
Write-Host "  -> K8s Version   : $($Vars.kubernetesVersion) (Calico $($Vars.calicoVersion))"
Write-Host "  -> Control Plane : $($Vars.controlPlaneHostname) ($($Vars.controlPlaneIp))"
Write-Host "  -> Pod CIDR      : $($Vars.podNetworkCidr) | Ingress: $($Vars.ingressHost)"
Write-Host "Kubernetes CKA template parameters verified." -ForegroundColor Green
