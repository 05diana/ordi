
module "vpc" {
  source           = "./modules/vpc"
  project          = var.project
  vpc_cidr         = var.vpc_cidr
  az_numbers       = var.az_numbers
  environment      = var.environment
  subnet_bits_mask = var.subnet_bits_mask
}

module "ec2" {
  source            = "./modules/ec2"
  project           = var.project
  vpc_cidr          = var.vpc_cidr
  ssh_keys          = var.ssh_keys
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "rds" {
  source               = "./modules/rds"
  db_name              = var.db_name
  db_user              = var.db_user
  project              = var.project
  vpc_cidr             = var.vpc_cidr
  multi_az             = var.multi_az
  db_version           = var.db_version
  db_storage           = var.db_storage
  db_password          = var.db_password
  environment          = var.environment
  db_instance_class    = var.db_instance_class
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.vpc.db_security_group_id
}

module "registry" {
  source         = "./modules/registry"
  region         = var.region
  project        = var.project
  environment    = var.environment
  micro_services = var.micro_services
}

module "ecs" {
  source             = "./modules/ecs"
  region             = var.region
  project            = var.project
  db_user            = var.db_user
  db_name            = var.db_name
  vpc_cidr           = var.vpc_cidr
  db_password        = var.db_password
  domain_name        = var.domain_name
  environment        = var.environment
  ecr_base_url       = var.ecr_base_url
  dynamic_hosts      = var.dynamic_hosts
  micro_services     = var.micro_services
  certificate_arn    = var.certificate_arn
  statics_hosts_min  = var.statics_hosts_min
  statics_hosts_max  = var.statics_hosts_max
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  db_security_group_id  = module.vpc.db_security_group_id
}
