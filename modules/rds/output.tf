output "db_instance_endpoint" {
  description = "RDS Endpoint"
  ##value       = module.db.db_instance_endpoint
  value = aws_db_instance.db.endpoint
}

output "db_instance_identifier" {
  description = "RDS Identifier"
  ##value       = module.db.db_instance_identifier
  value = aws_db_instance.db.identifier
}

output "db_instance_arn" {
  description = "RDS ARN"
  ##value       = module.db.db_instance_arn
  value = aws_db_instance.db.arn
}
