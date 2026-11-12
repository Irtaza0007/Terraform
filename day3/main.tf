terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = "my-unique-demo-corvit-bucket-name-12345"

  tags = {
    Name        = "My S3 Bucket"
    Environment = "Dev"
  }
}