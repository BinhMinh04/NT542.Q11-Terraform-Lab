
# AWS Security group Terraform module

AWS Terraform module which create Security Group resources on AWS


## Getting started

```bash

```

## Contribute

```bash
## Initialize
terraform init

## Validate
terraform validate

## Format
terraform fmt

## Update README.md
terraform-docs markdown table --output-file README.md --output-mode inject .
```


## Usage
### Example Module Call
```hcl
#create aws_security_group
module "security_group" {
  source      = "../../"
  name        = "${var.environment}-${var.workload}-sg"
  vpc_id      = module.vpc.id
  description = "Security group for ${var.workload} ${var.environment}"
  egress_rules = {
    "egress_for_sg1" = {
      security_group_key = "security_group_1"
      cidr_ipv4          = "0.0.0.0/0"
      from_port          = 8080
      ip_protocol        = "tcp"
      to_port            = 8080
    }
  }
  ingress_rules = {
    "ingress_for_sg1" = {
      security_group_key = "security_group_1"
      cidr_ipv4          = "10.0.0.0/8"
      from_port          = 80
      ip_protocol        = "tcp"
      to_port            = 80
    }
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.96 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the security group | `string` | `null` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules for VPC security groups | <pre>map(object({<br/>    referenced_security_group_id = optional(string)<br/>    ip_protocol                  = string<br/>    from_port                    = optional(number)<br/>    to_port                      = optional(number)<br/>    cidr_ipv4                    = optional(string)<br/>    cidr_ipv6                    = optional(string)<br/>    prefix_list_id               = optional(string)<br/>    description                  = optional(string)<br/>    tags                         = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules for VPC security groups | <pre>map(object({<br/>    referenced_security_group_id = optional(string)<br/>    ip_protocol                  = string<br/>    from_port                    = optional(number)<br/>    to_port                      = optional(number)<br/>    cidr_ipv4                    = optional(string)<br/>    cidr_ipv6                    = optional(string)<br/>    prefix_list_id               = optional(string)<br/>    description                  = optional(string)<br/>    tags                         = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the security group | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with the specified prefix | `string` | `null` | no |
| <a name="input_revoke_rules_on_delete"></a> [revoke\_rules\_on\_delete](#input\_revoke\_rules\_on\_delete) | Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the security group | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the security group | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the security group. |
| <a name="output_id"></a> [id](#output\_id) | ID of the security group. |
<!-- END_TF_DOCS -->
