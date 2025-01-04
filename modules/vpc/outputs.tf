
data "aws_availability_zones" "available" {}

output "vpc_id" {
  description = "VPC ID Created"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnts IDs list"
  value       = module.vpc.public_subnets
}

output "public_subnet_cidrs" {
  description = "Public Subnts CIDR list"
  value       = local.public_subnets
}

output "private_subnet_ids" {
  description = "Private Subnts IDs list"
  value       = module.vpc.private_subnets
}

output "private_subnet_cidrs" {
  description = "Private Subnts CIDR list"
  value       = local.private_subnets
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "availability_zones" {
  description = "Availability zones list"
  value       = local.azs
}

output "db_security_group_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds_sg.id
}
