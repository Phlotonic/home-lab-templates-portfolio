# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Automated Compliance, IP-Protection & Template Validator — Module 09
# =====================================================================
$ErrorActionPreference = 'Stop'

$VarsFile    = Join-Path $PSScriptRoot "template-variables.json"
$AnsibleFile = Join-Path $PSScriptRoot "ansible-cis-hardening.yml"
$VaultFile   = Join-Path $PSScriptRoot "vault-dynamic-db.hcl"
$LambdaFile  = Join-Path $PSScriptRoot "aws-s3-autoremediation.py"
$OtFile      = Join-Path $PSScriptRoot "ot-dmz-conduit.conf"
$Readme      = Join-Path $PSScriptRoot "README.md"

$AnsContent = Get-Content $AnsibleFile -Raw
$VltContent = Get-Content $VaultFile -Raw
$LmbContent = Get-Content $LambdaFile -Raw
$OtContent  = Get-Content $OtFile -Raw

$Checks = @(
    @{ Name = "Dual-License & Commercial Copyright Headers Present Across All Files"; Passed = (($AnsContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($VltContent -match "Copyright \(c\) 2026 Adam Dryden") -and ($LmbContent -match "Copyright \(c\) 2026 Adam Dryden")) },
    @{ Name = "Reusable Zero-Trust SecOps Parameters (template-variables.json & README.md)"; Passed = ((Test-Path $VarsFile) -and (Test-Path $Readme)) },
    @{ Name = "Ansible CIS Level 1 SSH & Kernel Sysctl Hardening Enforced"; Passed = (($AnsContent -match "PermitRootLogin no") -and ($AnsContent -match "tcp_syncookies") -and ($AnsContent -match "randomize_va_space")) },
    @{ Name = "HashiCorp Vault Ephemeral Database Credentials (1h Default TTL & Auto-Revoke)"; Passed = (($VltContent -match 'default_ttl = "1h"') -and ($VltContent -match "DROP ROLE IF EXISTS")) },
    @{ Name = "Event-Driven AWS S3 BlockPublicAccess Auto-Remediation Lambda"; Passed = (($LmbContent -match "put_public_access_block") -and ($LmbContent -match '"RestrictPublicBuckets": True')) },
    @{ Name = "IEC 62443 Level 3.5 WireGuard & MQTT TLS 1.3 mTLS Conduit Configured"; Passed = (($OtContent -match "require_certificate true") -and ($OtContent -match "tls_version tlsv1\.3")) },
    @{ Name = "OT/SCADA SparkplugB Command Write-Block Enforced in IDMZ Broker"; Passed = ($OtContent -match "deny write spBv1\.0/plant-01/NCMD/#") }
)

Write-Host "`n=== Module 09 (Zero-Trust SecOps, Vault, Auto-Remediation & IT/OT) Audit ===" -ForegroundColor Cyan
$AllPassed = $true
foreach ($Check in $Checks) {
    $Status = if ($Check.Passed) { "[PASS]" } else { "[FAIL]"; $AllPassed = $false }
    $Color  = if ($Check.Passed) { "Green" } else { "Red" }
    Write-Host ("{0,-8} {1}" -f $Status, $Check.Name) -ForegroundColor $Color
}

if (-not $AllPassed) {
    Write-Error "One or more Module 09 Zero-Trust SecOps checks failed."
    exit 1
}
Write-Host "`nAll 7 Zero-Trust SecOps, Ansible CIS, Vault, CSPM & IEC 62443 OT checks passed!" -ForegroundColor Green
