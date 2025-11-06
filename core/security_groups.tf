# Security Group for web server
module "web_security_group" {
  source = "../modules/aws-security-groups"

  name        = "web-${var.environment}-${var.project_name}"
  description = "Security group for web server"
  vpc_id      = module.vpc.id

  ingress_rules = {
    "ssh" = {
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = "0.0.0.0/0"
      description = "SSH access"
    }
    "http" = {
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP access"
    }
    "https" = {
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS access"
    }
  }

  egress_rules = {
    "all_outbound" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "All outbound traffic"
    }
  }

  tags = {
    Name        = "sg-web-${var.environment}-${var.project_name}"
    Environment = var.environment
    Project     = var.project_name
    createvia   = "terraform"
  }
}