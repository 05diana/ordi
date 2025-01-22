
## VPC
variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^(us-(east|west)-[12])$", var.region))
    error_message = "The region must be either us-east-1, us-east-2, us-west-1, or us-west-2."
  }
}

variable "environment" {
  description = "Environment Name (dev, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = can(regex("^(dev|pr[do])[a-z0-9]{0,9}$", var.environment))
    error_message = "The environment name must start with 'dev', 'pro', or 'prd', followed by up to 9 lowercase letters or numbers, with a total length between 3 and 12 characters."
  }

  validation {
    condition     = terraform.workspace == var.environment
    error_message = "Invalid workspace: The active workspace '${terraform.workspace}' does not match the specified environment '${var.environment}'."
  }
}

variable "domain_name" { #REQUIRED
  description = "Route53 Managed DNS"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9.]+$", var.domain_name))
    error_message = "The domain name must contain only lowercase letters, numbers, or dots (.)."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.0.0.0/16"
  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(\\d|[12]\\d|3[0-2])$", var.vpc_cidr))
    error_message = "The VPC CIDR block must be a valid IPv4 address followed by a / and a subnet mask (1-32)."
  }
}

variable "az_numbers" {
  description = "Number of AZs in use for the project"
  type        = number
  default     = 2
  validation {
    condition = (
      (var.region == "us-east-1" && var.az_numbers >= 2 && var.az_numbers <= 12) ||
      (var.region == "us-east-2" && var.az_numbers >= 2 && var.az_numbers <= 6) ||
      (var.region == "us-west-1" && var.az_numbers >= 2 && var.az_numbers <= 4) ||
      (var.region == "us-west-2" && var.az_numbers >= 2 && var.az_numbers <= 8)
    )
    error_message = "The number of AZs must be between 2 and the allowed maximum for the selected region: us-east-1 (12), us-east-2 (6), us-west-1 (4), us-west-2 (8)."
  }
}

variable "subnet_bits_mask" {
  description = "Increase the net mask for subnets in bits"
  type        = number
  default     = 6
  validation {
    condition     = var.subnet_bits_mask >= 4 && var.subnet_bits_mask <= 12
    error_message = "The subnet_bits_mask must be a number between 4 and 12."
  }
}

## RDS
variable "db_storage" {
  description = "Allocated storage for the database (in GB)"
  type        = number
  default     = 5
  validation {
    condition     = var.db_storage >= 5 && var.db_storage <= 1048576
    error_message = "The allocated storage for the database must be between 5 GB and 1048576 GB (1 TB)."
  }
}

variable "db_instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.micro"
  validation {
    condition     = can(regex("^db\\.[a-z0-9]+\\.(large|medium|small|micro)$", var.db_instance_class))
    error_message = "The instance class must start with 'db.', followed by alphanumeric characters, and end with '.large', '.medium', '.small', or '.micro'. Example: db.t3.large"
  }
}

variable "db_user" { #REQUIRED
  type        = string
  description = "Database username"
}

variable "db_password" { #REQUIRED
  sensitive   = true
  type        = string
  description = "Database password"
}

variable "db_name" { #REQUIRED
  type        = string
  description = "Name of the database"
}

variable "db_version" {
  description = "Engine version number"
  type        = string
  default     = "17.2"
  validation {
    condition     = can(regex("^(1[2-7])\\.([0-9]{1,2})$", var.db_version))
    error_message = "The engine version must be in the format 'XX.Y', where XX is between 12 and 17, and YY is a one or two digit number."
  }
}

variable "multi_az" {
  default     = false
  type        = bool
  description = "Enable multi-AZ deployment"
}

variable "ssh_keys" { #REQUIRED
  type        = list(string)
  description = "Public SSH Keys"
}

## Registry
variable "micro_services" { #REQUIRED
  type        = list(string)
  description = "Micro Service List Name"
}

## ECS
variable "dynamic_hosts" {
  default     = 4
  type        = number
  description = "SPOT Instances in cluster"
}

variable "statics_hosts_min" {
  default     = 1
  type        = number
  description = "Minimun Standar Instances in cluster"
}

variable "statics_hosts_max" {
  default     = 1
  type        = number
  description = "Maximun Standar Instances in cluster"
}

variable "certificate_arn" { #REQUIRED
  description = "ARN AWS Certificate"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:acm:us-(east|west)-[12]:[0-9]{12}:certificate/[a-zA-Z0-9-]+$", var.certificate_arn))
    error_message = "The certificate ARN ID."
  }
}

variable "ecr_base_url" { #REQUIRED
  description = "Base URL for ECR repository"
  type        = string
}
