
resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-${var.project}-rds-sg"
  description = "RDS Security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.project}-rds-sg"
    Environment = var.environment
    Projectname = var.project
    Terraform   = "true"
  }
}
