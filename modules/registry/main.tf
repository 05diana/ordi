
module "registry" {
  source   = "terraform-aws-modules/ecr/aws"
  for_each = toset(var.micro_services)

  repository_name         = each.key
  repository_force_delete = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  public_repository_catalog_data = {
    description       = "Repository for ${each.key} application"
    operating_systems = ["Linux"]
    architectures     = ["x86_64"]
  }

  tags = {
    Terraform     = "true"
    Projectname   = var.project
    Environment   = var.environment
    MicroServicio = "${each.key}-ms"
    Name          = "${var.environment}-ecr"
  }
}

resource "null_resource" "docker_build_push" {
  for_each = toset(var.micro_services)

  provisioner "local-exec" {
    command = <<EOT
      docker logout
      docker build -t ${module.registry[each.key].repository_url}:latest ${path.root}/${each.key}
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${module.registry[each.key].repository_url}
      docker push ${module.registry[each.key].repository_url}
      docker logout
      docker rmi ${module.registry[each.key].repository_url}
    EOT
  }

  triggers = {
    dockerfile = filemd5("${path.root}/${each.key}/Dockerfile")
  }
}
