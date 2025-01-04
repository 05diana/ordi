
locals {
  azs              = slice(data.aws_availability_zones.available.names, 0, var.az_numbers)
  public_subnets   = [for i in range(var.az_numbers) : cidrsubnet(var.vpc_cidr, var.subnet_bits_mask, i)]
  private_subnets  = [for i in range(var.az_numbers) : cidrsubnet(var.vpc_cidr, var.subnet_bits_mask, i + var.az_numbers)]
  database_subnets = [for i in range(var.az_numbers) : cidrsubnet(var.vpc_cidr, var.subnet_bits_mask, i + (var.az_numbers * 2))]
  # private_subnet_names = [for i in range(var.az_numbers) : "${var.environment}-${var.project}-private-subnet${i + 1}"]
  # public_subnet_names  = [for i in range(var.az_numbers) : "${var.environment}-${var.project}-public-subnet${i + 1}"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  azs                  = local.azs
  cidr                 = var.vpc_cidr
  name                 = "${var.environment}-${var.project}-vpc"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  #single_nat_gateway     = false
  #one_nat_gateway_per_az = false
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Projectname = var.project
    Environment = var.environment
    Name        = "${var.environment}-vpc"
  }
}
