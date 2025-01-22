
module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = var.vpc_cidr
  az_numbers       = var.az_numbers
  subnet_bits_mask = var.subnet_bits_mask
}

module "security" {
  source   = "./modules/security"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "ec2" {
  source            = "./modules/ec2"
  ssh_keys          = var.ssh_keys
  public_subnet_ids = module.vpc.public_subnet_ids
  postgresql_sg_id  = module.security.postgresql_sg_id
  ssh_sg_id         = module.security.ssh_sg_id
}

module "rds" {
  source              = "./modules/rds"
  db_name             = var.db_name
  db_user             = var.db_user
  multi_az            = var.multi_az
  db_version          = var.db_version
  db_storage          = var.db_storage
  db_password         = var.db_password
  db_instance_class   = var.db_instance_class
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnet_ids
  postgresql_sg_id    = module.security.postgresql_sg_id
}

module "registry" {
  source         = "./modules/registry"
  region         = var.region
  micro_services = var.micro_services
}

module "ecs" {
  source             = "./modules/ecs"
  db_user            = var.db_user
  db_name            = var.db_name
  db_pass            = var.db_password
  db_host            = module.rds.db_instance_endpoint
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  domain_name        = var.domain_name
  ecr_base_url       = var.ecr_base_url
  dynamic_hosts      = var.dynamic_hosts
  micro_services     = var.micro_services
  certificate_arn    = var.certificate_arn
  statics_hosts_max  = var.statics_hosts_max
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  postgresql_sg_id   = module.security.postgresql_sg_id
}
