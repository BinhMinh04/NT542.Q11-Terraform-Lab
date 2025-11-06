##################################################
#region AWS VPC with Subnets
##################################################
variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = null
}

variable "prefix_name" {
  description = "The prefix name of associated resources"
  type        = string
  default     = null
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "ipv4_ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR"
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC"
  type        = number
  default     = null
}

variable "ipv6_cidr_block" {
  description = "By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC"
  type        = string
  default     = null
}

variable "ipv6_ipam_pool_id" {
  description = "IPAM Pool ID for a IPv6 pool"
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "Netmask length to request from IPAM Pool"
  type        = number
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  description = "By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC"
  type        = string
  default     = null
}

variable "enable_dns_support" {
  description = "A boolean flag to enable or disable DNS support in the VPC. Defaults to true"
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Whether Network Address Usage metrics are enabled for the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  type        = bool
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the VPC resource"
  type        = map(string)
  default     = null
}

variable "tags_sg" {
  description = "A map of tags to assign to the default Security Group resource"
  type        = map(string)
  default     = null
}

variable "subnets" {
  description = "The configuration settings for defining subnets"

  type = map(object({
    cidr_block                                     = string
    availability_zone                              = string
    assign_ipv6_address_on_creation                = optional(bool)
    availability_zone_id                           = optional(string)
    customer_owned_ipv4_pool                       = optional(string)
    enable_dns64                                   = optional(bool)
    enable_lni_at_device_index                     = optional(string)
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)
    enable_resource_name_dns_a_record_on_launch    = optional(bool)
    ipv6_cidr_block                                = optional(string)
    ipv6_native                                    = optional(bool)
    map_customer_owned_ip_on_launch                = optional(bool)
    map_public_ip_on_launch                        = optional(bool)
    outpost_arn                                    = optional(string)
    private_dns_hostname_type_on_launch            = optional(string)
    tags                                           = optional(map(string))
  }))

  default = {}
}
##################################################
#endregion
##################################################
