#--------------------------------------------------------------
# Basically, it is already set so that the setting is completed only by changing tfvars.
# All parameters that need to be changed for each environment are described in TODO comments.
#--------------------------------------------------------------
#--------------------------------------------------------------
# Default Tags for Resources
# A tag that is set globally for the resources used.
#--------------------------------------------------------------
# TODO: need to change tags.
tags = {
  # TODO: need to change env.
  env = "dev"
  # TODO: need to change service.
  # service is project name or job name or product name.
  service = "base"
}
#--------------------------------------------------------------
# Name prefix
# It is used as a prefix attached to various resource names.
#--------------------------------------------------------------
# TODO: need to change name_prefix.
name_prefix = "base-"
#--------------------------------------------------------------
# Default Tags for Resources
#--------------------------------------------------------------
# TODO: need to change region.
region = "ap-northeast-1"

#--------------------------------------------------------------
# VPC
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
#--------------------------------------------------------------
vpc = {
  name = "developer"
  cidr = "10.0.0.0/16"
  azs = [
    "ap-northeast-1a",
    # "ap-northeast-1c",
    # "ap-northeast-1d",
  ]
  private_subnets = [
    "10.0.1.0/24",
    # "10.0.2.0/24",
    # "10.0.3.0/24"
  ]
  public_subnets = [
    "10.0.101.0/24",
    # "10.0.102.0/24",
    # "10.0.103.0/24"
  ]
  enable_dns_support   = true
  enable_dns_hostnames = true

  # One NAT Gateway per subnet (default behavior)
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # VPN Gateway
  enable_vpn_gateway = false

  # Flow Log(plain-text or parquet)
  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_cloudwatch_log_group_retention_in_days = 14
  flow_log_file_format                            = "parquet"
}
#--------------------------------------------------------------
# VPC Endpoint
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest/submodules/vpc-endpoints
#--------------------------------------------------------------
vpc_endpoints = {
  # TODO: need to set vpc endpoints
  create = false
  endpoints = {
    # TODO: need to set vpc endpoints
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    },
  }
}
#--------------------------------------------------------------
# Security Group
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
#--------------------------------------------------------------
security_group = {
  name        = "developer"
  description = "Security group for developer."
}
#--------------------------------------------------------------
# EC2 onDemand instance
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
ec2_ondemand = {
  # TODO: need to set Schedule for start/stop instance.
  # you need to set Instance Scheduler.
  # 
  # The Instance Scheduler on AWS solution helps you control your AWS resource cost by configuring
  # start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and
  # Amazon Relational Database Service (Amazon RDS) instances.
  #
  # https://aws.amazon.com/solutions/implementations/instance-scheduler/?nc1=h_ls
  # sample: scripts/aws/create_schedule.sh
  schedule = "mon-fri-9am-9pm"
  # TODO: need to add developer name.
  # An EC2 instance is created for the user added below.
  users = [
    # "developer-1",
    "developer-2",
  ]
  base = {
    name = "developer"
    # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
    ami = "ami-02c3627b04781eada"
    # https://aws.amazon.com/jp/ec2/instance-types/
    # VCPU:4 Memory:32GB
    # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/RootDeviceStorage.html
    root_block_device = [
      {
        delete_on_termination = true
        volume_size           = 50
        volume_type           = "gp3"
        iops                  = 3000
        throughput            = 125
      }
    ]
    ebs_block_device = [
      #   {
      #     delete_on_termination = true
      #     device_name           = "/dev/xvdb"
      #     #   device_name           = ebs_block_device.value.device_name
      #     encrypted = true
      #     # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ebs-volume-types.html#solid-state-drives
      #     iops = 3000
      #     # Size of the volume in gibibytes (GiB).
      #     volume_size = 50
      #     volume_type = "gp3"
      #     throughput            = 125
      #   }
    ]
    instance_type = "r5a.xlarge"
    monitoring    = false
  }
}
#--------------------------------------------------------------
# EC2 spot instance
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
ec2_spot = {
  # TODO: need to set Schedule for start/stop instance.
  # you need to set Instance Scheduler.
  # 
  # The Instance Scheduler on AWS solution helps you control your AWS resource cost by configuring
  # start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and
  # Amazon Relational Database Service (Amazon RDS) instances.
  #
  # https://aws.amazon.com/solutions/implementations/instance-scheduler/?nc1=h_ls
  # sample: scripts/aws/create_schedule.sh
  schedule = ""
  # TODO: need to add developer name.
  # An EC2 instance is created for the user added below.
  users = [
    # "developer-1-spot",
    # "developer-2-spot",
  ]
  base = {
    name = "developer-spot"
    # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
    ami = "ami-02c3627b04781eada"
    # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/RootDeviceStorage.html
    root_block_device = [
      {
        delete_on_termination = true
        volume_size           = 50
        volume_type           = "gp3"
        iops                  = 3000
        throughput            = 125
      }
    ]
    ebs_block_device = [
      #   {
      #     delete_on_termination = true
      #     device_name           = "/dev/xvdb"
      #     #   device_name           = ebs_block_device.value.device_name
      #     encrypted = true
      #     # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ebs-volume-types.html#solid-state-drives
      #     iops = 3000
      #     # Size of the volume in gibibytes (GiB).
      #     volume_size = 50
      #     volume_type = "gp3"
      #     throughput            = 125
      #   }
    ]
    # https://aws.amazon.com/jp/ec2/instance-types/
    # VCPU:4 Memory:32GB
    instance_type = "r5a.xlarge"
    monitoring    = false
  }
}

#--------------------------------------------------------------
# Instance Scheduler
# The Instance Scheduler on AWS solution helps you control your AWS resource cost
# by configuring start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and
# Amazon Relational Database Service (Amazon RDS) instances.
# https://aws.amazon.com/solutions/implementations/instance-scheduler/?nc1=h_ls
#--------------------------------------------------------------
instance_scheduler = {
  is_enabled = true
  name       = "instance-scheduler"
  parameters = {
    CrossAccountRoles     = ""
    DefaultTimezone       = "UTC"
    LogRetentionDays      = 7
    Regions               = ""
    ScheduleLambdaAccount = "Yes"
    ScheduledServices     = "EC2"
    SchedulingActive      = "Yes"
    SchedulerFrequency    = "5"
    StartedTags           = "StartedByInstanceScheduler=True"
    StoppedTags           = "StoppedByInstanceScheduler=True"
    TagName               = "Schedule"
    Trace                 = "No"
  }
}
