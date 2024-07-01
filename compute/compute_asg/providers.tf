# Terraform versions and providers.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

module "network" {
  source       = "./network"
  app_name     = "mimas"
  vpc_cidr     = "10.100.0.0/22"
  subnet_cidr  = ["10.100.0.0/23", "10.100.2.0/23"]
  enable_dns   = true
  av_zone      = ["us-east-1a", "us-east-1b"]
  gateway_cidr = "0.0.0.0/0"
  protocol     = "tcp"
}
