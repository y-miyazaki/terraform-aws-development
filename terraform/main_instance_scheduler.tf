#--------------------------------------------------------------
# locals
#--------------------------------------------------------------
locals {
  instance_scheduler_name = format("%s%s", var.name_prefix, var.instance_scheduler.name)
}
#--------------------------------------------------------------
# Instance Scheduler
# The Instance Scheduler on AWS solution helps you control your AWS resource cost
# by configuring start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and
# Amazon Relational Database Service (Amazon RDS) instances.
# https://aws.amazon.com/solutions/implementations/instance-scheduler/?nc1=h_ls
#--------------------------------------------------------------
resource "aws_cloudformation_stack" "instance_scheduler" {
  count         = var.instance_scheduler.is_enabled ? 1 : 0
  capabilities  = ["CAPABILITY_IAM"]
  name          = local.instance_scheduler_name
  parameters    = var.instance_scheduler.parameters
  template_body = file("template/aws-instance-scheduler.template")
  tags          = var.tags
}
