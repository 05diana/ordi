
output "availability_zones" {
  description = "Avaulability Zones List"
  value       = module.vpc.azs
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public Subnts IDs list"
  value       = module.vpc.public_subnets
}

output "public_subnet_arns" {
  description = "Public Subnts ARNs list"
  value       = module.vpc.public_subnet_arns
}

output "public_subnet_cidrs" {
  description = "Public Subnts CIDR list"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "private_subnet_ids" {
  description = "Private Subnts IDs list"
  value       = module.vpc.private_subnets
}

output "private_subnet_arns" {
  description = "Private Subnts ARNs list"
  value       = module.vpc.public_subnet_arns
}

output "private_subnet_cidrs" {
  description = "Private Subnts CIDR list"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "database_subnet_ids" {
  description = "DataBase Subnts IDs list"
  value       = module.vpc.database_subnets
}

output "database_subnet_arns" {
  description = "DataBase Subnts ARNs list"
  value       = module.vpc.database_subnet_arns
}

output "database_subnet_cidrs" {
  description = "DataBase Subnts CIDR list"
  value       = module.vpc.database_subnets_cidr_blocks
}
