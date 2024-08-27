@echo off
echo *******************************************************
echo IMPORTANT: Please backup your current Mods folder before proceeding.
echo The installation will overwrite existing files in your Mods directory.
echo *******************************************************
pause

git clone --recurse-submodules --remote-submodules https://github.com/Dimserene/Fine-tuned-Pack

echo Copying Mods folder to %appdata%\Balatro\Mods
xcopy "Fine-tuned-Pack\Mods" "%appdata%\Balatro\Mods" /w /e /h /i

echo Installation complete. Please ensure everything is working correctly.
pause
