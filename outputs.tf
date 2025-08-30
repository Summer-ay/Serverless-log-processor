output "s3_bucket_name" {
  value = aws_s3_bucket.logs_bucket.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.logs_table.name
}

output "lambda_function_name" {
  value = aws_lambda_function.log_processor.function_name
}

