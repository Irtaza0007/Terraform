terraform {

    backend "s3" {
    bucket = "techtutorialswithcorvit-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
    
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

# Define a variable for the channel name to be used in the bucket name
variable "channel_name" {
  description = "The name of the channel"
  type        = string
  default     = "my-unique"
}

# Define a variable for the AWS region

variable "region"{
    description = "The AWS region to deploy resources"
    default     = "us-east-1"
}


# Define a variable for the environment
variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
}

# Define a local variable for the bucket and VPC name
locals {
  bucket_name = "${var.channel_name}-bucket-corvit-${var.environment}"
  vpc_name    = "${var.environment}-vpc"
}


# Create S3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = local.bucket_name
  region = var.region
  tags = {
    Name        = local.bucket_name 
    Environment = var.environment
  }
}

resource "aws_instance" "my_instance" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  tags = {
    Name        = "My EC2 Instance"
    Environment = var.environment
  }
}

# create vpc 

resource "aws_vpc" "sample" {
  cidr_block = "10.0.1.0/24"
  region     = var.region
  tags = {
    Environment = var.environment #local variable
    Name = local.vpc_name
  }
}

output "vpc_id" {
  value       = aws_vpc.sample.id
  description = "The ID of the created VPC"
}

output "aws_instance_id" {
  value       = aws_instance.my_instance.id
  description = "The ID of the created EC2 instance"
} 