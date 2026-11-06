# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Reusable Template Renderer — Module 05 (Terraform Modular Pipeline)
# Dynamically synchronizes template-variables.json into tfvars.example
# =====================================================================
param(
    [string]$VariablesFile = (Join-Path $PSScriptRoot "template-variables.json")
)

$ErrorActionPreference = 'Stop'
$Vars = Get-Content $VariablesFile -Raw | ConvertFrom-Json

$TfVarsFile = Join-Path $PSScriptRoot "terraform.tfvars.example"
$RenderedTfVars = @"
# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
aws_region         = "$($Vars.awsRegion)"
env_prefix         = "$($Vars.envPrefix)"
vpc_cidr           = "$($Vars.vpcCidr)"
allowed_ingress_ip = "$($Vars.allowedIngressIp)"
instance_type      = "$($Vars.instanceType)"
"@
Set-Content -Path $TfVarsFile -Value $RenderedTfVars

Write-Host "[MOD-05] Rendered Terraform variables for environment '$($Vars.envPrefix)' in '$TfVarsFile'." -ForegroundColor Green
