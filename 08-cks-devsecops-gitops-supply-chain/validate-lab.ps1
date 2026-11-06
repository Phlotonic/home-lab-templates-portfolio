# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Module 08
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile = Join-Path $PSScriptRoot "template-variables.json"
$ArgoFile = Join-Path $PSScriptRoot "argocd-application.yaml"
$KyvFile  = Join-Path $PSScriptRoot "kyverno-cluster-policies.yaml"
$CiFile   = Join-Path $PSScriptRoot "supply-chain-ci.yml"
$Readme   = Join-Path $PSScriptRoot "README.md"

$ArgoContent = Get-Content $ArgoFile -Raw
$KyvContent  = Get-Content $KyvFile -Raw
$CiContent   = Get-Content $CiFile -Raw

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present"; Passed = (($ArgoContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($KyvContent -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable CKS Supply-Chain Parameters (template-variables.json & README.md)"; Passed = ((Test-Path $VarsFile) -and (Test-Path $Readme)) },
    @{ Name = "ArgoCD Automated GitOps Sync (selfHeal: true & prune: true) Configured"; Passed = (($ArgoContent -match "selfHeal: true") -and ($ArgoContent -match "prune: true")) },
    @{ Name = "Kyverno Admission Policy Enforces Non-Root & Read-Only Root Filesystem"; Passed = (($KyvContent -match "validationFailureAction: Enforce") -and ($KyvContent -match "runAsNonRoot: true") -and ($KyvContent -match "readOnlyRootFilesystem: true")) },
    @{ Name = "Kyverno Admission Policy Drops ALL Linux Capabilities & Disallows Privileged"; Passed = (($KyvContent -match "privileged: false") -and ($KyvContent -match "allowPrivilegeEscalation: false") -and ($KyvContent -match "- ALL")) },
    @{ Name = "Sigstore Cosign Keyless OIDC Image Verification Policy Enforced"; Passed = (($KyvContent -match "verifyImages:") -and ($KyvContent -match "rekor\.sigstore\.dev")) },
    @{ Name = "Trivy CRITICAL/HIGH CVE Gate & CycloneDX SBOM Pipeline Included"; Passed = (($CiContent -match "aquasecurity/trivy-action") -and ($CiContent -match "cyclonedx") -and ($CiContent -match "sigstore/cosign-installer")) }
)

Write-Host "`n=== Module 08 (CKS DevSecOps, GitOps & Admission Control) Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Module 08 CKS DevSecOps checks failed."
    exit 1
}
Write-Host "`nAll 7 CKS DevSecOps, ArgoCD GitOps, Trivy SBOM & Kyverno Admission checks passed!" -ForegroundColor Green
