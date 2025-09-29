terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    region  = "us-east-1"
    encrypt = true
  }
  required_version = ">= 1.1.9"
}

provider "aws" {
  region = "us-east-1"
}
