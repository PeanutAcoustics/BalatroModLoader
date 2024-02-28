@echo off
setlocal enabledelayedexpansion

:: Create temporary directories
set "temp_dir_git=%TEMP%\%RANDOM%"
mkdir "!temp_dir_git!"
set "temp_dir=%TEMP%\%RANDOM%"
mkdir "!temp_dir!"

:: Download latest repo version and extract
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/NanashiTheNameless/BalatroModLoader/archive/refs/heads/main.zip' -OutFile '!temp_dir_git!\BalatroModLoader.zip'"
powershell -NoProfile -Command "& {Expand-Archive -Path '!temp_dir_git!\BalatroModLoader.zip' -DestinationPath '!temp_dir_git!' -Force}"

:: Fix Directory
move "!temp_dir_git!\BalatroModLoader-main" "!temp_dir_git!"

:: Locate the Balatro directory
for /f "delims=" %%i in ('dir /b /s "common\Balatro\Balatro.exe"') do set "balatro_path=%%i"

:: Extract the Balatro.exe
"!temp_dir_git!\windows_deps\7z\7z.exe" x "!balatro_path!" -o"!temp_dir!"

echo Extraction completed to !temp_dir!.

:: Modify game.lua
powershell -Command "(Get-Content '!temp_dir!\game.lua') -replace 'self\.SPEEDFACTOR = 1', '$&`r`n    initSteamodded()' | Set-Content '!temp_dir!\game.lua'"

:: Prepare staging.lua
echo. > "!temp_dir_git!\staging.lua"
type "!temp_dir_git!\lua\core.lua" >> "!temp_dir_git!\staging.lua"
echo. >> "!temp_dir_git!\staging.lua"
type "!temp_dir_git!\lua\debug.lua" >> "!temp_dir_git!\staging.lua"
echo. >> "!temp_dir_git!\staging.lua"
type "!temp_dir_git!\lua\loader.lua" >> "!temp_dir_git!\staging.lua"
echo. >> "!temp_dir_git!\staging.lua"
type "!temp_dir_git!\lua\deck.lua" >> "!temp_dir_git!\staging.lua"
echo. >> "!temp_dir_git!\staging.lua"
type "!temp_dir_git!\lua\joker.lua" >> "!temp_dir_git!\staging.lua"

type "!temp_dir_git!\staging.lua" >> "!temp_dir!\main.lua"

:: Repack the main.lua into the Balatro.exe
"!temp_dir_git!\windows_deps\7z\7z.exe" a "!balatro_path!" "!temp_dir!\game.lua"
"!temp_dir_git!\windows_deps\7z\7z.exe" a "!balatro_path!" "!temp_dir!\main.lua"

:: Cleanup temporary directories
rmdir /s /q "!temp_dir!"
rmdir /s /q "!temp_dir_git!"

echo Script completed.
endlocal
