terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
   common_tags = {
     user = "desire.bahbioh"
     purpose = "rearc interview"
   }
}