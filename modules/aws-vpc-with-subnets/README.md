# AWS VPC with Subnets Terraform Module
This Terraform module provisions an AWS Virtual Private Cloud (VPC) with optional Internet Gateway, and multiple subnets (public/private). It also provides centralized tagging, removes default rules from security group and route tables, and supports both IPv4 and IPv6 CIDR configurations.

## Features
- Creating a VPC with customizable CIDR blocks
- Creating a default route table and default security group (without any ingress/egress rules)
- Creating multiple subnets defined via a map
- Optionally creating an Internet Gateway
- Supporting optional IPAM and IPv6 configurations
- Enabling DNS hostnames, DNS support, and flow log check compliance
- Fully compatible with AWS Provider `v5.*`
- Follows 27Global Terraform Best Practices
---
## Usage
### Basic Terraform Commands
```bash
# Initialize
terraform init

# Format
terraform fmt

# Validate
terraform validate

# Apply
terraform apply

# Get state
terraform state list

# Destroy
terraform destroy

# Generate README.md file
terraform-docs markdown table --output-file README.md --output-mode inject .
```

### Example Module Call

```hcl
module "vpc" {
  source = "../../"

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  subnets              = var.vpc_subnets
  prefix_name          = "${var.workload}-${var.environment}"

  tags = {
    Name = "${var.workload}-${var.environment}-vpc"
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.32.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../ | n/a |
| <a name="module_natgw"></a> [natgw](#module\_natgw) | git@github.com:twentyseven-global/aws-nat-gateway.git | v5.3 |
| <a name="module_public_rt"></a> [public\_rt](#module\_public\_rt) | git@github.com:twentyseven-global/aws-route-table.git | v5.1 |
| <a name="module_private_rt_2a"></a> [private\_rt\_2a](#module\_private\_rt\_2a) | git@github.com:twentyseven-global/aws-route-table.git | v5.1 |
| <a name="module_private_rt_2b"></a> [private\_rt\_2b](#module\_private\_rt\_2b) | git@github.com:twentyseven-global/aws-route-table.git | v5.1 |
| <a name="module_private_rt_2c"></a> [private\_rt\_2c](#module\_private\_rt\_2c) | git@github.com:twentyseven-global/aws-route-table.git | v5.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name | `string` | `"demo"` | no |
| <a name="input_automation"></a> [automation](#input\_automation) | The automation deployment | `string` | `"true"` | no |
| <a name="input_requested_by"></a> [requested\_by](#input\_requested\_by) | The group that requested the resource provisioning | `string` | `"ops"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | The workload name | `string` | `"project"` | no |
| <a name="input_created_by"></a> [created\_by](#input\_created\_by) | The agent responsible for creating the resource | `string` | `"terraform"` | no |
| <a name="input_prefix_name"></a> [prefix\_name](#input\_prefix\_name) | The prefix name of associated resources | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags for all resources | `map(string)` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create the VPC | `bool` | `true` | no |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create the Internet gateway | `bool` | `true` | no |
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | A boolean flag to enable or disable DNS support in the VPC. Defaults to true | `bool` | `true` | no |
| <a name="input_enable_network_address_usage_metrics"></a> [enable\_network\_address\_usage\_metrics](#input\_enable\_network\_address\_usage\_metrics) | Whether Network Address Usage metrics are enabled for the VPC | `bool` | `false` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="input_ipv4_ipam_pool_id"></a> [ipv4\_ipam\_pool\_id](#input\_ipv4\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR | `string` | `null` | no |
| <a name="input_ipv4_netmask_length"></a> [ipv4\_netmask\_length](#input\_ipv4\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC | `number` | `null` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | By default when an IPv6 CIDR is assigned to a VPC a default ipv6\_cidr\_block\_network\_border\_group will be set to the region of the VPC | `string` | `null` | no |
| <a name="input_ipv6_cidr_block_network_border_group"></a> [ipv6\_cidr\_block\_network\_border\_group](#input\_ipv6\_cidr\_block\_network\_border\_group) | By default when an IPv6 CIDR is assigned to a VPC a default ipv6\_cidr\_block\_network\_border\_group will be set to the region of the VPC | `string` | `null` | no |
| <a name="input_ipv6_ipam_pool_id"></a> [ipv6\_ipam\_pool\_id](#input\_ipv6\_ipam\_pool\_id) | IPAM Pool ID for a IPv6 pool | `string` | `null` | no |
| <a name="input_ipv6_netmask_length"></a> [ipv6\_netmask\_length](#input\_ipv6\_netmask\_length) | Netmask length to request from IPAM Pool | `number` | `null` | no |
| <a name="input_tags_sg"></a> [tags_sg](#input\_tags\_sg) | A map of tags to assign to the default Security Group resource | `map(string)` | `{}` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The IPv4 CIDR block for the VPC | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The configuration settings for defining subnets | <pre>map(object({<br>    cidr_block                                     = string<br>    availability_zone                              = string<br>    assign_ipv6_address_on_creation                = optional(bool)<br>    availability_zone_id                           = optional(string)<br>    customer_owned_ipv4_pool                       = optional(string)<br>    enable_dns64                                   = optional(bool)<br>    enable_lni_at_device_index                     = optional(string)<br>    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)<br>    enable_resource_name_dns_a_record_on_launch    = optional(bool)<br>    ipv6_cidr_block                                = optional(string)<br>    ipv6_native                                    = optional(bool)<br>    map_customer_owned_ip_on_launch                = optional(bool)<br>    map_public_ip_on_launch                        = optional(bool)<br>    outpost_arn                                    = optional(string)<br>    private_dns_hostname_type_on_launch            = optional(string)<br>    tags                                           = optional(map(string))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The VPC ARN |
| <a name="output_id"></a> [id](#output\_id) | The VPC ID |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | The Internet Gateway ID |
| <a name="output_subnet_arn"></a> [subnet\_arn](#output\_subnet\_arn) | The subnet ARN's based on the map of objects |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The subnet ID's based on the map of objects |
<!-- END_TF_DOCS -->
