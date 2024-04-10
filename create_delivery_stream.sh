#!/bin/bash

# Load environment variables
source env.sh
source credential_info.sh

aws firehose create-delivery-stream --delivery-stream-name $KINESIS_STREAM_NAME \
                                    --delivery-stream-type DirectPut \
                                    --s3-destination-configuration '{
                                        "RoleARN": "arn:aws:iam::'$ACCOUNT_ID':role/'$KINESIS_ROLE_NAME'",
                                        "BucketARN": "arn:aws:s3:::'$BUCKET_NAME'",
                                        "Prefix": "data/",
                                        "BufferingHints": {
                                            "SizeInMBs": '$BUFFER_SIZE',
                                            "IntervalInSeconds": '$BUFFER_INTERVAL'
                                        }
                                    }'

# Check delivery stream status
# aws firehose describe-delivery-stream --delivery-stream-name $KINESIS_STREAM_NAME
