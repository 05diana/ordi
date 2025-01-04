
output "ecr_base_url" {
  value = module.registry[var.micro_services[0]].repository_url
}

