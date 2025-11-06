environment  = "lab"
project_name = "NT542.Q11"

vpc_cidr_block = "10.25.0.0/16"

vpc_subnets = {
  "subnet-lab-NT542-Q11" = {
    cidr_block              = "10.25.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name        = "subnet-lab-NT542-Q11"
      Environment = "lab"
      Project     = "NT542.Q11"
      createvia   = "terraform"
    }
  }
}

# EC2 Configuration
instance_type = "t3.micro"
