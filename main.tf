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
