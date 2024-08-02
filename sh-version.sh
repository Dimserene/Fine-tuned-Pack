# Update local repository with the latest changes from the remote repository
git pull

# Update all submodules to their latest commit from the remote, merge them into the current branch
git submodule update --remote --recursive --merge

# Open the CurrentVersion.txt file for editing in the nano text editor
nano ./CurrentVersion.txt

# Copy the CurrentVersion.txt file to the Mods/ModpackUtil/ directory
cp ./CurrentVersion.txt ./Mods/ModpackUtil/

# Write the current UTC date and time to VersionTime.txt in the Mods/ModpackUtil/ directory
date -u "+%Y/%m/%d %H:%M:%S" > Mods/ModpackUtil/VersionTime.txt

# Stage all changes in the current directory for commit
git add .

# Commit the staged changes with the message from CurrentVersion.txt
git commit -F Mods/ModpackUtil/CurrentVersion.txt

# Push the committed changes to the remote repository
git push
