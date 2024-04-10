#!/bin/bash

# Load environment variables
source env.sh
source credential_info.sh

# Remove delivery stream
aws firehose delete-delivery-stream --delivery-stream-name $KINESIS_STREAM_NAME
aws iam detach-role-policy --role-name $KINESIS_ROLE_NAME --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$KINESIS_POLICY_NAME
aws iam delete-policy --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$KINESIS_POLICY_NAME
aws iam delete-role --role-name $KINESIS_ROLE_NAME

# Remove Iot rule
aws iot delete-topic-rule --rule-name $IOT_RULE_NAME
# aws iot delete-thing --thing-name $DEVICE_NAME
aws iam detach-role-policy --role-name $SEND_IOT_RULE_ROLE_NAME --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$SEND_IOT_RULE_POLICY_NAME
aws iam detach-role-policy --role-name $ERROR_IOT_RULE_ROLE_NAME --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$ERROR_IOT_RULE_POLICY_NAME
aws iam delete-policy --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$SEND_IOT_RULE_POLICY_NAME
aws iam delete-policy --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$ERROR_IOT_RULE_POLICY_NAME
aws iam delete-role --role-name $SEND_IOT_RULE_ROLE_NAME
aws iam delete-role --role-name $ERROR_IOT_RULE_ROLE_NAME

# Remove glue crawler
aws iam detach-role-policy --role-name $GLUE_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole
aws iam detach-role-policy --role-name $GLUE_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
aws iam delete-role --role-name $GLUE_ROLE_NAME
aws glue delete-database --name $DATABASE_NAME
aws glue delete-crawler --name $CRAWLER_NAME

# Remove lake formartion configurations
aws lakeformation deregister-resource --resource-arn arn:aws:s3:::$BUCKET_NAME/data/
# aws lakeformation revoke-permissions --cli-input-json file://permissions/lake_formation_permissions.json \
#                                      --principal DataLakePrincipalIdentifier=arn:aws:iam::$ACCOUNT_ID:user/$USER_NAME

# Remove S3 bucket and all of its objects
aws s3 rb s3://$BUCKET_NAME --force

