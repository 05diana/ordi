
locals {
  engine_family = "postgres${split(".", var.db_version)[0]}"
}

resource "aws_db_instance" "db" {
  apply_immediately           = true
  multi_az                    = var.multi_az
  db_name                     = var.db_name
  username                    = var.db_user
  password                    = var.db_password
  allocated_storage           = var.db_storage
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.db_version
  instance_class              = var.db_instance_class
  publicly_accessible         = true
  skip_final_snapshot         = true
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true
  identifier                  = "${var.environment}-${var.project}-db-instance"
  vpc_security_group_ids      = [var.db_security_group_id]
  db_subnet_group_name        = aws_db_subnet_group.main.name

  tags = {
    Terraform   = "true"
    Projectname = var.project
    Environment = var.environment
    Name        = "${var.environment}-db"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-${var.project}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Terraform   = "true"
    Projectname = var.project
    Environment = var.environment
    Name        = "${var.environment}-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "postgresql" {
  name   = "${var.environment}-postgresql-parameter-group"
  family = local.engine_family

  tags = {
    Terraform   = "true"
    Projectname = var.project
    Name        = "${var.environment}-pg-params"
    Environment = var.environment
  }
}
