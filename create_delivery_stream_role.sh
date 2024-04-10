#!/bin/bash

# Load environment variables
source env.sh
source credential_info.sh

# Create policy for AWS Kinesis firehose
# Modify <stream-name>, <bucket-name>, and <region> to fit your policy profile in json file
aws iam create-policy --policy-name $KINESIS_POLICY_NAME \
			          --policy-document file://kinesis_policy/kinesis_policy_settings.json \
			          --description "Policy for Kinesis firehose to get access to Apache Kafka APIs for MSK, CloudWatch Logs, Glue, Kinesis, KMS, Lambda, MSK, and S3."

# Create IAM role for AWS Kinesis firehose access
aws iam create-role --role-name $KINESIS_ROLE_NAME --description "Allows Kinesis to call AWS services on your behalf." \
                    --assume-role-policy-document file://kinesis_policy/kinesis_trust_policy.json

# Grant access to the role
aws iam attach-role-policy --role-name $KINESIS_ROLE_NAME --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$KINESIS_POLICY_NAME
