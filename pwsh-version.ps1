
# Update the local repository with the latest changes from the remote repository
git pull

# Update all submodules to their latest commit, using the merge strategy
git submodule update --remote --recursive --merge

# Open the CurrentVersion.txt file in Notepad for editing
notepad.exe CurrentVersion.txt

# Copy the updated CurrentVersion.txt file to the specified directory
xcopy /y .\CurrentVersion.txt .\Mods\ModpackUtil\

# Create or overwrite VersionTime.txt with the current date and time in UTC format
Get-Date -AsUTC -UFormat "%Y/%m/%d %H:%M:%S" > .\Mods\ModpackUtil\VersionTime.txt

# Stage all changes for the next commit
git add .

# Commit the staged changes using the contents of CurrentVersion.txt as the commit message
git commit -F Mods\ModpackUtil\CurrentVersion.txt

# Push the committed changes to the remote repository
git push