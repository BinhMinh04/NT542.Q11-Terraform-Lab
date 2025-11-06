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
    # Log everything for debugging
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    
    echo "Starting user data script at $(date)"
    
    # Update system
    yum update -y
    yum install -y httpd
    
    # Start and enable httpd
    systemctl start httpd
    systemctl enable httpd
    
    # Function to get metadata with retry
    get_metadata() {
        local endpoint=$1
        local retries=10
        local delay=2
        
        for i in $(seq 1 $retries); do
            echo "Attempt $i to fetch $endpoint"
            result=$(curl -s --max-time 5 http://169.254.169.254/latest/meta-data/$endpoint)
            if [[ $? -eq 0 && -n "$result" ]]; then
                echo "$result"
                return 0
            fi
            echo "Failed attempt $i, retrying in $delay seconds..."
            sleep $delay
        done
        echo "UNAVAILABLE"
        return 1
    }
    
    # Wait for network to be ready
    echo "Waiting for network to be ready..."
    sleep 10
    
    # Get metadata with retry logic
    INSTANCE_ID=$(get_metadata "instance-id")
    AZ=$(get_metadata "placement/availability-zone")
    PUBLIC_IP=$(get_metadata "public-ipv4")
    PRIVATE_IP=$(get_metadata "local-ipv4")
    
    # Create HTML page
    cat > /var/www/html/index.html << HTML
<!DOCTYPE html>
<html>
<head>
    <title>${var.project_name} Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .info { background: #f0f0f0; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <h1>🚀 Hello from ${var.project_name} Web Server</h1>
    <div class="info">
        <h3>Instance Information:</h3>
        <p><strong>Instance ID:</strong> <span class="success">$${INSTANCE_ID}</span></p>
        <p><strong>Availability Zone:</strong> <span class="success">$${AZ}</span></p>
        <p><strong>Public IP:</strong> <span class="success">$${PUBLIC_IP}</span></p>
        <p><strong>Private IP:</strong> <span class="success">$${PRIVATE_IP}</span></p>
    </div>
    <div class="info">
        <h3>Server Details:</h3>
        <p><strong>Environment:</strong> ${var.environment}</p>
        <p><strong>Project:</strong> ${var.project_name}</p>
        <p><strong>Deployment Time:</strong> $(date)</p>
        <p><strong>Server Status:</strong> <span class="success">✅ Running</span></p>
    </div>
    <div class="info">
        <h3>Logs:</h3>
        <p>User data logs: <code>/var/log/user-data.log</code></p>
        <p>Apache logs: <code>/var/log/httpd/</code></p>
    </div>
</body>
</html>
HTML
    
    # Set proper permissions
    chown apache:apache /var/www/html/index.html
    chmod 644 /var/www/html/index.html
    
    # Restart httpd to ensure it's running
    systemctl restart httpd
    
    echo "User data script completed at $(date)"
    echo "Instance ID: $INSTANCE_ID"
    echo "Availability Zone: $AZ"
    echo "Public IP: $PUBLIC_IP"
    echo "Private IP: $PRIVATE_IP"
  EOF
  )

  tags = {
    Name        = "ec2-web-${var.environment}-${var.project_name}"
    Environment = var.environment
    Project     = var.project_name
    createvia   = "terraform"
  }
}
