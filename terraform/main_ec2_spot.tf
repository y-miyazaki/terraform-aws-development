#--------------------------------------------------------------
# locals
#--------------------------------------------------------------
locals {
  ec2_spot_name = format("%s%s", var.name_prefix, var.ec2_spot.base.name)
  ec2_spot_users = { for k, v in var.ec2_spot.users : v => {
    key_name = v
    }
  }
  ec2_spot_tags = merge(var.tags, {
    "${var.instance_scheduler.parameters.TagName}" = var.ec2_spot.schedule
  })

}
#--------------------------------------------------------------
# key pair
# https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws/latest
#--------------------------------------------------------------
resource "tls_private_key" "spot" {
  for_each  = local.ec2_spot_users
  algorithm = "RSA"
}

module "key_pair_spot" {
  for_each   = local.ec2_spot_users
  source     = "terraform-aws-modules/key-pair/aws"
  version    = "1.0.1"
  key_name   = each.value.key_name
  public_key = tls_private_key.spot[each.value.key_name].public_key_openssh
}

#--------------------------------------------------------------
# EC2
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
module "ec2_spot" {
  for_each = local.ec2_spot_users
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "3.6.0"

  name = format("%s-%s", local.ec2_spot_name, each.value.key_name)
  # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
  ami                         = var.ec2_spot.base.ami
  associate_public_ip_address = false
  create_spot_instance        = true
  ebs_block_device            = var.ec2_spot.base.ebs_block_device
  iam_instance_profile        = module.ec2_instance_profile.ec2_instance_profile_name
  # https://aws.amazon.com/jp/ec2/instance-types/
  instance_type          = var.ec2_spot.base.instance_type
  key_name               = each.value.key_name
  monitoring             = var.ec2_spot.base.monitoring
  root_block_device      = var.ec2_spot.base.root_block_device
  subnet_id              = var.vpc.enable_nat_gateway ? module.vpc.private_subnets[0] : module.vpc.public_subnets[0]
  tags                   = local.ec2_spot_tags
  user_data              = file("./userdata/userdata.sh")
  vpc_security_group_ids = [module.security_group.security_group_id]
  depends_on = [
    module.key_pair
  ]
}
#--------------------------------------------------------------
# EC2 spot instance support tag.
#--------------------------------------------------------------
#resource "aws_ec2_tag" "spot" {
#  for_each = { for v0 in flatten([for k, v in module.ec2_spot : [
#    for k2, v2 in local.ec2_spot_tags : {
#      spot_instance_id = v.spot_instance_id
#      key              = k2
#      value            = v2
#    }
#    ]
#    ]) : format("%s-%s", v0.spot_instance_id, v0.key) => v0
#  }
#  resource_id = each.value.spot_instance_id
#  key         = each.value.key
#  value       = each.value.value
#}
#--------------------------------------------------------------
# Output
#--------------------------------------------------------------
module "settings_spot" {
  source = "../modules/aws/recipes/settings"
  users = { for k, v in var.ec2_spot.users : v => {
    key_name            = v
    private_key_openssh = tls_private_key.spot[v].private_key_openssh
    instance_id         = module.ec2_spot[v].spot_instance_id
    }
  }
  depends_on = [
    module.ec2_spot
  ]
}
