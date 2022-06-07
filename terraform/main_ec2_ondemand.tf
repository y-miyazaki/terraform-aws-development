#--------------------------------------------------------------
# locals
#--------------------------------------------------------------
locals {
  ec2_ondemand_name = format("%s%s", var.name_prefix, var.ec2_ondemand.base.name)
  ec2_ondemand_users = { for k, v in var.ec2_ondemand.users : v => {
    key_name = v
    }
  }
  ec2_ondemand_tags = merge(var.tags, {
    "${var.instance_scheduler.parameters.TagName}" = var.ec2_ondemand.schedule
  })
}
#--------------------------------------------------------------
# key pair
# https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws/latest
#--------------------------------------------------------------
resource "tls_private_key" "ondemand" {
  for_each  = local.ec2_ondemand_users
  algorithm = "RSA"
}

module "key_pair" {
  for_each   = local.ec2_ondemand_users
  source     = "terraform-aws-modules/key-pair/aws"
  version    = "1.0.1"
  key_name   = each.value.key_name
  public_key = tls_private_key.ondemand[each.value.key_name].public_key_openssh
}

#--------------------------------------------------------------
# EC2
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
module "ec2_ondemand" {
  for_each = local.ec2_ondemand_users
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "3.6.0"

  name = format("%s-%s", local.ec2_ondemand_name, each.value.key_name)
  # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
  ami                         = var.ec2_ondemand.base.ami
  associate_public_ip_address = false
  create_spot_instance        = false
  ebs_block_device            = var.ec2_ondemand.base.ebs_block_device
  iam_instance_profile        = module.ec2_instance_profile.ec2_instance_profile_name
  # https://aws.amazon.com/jp/ec2/instance-types/
  instance_type          = var.ec2_ondemand.base.instance_type
  key_name               = each.value.key_name
  monitoring             = var.ec2_ondemand.base.monitoring
  root_block_device      = var.ec2_ondemand.base.root_block_device
  subnet_id              = var.vpc.enable_nat_gateway ? module.vpc.private_subnets[0] : module.vpc.public_subnets[0]
  tags                   = local.ec2_ondemand_tags
  user_data              = file("./userdata/userdata.sh")
  vpc_security_group_ids = [module.security_group.security_group_id]
  depends_on = [
    module.key_pair
  ]
}

#--------------------------------------------------------------
# Output
#--------------------------------------------------------------
module "settings_ondemand" {
  source = "../modules/aws/recipes/settings"
  users = { for k, v in var.ec2_ondemand.users : v => {
    key_name            = v
    private_key_openssh = tls_private_key.ondemand[v].private_key_openssh
    instance_id         = module.ec2_ondemand[v].id
    }
  }
  depends_on = [
    module.ec2_ondemand
  ]
}
