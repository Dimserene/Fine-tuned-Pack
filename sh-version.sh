git pull
git submodule update --remote --recursive --merge
nano ./CurrentVersion.txt
cp ./CurrentVersion.txt ./Mods/ModpackUtil/
date -u "+%Y/%m/%d %H:%M:%S" > Mods/ModpackUtil/VersionTime.txt
git add .
git commit -F Mods/ModpackUtil/CurrentVersion.txt
git push