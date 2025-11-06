######################################
# Variables for EC2 Instance
######################################

variable "ami" {
  description = "The ID of the AMI to use for the instance."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start."
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in."
  type        = string
}

variable "availability_zone" {
  description = "The AZ to launch the instance in."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with."
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "The key name to use for the instance."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC."
  type        = bool
  default     = false
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection."
  type        = bool
  default     = false
}

variable "get_password_data" {
  description = "If true, the EC2 instance will retrieve the default Windows password."
  type        = bool
  default     = false
}

variable "hibernation" {
  description = "If true, the instance will be enabled for hibernation."
  type        = bool
  default     = false
}

variable "host_id" {
  description = "The ID of the dedicated host on which to launch the instance."
  type        = string
  default     = null
}

variable "host_resource_group_arn" {
  description = "ARN of the host resource group."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the instance."
  type        = string
  default     = null
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance (stop or terminate)."
  type        = string
  default     = "stop"
}

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses to assign to the ENI."
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "List of IPv6 addresses to assign to the ENI."
  type        = list(string)
  default     = []
}

variable "monitoring" {
  description = "If true, enables detailed monitoring."
  type        = bool
  default     = false
}

variable "placement_group" {
  description = "The placement group to start the instance in."
  type        = string
  default     = null
}

variable "placement_partition_number" {
  description = "The number of the partition the instance should launch in."
  type        = number
  default     = null
}

variable "private_ip" {
  description = "Private IP address to assign to the instance."
  type        = string
  default     = null
}

variable "secondary_private_ips" {
  description = "List of secondary private IP addresses."
  type        = list(string)
  default     = []
}

variable "source_dest_check" {
  description = "Controls whether source/destination checking is enabled on the instance."
  type        = bool
  default     = true
}

variable "tenancy" {
  description = "Tenancy of the instance (default, dedicated, or host)."
  type        = string
  default     = "default"
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "The base64 encoded user data to provide when launching the instance."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Whether to replace the instance when user_data changes."
  type        = bool
  default     = false
}
######################################
# Advanced Block: cpu_options, root_block_device, etc.
######################################

variable "cpu_options" {
  description = "The CPU options for the instance."
  type = object({
    amd_sev_snp      = optional(bool)
    core_count       = optional(number)
    threads_per_core = optional(number)
  })
  default = null
}

variable "root_block_device" {
  description = "Customize details about the root block device."
  type = object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
  })
  default = null
}

variable "ephemeral_block_device" {
  description = "Customize instance store volumes on the instance."
  type = list(object({
    device_name  = string
    no_device    = optional(bool)
    virtual_name = optional(string)
  }))
  default = []
}

variable "maintenance_options" {
  description = "The maintenance options for the instance."
  type = object({
    auto_recovery = optional(string)
  })
  default = null
}

variable "instance_market_options" {
  description = "The market (spot) options for the instance."
  type = object({
    spot_options = optional(object({
      instance_interruption_behavior = optional(string)
      max_price                      = optional(string)
      spot_instance_type             = optional(string)
      valid_until                    = optional(string)
    }))
  })
  default = null
}

variable "metadata_options" {
  description = "Customize metadata options for the instance."
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    instance_metadata_tags      = optional(string)
  })
  default = null
}

variable "launch_template" {
  description = "The launch template to use for the instance."
  type = object({
    name    = optional(string)
    version = optional(string)
  })
  default = null
}

######################################
# Variables for EBS Volumes
######################################

variable "ebs_volumes" {
  description = "A map of EBS volumes to create and attach to the instance."
  type = map(object({
    size                 = number
    final_snapshot       = optional(bool, false)
    iops                 = optional(number)
    multi_attach_enabled = optional(bool)
    type                 = optional(string, "gp3")
    kms_key_id           = optional(string)
    throughput           = optional(number)
    tags                 = map(string)
  }))
  default = {}
}
