@echo off
setlocal EnableDelayedExpansion

:: Plain explanation
echo This script compresses a specified folder into:
echo    "FolderName Backup <counter>.zip"
echo in the same directory as that folder.
echo =====================================================
echo Support: Windows 10 and later, Server 2016 and later.
echo Windows 7 / 8.1 must install WMF 5.x first.
echo.

:main
rem — 1) Ask for the folder
set /p "folder=Enter full path of the folder to back up: "
if not exist "!folder!\" (
    echo.
    echo ERROR: Folder "!folder!" not found.
    pause
    exit /b 1
)

rem — 2) Extract the folder name and its parent path
for %%I in ("!folder!") do (
    set "name=%%~nI"
    set "parent=%%~dpI"
)

rem — 3) Ask how many leading zeros (0 = none, max = 16)
echo.
set /p "zeros=Number of leading zeros to use (0 to 16): "
if "!zeros!"=="" set "zeros=0"

:validateZeros
for /f "delims=0123456789" %%A in ("!zeros!") do (
    echo.
    echo ERROR: "!zeros!" is not a valid number.
    set /p "zeros=Enter a number between 0 and 16: "
    goto validateZeros
)
if !zeros! LSS 0 (
    echo.
    echo ERROR: Minimum is 0.
    set /p "zeros=Enter a number between 0 and 16: "
    goto validateZeros
)
if !zeros! GTR 16 (
    echo.
    echo ERROR: Maximum is 16.
    set /p "zeros=Enter a number between 0 and 16: "
    goto validateZeros
)

rem — 4) Find existing backups and determine max counter
set "max=0"
for /f "delims=" %%F in ('dir /b /a-d "!parent!!name! Backup *.zip" 2^>nul') do (
    set "fname=%%~nF"
    set "num=!fname:*Backup =!"
    if defined num if !num! gtr !max! set "max=!num!"
)

rem — 5) Strip leading zeros so arithmetic is decimal‑safe
:stripZeros
if "!max:~0,1!"=="0" (
    set "max=!max:~1!"
    goto stripZeros
)
if "!max!"=="" set "max=0"

rem — 6) Compute the next counter
set /a next=max+1

rem — 7) Apply zero‑padding if requested
if !zeros! GTR 0 (
    set "pad=0000000000000000!next!"
    call set "next=%%pad:~-%zeros%%%"
)

rem — 8) Build the ZIP filename
set "zipfile=!parent!!name! Backup !next!.zip"

rem — 9) Compress the folder
powershell -noprofile -command "Compress-Archive -Path '!folder!\*' -DestinationPath '!zipfile!' -Force"

rem — 10) Report result
echo.
if exist "!zipfile!" (
    echo Backup created: !zipfile!
) else (
    echo ERROR: Failed to create backup.
)

rem — 11) Ask to do another
echo.
set /p "again=Do you want to compress another folder? (Y/N): "
if /I "!again!"=="Y" (
    echo.
    goto main
)

echo.
echo Process terminated
endlocal
pause
