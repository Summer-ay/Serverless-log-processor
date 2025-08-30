import json
import boto3
import os
from datetime import datetime

#Connect to DynamoDB
dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMODB_TABLE"]
table = dynamo.Table(table_name)

def lambda_handler(event, context):
    """
    Triggered by an S3 PUT event
    Logs file details into DynamoDB.
    """

    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
        timestamp = datetime.utcnow().isformat()

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

