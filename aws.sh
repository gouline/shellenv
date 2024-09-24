#!/bin/bash

# AWS profile switcher
# Set AWS_PROFILE_ASSUME=1 to assume role (requires jq)
if [ -f $HOME/.aws/config ]; then
    aws-profile() {
        export AWS_PROFILE=$1

        if [ "$AWS_PROFILE_ASSUME" = "1" ]; then
            role_arn=$(aws configure get role_arn --profile $1)
            account_id=$(aws configure get aws_account_id --profile $1)
            region=$(aws configure get region --profile $1)
            source_profile=$(aws configure get source_profile --profile $1)
            
            echo "Assuming AWS profile $1 role $role_arn"
            creds=$(aws --profile $source_profile sts assume-role --role-arn $role_arn --region $region --role-session-name AWSCLI-Session)
            export AWS_ACCESS_KEY_ID=$(echo $creds| jq -r ".Credentials | .AccessKeyId")
            export AWS_SECRET_ACCESS_KEY=$(echo $creds| jq -r ".Credentials | .SecretAccessKey")
            export AWS_SESSION_TOKEN=$(echo $creds| jq -r ".Credentials | .SessionToken")
            export AWS_ACCOUNT_ID=$account_id
            export AWS_REGION=$region
        fi
    }

    complete -W "`sed -nE 's:^\[profile (.+)\]$:\1:p' $HOME/.aws/config | tr '\n' ' '`" aws-profile
fi
