##################################################
#region AWS VPC with Subnets
##################################################
output "arn" {
  description = "The VPC ARN"
  value       = aws_vpc.main.arn
}

output "id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_arn" {
  description = "The subnet ARN's based on the map of objects"

  value = {
    for k, v in aws_subnet.this : k => v.arn
  }

  sensitive = true
}

output "subnet_id" {
  description = "The subnet ID's based on the map of objects"

  value = {
    for k, v in aws_subnet.this : k => v.id
  }
}

output "igw_id" {
  description = "The Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}
##################################################
#endregion
##################################################
