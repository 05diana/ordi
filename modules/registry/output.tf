
output "registry" {
  value = {
    for service in var.micro_services :
    service => {
      repository_url = module.registry[service].repository_url
    }
  }
}

output "ecr_base_url" {
  value = module.registry[var.micro_services[0]].repository_url
}
