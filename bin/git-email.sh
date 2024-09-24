#!/bin/bash
# 
# Tool for switching user.email and corresponding GPG commit signing keys for git repositories.
#
# Usage:
#
#   1. Fill in your email addresses by aliases in the case statement below

case $1 in

  gh | github | github.com)
    email=1234567+username@users.noreply.github.com
    ;;

  *)
    echo "ERROR: no email found for '$1'"
    exit 1
    ;;

esac

#   2. Generate GPG keys for all emails (https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification)
#       (alternatively, you can disable signing by setting the below to 0)

ENABLE_COMMIT_SIGNING=1

#   3. Make this script executable: chmod +x git-email
#   4. Move it to somewhere in your $PATH
#   5. Execute in a git repository OR a directory with git repositories: git email <ALIAS>
#

config_email() {
  email=$1

  (set -x; git config user.email "$email")
}

config_sign() {
  if [ $ENABLE_COMMIT_SIGNING == 0 ]; then
    return
  fi

  email=$1

  gpg_output=`gpg --list-keys $email | sed -n 2p`
  git_key_id=${gpg_output: -16}

  if [ -z "$git_key_id" ]; then
    return
  fi

  (set -x; git config user.signingkey "$git_key_id" )
  (set -x; git config commit.gpgsign true )
}

config_repo() {
    email=$1
    dir=$2
    
    read -p "Confirm configuring user.email=$email on repository \"$dir\"? " -n 1 -r
    (cd "$dir" && config_email "$email" && config_sign "$email")
}

if [ -d "./.git" ]; then
    config_repo "$email" "."
else
    for dir in */; do
        if [ -d "$dir/.git" ]; then
            config_repo "$email" "$dir"
        fi
    done
fi
