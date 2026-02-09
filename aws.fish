# AWS profile switcher
# Set AWS_PROFILE_ASSUME=1 to assume role (requires jq)
if test -f "$HOME/.aws/config"
    function aws-profile
        set -gx AWS_PROFILE $argv[1]

        if test "$AWS_PROFILE_ASSUME" = "1"
            set role_arn (aws configure get role_arn --profile $argv[1])
            set account_id (aws configure get aws_account_id --profile $argv[1])
            set region (aws configure get region --profile $argv[1])
            set source_profile (aws configure get source_profile --profile $argv[1])

            echo "Assuming AWS profile $argv[1] role $role_arn"
            set creds (aws --profile $source_profile sts assume-role --role-arn $role_arn --region $region --role-session-name AWSCLI-Session)
            set -gx AWS_ACCESS_KEY_ID (echo $creds | jq -r ".Credentials | .AccessKeyId")
            set -gx AWS_SECRET_ACCESS_KEY (echo $creds | jq -r ".Credentials | .SecretAccessKey")
            set -gx AWS_SESSION_TOKEN (echo $creds | jq -r ".Credentials | .SessionToken")
            set -gx AWS_ACCOUNT_ID $account_id
            set -gx AWS_REGION $region
        end
    end

    function _aws_profiles
        sed -nE 's:^\[profile (.+)\]$:\1:p' "$HOME/.aws/config"
    end

    complete -c aws-profile -f -a "(_aws_profiles)"
end
