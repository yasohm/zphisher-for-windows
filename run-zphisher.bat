@echo off
echo ========================================
echo    Zphisher Windows Edition
echo ========================================
echo.
echo Starting Zphisher (PowerShell version)...
echo.
echo If you see execution policy errors, run:
echo   powershell -ExecutionPolicy Bypass -File "zphisher.ps1"
echo.
echo Press any key to continue...
pause >nul

powershell -ExecutionPolicy Bypass -File "zphisher.ps1"

echo.
echo Zphisher has exited.
echo Press any key to close this window...
pause >nul
