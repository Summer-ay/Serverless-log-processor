terraform {
	required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}

provider "aws" {
	region = var.region
}

variable "serverless_log_processor" { type = string }
variable "lock_table" { type = string default = "tf-state-locks" }

resource "aws_s3_bucket" "tf_state" {
	bucket = var.serverless_log_processor
	lifecycle { prevent_destroy = true }
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configration" "enc" {
  bucket = aws_s3_bucket.tf_state.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}

resource "aws_dynamodb_table" "locks" {
  name         = var.lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute { name = "LockID" type = "S" }
}

