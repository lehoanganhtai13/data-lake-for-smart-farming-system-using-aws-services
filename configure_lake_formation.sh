#!/bin/bash

# Load environment variables
source env.sh

# load credential info to lake_formation_settings.json
source credential_info.sh

# Set administrator for lake formation service 
aws lakeformation put-data-lake-settings --data-lake-settings '{ "DataLakeAdmins": [{ "DataLakePrincipalIdentifier": "arn:aws:iam::'$ACCOUNT_ID':user/'$USER_NAME'" }] }' \
                                         --cli-input-json file://data_lake_settings/lake_formation_settings.json

# Create database in lake formation (clear default setting "Use only IAM access control" for new tables and databases)
aws glue create-database --database-input '{"Name": "'$DATABASE_NAME'", "LocationUri": "s3://'$BUCKET_NAME'/data", "Description": "Demo database for data lake."}'

# Register folder data in S3 bucket to be the storage for the data lake including AWSServiceRoleForLakeFormationDataAccess role
aws lakeformation register-resource --resource-arn arn:aws:s3:::$BUCKET_NAME/data/ --use-service-linked-role --hybrid-access-enabled
