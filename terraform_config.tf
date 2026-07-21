terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # pinning to v6.x
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
}
