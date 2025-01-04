
output "bastion_public_ip" {
  value       = module.ec2_instance.public_ip
  description = "Bastion host Public IP"
}

output "bastion_sg_id" {
  value       = aws_security_group.bastion_sg.id
  description = "Bastion host Security Group ID"
}
