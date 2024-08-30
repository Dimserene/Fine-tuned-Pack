#!/bin/bash

# Function to generate the new version string based on the latest commit message
generate_new_version_string() {
    # Get the latest commit message
    local latest_commit_msg=$(git log -1 --pretty=%B)

    # Extract the date part (YYYY-MM-DD) from the latest commit message
    local latest_version_date=$(echo "$latest_commit_msg" | grep -oE "^[0-9]{4}-[0-9]{2}-[0-9]{2}")

    # Extract the alphabet character from the latest commit message
    local latest_version_alpha=$(echo "$latest_commit_msg" | grep -oE "[a-z]$")

    # Get the current date in UTC format (YYYY-MM-DD)
    local current_date=$(date -u "+%Y-%m-%d")

    if [ "$latest_version_date" = "$current_date" ]; then
        # If the latest commit date matches the current date, advance the alphabet by one
        if [ "$latest_version_alpha" = "z" ]; then
            latest_version_alpha="a"  # If it's 'z', roll over to 'a'
        else
            latest_version_alpha=$(echo "$latest_version_alpha" | tr "a-y" "b-z")  # Advance alphabet by one
        fi
    else
        # If the dates don't match, set the date to the current date and reset alphabet to "a"
        latest_version_date="$current_date"
        latest_version_alpha="a"
    fi

    # Combine the date and alphabet to form the new version string
    echo "${latest_version_date}${latest_version_alpha}"
}

# Get the name of the current working folder
working_folder_name=$(basename "$PWD")

# Pull the latest changes from the remote repository
git pull

# Update all submodules to their latest commit from the remote repository and merge them
git submodule update --remote --recursive --merge

# Generate a new version string based on the latest commit and current date
new_version_string=$(generate_new_version_string)

# Read the current version from the CurrentVersion.txt file, if it exists
old_version_string=""
if [ -f "./CurrentVersion.txt" ]; then
    old_version_string=$(cat ./CurrentVersion.txt)
fi

# Update the CurrentVersion.txt file with the new version string
echo "$new_version_string" > ./CurrentVersion.txt
echo "New version string: $new_version_string written to CurrentVersion.txt"

# Copy the updated CurrentVersion.txt file to the Mods/ModpackUtil/ directory
cp ./CurrentVersion.txt ./Mods/ModpackUtil/

# Write the current UTC date and time to VersionTime.txt in the Mods/ModpackUtil/ directory
date -u "+%Y/%m/%d %H:%M:%S" > Mods/ModpackUtil/VersionTime.txt

# Stage all changes in the current directory for commit
git add .

# Commit the staged changes using the content of CurrentVersion.txt as the commit message
git commit -F Mods/ModpackUtil/CurrentVersion.txt
