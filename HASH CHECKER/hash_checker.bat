@echo off
setlocal enabledelayedexpansion

:start
cls
:: Set the directory to the default Downloads folder for the current user
set "download_dir=C:\Users\%USERNAME%\Downloads"

:: Find the latest file in the directory
for /f "delims=" %%i in ('dir /b /a-d /o-d "%download_dir%\*"') do (
    set "file=%download_dir%\%%i"
    goto :found
)

:found
echo Latest downloaded file found: %file%

:: Get expected hashes from the user
set /p "md5_expected=Enter the expected MD5 hash: "
set /p "sha256_expected=Enter the expected SHA256 hash: "

:: Calculate MD5 hash
for /f "tokens=* usebackq" %%i in (`powershell -command "Get-FileHash -Algorithm MD5 -Path '%file%' | Select-Object -ExpandProperty Hash"`) do (
    set "md5_hash=%%i"
)

:: Calculate SHA256 hash
for /f "tokens=* usebackq" %%i in (`powershell -command "Get-FileHash -Algorithm SHA256 -Path '%file%' | Select-Object -ExpandProperty Hash"`) do (
    set "sha256_hash=%%i"
)

:: Display calculated hashes and expected hashes
echo.
echo =======================
echo MD5 Hash:
echo Expected:    %md5_expected%
echo Calculated:  %md5_hash%
echo =======================

echo.
echo =======================
echo SHA256 Hash:
echo Expected:    %sha256_expected%
echo Calculated:  %sha256_hash%
echo =======================

:: Compare MD5 and SHA256
if /i "%md5_hash%"=="%md5_expected%" (
    if /i "%sha256_hash%"=="%sha256_expected%" (
        color 2f
        echo Both MD5 and SHA256 hashes match.
    ) else (
        color 6f
        echo MD5 matches, but SHA256 does not match.
    )
) else (
    if /i "%sha256_hash%"=="%sha256_expected%" (
        color 2f
        echo SHA256 matches, but MD5 does not match.
    ) else (
        color 4f
        echo Neither MD5 nor SHA256 hashes match.
    )
)

:menu
echo.
echo =======================
echo Do you want to re-do the test or close the program?
echo 1. Re-do the test
echo 2. Close
echo =======================
set /p "choice=Enter your choice (1 or 2): "

if "%choice%"=="1" (
    goto start
) else if "%choice%"=="2" (
    exit
) else (
    echo Invalid choice, please enter 1 or 2.
    goto menu
)

:: Keep the current color until the user selects
pause
