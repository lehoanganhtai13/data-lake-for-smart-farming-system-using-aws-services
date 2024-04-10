#!/bin/bash

# Load environment variables
source env.sh
source credential_info.sh

# Grant permissions for AWS Glue crawler to the database and its tables
aws lakeformation grant-permissions --principal '{ "DataLakePrincipalIdentifier": "arn:aws:iam::'$ACCOUNT_ID':role/'$GLUE_ROLE_NAME'" }' \
                                    --cli-input-json file://permissions/lake_formation_permissions.json

# Create crawler and configure crawler with schedule for on demand (craw new sub-folders only)
aws glue create-crawler --name $CRAWLER_NAME --role $GLUE_ROLE_NAME --database-name $DATABASE_NAME \
						--targets '{ "S3Targets": [{ "Path": "s3://'$BUCKET_NAME'/data/" }] }' \
						--recrawl-policy '{ "RecrawlBehavior": "CRAWL_NEW_FOLDERS_ONLY" }'
