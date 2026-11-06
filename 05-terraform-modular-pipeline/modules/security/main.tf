# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# FILE: modules/security/main.tf
# =====================================================================
variable "vpc_id" { type = string }
variable "allowed_ingress_ip" { type = string }

resource "aws_security_group" "app_sg" {
  name        = "sg-modular-app"
  description = "Least-privilege HTTPS ingress security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from trusted management CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ingress_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "app_sg_id" { value = aws_security_group.app_sg.id }
