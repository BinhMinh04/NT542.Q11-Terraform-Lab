provider "aws" {
  region = "us-east-1"
}

terraform {
  # Comment out S3 backend for initial testing - uncomment when ready to use remote state
  backend "s3" {
    bucket       = "s3-lab-tfstate"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.96.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
