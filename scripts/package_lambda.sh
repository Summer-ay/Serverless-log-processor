#!/bin/bash
set -e

echo "Packaging Lambda function..."
cd lambda

# Install dependencies (if any) into a temp folder
mkdir -p package
pip install --target ./package -r requirements.txt

# Copy function code
cp lambda_function.py package/

# Zip it
cd package
zip -r9 ../../lambda_function.zip .
cd ../../

echo "Lambda package created: lambda_function.zip"

