
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "${terraform.workspace}-ecs_cluster"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = var.statics_hosts_max
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = var.dynamic_hosts
      }
    }
  }

  services = {
    for service in var.micro_services : service => {
      cpu         = 256
      memory      = 512
      launch_type = "FARGATE"

      container_definitions = {
        "${service}" = {
          cpu                      = 256
          memory                   = 512
          essential                = true
          image                    = "${var.ecr_base_url}/${service}:latest"
          readonly_root_filesystem = false

          environment = [
            { name = "DB_USER", value = var.db_user },
            { name = "DB_NAME", value = var.db_name },
            { name = "DB_PASS", value = var.db_pass },
          ]

          port_mappings = [
            {
              name          = "http"
              protocol      = "tcp"
              containerPort = 80
            }
          ]
        }
      }

      subnet_ids = var.private_subnet_ids

      security_group_rules = {
        alb_ingress = {
          type        = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          description = "HTTP port"
          cidr_blocks = ["0.0.0.0/0"]
        }

        db_ingress = {
          type                     = "ingress"
          from_port                = 5432
          to_port                  = 5432
          protocol                 = "tcp"
          description              = "Postgres Service"
          source_security_group_id = var.postgresql_sg_id
        }

        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb[service].target_groups["default-instance"].arn
          container_name   = service
          container_port   = 80
        }
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }

  depends_on = [module.alb]
}

## LoadBalancer
module "alb" {
  source   = "terraform-aws-modules/alb/aws"
  for_each = toset(var.micro_services)

  internal                   = false
  vpc_id                     = var.vpc_id
  load_balancer_type         = "application"
  subnets                    = var.public_subnet_ids
  name                       = "${each.key}-${terraform.workspace}-alb"
  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP web traffic"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS web traffic"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr
    }
  }

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.certificate_arn
      forward = {
        target_group_key = "default-instance"
      }
    },
    http = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  target_groups = {
    "default-instance" = {
      name_prefix = "tg"
      port        = 80
      target_type = "ip"
      protocol    = "HTTP"
      vpc_id      = var.vpc_id
      target_id   = "172.0.15.254"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

## DNS
module "route53_A_to_CNAME_records" {
  source   = "terraform-aws-modules/route53/aws//modules/records"
  for_each = toset(var.micro_services)

  zone_name = var.domain_name
  records = [
    {
      name = "${each.key}-${terraform.workspace}"
      type = "A"
      alias = {
        name                   = module.alb[each.key].dns_name
        zone_id                = module.alb[each.key].zone_id
        evaluate_target_health = true
      }
    }
  ]
}
