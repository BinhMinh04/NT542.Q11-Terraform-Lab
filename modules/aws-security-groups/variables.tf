variable "name" {
  description = "Name of the security group"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
  default     = null
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself"
  type        = bool
  default     = false
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the security group"
  type        = map(string)
  default     = {}
}

variable "egress_rules" {
  description = "List of egress rules for VPC security groups"
  type = map(object({
    referenced_security_group_id = optional(string)
    ip_protocol                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    description                  = optional(string)
    tags                         = optional(map(string))
  }))
  default = {}
}


variable "ingress_rules" {
  description = "List of ingress rules for VPC security groups"
  type = map(object({
    referenced_security_group_id = optional(string)
    ip_protocol                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    description                  = optional(string)
    tags                         = optional(map(string))
  }))
  default = {}
}

