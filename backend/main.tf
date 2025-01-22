
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = "tfstate-ordi-io4wdpklwwjdattfsri2egsjecb2sdpufiusipyg15edqu8oo"
  force_destroy = true

  tags = {
    Project   = "ordi"
    Terraform = "true"
  }
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tfstate_locking" {
  name         = "tfstate-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project   = "ordi"
    Terraform = "true"
  }
}
