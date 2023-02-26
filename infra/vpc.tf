module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "rearc-vpc-${terraform.workspace}"
  cidr = var.vpc_cidr

  azs  = var.azs
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true

  tags = local.common_tags
}
