##################################################
#region AWS VPC with Subnets
##################################################

# Create a VPC
resource "aws_vpc" "main" {
  #checkov:skip=CKV2_AWS_11: "Ensure VPC flow logging is enabled in all VPCs"
  #checkov:skip=CKV2_AWS_12: "Ensure the default security group of every VPC restricts all traffic"
  cidr_block                           = var.cidr_block
  instance_tenancy                     = var.instance_tenancy
  ipv4_ipam_pool_id                    = var.ipv4_ipam_pool_id
  ipv4_netmask_length                  = var.ipv4_netmask_length
  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  enable_dns_hostnames                 = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block     = var.assign_generated_ipv6_cidr_block
  tags                                 = var.tags
}

# Take control of the default VPC security group generated from the above aws_vpc resource and remove all ingress/egress rules.
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.main.id

  tags = coalesce(
    var.tags_sg,
    {
      Name = "${var.prefix_name}-default-sg"
    }
  )
}

# Take control of the default VPC route table generated from the above aws_vpc resource and remove all routes.
resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${var.prefix_name}-default-rt"
  }
}

# Create subnets based on a map of objects
resource "aws_subnet" "this" {
  #checkov:skip=CKV_AWS_130: "Ensure VPC subnets do not assign public IP by default"

  for_each = var.subnets

  vpc_id = aws_vpc.main.id

  cidr_block                                     = each.value.cidr_block
  availability_zone                              = each.value.availability_zone
  availability_zone_id                           = each.value.availability_zone_id
  customer_owned_ipv4_pool                       = each.value.customer_owned_ipv4_pool
  enable_dns64                                   = each.value.enable_dns64
  enable_lni_at_device_index                     = each.value.enable_lni_at_device_index
  enable_resource_name_dns_aaaa_record_on_launch = each.value.enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = each.value.enable_resource_name_dns_a_record_on_launch
  ipv6_cidr_block                                = each.value.ipv6_cidr_block
  ipv6_native                                    = each.value.ipv6_native
  map_customer_owned_ip_on_launch                = each.value.map_customer_owned_ip_on_launch
  map_public_ip_on_launch                        = each.value.map_public_ip_on_launch
  outpost_arn                                    = each.value.outpost_arn
  private_dns_hostname_type_on_launch            = each.value.private_dns_hostname_type_on_launch
  tags                                           = each.value.tags
}

# Create an Internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix_name}-igw"
  }
}
##################################################
#endregion
##################################################
