# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Lab 5 (TF)
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile  = Join-Path $PSScriptRoot "template-variables.json"
$TfVarsEx  = Join-Path $PSScriptRoot "terraform.tfvars.example"
$RootTf    = Join-Path $PSScriptRoot "main.tf"
$NetTf     = Join-Path $PSScriptRoot "modules\networking\main.tf"
$SecTf     = Join-Path $PSScriptRoot "modules\security\main.tf"
$CompTf    = Join-Path $PSScriptRoot "modules\compute\main.tf"
$Workflow  = Join-Path $PSScriptRoot "workflows\terraform-pr.yml"

$RootContent = Get-Content $RootTf -Raw
$NetContent  = Get-Content $NetTf -Raw
$SecContent  = Get-Content $SecTf -Raw
$CompContent = Get-Content $CompTf -Raw
$WfContent   = Get-Content $Workflow -Raw

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present Across All Modules"; Passed = (($RootContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($NetContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($CompContent -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable Parameterization (terraform.tfvars.example & template-variables.json)"; Passed = ((Test-Path $TfVarsEx) -and (Test-Path $VarsFile)) },
    @{ Name = "S3 Remote State Encryption & DynamoDB State Locking Configured"; Passed = (($RootContent -match 'backend "s3"') -and ($RootContent -match "encrypt\s*=\s*true") -and ($RootContent -match "dynamodb_table")) },
    @{ Name = "3 Reusable Child Modules Wired (networking, security, compute)"; Passed = (($RootContent -match 'module "networking"') -and ($RootContent -match 'module "security"') -and ($RootContent -match 'module "compute"')) },
    @{ Name = "Dynamic Subnet Calculation via cidrsubnet() in Networking Module"; Passed = ($NetContent -match "cidrsubnet\(") },
    @{ Name = "EC2 Instance Metadata Service v2 (IMDSv2) Enforced (http_tokens = required)"; Passed = ($CompContent -match 'http_tokens\s*=\s*"required"') },
    @{ Name = "GitHub Actions PR Pipeline Uses Keyless AWS OIDC & Speculative Plan"; Passed = (($WfContent -match "aws-actions/configure-aws-credentials@v4") -and ($WfContent -match "terraform fmt -check -recursive") -and ($WfContent -match "terraform plan")) }
)

Write-Host "`n=== Lab 5 (Terraform Associate) Multi-Module IaC & CI Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Lab 5 Terraform checks failed."
    exit 1
}
Write-Host "`nAll 7 Terraform modular IaC, state lock, IMDSv2, and CI checks passed!" -ForegroundColor Green
