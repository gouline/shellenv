#!/bin/bash
#
# Shell script to migrate a repository checked out locally to a new remote URL.
# 
# Usage: git-migrate <target_path> <new_url>
#    target_path  local path to existing repository"
#    new_url      git URL for the new repository to migrate to"
#

log_error() {
    echo "ERROR: $1"
}

log_fatal() {
    log_error "$1"
    exit 1
}

log_usage() {
    log_error "$1"
    echo
    echo "Usage: git-migrate <target_path> <new_url>"
    echo "   target_path  local path to existing repository"
    echo "   new_url      git URL for the new repository to migrate to"
    exit 2
}

[[ ( "$#" -lt 1 ) ]] && log_usage "missing target_path argument"
[[ ( "$#" -lt 2 ) ]] && log_usage "missing new_url argument"

TARGET_PATH="$1"
NEW_URL="$2"

[ ! -d $TARGET_PATH ] && log_fatal "target_path does not exist"

cd $1

[[ ! -n "$(type -t git)" ]]     && log_fatal "no git command found in your path"
[[ ! -d .git ]]                 && log_fatal "target_path is not a git repository"
[[ ! -z $(git status -s) ]]     && log_fatal "target repository has uncommitted changes; please stash/commit/reset these changes and try again"
[[ "$NEW_URL" != *.git ]]       && log_fatal "new_url is not a valid git URL"

set -e

set -x
git pull
git fetch --prune
git remote -v
git remote set-url origin $NEW_URL
set +x

echo
read -p "Ready to force push $TARGET_PATH to $NEW_URL (WARNING: cannot be undone)? [y/N] " READY_RESP
case "$READY_RESP" in
    [yY][eE][sS]|[yY])
        ;;
    *)
        log_fatal "aborted by user"
        ;;
esac

set -x
git push --mirror
set +x

echo "Repository successfully migrated!"
