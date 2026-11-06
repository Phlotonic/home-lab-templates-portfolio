# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Lab 4 (AWS)
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile = Join-Path $PSScriptRoot "template-variables.json"
$CfnFile  = Join-Path $PSScriptRoot "aws-three-tier-ha.yaml"
$DrillSh  = Join-Path $PSScriptRoot "run-failover-drill.sh"

$Cfn   = Get-Content $CfnFile -Raw
$Drill = Get-Content $DrillSh -Raw

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present"; Passed = (($Cfn -match "Copyright \(c\) 2026 Adam Dryden") -and ($Drill -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable CloudFormation Template Parameters (template-variables.json)"; Passed = (Test-Path $VarsFile) },
    @{ Name = "3-Tier Subnet Segmentation Across 2 AZs (Public, PrivateApp, PrivateData)"; Passed = (($Cfn -match "PublicSubnetA") -and ($Cfn -match "PrivateAppSubnetB") -and ($Cfn -match "PrivateDataSubnetB")) },
    @{ Name = "Chained Security Groups (ALB -> WebTier -> RDS Port 3306 Only)"; Passed = (($Cfn -match "SourceSecurityGroupId: !Ref ALBSecurityGroup") -and ($Cfn -match "SourceSecurityGroupId: !Ref WebTierSecurityGroup")) },
    @{ Name = "ELB HealthCheckType & /healthz Endpoint Configured on Auto Scaling Group"; Passed = (($Cfn -match "HealthCheckPath: /healthz") -and ($Cfn -match "HealthCheckType: ELB")) },
    @{ Name = "Isolated RDS Database Enforces PubliclyAccessible: false"; Passed = ($Cfn -match "PubliclyAccessible: false") },
    @{ Name = "Chaos Failover Drill & Free-Tier Teardown Script Included"; Passed = (($Drill -match "terminate-instances") -and ($Drill -match "delete-stack")) }
)

Write-Host "`n=== Lab 4 (AWS SAA-C03) 3-Tier HA & Chaos Failover Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Lab 4 AWS CloudFormation checks failed."
    exit 1
}
Write-Host "`nAll 7 AWS SAA-C03 3-tier HA, chained SG, and failover drill checks passed!" -ForegroundColor Green
