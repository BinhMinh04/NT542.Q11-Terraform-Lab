resource "aws_security_group" "main" {
  name                   = var.name
  name_prefix            = var.name_prefix
  vpc_id                 = var.vpc_id
  description            = var.description
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = var.tags
}

# Create egress resource based on map of object
resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = var.egress_rules

  security_group_id            = aws_security_group.main.id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  description                  = each.value.description
  tags                         = each.value.tags
}
# Create ingress resource based on map of object
resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = var.ingress_rules

  security_group_id            = aws_security_group.main.id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  description                  = each.value.description
  tags                         = each.value.tags
}