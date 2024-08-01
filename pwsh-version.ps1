git pull
git submodule update --remote --recursive --merge
notepad.exe CurrentVersion.txt
xcopy /y .\CurrentVersion.txt .\Mods\ModpackUtil\
Get-Date -AsUTC -UFormat "%Y/%m/%d %H:%M:%S" > .\Mods\ModpackUtil\VersionTime.txt
git add .
git commit -F Mods\ModpackUtil\CurrentVersion.txt
git push