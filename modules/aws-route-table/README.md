<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of route table | `string` | `null` | no |
| <a name="input_route_table_associations"></a> [route\_table\_associations](#input\_route\_table\_associations) | The route table associations with subnets, Internet gateway, or virtual private gateway | <pre>map(object({<br/>    subnet_id  = optional(string, null)<br/>    gateway_id = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Configuration settings for defining a route table entry | <pre>map(object({<br/>    destination_cidr_block    = optional(string, null)<br/>    carrier_gateway_id        = optional(string, null)<br/>    core_network_arn          = optional(string, null)<br/>    egress_only_gateway_id    = optional(string, null)<br/>    gateway_id                = optional(string, null)<br/>    local_gateway_id          = optional(string, null)<br/>    nat_gateway_id            = optional(string, null)<br/>    network_interface_id      = optional(string, null)<br/>    transit_gateway_id        = optional(string, null)<br/>    vpc_endpoint_id           = optional(string, null)<br/>    vpc_peering_connection_id = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom labels for resources | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the route table |
<!-- END_TF_DOCS -->