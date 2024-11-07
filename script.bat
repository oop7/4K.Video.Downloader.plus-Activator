@echo off
setlocal

:: Set script directories
set "SCRIPT_DIR=%~dp0"
set "SRC_DIR=%SCRIPT_DIR%src\"

:: Set the paths for the encoded files
set "ENCODED_FILE=%SRC_DIR%encoded.txt"

:: Define color codes for output
set "RESET=[0m"
set "GREEN=[32m"
set "RED=[31m"

:: Check for administrator rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    :: If not admin, print a message and exit
    echo %RED%You need to run this script as Administrator. Please right-click the script and choose "Run as Administrator".%RESET%
    pause
    exit /b
)

:: Now running with admin privileges
echo %GREEN%Running with administrative privileges...%RESET%
echo Decoding encoded files...

:: Decode main file
powershell -Command "[System.IO.File]::WriteAllBytes('%TEMP%\decoded_file.txt', [System.Convert]::FromBase64String((Get-Content '%ENCODED_FILE%' -Raw)))"
if %errorlevel% neq 0 (
    echo %RED%Failed to decode file.%RESET%
    pause
    exit /b
)


:: Display ASCII art
chcp 65001 >nul
@echo off
setlocal enabledelayedexpansion

:: Define the path to your ASCII art file
set "ascii_file=%SRC_DIR%\ASCII_art.txt"

:: Define the number of spaces for padding
set "padding=                                            "

:: Loop through each line in the ASCII art file and add spaces
for /f "delims=" %%i in (%ascii_file%) do (
    echo !padding!%%i
)

:: Add blank lines at the bottom for additional space
echo.
echo.
echo.

:: Prompt for user input
echo %GREEN%1. Activate%RESET%
echo %RED%2. Exit%RESET%
set /p choice=Choose an option (1 or 2): 

:: Handle user choice
if "%choice%"=="1" (
    echo Verifying source file...
    if not exist "%TEMP%\decoded_file.txt" (
        echo %RED%Source file not found. Please verify.%RESET%
        pause
        exit /b
    )
    echo Source file exists.

     :: Terminate 4kvideodownloaderplus.exe process if running
    echo Terminating 4kvideodownloaderplus.exe if running...
    @taskkill /F /IM 4kvideodownloaderplus.exe >nul 2>&1
    if %errorlevel% neq 0 (
        echo %RED%Failed to terminate 4kvideodownloaderplus.exe or process not found.%RESET%
    ) else (
        echo %GREEN%4kvideodownloaderplus.exe process terminated.%RESET%
    )

    echo %GREEN%Activated%RESET%
    regedit /s "%TEMP%\decoded_file.txt"
    if %errorlevel% neq 0 (
        echo %RED%Failed to copy the file.%RESET%
    )
    pause
) else if "%choice%"=="2" (
    echo Exiting...
    pause
    exit
) else (
    echo %RED%Invalid choice. Please run the script again and choose 1 or 2.%RESET%
)

:: Wait for user to press a key before closing
pause
endlocal
