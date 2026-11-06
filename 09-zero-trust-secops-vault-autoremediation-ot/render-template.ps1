# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 09 (Zero-Trust SecOps & IT/OT)
# Dynamically interpolates template-variables.json into Vault & OT configs
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$VaultFile = Join-Path $PSScriptRoot "vault-dynamic-db.hcl"
if (Test-Path $VaultFile) {
    $Raw = Get-Content $VaultFile -Raw
    $Updated = $Raw -replace 'default_ttl\s*=\s*"\S+"', "default_ttl = `"$($Vars.defaultLeaseTtl)`"" `
                    -replace 'max_ttl\s*=\s*"\S+"', "max_ttl     = `"$($Vars.maxLeaseTtl)`""
    Set-Content -Path $VaultFile -Value $Updated -NoNewline
}

$OtFile = Join-Path $PSScriptRoot "ot-dmz-conduit.conf"
if (Test-Path $OtFile) {
    $Raw = Get-Content $OtFile -Raw
    $Updated = $Raw -replace 'listener \d+', "listener $($Vars.mqttBrokerPort)"
    Set-Content -Path $OtFile -Value $Updated -NoNewline
}

Write-Host "[MOD-09] Rendered Vault dynamic secret lease ('$($Vars.defaultLeaseTtl)') and IEC 62443 OT DMZ conduit (Port $($Vars.mqttBrokerPort))." -ForegroundColor Green
