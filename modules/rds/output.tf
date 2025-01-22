
output "db_instance_identifier" {
  description = "RDS Identifier"
  value       = module.rds.db_instance_identifier
}

output "db_instance_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_arn" {
  description = "RDS ARN"
  value       = module.rds.db_instance_arn
}
