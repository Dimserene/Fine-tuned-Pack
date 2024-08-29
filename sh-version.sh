#!/bin/bash

# Function to prompt user and wait for a response with options (y, n, q)
prompt_to_continue() {
    while true; do
        read -p "$1 (press y to continue, n to skip, q to quit): " ynq
        case $ynq in
            [Yy]* ) return 0;;  # User chose to continue
            [Nn]* ) return 1;;  # User chose to skip the action
            [Qq]* ) echo "Quitting."; exit;;  # User chose to quit the script
            * ) echo "Please answer y, n, or q.";;  # Invalid input, prompt again
        esac
    done
}

# Function to prompt user to press any key to continue
prompt_any_key() {
    echo -n "$1 (press enter to continue)"
    read _  # Wait for the user to press enter
    echo
}

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

    if [[ "$latest_version_date" == "$current_date" ]]; then
        # If the latest commit date matches the current date, advance the alphabet by one
        if [[ "$latest_version_alpha" == "z" ]]; then
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

# Initial prompt to ask the user if they want to update the working folder
prompt_to_continue "Do you want to update ${working_folder_name}?"

# Pull the latest changes from the remote repository
git pull

# Update all submodules to their latest commit from the remote repository and merge them
git submodule update --remote --recursive --merge

# Generate a new version string based on the latest commit and current date
new_version_string=$(generate_new_version_string)

# Read the current version from the CurrentVersion.txt file, if it exists
old_version_string=""
if [[ -f "./CurrentVersion.txt" ]]; then
    old_version_string=$(cat ./CurrentVersion.txt)
fi

# Prompt the user to update the CurrentVersion.txt file, showing the old and new version
if prompt_to_continue "Update CurrentVersion.txt? ${old_version_string} -> ${new_version_string}"; then
    # If the user agrees, write the new version string to CurrentVersion.txt
    echo "$new_version_string" > ./CurrentVersion.txt
    echo "New version string: $new_version_string written to CurrentVersion.txt"
fi

# Copy the updated CurrentVersion.txt file to the Mods/ModpackUtil/ directory
cp ./CurrentVersion.txt ./Mods/ModpackUtil/

# Write the current UTC date and time to VersionTime.txt in the Mods/ModpackUtil/ directory
date -u "+%Y/%m/%d %H:%M:%S" > Mods/ModpackUtil/VersionTime.txt

# Stage all changes in the current directory for commit
git add .

# Commit the staged changes using the content of CurrentVersion.txt as the commit message
git commit -F Mods/ModpackUtil/CurrentVersion.txt

# Push the committed changes to the remote repository
git push

# Prompt user after pushing changes to confirm the process completion
prompt_any_key "Changes pushed to the remote repository."
