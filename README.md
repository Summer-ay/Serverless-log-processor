# Serverless Log Processor

This project demonstrates a serverless pipeline built using the AWS Management Console(manually) and Terraform(automated).
When a file is uploaded to an S3 bucket, an AWS Lambda function is triggered.
The Lambda logs details of the uploaded file into a DynamoDB table.

## I implemented this project in two ways:
- Using the AWS Console
- Using Terraform (Infrastructure as Code)

## Features

- Event-driven architecture using S3 → Lambda → DynamoDB
- Completely serverless (no servers to manage)
- Real-time file logging and tracking
- Easy to replicate using the AWS Console

## Architecture

     +-------------+       put event      +-------------+     triggers       +-------------+        writes        +----------------+
     |   S3 Bucket |  ----------------->  |  EventBridge| -----------------> |   Lambda    |  ----------------->  |   DynamoDB     |
     | (File Upload)|                     |    Rules    |                    | (Python)    |                      | (Log Storage)  |
     +-------------+                      +-------------+                    +-------------+                      +----------------+

# Approach 1: AWS Console
## Steps
 #### 1️. Create an S3 Bucket
- Go to S3 → Create bucket
- Give it a globally unique name (e.g., log-ingestion-bucket-2025)
- Leave defaults and create

#### 2️.  Create a DynamoDB Table
- Go to DynamoDB → Create table
- Table name: log-table
- Partition key: id (String)
- Use On-Demand billing

#### 3️.  Create a Lambda Function
- Go to Lambda → Create function
- Choose Author from scratch
- Runtime: Python 3.11
- Execution role: Create new role with basic Lambda permissions
- Create function

![WhatsApp Image 2025-08-30 at 08 42 58_fea8f318](https://github.com/user-attachments/assets/d0cb95b4-1171-4ddf-96f2-7a33f7d901a3)  

### I wrote this following python code.
 
    import json
    import boto3
    import os
    from datetime import datetime
   
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("log-table")  # replace if different
       
    def lambda_handler(event, context):
        for record in event["Records"]:
            bucket = record["s3"]["bucket"]["name"]
            key = record["s3"]["object"]["key"]
            timestamp = datetime.utcnow().isoformat()
       
            table.put_item(
                Item={
                    "id": f"{bucket}/{key}",
                    "bucket": bucket,
                    "filename": key,
                    "timestamp": timestamp
                }
           )
       
        return {
            "statusCode": 200,
            "body": json.dumps("File logged successfully")
        }
  (This code will show the characteristics of the file uploaded in S3 in DynamoDB)
  - Click Deploy after saving the code.

#### 4. Grant Permissions with IAM Role
- Go to the IAM role created for Lambda
- Attach policies:
  - ``AmazonDynamoDBFullAccess`` (for DynamoDB)
  - ``AmazonS3ReadOnlyAccess`` (for reading S3 event metadata)
  - ``CloudWatchLogsFullAccess`` (for logging execution)

#### 5. Add S3 Trigger to Lambda
- Open your Lambda → Add trigger → Select S3
- Choose your bucket
- Event type: ```All object create events```
- Save

![WhatsApp Image 2025-08-30 at 10 34 31_b4fc694b](https://github.com/user-attachments/assets/e45f8804-88a6-4d16-bb15-a5325fa7e142)

Now Lambda will trigger whenever a file is uploaded to S3.

#### 6. EventBridge Rule Trigger
- Go to EventBridge → Create rule
- Pattern: S3 PutObject event (from CloudTrail)
- Target: the same Lambda function.

This ensures Lambda can be triggered directly from S3 or via EventBridge.

#### 7. Test the Flow
- Upload any file to the S3 bucket

![WhatsApp Image 2025-08-30 at 09 54 08_b4333bfa](https://github.com/user-attachments/assets/d307d00d-980c-44ec-80a0-950bb1a96d92)

- Go to DynamoDB → Tables → Explore items

![WhatsApp Image 2025-08-30 at 09 10 36_4830bac3](https://github.com/user-attachments/assets/206b34da-304b-4843-9c24-1058b948c03e)

- You should see the file details stored (bucket, filename, timestamp)
- I also checked CloudWatch Logs for Lambda execution details

#### (Optional): 
You can also simulate an event without actually uploading a file to S3 in AWS Console.

 - I created a fake event "S3 PutObjecct event" and had the following JSON code tested first before actually uploading the file to S3.

        {
          "Records": [
            {
              "s3": {
                "bucket": {
                  "name": "my-upload-bucket"
                },
                "object": {
                  "key": "example.txt"
                }
              }
            }
          ]
        }

     ![WhatsApp Image 2025-08-30 at 09 06 12_8c79f684](https://github.com/user-attachments/assets/a7a4c478-cbfd-477c-8783-045228b3c51d)

# Approach 2: Terraform (Infrastructure as Code)
  Instead of manually creating resources, I automated everything using Terraform. 
  
  All the above files and directories contains the code I wrote for this project.

### Here are all the uses for each file used

#### 1. main.tf
- Defines your main infrastructure resources:
    - S3 bucket for file uploads
    - DynamoDB table to store logs
    - Lambda function to process events
    - (Optionally) EventBridge rule if you use it

#### 2. variables.tf
- Stores input variables (like bucket name, DynamoDB table name, Lambda function name).
- Makes the code reusable and configurable.

#### 3. outputs.tf
- Defines outputs Terraform will show after deployment, e.g.:
   - Lambda ARN
   - DynamoDB table name
   - S3 bucket name

#### 4. iam.tf
- Defines the IAM role and permissions for Lambda so it can:
   - Read events from S3
   - Write to DynamoDB

#### 5. lambda/
- lambda_function.py
    - Your Python Lambda handler: Triggered when a file is uploaded, processes metadata, and stores it in DynamoDB.

#### 6. scripts/
- package_lambda.sh
  - Bash script to: Zip your Lambda code + dependencies

### Outcome
- Both manual (AWS Console) and automated (Terraform IaC) ways implemented
- Serverless workflow works: uploading a file to S3 → logs into DynamoDB automatically
- Gained hands-on with:
  - AWS S3, Lambda, DynamoDB, IAM
  - Terraform for automation
