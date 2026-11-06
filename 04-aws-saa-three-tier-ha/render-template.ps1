# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 04 (AWS SAA-C03 3-Tier HA VPC)
# Dynamically synchronizes template-variables.json into CloudFormation
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$CfnFile = Join-Path $PSScriptRoot "aws-three-tier-ha.yaml"
if (Test-Path $CfnFile) {
    $Raw = Get-Content $CfnFile -Raw
    $Updated = $Raw -replace "InstanceType: \S+", "InstanceType: $($Vars.instanceType)" `
                    -replace "DBInstanceClass: \S+", "DBInstanceClass: $($Vars.rdsInstanceClass)" `
                    -replace "MinSize: '\d+'", "MinSize: '$($Vars.asgMinSize)'" `
                    -replace "DesiredCapacity: '\d+'", "DesiredCapacity: '$($Vars.asgDesiredCapacity)'" `
                    -replace "MaxSize: '\d+'", "MaxSize: '$($Vars.asgMaxSize)'"
    Set-Content -Path $CfnFile -Value $Updated -NoNewline
}

Write-Host "[MOD-04] Rendered AWS CloudFormation stack '$($Vars.stackName)' for VPC '$($Vars.vpcCidr)'." -ForegroundColor Green
