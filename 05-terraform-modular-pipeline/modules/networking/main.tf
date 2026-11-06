# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# FILE: modules/networking/main.tf
# =====================================================================
variable "vpc_cidr" { type = string }
variable "env_prefix" { type = string }

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "${var.env_prefix}-vpc" }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 10)
  availability_zone = "us-east-1a"
  tags              = { Name = "${var.env_prefix}-private-subnet" }
}

output "vpc_id" { value = aws_vpc.this.id }
output "private_subnet_id" { value = aws_subnet.private.id }
