#!/bin/bash

set -x

# Change directory to the root of the repository
cd "$(git rev-parse --show-toplevel)"

NEW_VERSION=$1

# Update library.json
sed -i "s/\"version\": \".*\"/\"version\": \"$1\"/g" .library.json

# Update CHANGELOG
sed -i~ -bE "4s/HEAD/$TAG ($DATE)/; 5s/-+/$UNDERLINE/" CHANGELOG.md

# Update PLatformIO badge in README
package_name=$(jq -r '.name' library.json)
package_owner=$(echo "${GITHUB_REPOSITORY}" | cut -d / -f 1)
BADGE_REGEX='\[!\[PlatformIO Registry\]\(https:\/\/badges\.registry\.platformio\.org\/packages\/'"${package_owner}"'\/library\/'"${package_name}"'\.svg\?version=[0-9]+\.[0-9]+\.[0-9]+\)\]'
BADGE_REPLACE='[![PlatformIO Registry](https://badges.registry.platformio.org/packages/'"${package_owner}"'/library/'"${package_name}"'.svg?version='"${NEW_VERSION}"')]'
sed -i -E "s#${BADGE_REGEX}#${BADGE_REPLACE}#g" README.md


# Commit file changes to git
git config --global user.email "paclema@gmail.com"
git config --global user.name "Pablo Clemente"
git add README.md
git commit -m "Update library to ${NEW_VERSION}"
git push

# Update tag on last commit and add info
TAG=$NEW_VERSION
CHANGES=$(awk '/\* /{ FOUND=1; print; next } { if (FOUND) exit}' CHANGELOG.md)
git tag "$TAG" "$TAG"^{} -f -m "$package_name $NEW_VERSION"$'\n'"$CHANGES"
git push --follow-tags

set +x