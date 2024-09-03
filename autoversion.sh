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

# Step 3: Check if there are any changes in the "Mods" folder
status_output=$(git status --porcelain Mods/ | grep -v "README.md")

# Variable to track if version was bumped
version_bumped=false

if [ -n "$status_output" ]; then
    # If changes are detected in the Mods folder, generate a new version string
    new_version_string=$(generate_new_version_string)
    echo "Step 4: Generated new version string: $new_version_string"

    # Step 5: Update the CurrentVersion.txt file with the new version string
    if echo "$new_version_string" > ./CurrentVersion.txt; then
        echo "Step 5: New version string written to CurrentVersion.txt"
        update_version_status="SUCCESS"
        version_bumped=true
    else
        echo "Step 5: Failed to write new version string to CurrentVersion.txt"
        update_version_status="FAILED"
    fi

    # Step 6: Copy the updated CurrentVersion.txt file to the Mods/ModpackUtil/ directory
    if cp ./CurrentVersion.txt ./Mods/ModpackUtil/; then
        echo "Step 6: CurrentVersion.txt copied to Mods/ModpackUtil/"
        copy_version_status="SUCCESS"
    else
        echo "Step 6: Failed to copy CurrentVersion.txt to Mods/ModpackUtil/"
        copy_version_status="FAILED"
    fi
else
    echo "No changes detected in the Mods folder. Skipping version bump."
    update_version_status="SKIPPED"
    copy_version_status="SKIPPED"
fi

# Step 7: Write the current UTC date and time to VersionTime.txt in the Mods/ModpackUtil/ directory
if date -u "+%Y/%m/%d %H:%M:%S" > Mods/ModpackUtil/VersionTime.txt; then
    echo "Step 7: VersionTime.txt updated successfully."
    update_time_status="SUCCESS"
else
    echo "Step 7: Failed to update VersionTime.txt."
    update_time_status="FAILED"
fi

# Step 8: Stage all changes in the current directory for commit
if git add .; then
    echo "Step 8: Changes staged successfully."
    stage_status="SUCCESS"
else
    echo "Step 8: Failed to stage changes."
    stage_status="FAILED"
fi

# Step 9: Commit the staged changes
if [ -f "./CurrentVersion.txt" ]; then
    commit_message=$(cat ./CurrentVersion.txt)
else
    commit_message="Update without version bump"
fi

if git commit -m "$commit_message"; then
    echo "Step 9: Changes committed successfully."
    commit_status="SUCCESS"
else
    echo "Step 9: Failed to commit changes."
    commit_status="FAILED"
fi

# Step 10: Push the changes to the remote repository
if git push; then
    echo "Step 10: Changes pushed to remote repository successfully."
    push_status="SUCCESS"
else
    echo "Step 10: Failed to push changes to remote repository."
    push_status="FAILED"
fi

# Summary of the results
echo ""
echo "Update Summary for ${working_folder_name}:"
echo "------------------------------------------"
if [ "$update_version_status" = "SUCCESS" ] || [ "$update_version_status" = "SKIPPED" ]; then
    echo "${working_folder_name}: SUCCESSFULLY UPDATED"
else
    echo "${working_folder_name}: FAILED TO UPDATE"
    [ "$update_version_status" != "SUCCESS" ] && [ "$update_version_status" != "SKIPPED" ] && echo "  - Failed to update version"
    [ "$copy_version_status" != "SUCCESS" ] && [ "$copy_version_status" != "SKIPPED" ] && echo "  - Failed to copy version file"
    [ "$update_time_status" != "SUCCESS" ] && echo "  - Failed to update version time"
    [ "$stage_status" != "SUCCESS" ] && echo "  - Failed to stage changes"
    [ "$commit_status" != "SUCCESS" ] && echo "  - Failed to commit changes"
    [ "$push_status" != "SUCCESS" ] && echo "  - Failed to push changes"
fi
echo "------------------------------------------"

# Exit with appropriate status
if [ "$pull_status" = "SUCCESS" ] && \
   [ "$submodule_status" = "SUCCESS" ] && \
   ([ "$update_version_status" = "SUCCESS" ] || [ "$update_version_status" = "SKIPPED" ]) && \
   ([ "$copy_version_status" = "SUCCESS" ] || [ "$copy_version_status" = "SKIPPED" ]) && \
   [ "$update_time_status" = "SUCCESS" ] && \
   [ "$stage_status" = "SUCCESS" ] && \
   [ "$commit_status" = "SUCCESS" ] && \
   [ "$push_status" = "SUCCESS" ]; then
    exit 0
else
    exit 1
fi