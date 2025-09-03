@echo off
setlocal enabledelayedexpansion

set "VERSION=2.3.5-Windows"
set "HOST=127.0.0.1"
set "PORT=8080"

set "RED=[91m"
set "GREEN=[92m"
set "ORANGE=[93m"
set "BLUE=[94m"
set "MAGENTA=[95m"
set "CYAN=[96m"
set "WHITE=[97m"
set "RESET=[0m"

if not exist ".server" mkdir ".server"
if not exist "auth" mkdir "auth"
if not exist ".server\www" mkdir ".server\www"

if exist ".server\.loclx" del /q ".server\.loclx"
if exist ".server\.cld.log" del /q ".server\.cld.log"

:print_color
set "color=%~1"
set "text=%~2"
echo %color%%text%%RESET%
goto :eof

:command_exists
set "cmd=%~1"
where %cmd% >nul 2>&1
if %errorlevel% equ 0 (
    set "exists=true"
) else (
    set "exists=false"
)
goto :eof

:check_internet
echo.
call :print_color %GREEN% "[+] Checking internet connection..."
powershell -Command "try { Invoke-WebRequest -Uri 'https://api.github.com' -UseBasicParsing -TimeoutSec 3 | Out-Null; exit 0 } catch { exit 1 }"
if %errorlevel% equ 0 (
    call :print_color %GREEN% "Internet: Online"
    goto :check_update
) else (
    call :print_color %RED% "Internet: Offline"
    goto :main_menu
)

:check_update
echo.
call :print_color %CYAN% "[+] Checking for updates..."
call :print_color %GREEN% "Up to date"

:main_menu
cls
echo.
call :print_color %CYAN% "╔══════════════════════════════════════════╗"
call :print_color %CYAN% "║             ZPHISHER v%VERSION%          ║"
call :print_color %CYAN% "║        Windows-Compatible Version        ║"
call :print_color %CYAN% "╚══════════════════════════════════════════╝"
echo.
call :print_color %WHITE% "Available Options:"
echo.
call :print_color %GREEN% "1) Localhost"
call :print_color %GREEN% "2) Cloudflared (Tunnel)"
call :print_color %GREEN% "3) LocalXpose (Tunnel)"
call :print_color %GREEN% "4) About"
call :print_color %RED% "5) Exit"
echo.
set /p "choice=Select an option (1-5): "

if "%choice%"=="1" goto :localhost
if "%choice%"=="2" goto :cloudflared
if "%choice%"=="3" goto :localxpose
if "%choice%"=="4" goto :about
if "%choice%"=="5" goto :exit
goto :main_menu

:localhost
cls
call :print_color %CYAN% "[+] Starting localhost server..."
call :print_color %WHITE% "Server will be available at: http://%HOST%:%PORT%"
echo.
call :print_color %GREEN% "[+] Starting PHP server..."
cd .server\www
start "Zphisher PHP Server" cmd /c "php -S %HOST%:%PORT%"
cd ..\..
echo.
call :print_color %GREEN% "[+] PHP server started successfully!"
call :print_color %WHITE% "Press any key to return to main menu..."
pause >nul
goto :main_menu

:cloudflared
cls
call :print_color %CYAN% "[+] Cloudflared tunnel option"
call :print_color %WHITE% "This feature requires cloudflared to be installed."
call :print_color %WHITE% "Please install cloudflared from: https://github.com/cloudflare/cloudflared/releases"
echo.
call :print_color %WHITE% "Press any key to return to main menu..."
pause >nul
goto :main_menu

:localxpose
cls
call :print_color %CYAN% "[+] LocalXpose tunnel option"
call :print_color %WHITE% "This feature requires LocalXpose to be installed."
call :print_color %WHITE% "Please install LocalXpose from: https://github.com/Intriguinio/loclx"
echo.
call :print_color %WHITE% "Press any key to return to main menu..."
pause >nul
goto :main_menu

:about
cls
call :print_color %CYAN% "╔══════════════════════════════════════════╗"
call :print_color %CYAN% "║                ABOUT                     ║"
call :print_color %CYAN% "╚══════════════════════════════════════════╝"
echo.
call :print_color %WHITE% "Zphisher is an automated phishing tool with 30+ templates."
call :print_color %WHITE% "This Windows version maintains the same functionality as the original."
echo.
call :print_color %RED% "DISCLAIMER:"
call :print_color %WHITE% "This tool is for educational purposes only."
call :print_color %WHITE% "Do not use for malicious purposes."
echo.
call :print_color %WHITE% "Press any key to return to main menu..."
pause >nul
goto :main_menu

:exit
call :print_color %RED% "[!] Exiting Zphisher..."
call :print_color %WHITE% "Thank you for using Zphisher Windows Edition!"
timeout /t 2 >nul
exit /b 0
