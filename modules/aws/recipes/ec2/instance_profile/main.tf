
#--------------------------------------------------------------
# Generates an IAM policy document in JSON format for use with resources that expect policy documents such as aws_iam_policy.
#--------------------------------------------------------------
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
#--------------------------------------------------------------
# Provides an IAM role.
#--------------------------------------------------------------
resource "aws_iam_role" "this" {
  description        = var.aws_iam_role_description
  name               = var.aws_iam_role_name
  path               = var.path
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags               = var.tags
}

#--------------------------------------------------------------
# Attaches a Managed IAM Policy to an IAM role
#--------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_policy" {
  count      = var.attach_ssm_managed_instance_core_policy ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#--------------------------------------------------------------
# Attaches a Managed IAM Policy to an IAM role
#--------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  count      = var.attach_cloudwatch_agent_server_policy ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
#--------------------------------------------------------------
# Attaches a Managed IAM Policy to an IAM role
#--------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "custom" {
  count      = length(var.policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arns[count.index]
}
#--------------------------------------------------------------
# Attaches a Managed IAM Policy to an IAM role
#--------------------------------------------------------------
resource "aws_iam_policy" "user_policies" {
  count  = length(var.policy_jsons)
  name   = "${var.policy_jsons_name}-${count.index}"
  path   = var.path
  policy = var.policy_jsons[count.index]
  tags   = var.tags
}
resource "aws_iam_role_policy_attachment" "user_policies" {
  count      = length(var.policy_jsons)
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.user_policies[count.index].arn
}

#--------------------------------------------------------------
# Provides an IAM instance profile.
#--------------------------------------------------------------
resource "aws_iam_instance_profile" "this" {
  name = var.aws_iam_instance_profile_name
  path = var.path
  role = aws_iam_role.this.name
  tags = var.tags
}
