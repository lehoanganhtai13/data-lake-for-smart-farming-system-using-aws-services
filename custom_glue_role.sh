#!/bin/bash

# Load environment variables
source env.sh

# Create IAM role for AWS Glue access
aws iam create-role --role-name $GLUE_ROLE_NAME --description "Allows Glue to call AWS services on your behalf." \
                    --assume-role-policy-document file://trust_policy/glue_trust_policy.json

# Grant access to the role
aws iam attach-role-policy --role-name $GLUE_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole
aws iam attach-role-policy --role-name $GLUE_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
