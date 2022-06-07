#--------------------------------------------------------------
# module variables
#--------------------------------------------------------------
variable "attach_cloudwatch_agent_server_policy" {
  type        = bool
  description = "(Optional) Set to true if Attach AmazonSSMManagedInstanceCore to Role."
  default     = false
}
variable "attach_ssm_managed_instance_core_policy" {
  type        = bool
  description = "(Optional) Set to true if Attach CloudWatchAgentServerPolicy to Role."
  default     = false
}
variable "aws_iam_instance_profile_name" {
  type        = string
  description = "(Required) Name of the instance profile. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix. Can be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: _, +, =, ,, ., @, -. Spaces are not allowed."
}
variable "aws_iam_role_description" {
  type        = string
  description = "(Optional) Description of the IAM policy."
  default     = "Role assigned to the EC2 instance profile."
}
variable "aws_iam_role_name" {
  type        = string
  description = "(Required) Friendly name of the role. If omitted, Terraform will assign a random, unique name. See IAM Identifiers for more information."
}
variable "path" {
  type        = string
  description = "(Optional) Path to the role. See IAM Identifiers for more information."
  default     = null
}
variable "policy_jsons" {
  type        = list(string)
  description = "Valid JSON policies for the role"
  default     = []
}
variable "policy_jsons_name" {
  type        = string
  description = "(Optional) The name of the policy."
  default     = "ec2-instance-profile-policy"
}
variable "policy_arns" {
  type        = list(string)
  description = "ARNs of IAM policies for the role"
  default     = []
}
variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = null
}
