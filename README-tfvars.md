# How do we fix base tfvars?

The example is [terraform.example.tfvars](terraform/terraform.example.tfvars). The following is a list of things that must be modified and things that should be modified when doing terraform apply for the first time.
If you need to adjust the parameters, you can do so by yourself by searching TODO.

- [Initial setting](#initial-setting)
- [Required](#required)
  - [region](#region)
  - [users](#users)
- [Not Required](#not-required)
  - [tags](#tags)
  - [EC2 settings](#ec2-settings)
  - [Instance Scheduler](#instance-scheduler)

# Initial setting

This section describes the initial settings for running [Base's Terraform](./terraform/). If an item has already been addressed, please skip to the next section.

- Manual creation of IAM user and IAM group to run Terraform  
  Create an IAM user and an IAM group from the management console in order to run Terraform.
  Create an IAM group (pseudonym: deploy). Attach AdministratorAccess as the policy.
  Create an IAM user (pseudonym: terraform), giving it only Programmatic access for Access Type, and add it to the IAM group (pseudonym: deploy).

- Create an S3 to store the Terraform State  
  Create an S3 from the management console to manage the Terraform State.
  However, if you have an environment where you can run the aws command and profile already configured, you can create an S3 by running the following command.  
  https://github.com/y-miyazaki/cloud-commands/blob/master/cmd/awstfinitstate

```sh
# awstfinitstate -h

This command creates a S3 Bucket for Terraform State.
You can also add random hash to bucket name suffix.

Usage:
    awstfinitstate -r {region} -b {bucket name} -p {profile}[<options>]
    awstfinitstate -r ap-northeast-1 -b terraform-state
    awstfinitstate -r ap-northeast-1 -b terraform-state -p default -s

Options:
    -b {bucket name}          S3 bucket name
    -p {aws profile name}     Name of AWS profile
    -r {region}               S3 region
    -s                        If set, a random hash will suffix bucket name.
    -h                        Usage awstfinitstate

# awstfinitstate -r ap-northeast-1 -b terraform-state -p default -s
~
~
~
~
~
~
~
~
~
~
~
~
~
--------------------------------------------------------------
bucket_name: terraform-state-xxxxxxxxxx
region: ap-northeast-1
--------------------------------------------------------------
```

- terraform.{environment}.tfvars file to configure for each environment  
  You need to rename the linked file [terraform.example.tfvars](terraform/terraform.example.tfvars) and change each variable for your environment. The variables that need to be changed are marked with TODO comments; search for them in TODO.
- main_provider.tf file to set for each environment  
  Rename the linked file [main_provider.tf.example](terraform/main_provider.tf.example) to main_provider.tf. After that, you need to change each parameter. The variables that need to be changed are marked with TODO comments, search for them in TODO.

```terraform
#--------------------------------------------------------------
# Terraform Provider
#--------------------------------------------------------------
terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
  }
  backend "s3" {
    # TODO: need to change bucket for terraform state.
    bucket = "xxxxxxxxxxxxxxxx"
    # TODO: need to change bucket key for terraform state.
    key = "xxxxxxxxxx"
    # TODO: need to change profile for terraform state.
    profile = "default"
    # TODO: need to change region for terraform state.
    region = "ap-northeast-1"
  }
}

#--------------------------------------------------------------
# AWS Provider
# access key and secret key should not use.
#--------------------------------------------------------------
provider "aws" {
  # TODO: need to change profile.
  profile = "default"
  # TODO: need to change region.
  region = "ap-northeast-1"
  #   default_tags {
  #     tags = var.tags
  #   }
}
# Need to add aws provider(us-east-1) for CloudFront Metric.
provider "aws" {
    region = "us-east-1"
    alias  = "us-east-1"
  #   default_tags {
  #     tags = var.tags
  #   }
}
```

- Running Terraform  
  Run the terraform command: terraform init followed by terraform apply.
  You may find that terraform apply fails due to conflicts or other problems, so run it again and it will succeed.

```sh
bash-5.1# terraform init
There are some problems with the CLI configuration:

Error: The specified plugin cache dir /root/.terraform.d/plugin-cache cannot be opened: stat /root/.terraform.d/plugin-cache: no such file or directory


As a result of the above problems, Terraform may not behave as intended.


Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of hashicorp/template from the dependency lock file
- Installing hashicorp/aws v3.29.1...
- Installed hashicorp/aws v3.29.1 (signed by HashiCorp)
- Installing hashicorp/random v3.1.0...
- Installed hashicorp/random v3.1.0 (signed by HashiCorp)
- Installing hashicorp/template v2.2.0...
- Installed hashicorp/template v2.2.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```sh
bash-5.1# terraform apply --auto-approve -var-file=terraform.example.tfvars
tls_private_key.spot["y-miyazaki-1-spot"]: Refreshing state... [id=66549f419717bafb9bf494eba7f6cb92e18b0397]
module.ec2_instance_profile.data.aws_iam_policy_document.this: Reading...
module.vpc.data.aws_iam_policy_document.vpc_flow_log_cloudwatch[0]: Reading...
module.ec2_instance_profile.data.aws_iam_policy_document.this: Read complete after 0s [id=1903849331]
...
...
...

Apply complete! resources: x added, x changed, 0 destroyed.
...
...
...
```

# Required

The following items must be modified; terraform apply will fail if you run it as an example.

## region

Select the region where you want to create the resource.

```
# TODO: need to change region.
region = "ap-northeast-1"
```

## users

When you add to users, an instance will be built for that number of minutes. Initially, there is 1 OnDemand and 0 Spot. The information will be displayed as Output after terraform apply for later distribution to developers, so give it a name that is easy to understand.

```
#--------------------------------------------------------------
# EC2 On-Demand instance
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
ec2_ondemand = {
  # TODO: need to add developer name.
  # An EC2 instance is created for the user added below.
  users = [
    "developer-1",
    # "developer-2",
  ]
```

```
#--------------------------------------------------------------
# EC2 spot instance
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
ec2_spot = {
  # TODO: need to add developer name.
  # An EC2 instance is created for the user added below.
  users = [
    # "developer-1-spot",
    # "developer-2-spot",
  ]
```

# Not Required

Although terraform apply will succeed without fixing the following items, the following is a list of things that should be changed for each environment.

## tags

You can leave the following as it is without any problem. However, if you want to add TAGs to the resources according to your environment, please modify the following.

```
# TODO: need to change tags.
tags = {
# TODO: need to change env.
env = "dev"
# TODO: need to change service.
# service is project name or job name or product name.
service = "base"
}
```

## EC2 settings

The EC2 configuration defaults to rather high specs for running Docker. Since the cost will be high, it is advisable to change the instance_type depending on the situation.

```
#--------------------------------------------------------------
# EC2 On-Demand instance
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
ec2_ondemand = {
```

```
#--------------------------------------------------------------
# EC2 spot instance
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#--------------------------------------------------------------
ec2_spot = {
```

## Instance Scheduler

If you want to schedule the start and stop of EC2 by Instance Scheduler, set is_enabled to true.
However, the scheduling must be set from DynamoDB or the Schedule CLI.
If you want to configure the settings from DynamoDB, this Blog is a good reference.

https://aws.amazon.com/jp/builders-flash/202110/instance-scheduler/?awsf.filter-name=*all  
_NOTE: Japanese document..._

```
#--------------------------------------------------------------
# Instance Scheduler
# The Instance Scheduler on AWS solution helps you control your AWS resource cost
# by configuring start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and
# Amazon Relational Database Service (Amazon RDS) instances.
# https://aws.amazon.com/solutions/implementations/instance-scheduler/?nc1=h_ls
#--------------------------------------------------------------
instance_scheduler = {
  is_enabled = false
```

If you want to configure the settings from the Scheduler CLI, please refer to this. We have prepared a script for your reference.

- install script for Scheduler CLI.

  ```
  $ scripts/aws/install_scheduler_cli.sh
  ```

- create schedule by Scheduler CLI.  
  Several sample schedules are supported to be set by command.
  ```
  ./scripts/aws/create_schedule.sh
  ```
  https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/scheduler-cli.html
