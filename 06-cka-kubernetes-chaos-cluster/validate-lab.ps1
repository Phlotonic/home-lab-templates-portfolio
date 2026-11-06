# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Lab 6 (CKA)
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile  = Join-Path $PSScriptRoot "template-variables.json"
$Bootstrap = Join-Path $PSScriptRoot "bootstrap-kubeadm.sh"
$Workloads = Join-Path $PSScriptRoot "cluster-workloads.yaml"
$Runbook   = Join-Path $PSScriptRoot "CKA-Break-Fix-Runbook.md"

$BootContent = Get-Content $Bootstrap -Raw
$WorkContent = Get-Content $Workloads -Raw
$RunContent  = Get-Content $Runbook -Raw

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present"; Passed = (($BootContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($WorkContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($RunContent -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable Kubernetes CKA Parameters (template-variables.json)"; Passed = (Test-Path $VarsFile) },
    @{ Name = "Containerd Configured with SystemdCgroup = true & Swap Disabled"; Passed = (($BootContent -match "swapoff -a") -and ($BootContent -match "SystemdCgroup = true")) },
    @{ Name = "Calico CNI & Bare-Metal NGINX Ingress Installed on Control Plane"; Passed = (($BootContent -match "calico\.yaml") -and ($BootContent -match "ingress-nginx")) },
    @{ Name = "PersistentVolume (5Gi), PVC, Deployment, Service & Ingress Defined"; Passed = (($WorkContent -match "kind: PersistentVolume") -and ($WorkContent -match "kind: PersistentVolumeClaim") -and ($WorkContent -match "kind: Ingress")) },
    @{ Name = "Zero-Trust NetworkPolicy Isolates 'backend' to 'tier: frontend'"; Passed = (($WorkContent -match "kind: NetworkPolicy") -and ($WorkContent -match "isolate-backend-namespace") -and ($WorkContent -match "tier: frontend")) },
    @{ Name = "3-Drill CKA Break/Fix Chaos Runbook (API Server, Kubelet & PKI Certs)"; Passed = (($RunContent -match "Drill 1") -and ($RunContent -match "Drill 2") -and ($RunContent -match "Drill 3") -and ($RunContent -match "kubeadm certs renew all")) }
)

Write-Host "`n=== Lab 6 (Kubernetes CKA) Cluster & Chaos Runbook Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Lab 6 Kubernetes CKA checks failed."
    exit 1
}
Write-Host "`nAll 7 Kubernetes CKA bootstrap, NetworkPolicy, and chaos runbook checks passed!" -ForegroundColor Green
