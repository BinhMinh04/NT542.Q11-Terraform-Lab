##################################################
#region Route Table
##################################################

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# Create route table entries in a route table
resource "aws_route" "this" {
  for_each = {
    for k, v in var.routes : k => v
    if !(
      v.vpc_peering_connection_id != null &&
      v.destination_cidr_block == "0.0.0.0/0"
    )
  }

  route_table_id            = aws_route_table.main.id
  destination_cidr_block    = each.value.destination_cidr_block
  carrier_gateway_id        = each.value.carrier_gateway_id
  core_network_arn          = each.value.core_network_arn
  egress_only_gateway_id    = each.value.egress_only_gateway_id
  gateway_id                = each.value.gateway_id
  local_gateway_id          = each.value.local_gateway_id
  nat_gateway_id            = each.value.nat_gateway_id
  network_interface_id      = each.value.network_interface_id
  transit_gateway_id        = each.value.transit_gateway_id
  vpc_endpoint_id           = each.value.vpc_endpoint_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}

# Create a route table association with a subnet, an Internet gateway, or a virtual private gateway
resource "aws_route_table_association" "this" {
  for_each = var.route_table_associations

  route_table_id = aws_route_table.main.id

  subnet_id  = each.value.subnet_id
  gateway_id = each.value.gateway_id
}
##################################################
#endregion
##################################################