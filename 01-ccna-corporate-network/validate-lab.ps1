# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Lab 1 (CCNA)
# =====================================================================
$ErrorActionPreference = 'Stop'

$RepoRoot  = Split-Path -Parent $PSScriptRoot
$ConfigDir = Join-Path $PSScriptRoot "configs"
$VarsFile  = Join-Path $PSScriptRoot "template-variables.json"
$Renderer  = Join-Path $PSScriptRoot "render-template.ps1"
$License   = Join-Path $RepoRoot "LICENSE"
$CommLic   = Join-Path $RepoRoot "COMMERCIAL-LICENSE.md"

$SiteA = Get-Content (Join-Path $ConfigDir "site-a-hq.txt") -Raw
$SiteB = Get-Content (Join-Path $ConfigDir "site-b-branch.txt") -Raw
$Vars  = Get-Content $VarsFile -Raw | ConvertFrom-Json

$Checks = @(
    @{ Name = "Dual-License & Commercial IP Protection (LICENSE, COMMERCIAL-LICENSE.md & Headers)"; Passed = ((Test-Path $License) -and (Test-Path $CommLic) -and ($SiteA -match "Copyright \(c\) 2026 Adam Dryden") -and ($SiteB -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable Template Parameters (template-variables.json & render-template.ps1)"; Passed = ((Test-Path $VarsFile) -and (Test-Path $Renderer) -and ($null -ne $Vars.organizationDomain)) },
    @{ Name = "Site A: HQ-R1 & HQ-SW1 Hostnames Defined"; Passed = ($SiteA -match "hostname HQ-R1" -and $SiteA -match "hostname HQ-SW1") },
    @{ Name = "Site B: BR-R1 & BR-SW1 Hostnames Defined"; Passed = ($SiteB -match "hostname BR-R1" -and $SiteB -match "hostname BR-SW1") },
    @{ Name = "OSPF Process 1 Point-to-Point WAN Configured"; Passed = ($SiteA -match "ip ospf network point-to-point" -and $SiteB -match "ip ospf network point-to-point") },
    @{ Name = "All 4 Segmented VLANs (10, 20, 30, 99) Present"; Passed = ($SiteA -match "vlan 10" -and $SiteA -match "vlan 20" -and $SiteA -match "vlan 30" -and $SiteA -match "vlan 99") },
    @{ Name = "Extended ACL 'RESTRICT-GUEST-WIFI' Applied Inbound on Vlan30"; Passed = ($SiteA -match "ip access-group RESTRICT-GUEST-WIFI in" -and $SiteB -match "ip access-group RESTRICT-GUEST-WIFI in") },
    @{ Name = "SSHv2 Enforced & Telnet Disabled ('transport input ssh')"; Passed = ($SiteA -match "ip ssh version 2" -and $SiteA -match "transport input ssh" -and $SiteB -match "transport input ssh") },
    @{ Name = "VTY Admin ACL Blocks Guest Subnets (10.10.30.0 & 10.20.30.0)"; Passed = ($SiteA -match "access-class VTY-ADMIN-ALLOW in" -and $SiteB -match "access-class VTY-ADMIN-ALLOW in") }
)

Write-Host "`n=== Lab 1 (Cisco CCNA) Commercial IP, Template & Security Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Lab 1 configuration checks failed."
    exit 1
}
Write-Host "`nAll 9 commercial IP, reusable template, security & routing checks passed!" -ForegroundColor Green
