#!/bin/bash

# Load environment variables
source env.sh
source credential_info.sh

# Modify <kinesis-stream-name> and <region> in json file
aws iam create-policy --policy-name $SEND_IOT_RULE_POLICY_NAME \
			          --policy-document file://IoT_policy/send_IoT_policy_settings.json 
# Modify <topic-error-log-name> and <region> in json file
aws iam create-policy --policy-name $ERROR_IOT_RULE_POLICY_NAME \
			          --policy-document file://IoT_policy/error_IoT_policy_settings.json 

# Create IAM role for AWS Kinesis firehose access
aws iam create-role --role-name $SEND_IOT_RULE_ROLE_NAME --assume-role-policy-document file://IoT_policy/IoT_trust_policy.json
aws iam create-role --role-name $ERROR_IOT_RULE_ROLE_NAME --assume-role-policy-document file://IoT_policy/IoT_trust_policy.json

# Grant access to the role
aws iam attach-role-policy --role-name $SEND_IOT_RULE_ROLE_NAME --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$SEND_IOT_RULE_POLICY_NAME
aws iam attach-role-policy --role-name $ERROR_IOT_RULE_ROLE_NAME --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$ERROR_IOT_RULE_POLICY_NAME

aws iot create-topic-rule \
    --rule-name $IOT_RULE_NAME \
    --topic-rule-payload '{
        "sql": "SELECT * FROM \"'$TOPIC_NAME'\"",
        "actions": [{
            "firehose": {
                "roleArn": "arn:aws:iam::'$ACCOUNT_ID':role/'$SEND_IOT_RULE_ROLE_NAME'",
                "deliveryStreamName": "'$KINESIS_STREAM_NAME'",
                "separator": "\n",
                "batchMode": false
            }
        }],
        "errorAction": {
            "republish": {
                "roleArn": "arn:aws:iam::'$ACCOUNT_ID':role/'$ERROR_IOT_RULE_ROLE_NAME'",
                "topic": "'$ERROR_TOPIC_NAME'",
                "qos": 0
            }
        },
        "ruleDisabled": false,
        "awsIotSqlVersion": "2016-03-23"
    }'
