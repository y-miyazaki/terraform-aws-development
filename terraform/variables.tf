variable "tags" {
  type        = map(any)
  description = "(Required) This is a TAG that is commonly assigned to each resource."
}
variable "name_prefix" {
  type        = string
  description = "(Required) The name to prefix the resource name."
}
variable "region" {
  type        = string
  description = "(Required) The name to prefix the resource name."
}
variable "vpc" {
  type        = any
  description = "Settings related to VPC."
}
variable "vpc_endpoints" {
  type        = any
  description = "Settings related to VPC Endpoint."
}
variable "security_group" {
  type        = any
  description = "Settings related to Security Group."
}

variable "ec2_ondemand" {
  type        = any
  description = "Settings related to EC2 instance."
}
variable "ec2_spot" {
  type        = any
  description = "Settings related to EC2 spot instance."
}
variable "instance_scheduler" {
  type        = any
  description = "Configure AWS Instance Scheduler."
}
