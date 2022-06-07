#--------------------------------------------------------------
# SSM Management to EC2 instance profile.
# https://registry.terraform.io/modules/jeandek/ec2-instance-profile/aws/latest
#--------------------------------------------------------------
module "ec2_instance_profile" {
  source                                  = "../modules/aws/recipes/ec2/instance_profile"
  aws_iam_instance_profile_name           = format("%s%s", var.name_prefix, "ec2-instance-profile")
  aws_iam_role_name                       = format("%s%s", var.name_prefix, "ec2-instance-profile-role")
  attach_ssm_managed_instance_core_policy = true
}

