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

echo ""
echo "Start updating ${working_folder_name}..."
echo ""

# Step 1: Pull the latest changes from the remote repository
if git pull; then
    echo "Step 1: Pull successful."
    pull_status="SUCCESS"
else
    echo "Step 1: Pull failed."
    pull_status="FAILED"
fi

# Step 2: Update all submodules to their latest commit from the remote repository and merge them
if git submodule update --remote --recursive --merge; then
    echo "Step 2: Submodule update successful."
    submodule_status="SUCCESS"
else
    echo "Step 2: Submodule update failed."
    submodule_status="FAILED"
fi

# Step 3: Check if there are any changes staged or in the working directory
status_output=$(git status --porcelain | grep -v "README.md")

if [ -z "$status_output" ]; then
    echo "No changes detected after pull and submodule update. Exiting..."
    exit 0
fi

# Step 4: Generate a new version string based on the latest commit and current date
new_version_string=$(generate_new_version_string)
echo "Step 4: Generated new version string: $new_version_string"

# Step 5: Read the current version from the CurrentVersion.txt file, if it exists
old_version_string=""
if [ -f "./CurrentVersion.txt" ]; then
    old_version_string=$(cat ./CurrentVersion.txt)
    echo "Step 5: Read old version string: $old_version_string"
else
    echo "Step 5: No previous version found. This is the first version."
fi

# Step 6: Update the CurrentVersion.txt file with the new version string
if echo "$new_version_string" > ./CurrentVersion.txt; then
    echo "Step 6: New version string written to CurrentVersion.txt"
    update_version_status="SUCCESS"
else
    echo "Step 6: Failed to write new version string to CurrentVersion.txt"
    update_version_status="FAILED"
fi

# Step 7: Copy the updated CurrentVersion.txt file to the Mods/ModpackUtil/ directory
if cp ./CurrentVersion.txt ./Mods/ModpackUtil/; then
    echo "Step 7: CurrentVersion.txt copied to Mods/ModpackUtil/"
    copy_version_status="SUCCESS"
else
    echo "Step 7: Failed to copy CurrentVersion.txt to Mods/ModpackUtil/"
    copy_version_status="FAILED"
fi

# Step 8: Write the current UTC date and time to VersionTime.txt in the Mods/ModpackUtil/ directory
if date -u "+%Y/%m/%d %H:%M:%S" > Mods/ModpackUtil/VersionTime.txt; then
    echo "Step 8: VersionTime.txt updated successfully."
    update_time_status="SUCCESS"
else
    echo "Step 8: Failed to update VersionTime.txt."
    update_time_status="FAILED"
fi

# Step 9: Stage all changes in the current directory for commit
if git add .; then
    echo "Step 9: Changes staged successfully."
    stage_status="SUCCESS"
else
    echo "Step 9: Failed to stage changes."
    stage_status="FAILED"
fi

# Step 10: Commit the staged changes using the content of CurrentVersion.txt as the commit message
if git commit -F Mods/ModpackUtil/CurrentVersion.txt; then
    echo "Step 10: Changes committed successfully."
    commit_status="SUCCESS"
else
    echo "Step 10: Failed to commit changes."
    commit_status="FAILED"
fi

# Step 11: Push the changes to the remote repository
if git push; then
    echo "Step 11: Changes pushed to remote repository successfully."
    push_status="SUCCESS"
else
    echo "Step 11: Failed to push changes to remote repository."
    push_status="FAILED"
fi

# Summary of the results
echo ""
echo "Update Summary for ${working_folder_name}:"
echo "------------------------------------------"
echo "Step 1: Pull status: $pull_status"
echo "Step 2: Submodule update status: $submodule_status"
echo "Step 6: Version update status: $update_version_status"
echo "Step 7: Copy version file status: $copy_version_status"
echo "Step 8: Update version time status: $update_time_status"
echo "Step 9: Stage changes status: $stage_status"
echo "Step 10: Commit status: $commit_status"
echo "Step 11: Push status: $push_status"
echo "------------------------------------------"

# Exit with appropriate status
if [[ "$pull_status" == "SUCCESS" && "$submodule_status" == "SUCCESS" && "$update_version_status" == "SUCCESS" && "$copy_version_status" == "SUCCESS" && "$update_time_status" == "SUCCESS" && "$stage_status" == "SUCCESS" && "$commit_status" == "SUCCESS" && "$push_status" == "SUCCESS" ]]; then
    exit 0
else
    exit 1
fi