# Terraform Block
terraform {
  required_version = "~> 1.2"  
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.14.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "s3-tfs-gb-st-01"
    key = "automation/dev/finance/eks/external-dns-ssl-lbc/terraform.tfstate"
    region = "ap-southeast-1"

    # For State Locking
    dynamodb_table = "ddb-tfl-gb-st-01"
  }
}