#--------------------------------------------------------------
# locals
#--------------------------------------------------------------
locals {
  vpc_name            = format("%s%s", var.name_prefix, var.vpc.name)
  security_group_name = format("%s%s", var.name_prefix, var.security_group.name)
}
#--------------------------------------------------------------
# VPC
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
#--------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = local.vpc_name
  cidr = var.vpc.cidr

  # Network
  azs             = var.vpc.azs
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets

  enable_dns_hostnames = var.vpc.enable_dns_hostnames
  enable_dns_support   = var.vpc.enable_dns_support

  # NAT Gateway
  enable_nat_gateway     = var.vpc.enable_nat_gateway
  single_nat_gateway     = var.vpc.single_nat_gateway
  one_nat_gateway_per_az = var.vpc.one_nat_gateway_per_az

  # VPN Gateway
  enable_vpn_gateway = var.vpc.enable_vpn_gateway

  # Flow Log
  enable_flow_log                                 = var.vpc.enable_flow_log
  create_flow_log_cloudwatch_log_group            = var.vpc.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role             = var.vpc.create_flow_log_cloudwatch_iam_role
  flow_log_cloudwatch_log_group_retention_in_days = var.vpc.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_file_format                            = var.vpc.flow_log_file_format

  #   Public access to RDS instances
  # Sometimes it is handy to have public access to RDS instances (it is not recommended for production) by specifying these arguments:
  create_database_subnet_group           = lookup(var.vpc, "create_database_subnet_group", false)
  create_database_subnet_route_table     = lookup(var.vpc, "var.vpc.create_database_subnet_route_table", false)
  create_database_internet_gateway_route = lookup(var.vpc, "var.vpc.create_database_internet_gateway_route", false)
  tags                                   = var.tags
}

#--------------------------------------------------------------
# VPC Endpoint
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest/submodules/vpc-endpoints
#--------------------------------------------------------------
module "vpc_endpoints" {
  source    = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version   = "3.14.0"
  create    = var.vpc_endpoints.create
  vpc_id    = module.vpc.vpc_id
  endpoints = var.vpc_endpoints
  tags      = var.tags
}

#--------------------------------------------------------------
# Security Group
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
#--------------------------------------------------------------
# module "security_group_bastion" {
#   source              = "terraform-aws-modules/security-group/aws//modules/ssh"
#   version             = "4.9.0"
#   name                = local.security_group_name
#   description         = var.security_group.description
#   vpc_id              = module.vpc.vpc_id
#   ingress_cidr_blocks = var.security_group.ingress_cidr_blocks
# }
#--------------------------------------------------------------
# Security Group
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
#--------------------------------------------------------------
module "security_group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.9.0"
  name        = local.security_group_name
  description = var.security_group.description
  vpc_id      = module.vpc.vpc_id
  computed_ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.vpc.cidr
    },
  ]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.vpc.default_security_group_id
    },
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
  number_of_computed_ingress_with_cidr_blocks              = 1
  egress_rules                                             = ["all-all"]
}

#--------------------------------------------------------------
# Output
#--------------------------------------------------------------
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}
