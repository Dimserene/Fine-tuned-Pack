cd ..
xcopy /y .\Util\CurrentVersion.txt .\Mods\ModpackUtil\
Get-Date -AsUTC -UFormat "%Y/%m/%d %H:%M:%S" > .\Mods\ModpackUtil\VersionTime.txt