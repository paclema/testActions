#!/bin/bash

# Check that two version arguments have been provided
if [ $# -ne 2 ]; then
  echo "Two version arguments are required to compare"
  exit 1
fi

# Split each version into its parts separated by dots
IFS='.' read -ra VER1 <<< "$1"
IFS='.' read -ra VER2 <<< "$2"

# Compare each part of the version
for i in "${!VER1[@]}"; do
  if [ "${VER1[i]}" -gt "${VER2[i]}" ]; then
    echo "Version $1 is greater than $2"
    exit 0
  elif [ "${VER1[i]}" -lt "${VER2[i]}" ]; then
    echo "Version $1 is less than $2"
    exit 1
  fi
done

# If the version parts are equal, the versions are equal
echo "Versions are equal"
exit 1
