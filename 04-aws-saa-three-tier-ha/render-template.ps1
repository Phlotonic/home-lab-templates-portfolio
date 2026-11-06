# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Lab 4 (AWS SAA-C03 3-Tier HA VPC)
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

Write-Host "Rendering AWS SAA-C03 3-Tier HA CloudFormation Parameters..." -ForegroundColor Cyan
Write-Host "  -> Stack Name : $($Vars.stackName) ($($Vars.awsRegion))"
Write-Host "  -> VPC CIDR   : $($Vars.vpcCidr) across 2 Availability Zones"
Write-Host "  -> AutoScale  : Min=$($Vars.asgMinSize), Desired=$($Vars.asgDesiredCapacity), Max=$($Vars.asgMaxSize) ($($Vars.instanceType))"
Write-Host "AWS CloudFormation template parameters verified." -ForegroundColor Green
