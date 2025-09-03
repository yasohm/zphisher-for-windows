@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    Zphisher Windows Installation
echo ========================================
echo.

net session >nul 2>&1
if %errorLevel% == 0 (
    echo [INFO] Running as Administrator
) else (
    echo [ERROR] This script requires Administrator privileges
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
echo [INFO] Windows Version: %VERSION%
echo.

echo [INFO] Checking for Chocolatey package manager...
where choco >nul 2>&1
if %errorLevel% == 0 (
    echo [INFO] Chocolatey found, updating to latest version...
    choco upgrade chocolatey -y
    set "USE_CHOCO=true"
) else (
    echo [INFO] Chocolatey not found, installing automatically...
    echo [INFO] Installing Chocolatey package manager...
    
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    
    if %errorLevel% == 0 (
        echo [INFO] Chocolatey installed successfully
        set "USE_CHOCO=true"
        
        echo [INFO] Refreshing environment variables...
        call refreshenv.cmd 2>nul
        if %errorLevel% neq 0 (
            echo [INFO] Please restart this script to continue with installations
            echo [INFO] Or restart your command prompt and run again
            pause
            exit /b 0
        )
    ) else (
        echo [ERROR] Failed to install Chocolatey
        echo [INFO] Will attempt manual installation methods
        set "USE_CHOCO=false"
    )
)

echo.
echo ========================================
echo    Installing Dependencies
echo ========================================
echo.

if "%USE_CHOCO%"=="true" (
    echo [INFO] Installing all dependencies using Chocolatey...
    echo.
    
    echo [1/4] Installing PHP...
    choco install php -y --force
    if %errorLevel% == 0 (
        echo [✓] PHP installed successfully
    ) else (
        echo [✗] PHP installation failed
    )
    
    echo.
    echo [2/4] Installing Git...
    choco install git -y --force
    if %errorLevel% == 0 (
        echo [✓] Git installed successfully
    ) else (
        echo [✗] Git installation failed
    )
    
    echo.
    echo [3/4] Installing Curl...
    choco install curl -y --force
    if %errorLevel% == 0 (
        echo [✓] Curl installed successfully
    ) else (
        echo [✗] Curl installation failed
    )
    
    echo.
    echo [4/4] Installing Node.js...
    choco install nodejs -y --force
    if %errorLevel% == 0 (
        echo [✓] Node.js installed successfully
    ) else (
        echo [✗] Node.js installation failed
    )
    
    echo.
    echo [INFO] Refreshing environment variables...
    call refreshenv.cmd 2>nul
    
) else (
    echo [INFO] Chocolatey not available, attempting manual installations...
    echo.
    
    echo [1/4] Installing PHP...
    echo [INFO] Downloading PHP installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://windows.php.net/downloads/releases/php-8.2.12-Win32-vs16-x64.zip' -OutFile 'php.zip'"
    if exist "php.zip" (
        echo [INFO] Extracting PHP...
        powershell -Command "Expand-Archive -Path 'php.zip' -DestinationPath 'C:\php' -Force"
        echo [INFO] Adding PHP to PATH...
        setx PATH "%PATH%;C:\php" /M
        del "php.zip"
        echo [✓] PHP installed manually
    ) else (
        echo [✗] PHP download failed
    )
    
    echo.
    echo [2/4] Installing Git...
    echo [INFO] Downloading Git installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe' -OutFile 'git-installer.exe'"
    if exist "git-installer.exe" (
        echo [INFO] Installing Git silently...
        git-installer.exe /VERYSILENT /NORESTART
        del "git-installer.exe"
        echo [✓] Git installed manually
    ) else (
        echo [✗] Git download failed
    )
    
    echo.
    echo [3/4] Installing Curl...
    echo [INFO] Downloading Curl...
    powershell -Command "Invoke-WebRequest -Uri 'https://curl.se/windows/curl-8.4.0_5-win64-mingw.zip' -OutFile 'curl.zip'"
    if exist "curl.zip" (
        echo [INFO] Extracting Curl...
        powershell -Command "Expand-Archive -Path 'curl.zip' -DestinationPath 'C:\curl' -Force"
        echo [INFO] Adding Curl to PATH...
        setx PATH "%PATH%;C:\curl\bin" /M
        del "curl.zip"
        echo [✓] Curl installed manually
    ) else (
        echo [✗] Curl download failed
    )
    
    echo.
    echo [4/4] Installing Node.js...
    echo [INFO] Downloading Node.js installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.8.0/node-v20.8.0-x64.msi' -OutFile 'nodejs-installer.msi'"
    if exist "nodejs-installer.msi" (
        echo [INFO] Installing Node.js silently...
        msiexec /i nodejs-installer.msi /quiet /norestart
        del "nodejs-installer.msi"
        echo [✓] Node.js installed manually
    ) else (
        echo [✗] Node.js download failed
    )
)

echo.
echo ========================================
echo    Configuration
echo ========================================
echo.

echo [INFO] Creating shortcuts...
if not exist "run-zphisher.bat" (
    echo @echo off > run-zphisher.bat
    echo echo Starting Zphisher... >> run-zphisher.bat
    echo powershell -ExecutionPolicy Bypass -File "zphisher.ps1" >> run-zphisher.bat
    echo pause >> run-zphisher.bat
    echo [INFO] Created run-zphisher.bat shortcut
)

if not exist "run-zphisher-cmd.bat" (
    echo @echo off > run-zphisher-cmd.bat
    echo echo Starting Zphisher (CMD version)... >> run-zphisher-cmd.bat
    echo zphisher.bat >> run-zphisher-cmd.bat
    echo pause >> run-zphisher-cmd.bat
    echo [INFO] Created run-zphisher-cmd.bat shortcut
)

echo.
echo ========================================
echo    Verification
echo ========================================
echo.

echo [INFO] Verifying installations...
echo.

echo [INFO] Refreshing environment variables...
call refreshenv.cmd 2>nul

echo [INFO] Testing PHP...
where php >nul 2>&1
if %errorLevel% == 0 (
    echo [✓] PHP: Found
    php --version | findstr "PHP"
) else (
    echo [✗] PHP: Not found in PATH
    echo [INFO] You may need to restart your command prompt
)

echo.
echo [INFO] Testing Git...
where git >nul 2>&1
if %errorLevel% == 0 (
    echo [✓] Git: Found
    git --version
) else (
    echo [✗] Git: Not found in PATH
    echo [INFO] You may need to restart your command prompt
)

echo.
echo [INFO] Testing Curl...
where curl >nul 2>&1
if %errorLevel% == 0 (
    echo [✓] Curl: Found
    curl --version | findstr "curl"
) else (
    echo [✗] Curl: Not found in PATH
    echo [INFO] You may need to restart your command prompt
)

echo.
echo [INFO] Testing Node.js...
where node >nul 2>&1
if %errorLevel% == 0 (
    echo [✓] Node.js: Found
    node --version
) else (
    echo [✗] Node.js: Not found in PATH
    echo [INFO] You may need to restart your command prompt
)

echo.
echo ========================================
echo    Next Steps
echo ========================================
echo.
echo [INFO] Installation process completed!
echo.
echo [NOTE] If any tools show as "Not found", please restart your command prompt
echo [NOTE] This will refresh the PATH environment variable
echo.
echo To run Zphisher, you can use:
echo   1. run-zphisher.bat (PowerShell version - Recommended)
echo   2. run-zphisher-cmd.bat (CMD version)
echo   3. powershell -ExecutionPolicy Bypass -File "zphisher.ps1"
echo   4. zphisher.bat
echo.
echo [INFO] Testing Zphisher installation...
echo.
call test-windows.ps1 2>nul
if %errorLevel% neq 0 (
    echo [INFO] PowerShell test failed, trying batch version...
    call test-windows.bat 2>nul
)

echo.
echo [INFO] Installation complete! Press any key to exit...
pause >nul
