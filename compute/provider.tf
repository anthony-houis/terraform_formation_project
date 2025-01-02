terraform {
  backend "s3" {
    bucket         = "formation-dev"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "formation_lock_table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.82.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}