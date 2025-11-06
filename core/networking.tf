module "vpc" {
  source = "../modules/aws-vpc-with-subnets"

  cidr_block  = var.vpc_cidr_block
  subnets     = var.vpc_subnets
  prefix_name = "vpc-${var.environment}-${var.project_name}"

  tags = {
    Environment = var.environment
    Description = "VPC for ${var.project_name} in ${var.environment}"
    Project     = var.project_name
    createvia   = "terraform"
  }
}

# Public Route Table for Internet access
module "public_route_table" {
  source = "../modules/aws-route-table"

  name   = "rtb-public-${var.environment}-${var.project_name}"
  vpc_id = module.vpc.id

  routes = {
    "internet_route" = {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = module.vpc.igw_id
    }
  }

  route_table_associations = {
    for subnet_name, subnet_config in var.vpc_subnets : subnet_name => {
      subnet_id = module.vpc.subnet_id[subnet_name]
    }
  }

  tags = {
    Name        = "rtb-public-${var.environment}-${var.project_name}"
    Environment = var.environment
    Project     = var.project_name
    createvia   = "terraform"
  }
}
