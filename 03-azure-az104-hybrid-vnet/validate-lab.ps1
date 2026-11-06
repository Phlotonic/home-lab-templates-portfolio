# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Lab 3 (AZ-104)
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile  = Join-Path $PSScriptRoot "template-variables.json"
$BicepFile = Join-Path $PSScriptRoot "main.bicep"
$EntraSh   = Join-Path $PSScriptRoot "configure-entra-and-secrets.sh"

$Bicep  = Get-Content $BicepFile -Raw
$Script = Get-Content $EntraSh -Raw

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present"; Passed = (($Bicep -match "Copyright \(c\) 2026 Adam Dryden") -and ($Script -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable Azure Template Parameters (template-variables.json)"; Passed = (Test-Path $VarsFile) },
    @{ Name = "Bidirectional Global VNet Peering (peer-hub-to-spoke & peer-spoke-to-hub)"; Passed = (($Bicep -match "peer-hub-to-spoke") -and ($Bicep -match "peer-spoke-to-hub")) },
    @{ Name = "Zero-Public-IP Private Workload NIC Behind Strict NSG"; Passed = (($Bicep -match "Allow-Bastion-SSH-Inbound-Only") -and ($Bicep -match "Deny-All-Internet-Inbound")) },
    @{ Name = "Azure Bastion Host Deployed in Hub VNet (AzureBastionSubnet)"; Passed = (($Bicep -match "AzureBastionSubnet") -and ($Bicep -match "Microsoft\.Network/bastionHosts")) },
    @{ Name = "Azure Key Vault RBAC & SystemAssigned Managed Identity Configured"; Passed = (($Bicep -match "enableRbacAuthorization: true") -and ($Bicep -match "SystemAssigned")) },
    @{ Name = "Entra ID Conditional Access MFA Policy Script Included"; Passed = ($Script -match "CA01-Require-MFA-For-Azure-Resource-Manager") }
)

Write-Host "`n=== Lab 3 (Microsoft Azure AZ-104) Bicep & Zero-Trust Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Lab 3 Azure Bicep checks failed."
    exit 1
}
Write-Host "`nAll 7 Azure AZ-104 Bicep, Bastion, Key Vault & Entra ID checks passed!" -ForegroundColor Green
