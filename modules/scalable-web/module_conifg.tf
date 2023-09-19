
# Provider required for the module
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Region is parameterized
provider "aws" {
  region = var.region
}

