##################################################
#region Route Table
##################################################
variable "name" {
  description = "The name of route table"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = null
}

variable "tags" {
  description = "Custom labels for resources"
  type        = map(any)
  default     = {}
}

variable "routes" {
  description = "Configuration settings for defining a route table entry"
  type = map(object({
    destination_cidr_block    = optional(string, null)
    carrier_gateway_id        = optional(string, null)
    core_network_arn          = optional(string, null)
    egress_only_gateway_id    = optional(string, null)
    gateway_id                = optional(string, null)
    local_gateway_id          = optional(string, null)
    nat_gateway_id            = optional(string, null)
    network_interface_id      = optional(string, null)
    transit_gateway_id        = optional(string, null)
    vpc_endpoint_id           = optional(string, null)
    vpc_peering_connection_id = optional(string, null)
  }))
  default = {}
}

variable "route_table_associations" {
  description = "The route table associations with subnets, Internet gateway, or virtual private gateway"
  type = map(object({
    subnet_id  = optional(string, null)
    gateway_id = optional(string, null)
  }))
  default = {}
}
##################################################
#endregion
##################################################