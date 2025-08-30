# Serverless Log Processor (AWS Console Version)


This project demonstrates a serverless pipeline built using the AWS Management Console.
When a file is uploaded to an S3 bucket, an AWS Lambda function is triggered.
The Lambda logs details of the uploaded file into a DynamoDB table.

This was implemented fully through the AWS Console (graphical way) — without writing Terraform code.

## Features

- Event-driven architecture using S3 → Lambda → DynamoDB
- Completely serverless (no servers to manage)
- Real-time file logging and tracking
- Easy to replicate using the AWS Console

## Architecture



## Steps (AWS Console)
 1️  Create an S3 Bucket
- Go to S3 → Create bucket
- Give it a globally unique name (e.g., serverless-log-bucket-12345)
- Leave defaults and create

 2️  Create a DynamoDB Table
- Go to DynamoDB → Create table
- Table name: log-table
- Partition key: id (String)
- Use On-Demand billing

 3️  Create a Lambda Function
- Go to Lambda → Create function
- Choose Author from scratch
- Runtime: Python 3.11
- Execution role: Create new role with basic Lambda permissions
- Create function
