# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================

terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote State Storage in S3 with DynamoDB State Locking to Prevent Concurrent Corruption
  backend "s3" {
    bucket         = "quanumis-tfstate-production-lock-2026"
    key            = "envs/production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "quanumis-terraform-state-locks"
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "env_prefix" {
  type    = string
  default = "prod"
}

variable "vpc_cidr" {
  type    = string
  default = "10.50.0.0/16"
}

variable "allowed_ingress_ip" {
  type    = string
  default = "203.0.113.50/32"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

module "networking" {
  source     = "./modules/networking"
  vpc_cidr   = var.vpc_cidr
  env_prefix = var.env_prefix
}

module "security" {
  source             = "./modules/security"
  vpc_id             = module.networking.vpc_id
  allowed_ingress_ip = var.allowed_ingress_ip
}

module "compute" {
  source            = "./modules/compute"
  subnet_id         = module.networking.private_subnet_id
  security_group_id = module.security.app_sg_id
  instance_type     = var.instance_type
}
