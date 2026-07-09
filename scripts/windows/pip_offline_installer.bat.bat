

@echo off
REM ============================================================================
REM  PIP Offline Package Installer
REM  Author: ioWiz
REM  Description: Automates downloading and installing Python packages offline
REM  Version: 1.0
REM  License: MIT
REM ============================================================================

setlocal enabledelayedexpansion
color 09
title PIP Offline Package Installer - ioWiz

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Python is not installed or not in PATH^!
    echo Please install Python and try again.
    echo.
    pause
    exit /b 1
)

REM Check if pip is available
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] pip is not installed or not available^!
    echo Please install pip and try again.
    echo.
    pause
    exit /b 1
)

:MENU
color 09
cls
echo.
echo ============================================================================
echo                    PIP OFFLINE PACKAGE INSTALLER
echo                           by ioWiz
echo ============================================================================
echo.
echo  Current Directory: %CD%
echo.
echo  Python Version: 
python --version
echo.
echo  pip Version: 
python -m pip --version
echo.
echo ============================================================================
echo.
echo  [1] Download Packages (Online Mode)
echo  [2] Install Packages from Offline Directory
echo  [3] List Downloaded Packages
echo  [4] Create requirements.txt from installed packages
echo  [5] Help ^& Documentation
echo  [6] Exit
echo.
echo ============================================================================
echo.

set choice=""

set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto DOWNLOAD
if "%choice%"=="2" goto INSTALL
if "%choice%"=="3" goto LIST
if "%choice%"=="4" goto CREATE_REQUIREMENTS
if "%choice%"=="5" goto HELP
if "%choice%"=="6" goto EXIT
echo.
echo [WARNING] Invalid choice^! Please enter a number between 1 and 6.
timeout /t 2 >nul
goto MENU

REM ============================================================================
REM  DOWNLOAD PACKAGES SECTION
REM ============================================================================
:DOWNLOAD
color 09
cls
echo.
echo ============================================================================
echo                         DOWNLOAD PACKAGES
echo ============================================================================
echo.
echo This option downloads packages and all their dependencies.
echo.

set download_dir=offline_packages

set /p download_dir="Enter offline packages directory name [default: offline_packages]: "
if "%download_dir%"=="" set download_dir=offline_packages

:: -----------------------------
:: STEP 1 — Create directory
:: -----------------------------

REM Create directory if it doesn't exist
if not exist "%download_dir%" (
    mkdir "%download_dir%"
    echo [INFO] Created directory: %download_dir%
) else (
    echo [INFO] Using existing directory: %download_dir%
)
echo.

:: -----------------------------
:: STEP 2 — Create virtualenv temp area
:: -----------------------------
set TEMP_ENV=%download_dir%\temp_env

echo Creating temporary virtual environment...
python -m venv %TEMP_ENV% --clear >nul 2>&1

call "%TEMP_ENV%\Scripts\activate.bat"
REM python -m pip install --upgrade pip

cls
echo.
echo Choose download method:
echo  [1] Single package
echo  [2] Multiple packages (space-separated)
echo  [3] From requirements.txt file
echo.

set dl_method=""

set /p dl_method="Enter your choice (1-3): "

if "%dl_method%"=="1" goto DOWNLOAD_SINGLE
if "%dl_method%"=="2" goto DOWNLOAD_MULTIPLE
if "%dl_method%"=="3" goto DOWNLOAD_REQUIREMENTS
echo [WARNING] Invalid choice^!
timeout /t 2 >nul
goto DOWNLOAD

:DOWNLOAD_SINGLE
color 09
echo.

set package=""

set /p package="Enter package name (e.g., requests or pandas==1.5.0): "
if "%package%"=="" (
    echo [ERROR] Package name cannot be empty^!
    timeout /t 2 >nul
    goto DOWNLOAD
)
echo.
echo [INFO] Downloading %package% and dependencies to %download_dir%...
echo.

echo Installing package online in temporary virtual environment so pip freeze can detect exact versions...
pip install "%package%"

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Package downloaded successfully^!
) else (
    echo.
    echo [ERROR] Failed to download package^!
)

echo.
echo Freezing versions to requirements.txt...
echo.

pip freeze > "%download_dir%\.requirements.txt"

echo Downloading ALL required wheels and sources...
pip download -r "%download_dir%\.requirements.txt" -d "%download_dir%"

echo.
echo Cleaning temporary environment...
call "%TEMP_ENV%\Scripts\deactivate.bat"
echo %TEMP_ENV%

rmdir /S /Q %TEMP_ENV% >nul 2>&1

echo.
echo ============================================
echo OFFLINE PACKAGE COLLECTION READY
echo ============================================

pause
goto MENU

:DOWNLOAD_MULTIPLE
color 09
echo.
echo Enter package names separated by spaces

set packages=""

set /p packages="(e.g., requests numpy pandas): "
if "%packages%"=="" (
    echo [ERROR] Package names cannot be empty^!
    timeout /t 2 >nul
    goto DOWNLOAD
)
echo.
echo [INFO] Downloading packages and dependencies to %download_dir%...
echo.
echo Installing package online in temporary virtual environment so pip freeze can detect exact versions...
echo.

for %%p in (%packages%) do (
	echo Installing package %%p in temporary virtual environment ...
    pip install "%%p"
)

if %errorlevel% equ 0 (
echo.
echo [SUCCESS] All packages downloaded^!
) else (
echo.
echo [ERROR] Failed to download some packages^!
)

echo.
echo Freezing versions to requirements.txt...
echo.

pip freeze > "%download_dir%\.requirements.txt"

echo Downloading ALL required wheels and sources...
pip download -r "%download_dir%\.requirements.txt" -d "%download_dir%"

echo.
echo Cleaning temporary environment...
call "%TEMP_ENV%\Scripts\deactivate.bat"
echo %TEMP_ENV%

rmdir /S /Q %TEMP_ENV% >nul 2>&1

echo.
echo ============================================
echo OFFLINE PACKAGES COLLECTION READY
echo ============================================

pause
goto MENU

:DOWNLOAD_REQUIREMENTS
color 09
echo.

set req_file=requirements.txt

set /p req_file="Enter requirements.txt file path [default: requirements.txt]: "
if "%req_file%"=="" set req_file=requirements.txt

if not exist "%req_file%" (
    echo [ERROR] File '%req_file%' not found^!
    echo.
    pause
    goto DOWNLOAD
)

echo.
echo [INFO] Downloading packages from %req_file% to %download_dir%...
echo.

for /f "tokens=*" %%a in (%req_file%) do (
  echo Installing package %%a in temporary virtual environment ...
  pip install "%%a"
)

if %errorlevel% equ 0 (
echo.
echo [SUCCESS] All packages downloaded^!
) else (
echo.
echo [ERROR] Failed to download some packages^!
)

echo.
echo Freezing versions to requirements.txt...
echo.

pip freeze > "%download_dir%\.requirements.txt"

echo Downloading ALL required wheels and sources...
pip download -r "%download_dir%\.requirements.txt" -d "%download_dir%"

echo.
echo Cleaning temporary environment...
call "%TEMP_ENV%\Scripts\deactivate.bat"
echo %TEMP_ENV%

rmdir /S /Q %TEMP_ENV% >nul 2>&1

echo.
echo ============================================
echo OFFLINE PACKAGES COLLECTION READY
echo ============================================

pause
goto MENU

REM ============================================================================
REM  INSTALL PACKAGES SECTION
REM ============================================================================
:INSTALL
color 09
cls
echo.
echo ============================================================================
echo                    INSTALL PACKAGES (OFFLINE MODE)
echo ============================================================================
echo.
echo This option installs packages WITHOUT internet connection.
echo.

set install_dir=offline_packages

set /p install_dir="Enter offline packages directory name [default: offline_packages]: "
if "%install_dir%"=="" set install_dir=offline_packages

if not exist "%install_dir%" (
    echo.
    echo [ERROR] Directory '%install_dir%' does not exist^!
    echo Please download packages first using Option 1.
    echo.
    pause
    goto MENU
)

REM Count wheel files
setlocal EnableDelayedExpansion
set count=0
for %%f in ("%install_dir%\*.whl") do (
    set /a count+=1
)

if !count! equ 0 (
	echo.
    echo [ERROR] No wheel files ^(.whl^) found in "%install_dir%"^!
    echo Please download packages first using Option 1.
    echo.
    pause
    goto MENU
)

echo.
echo Found %count% wheel file(s) in '%install_dir%'

endlocal

echo.
echo Choose installation method:
echo  [1] Install specific package
echo  [2] Install all packages in directory
echo  [3] Install from requirements.txt (offline)
echo.

set inst_method=""

set /p inst_method="Enter your choice (1-3): "

if "%inst_method%"=="1" goto INSTALL_SINGLE
if "%inst_method%"=="2" goto INSTALL_ALL
if "%inst_method%"=="3" goto INSTALL_REQUIREMENTS_OFFLINE
echo [WARNING] Invalid choice^!
timeout /t 2 >nul
goto INSTALL

:INSTALL_SINGLE
color 09
echo.

set package=""

set /p package="Enter package name to install: "
if "%package%"=="" (
    echo [ERROR] Package name cannot be empty^!
    timeout /t 2 >nul
    goto INSTALL
)
echo.
echo [INFO] Installing %package% from offline packages...
echo.
python -m pip install --no-index --find-links="%install_dir%" "%package%"
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Package installed successfully^!
) else (
    echo.
    echo [ERROR] Failed to install package^!
)
echo.
pause
goto MENU

:INSTALL_ALL
color 09
echo.
echo [WARNING] This will install ALL packages from '%install_dir%'

set confirm=""

set /p confirm="Continue? (Y/N): "
if /i not "%confirm%"=="Y" goto MENU
echo.
echo [INFO] Installing all packages from offline directory...
echo.
for %%f in ("%install_dir%\*.whl") do (
    echo Installing %%~nxf...
    python -m pip install --no-index --find-links="%install_dir%" "%%f"
)
echo.
echo [SUCCESS] Installation complete^!
echo.
pause
goto MENU

:INSTALL_REQUIREMENTS_OFFLINE
color 09
echo.

set req_file=requirements.txt

set /p req_file="Enter requirements.txt file path [default: requirements.txt]: "
if "%req_file%"=="" set req_file=requirements.txt

if not exist "%req_file%" (
    echo [ERROR] File '%req_file%' not found^!
    echo.
    pause
    goto INSTALL
)
echo.
echo [INFO] Installing packages from %req_file% (offline mode)...
echo.
python -m pip install --no-index --find-links="%install_dir%" -r "%req_file%"
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] All packages installed successfully^!
) else (
    echo.
    echo [ERROR] Failed to install some packages^!
)
echo.
pause
goto MENU

REM ============================================================================
REM  LIST PACKAGES SECTION
REM ============================================================================
:LIST
color 09
cls
echo.
echo ============================================================================
echo                       DOWNLOADED PACKAGES LIST
echo ============================================================================
echo.

set list_dir=offline_packages

set /p list_dir="Enter offline packages directory name [default: offline_packages]: "
if "%list_dir%"=="" set list_dir=offline_packages

if not exist "%list_dir%" (
    echo.
    echo [ERROR] Directory '%list_dir%' does not exist^!
    echo.
    pause
    goto MENU
)

echo.
echo Contents of '%list_dir%':
echo ============================================================================
echo.

set count=0
for %%f in ("%list_dir%\*.whl") do (
    set /a count+=1
    echo [!count!] %%~nxf
)

if %count% equ 0 (
    echo No wheel files found in this directory.
) else (
    echo.
    echo ============================================================================
    echo Total: %count% package(s^)
)

echo.
echo Other files in directory:
echo.
for %%f in ("%list_dir%\*.*") do (
    if not "%%~xf"==".whl" echo  - %%~nxf
)

echo.
pause
goto MENU

REM ============================================================================
REM  CREATE REQUIREMENTS SECTION
REM ============================================================================
:CREATE_REQUIREMENTS
color 09
cls
echo.
echo ============================================================================
echo                   CREATE REQUIREMENTS.TXT
echo ============================================================================
echo.
echo This creates a requirements.txt from currently installed packages.
echo.

set req_output=requirements.txt

set /p req_output="Enter output filename [default: requirements.txt]: "
if "%req_output%"=="" set req_output=requirements.txt
echo.
echo [INFO] Generating %req_output%...
echo.
python -m pip freeze > "%req_output%"

if %errorlevel% equ 0 (
    echo [SUCCESS] Requirements file created: %req_output%
    echo.
    echo Preview ^(first 10 lines^):
    echo ============================================================================
    for /f "delims=" %%A in ('findstr /n "^" "%req_output%" ^| findstr "^[1-9]:"') do echo %%A
) else (
    echo [ERROR] Failed to create requirements file^!
)
echo.
pause
goto MENU

REM ============================================================================
REM  HELP SECTION
REM ============================================================================
:HELP
color 09
cls
echo.
echo ============================================================================
echo                        HELP ^& DOCUMENTATION
echo ============================================================================
echo.
echo OVERVIEW:
echo This tool helps you install Python packages without internet connection.
echo.
echo WORKFLOW:
echo  1. On an ONLINE machine: Use Option 1 to download packages
echo  2. Transfer the 'offline_packages' folder to your offline machine
echo  3. On the OFFLINE machine: Use Option 2 to install packages
echo.
echo ============================================================================
echo.
echo OPTION 1 - DOWNLOAD PACKAGES:
echo  Downloads packages and ALL dependencies as .whl files
echo  Requires: Internet connection
echo  Command used: pip download ^<package^> -d ^<directory^>
echo.
echo OPTION 2 - INSTALL OFFLINE:
echo  Installs packages from local .whl files
echo  Requires: No internet needed
echo  Command used: pip install --no-index --find-links=^<dir^> ^<package^>
echo.
echo OPTION 3 - LIST PACKAGES:
echo  Shows all downloaded .whl files in your offline directory
echo.
echo OPTION 4 - CREATE REQUIREMENTS:
echo  Generates requirements.txt from currently installed packages
echo  Command used: pip freeze ^> requirements.txt
echo.
echo ============================================================================
echo.
echo TIPS:
echo  - Always download on the SAME platform (Windows/Linux/Mac) as target
echo  - Specify versions if needed: package==1.2.3
echo  - Use requirements.txt for multiple packages
echo  - Keep offline_packages folder organized by project
echo.
echo COMMON ISSUES:
echo  - "No matching distribution": Wrong Python version or platform
echo  - "Permission denied": Run as administrator or use virtual environment
echo  - "Failed to download": Check internet connection and package name
echo.
echo ============================================================================
echo.
echo For more help, visit: https://pip.pypa.io/en/stable/
echo.
pause
goto MENU

REM ============================================================================
REM  EXIT SECTION
REM ============================================================================
:EXIT
color 09
cls
echo.
echo ============================================================================
echo.
echo  Thank you for using PIP Offline Package Installer by ioWiz^!
echo.
echo  Subscribe to ioWiz on YouTube for more incredible tutorials^!
echo.
echo ============================================================================
echo.
timeout /t 3 >nul
exit /b 0