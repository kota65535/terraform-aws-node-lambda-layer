terraform {
  backend "s3" {
    bucket = "terraform-backend-561678142736"
    region = "ap-northeast-1"
    key    = "terraform-aws-nodejs-lambda-layer.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
  required_version = "~> 1.6.0"
}

provider "aws" {
  region = "ap-northeast-1"
}
