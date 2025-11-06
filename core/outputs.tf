# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = module.vpc.arn
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = module.vpc.subnet_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

# Route Table Outputs
output "route_table_id" {
  description = "ID of the public route table"
  value       = module.public_route_table.id
}

# Security Group Outputs
output "web_security_group_id" {
  description = "ID of the web security group"
  value       = module.web_security_group.id
}

output "web_security_group_arn" {
  description = "ARN of the web security group"
  value       = module.web_security_group.arn
}

# EC2 Outputs
output "web_server_instance_id" {
  description = "ID of the web server instance"
  value       = module.web_server.instance_id
}

output "web_server_instance_arn" {
  description = "ARN of the web server instance"
  value       = module.web_server.instance_arn
}

output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = module.web_server.instance_id != null ? data.aws_instance.web_server.public_ip : null
}

output "web_server_private_ip" {
  description = "Private IP address of the web server"
  value       = module.web_server.instance_id != null ? data.aws_instance.web_server.private_ip : null
}

# Key Pair Outputs
output "key_pair_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.es.key_name
}

output "private_key_ssm_parameter" {
  description = "SSM Parameter name containing the private key"
  value       = aws_ssm_parameter.es_private_key.name
}

# Data source to get instance details
data "aws_instance" "web_server" {
  instance_id = module.web_server.instance_id
}