###############################################################################
# main.tf — Root Terraform Configuration
###############################################################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

###############################################################################
# Module Imports
###############################################################################

# S3 Data Layers
module "s3_layers" {
  source = "./s3_buckets"
}

###############################################################################
# Outputs
###############################################################################

output "s3_layer_buckets" {
  description = "List of S3 buckets representing the data storage layers"
  value       = module.s3_layers.bucket_names
}

###############################################################################
# Notes
###############################################################################
# This configuration demonstrates how Terraform could provision data storage
# layers for an ETL pipeline. Other components could be IaC-managed in a similar
# way but are omitted due to time constraints.
###############################################################################
