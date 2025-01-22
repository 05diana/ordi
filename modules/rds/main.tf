
locals {
  engine_family = "postgres${split(".", var.db_version)[0]}"
}

module "rds" {
  source = "terraform-aws-modules/rds/aws"

  engine                      = "postgres"
  family                      = local.engine_family
  multi_az                    = var.multi_az
  engine_version              = var.db_version
  db_name                     = var.db_name
  username                    = var.db_user
  password                    = var.db_password
  allocated_storage           = var.db_storage
  instance_class              = var.db_instance_class
  skip_final_snapshot         = true
  deletion_protection         = false
  publicly_accessible         = true
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true
  identifier                  = "${terraform.workspace}-db-instance"
  subnet_ids                  = var.database_subnet_ids
  vpc_security_group_ids      = [var.postgresql_sg_id]
  create_db_subnet_group      = true
  storage_encrypted           = false
  manage_master_user_password = false

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}
