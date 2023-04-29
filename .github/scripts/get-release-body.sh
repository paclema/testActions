#!/bin/bash

set -eu

TAG="$1"
LAST_TAG="$2"
CHANGELOG="$3"

REPO_OWNER=$(echo "$GITHUB_REPOSITORY" | cut -d/ -f 1)
REPO_NAME=$(echo "$GITHUB_REPOSITORY" | cut -d/ -f 2)

cat << END
## Changes

$(awk '/\* /{ FOUND=1 } /^[[:space:]]*$/ { if(FOUND) exit } { if(FOUND) print }' "$CHANGELOG")

**Full Changelog:** [$LAST_TAG...$TAG](https://github.com/$REPO_OWNER/$REPO_NAME/compare/$LAST_TAG...$TAG)
END

# [View version history](https://github.com/$REPO_OWNER/$REPO_NAME/blob/$TAG/CHANGELOG.md)
