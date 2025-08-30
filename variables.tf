variable "project_name" {
  description = "Name prefix for resources"
  default     = "serverless-log-processor"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "dynamodb_table" {
  description = "DynamoDB table name"
  default     = "log-table"
}

variable "s3_bucket" {
  description = "S3 bucket name"
  default     = "serverless-log-bucket-12345" # must be globally unique
}

