cp ./CurrentVersion.txt ./Mods/ModpackUtil/
date -u "+%Y/%m/%d %H:%M:%S" > Mods/ModpackUtil/VersionTime.txt
git pull
git submodule update --remote --recursive --merge
git add .
git commit -F Mods/ModpackUtil/CurrentVersion.txt
git push