#!/bin/bash

set -x

# Change directory to the root of the repository
cd "$(git rev-parse --show-toplevel)"

package_name=$(jq -r '.name' library.json)
package_version=$(jq -r '.version' library.json)
package_owner=$(echo "${GITHUB_REPOSITORY}" | cut -d / -f 1)

# Update PLatformIO badge in README
BADGE_REGEX='\[!\[PlatformIO Registry\]\(https:\/\/badges\.registry\.platformio\.org\/packages\/'"${package_owner}"'\/library\/'"${package_name}"'\.svg\?version=[0-9]+\.[0-9]+\.[0-9]+\)\]'
BADGE_REPLACE='[![PlatformIO Registry](https://badges.registry.platformio.org/packages/'"${package_owner}"'/library/'"${package_name}"'.svg?version='"${package_version}"')]'
sed -i -E "s#${BADGE_REGEX}#${BADGE_REPLACE}#g" README.md

# Commit file changes to git
git config --global user.email "paclema@gmail.com"
git config --global user.name "Pablo Clemente"
git add README.md
git commit -m "Update library to v${package_version}"
git push
set +x
