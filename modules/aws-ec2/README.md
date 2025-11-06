# AWS EC2 Terraform Module

This Terraform module creates and manages AWS EC2 Instances and their associated resources.

---

## Features
- Launch EC2 Instances with configurable AMI, instance types, volumes, and networking
- Attach additional EBS volumes
- Configure instance IAM roles and instance profiles
- Enable detailed monitoring
- Support user data scripts
- Follows 27Global Terraform Best Practices

---

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
---

## Usage Examples

```hcl
module "ec2_instance" {
  source = "../modules/aws-ec2"

  name                    = "ec2-${var.workload}-${var.environment}"
  ami                     = data.aws_ami.amzn2.id
  instance_type           = "t3.micro"
  subnet_id               = "" # reference this via the aws-vpc-with-subnets module
  vpc_security_group_ids  = [""] # reference this via the aws-vpc-with-subnets module
  associate_public_ip_address = false
  monitoring              = true
  iam_instance_profile    = "Managed_Instance_Core_SSM"

  root_block_device = {
    encrypted    = true
    volume_type  = "gp3"
    volume_size  = 8
    throughput   = 125
    tags = {
      Name = "ec2-${var.workload}-${var.environment}"
    }
  }

  tags = {
    Environment = var.environment
    Workload    = var.workload
  }
}
```
---
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.95 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.dependence](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_instance.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_volume_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | The ID of the AMI to use for the instance. | `string` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with an instance in a VPC. | `bool` | `false` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The AZ to launch the instance in. | `string` | n/a | yes |
| <a name="input_cpu_options"></a> [cpu\_options](#input\_cpu\_options) | The CPU options for the instance. | <pre>object({<br/>    amd_sev_snp      = optional(bool)<br/>    core_count       = optional(number)<br/>    threads_per_core = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_disable_api_stop"></a> [disable\_api\_stop](#input\_disable\_api\_stop) | If true, enables EC2 Instance Stop Protection. | `bool` | `false` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | If true, enables EC2 Instance Termination Protection. | `bool` | `false` | no |
| <a name="input_ebs_volumes"></a> [ebs\_volumes](#input\_ebs\_volumes) | A map of EBS volumes to create and attach to the instance. | <pre>map(object({<br/>    size                 = number<br/>    final_snapshot       = optional(bool, false)<br/>    iops                 = optional(number)<br/>    multi_attach_enabled = optional(bool)<br/>    type                 = optional(string, "gp3")<br/>    kms_key_id           = optional(string)<br/>    throughput           = optional(number)<br/>    tags                 = map(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_ephemeral_block_device"></a> [ephemeral\_block\_device](#input\_ephemeral\_block\_device) | Customize instance store volumes on the instance. | <pre>list(object({<br/>    device_name  = string<br/>    no_device    = optional(bool)<br/>    virtual_name = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_get_password_data"></a> [get\_password\_data](#input\_get\_password\_data) | If true, the EC2 instance will retrieve the default Windows password. | `bool` | `false` | no |
| <a name="input_hibernation"></a> [hibernation](#input\_hibernation) | If true, the instance will be enabled for hibernation. | `bool` | `false` | no |
| <a name="input_host_id"></a> [host\_id](#input\_host\_id) | The ID of the dedicated host on which to launch the instance. | `string` | `null` | no |
| <a name="input_host_resource_group_arn"></a> [host\_resource\_group\_arn](#input\_host\_resource\_group\_arn) | ARN of the host resource group. | `string` | `null` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | The IAM instance profile to associate with the instance. | `string` | `null` | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Shutdown behavior for the instance (stop or terminate). | `string` | `"stop"` | no |
| <a name="input_instance_market_options"></a> [instance\_market\_options](#input\_instance\_market\_options) | The market (spot) options for the instance. | <pre>object({<br/>    spot_options = optional(object({<br/>      instance_interruption_behavior = optional(string)<br/>      max_price                      = optional(string)<br/>      spot_instance_type             = optional(string)<br/>      valid_until                    = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start. | `string` | n/a | yes |
| <a name="input_ipv6_address_count"></a> [ipv6\_address\_count](#input\_ipv6\_address\_count) | Number of IPv6 addresses to assign to the ENI. | `number` | `null` | no |
| <a name="input_ipv6_addresses"></a> [ipv6\_addresses](#input\_ipv6\_addresses) | List of IPv6 addresses to assign to the ENI. | `list(string)` | `[]` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The key name to use for the instance. | `string` | `null` | no |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | The launch template to use for the instance. | <pre>object({<br/>    name    = optional(string)<br/>    version = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_maintenance_options"></a> [maintenance\_options](#input\_maintenance\_options) | The maintenance options for the instance. | <pre>object({<br/>    auto_recovery = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | Customize metadata options for the instance. | <pre>object({<br/>    http_endpoint               = optional(string)<br/>    http_tokens                 = optional(string)<br/>    http_put_response_hop_limit = optional(number)<br/>    instance_metadata_tags      = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | If true, enables detailed monitoring. | `bool` | `false` | no |
| <a name="input_placement_group"></a> [placement\_group](#input\_placement\_group) | The placement group to start the instance in. | `string` | `null` | no |
| <a name="input_placement_partition_number"></a> [placement\_partition\_number](#input\_placement\_partition\_number) | The number of the partition the instance should launch in. | `number` | `null` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address to assign to the instance. | `string` | `null` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Customize details about the root block device. | <pre>object({<br/>    delete_on_termination = optional(bool)<br/>    encrypted             = optional(bool)<br/>    iops                  = optional(number)<br/>    kms_key_id            = optional(string)<br/>    throughput            = optional(number)<br/>    volume_size           = optional(number)<br/>    volume_type           = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_secondary_private_ips"></a> [secondary\_private\_ips](#input\_secondary\_private\_ips) | List of secondary private IP addresses. | `list(string)` | `[]` | no |
| <a name="input_source_dest_check"></a> [source\_dest\_check](#input\_source\_dest\_check) | Controls whether source/destination checking is enabled on the instance. | `bool` | `true` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID to launch the instance in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_tenancy"></a> [tenancy](#input\_tenancy) | Tenancy of the instance (default, dedicated, or host). | `string` | `"default"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance. | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | The base64 encoded user data to provide when launching the instance. | `string` | `null` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | Whether to replace the instance when user\_data changes. | `bool` | `false` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_volume_ids"></a> [ebs\_volume\_ids](#output\_ebs\_volume\_ids) | The list of IDs of the EBS volumes attached to the instance. |
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | The ARN of the EC2 instance. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the EC2 instance. |
<!-- END_TF_DOCS -->
