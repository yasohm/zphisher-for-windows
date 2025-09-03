Write-Host "Zphisher Windows Test Script" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/6] Testing PowerShell version..." -ForegroundColor Green
$psVersion = $PSVersionTable.PSVersion
Write-Host "PowerShell Version: $psVersion" -ForegroundColor White
if ($psVersion.Major -ge 2) {
    Write-Host "✓ PowerShell version is compatible" -ForegroundColor Green
} else {
    Write-Host "✗ PowerShell version may be too old" -ForegroundColor Red
}
Write-Host ""

Write-Host "[2/6] Testing execution policy..." -ForegroundColor Green
$executionPolicy = Get-ExecutionPolicy
Write-Host "Current Execution Policy: $executionPolicy" -ForegroundColor White
if ($executionPolicy -eq "Restricted") {
    Write-Host "⚠ Execution policy is restricted. You may need to run:" -ForegroundColor Yellow
    Write-Host "  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
} else {
    Write-Host "✓ Execution policy allows script execution" -ForegroundColor Green
}
Write-Host ""

Write-Host "[3/6] Testing required dependencies..." -ForegroundColor Green
$dependencies = @{
    "PHP" = "php"
    "Git" = "git"
    "Curl" = "curl"
}

$missingDeps = @()
foreach ($dep in $dependencies.GetEnumerator()) {
    try {
        $version = & $dep.Value --version 2>$null | Select-Object -First 1
        if ($version) {
            Write-Host "✓ $($dep.Key): Found - $version" -ForegroundColor Green
        } else {
            Write-Host "✗ $($dep.Key): Not found" -ForegroundColor Red
            $missingDeps += $dep.Key
        }
    } catch {
        Write-Host "✗ $($dep.Key): Not found" -ForegroundColor Red
        $missingDeps += $dep.Key
    }
}
Write-Host ""

Write-Host "[4/6] Testing optional dependencies..." -ForegroundColor Green
$optionalDeps = @{
    "Node.js" = "node"
    "Chocolatey" = "choco"
}

foreach ($dep in $optionalDeps.GetEnumerator()) {
    try {
        $version = & $dep.Value --version 2>$null | Select-Object -First 1
        if ($version) {
            Write-Host "✓ $($dep.Key): Found - $version" -ForegroundColor Green
        } else {
            Write-Host "- $($dep.Key): Not found (Optional)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "- $($dep.Key): Not found (Optional)" -ForegroundColor Gray
    }
}
Write-Host ""

Write-Host "[5/6] Testing file structure..." -ForegroundColor Green
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$requiredFiles = @(
    "zphisher.ps1",
    "zphisher.bat",
    "install-windows.bat"
)

$requiredDirs = @(
    ".sites",
    "auth"
)

foreach ($file in $requiredFiles) {
    $path = Join-Path $baseDir $file
    if (Test-Path $path) {
        Write-Host "✓ File: $file" -ForegroundColor Green
    } else {
        Write-Host "✗ File: $file - Missing" -ForegroundColor Red
    }
}

foreach ($dir in $requiredDirs) {
    $path = Join-Path $baseDir $dir
    if (Test-Path $path) {
        Write-Host "✓ Directory: $dir" -ForegroundColor Green
    } else {
        Write-Host "✗ Directory: $dir - Missing" -ForegroundColor Red
    }
}
Write-Host ""

Write-Host "[6/6] Testing network connectivity..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "https://api.github.com" -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ Internet connection: Working" -ForegroundColor Green
} catch {
    Write-Host "✗ Internet connection: Failed" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor White
}
Write-Host ""

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Test Results Summary" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

if ($missingDeps.Count -gt 0) {
    Write-Host "Missing required dependencies:" -ForegroundColor Red
    foreach ($dep in $missingDeps) {
        Write-Host "  - $dep" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "Please install missing dependencies before using Zphisher." -ForegroundColor Yellow
} else {
    Write-Host "All required dependencies are installed!" -ForegroundColor Green
}

Write-Host ""
Write-Host "To run Zphisher:" -ForegroundColor Cyan
Write-Host "  PowerShell: .\zphisher.ps1" -ForegroundColor White
Write-Host "  Batch: zphisher.bat" -ForegroundColor White
Write-Host "  Quick start: run-zphisher.bat" -ForegroundColor White
Write-Host ""

Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
