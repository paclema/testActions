#!/bin/bash

# set -x

package_name=$(jq -r '.name' library.json)
username=$(echo "$GITHUB_REPOSITORY" | cut -d/ -f1)
echo "Checking PlatformIO Registry library: $username/$package_name"

current_version=$(jq -r '.version' library.json)
latest_version=$(pio package search "$username/$package_name" | grep -Eo "Library • [^ ]+ " | sed -e 's/Library • //')
echo "New version: v$current_version   -   Latest version: v$latest_version"

if [[ "$current_version" != "$(echo -e "$current_version\n$latest_version" | sort -V | tail -n1)" ]]; then
    echo "Error: The new version ($current_version) is not greater than latest version ($latest_version)"
    exit 1
fi

# set +x