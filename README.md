# Zphisher Windows Edition

A Windows-compatible version of the popular phishing awareness tool, designed to work seamlessly on Windows operating systems.

## DISCLAIMER

**This tool is for educational purposes only.** It demonstrates how phishing attacks work and should only be used in controlled, ethical environments for learning purposes. 

**DO NOT use this tool for malicious purposes or to harm others.** The authors and contributors are not responsible for any misuse of this tool.

## Features

- **Windows Native**: Built specifically for Windows systems
- **Multiple Versions**: Both PowerShell and Batch file versions available
- **Easy Installation**: Automated dependency installation script
- **30+ Templates**: All original phishing templates work on Windows
- **PHP Server**: Built-in PHP server for hosting templates
- **Credential Capture**: Captures and stores login attempts
- **IP Logging**: Logs visitor IP addresses and user agents

## Requirements

### Minimum Requirements
- Windows 7 or later
- PowerShell 2.0 or later
- Internet connection for initial setup

### Required Dependencies
- **PHP** (7.0 or later recommended)
- **Git** (for version control)
- **Curl** (for web requests)

### Optional Dependencies
- **Node.js** (for advanced features)
- **Chocolatey** (for easy package management)

## Quick Installation

1. **Download** the tool to your Windows machine
2. **Right-click** on `install-windows.bat` and select "Run as administrator"
3. **Follow the prompts** to install dependencies
4. **Wait for completion** - the script will verify all installations

## Quick Start

1. **Double-click** `run-zphisher.bat` (PowerShell version - Recommended)
2. **Or run** `run-zphisher-cmd.bat` (CMD version)
3. **Follow the on-screen menu** to select options

## File Structure

```
zphisher-windows/
├── zphisher.ps1              # PowerShell version (Recommended)
├── zphisher.bat              # Batch file version
├── install-windows.bat       # Installation script
├── run-zphisher.bat          # Quick start shortcut
├── run-zphisher-cmd.bat      # CMD version shortcut
├── test-windows.ps1          # Testing script
├── README.md                 # This file
├── .sites/                   # Phishing templates (30+ available)
├── auth/                     # Captured data storage
└── .server/                  # Server files
```

## Usage

### PowerShell Version (Recommended)
```powershell
# Interactive mode
.\zphisher.ps1

# View captured credentials
.\zphisher.ps1 -Auth

# View captured IPs
.\zphisher.ps1 -IP

# Show help
.\zphisher.ps1 -Help
```

### Batch Version
```cmd
# Interactive mode
zphisher.bat
```

### Testing
```powershell
# Test if everything works
.\test-windows.ps1
```

## Security Notes

- **Local Use Only**: The tool runs on localhost by default
- **Firewall**: Windows Firewall may ask for permission
- **Antivirus**: Some antivirus software may flag the tool
- **Isolation**: Use in isolated environments for testing

## Learning Resources

- **Phishing Awareness**: Learn to recognize phishing attempts
- **Web Security**: Understand how login forms work
- **Social Engineering**: Study human behavior in security
- **Ethical Hacking**: Practice in controlled environments

## Contributing

To contribute to the Windows version:

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Test thoroughly on Windows**
5. **Submit a pull request**

## License

This project is licensed under the GNU General Public License v3.0.

## Acknowledgments

- **Original Author**: TAHMID RAYAT
- **Windows Adaptation**: Assistant
- **Contributors**: All contributors to the original project

## Support

For Windows-specific issues:
1. Check this README first
2. Run `.\test-windows.ps1` to diagnose problems
3. Ensure all dependencies are properly installed
4. Check Windows compatibility

---

**Remember**: This tool is for educational purposes only. Use responsibly and ethically.
