# Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "es" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "es" {
  key_name   = "es-${var.environment}-key"
  public_key = tls_private_key.es.public_key_openssh
}

resource "aws_ssm_parameter" "es_private_key" {
  name        = "/${var.environment}/ec2/keypair/elasticsearch"
  description = "Private key for ES Dev EC2"
  type        = "SecureString"
  value       = tls_private_key.es.private_key_pem
}

# Web Server EC2 Instance
module "web_server" {
  source = "../modules/aws-ec2"

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.subnet_id["subnet-lab-NT542-Q11"]
  availability_zone           = var.vpc_subnets["subnet-lab-NT542-Q11"].availability_zone
  vpc_security_group_ids      = [module.web_security_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.es.key_name

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ${var.project_name} Web Server</h1>" > /var/www/html/index.html
    echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
    echo "<p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>" >> /var/www/html/index.html
  EOF
  )

  tags = {
    Name        = "ec2-web-${var.environment}-${var.project_name}"
    Environment = var.environment
    Project     = var.project_name
    createvia   = "terraform"
  }
}
