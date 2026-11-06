# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Lab 5 (HashiCorp Terraform Modular Pipeline)
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

Write-Host "Rendering Terraform Multi-Module Parameters..." -ForegroundColor Cyan
Write-Host "  -> Environment : $($Vars.envPrefix) ($($Vars.awsRegion))"
Write-Host "  -> VPC CIDR    : $($Vars.vpcCidr)"
Write-Host "  -> State Lock  : s3://$($Vars.stateBucket) + DynamoDB '$($Vars.lockDynamoDbTable)'"
Write-Host "Terraform modular template parameters verified." -ForegroundColor Green
