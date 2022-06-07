<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.17.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.user_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_agent_server_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_managed_instance_core_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.user_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_cloudwatch_agent_server_policy"></a> [attach\_cloudwatch\_agent\_server\_policy](#input\_attach\_cloudwatch\_agent\_server\_policy) | (Optional) Set to true if Attach AmazonSSMManagedInstanceCore to Role. | `bool` | `false` | no |
| <a name="input_attach_ssm_managed_instance_core_policy"></a> [attach\_ssm\_managed\_instance\_core\_policy](#input\_attach\_ssm\_managed\_instance\_core\_policy) | (Optional) Set to true if Attach CloudWatchAgentServerPolicy to Role. | `bool` | `false` | no |
| <a name="input_aws_iam_instance_profile_name"></a> [aws\_iam\_instance\_profile\_name](#input\_aws\_iam\_instance\_profile\_name) | (Required) Name of the instance profile. If omitted, Terraform will assign a random, unique name. Conflicts with name\_prefix. Can be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: \_, +, =, ,, ., @, -. Spaces are not allowed. | `string` | n/a | yes |
| <a name="input_aws_iam_role_description"></a> [aws\_iam\_role\_description](#input\_aws\_iam\_role\_description) | (Optional) Description of the IAM policy. | `string` | `"Role assigned to the EC2 instance profile."` | no |
| <a name="input_aws_iam_role_name"></a> [aws\_iam\_role\_name](#input\_aws\_iam\_role\_name) | (Required) Friendly name of the role. If omitted, Terraform will assign a random, unique name. See IAM Identifiers for more information. | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | (Optional) Path to the role. See IAM Identifiers for more information. | `string` | `null` | no |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | ARNs of IAM policies for the role | `list(string)` | `[]` | no |
| <a name="input_policy_jsons"></a> [policy\_jsons](#input\_policy\_jsons) | Valid JSON policies for the role | `list(string)` | `[]` | no |
| <a name="input_policy_jsons_name"></a> [policy\_jsons\_name](#input\_policy\_jsons\_name) | (Optional) The name of the policy. | `string` | `"ec2-instance-profile-policy"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_instance_profile_name"></a> [ec2\_instance\_profile\_name](#output\_ec2\_instance\_profile\_name) | EC2 instance profile name. |
<!-- END_TF_DOCS -->