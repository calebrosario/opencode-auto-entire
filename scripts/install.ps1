#
# OpenCode Auto-Entire Plugin Installer for Windows
# Supports: Windows PowerShell 5.1+ and PowerShell Core 7+
# This script installs both the plugin and Entire CLI
#

param(
    [switch]$Force,
    [switch]$SkipEntire,
    [switch]$Help
)

$Script:Version = "1.0.0"
$Script:PluginName = "opencode-auto-entire"
$Script:PluginDir = Join-Path $env:USERPROFILE ".config\opencode\plugins\$Script:PluginName"
$Script:ConfigDir = Join-Path $env:USERPROFILE ".config\opencode"

function Write-Header {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║     OpenCode Auto-Entire Plugin Installer v$Script:Version          ║" -ForegroundColor Cyan
    Write-Host "║     Automatic Entire CLI monitoring for OpenCode          ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success($Message) {
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error($Message) {
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning($Message) {
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Info($Message) {
    Write-Host "ℹ $Message" -ForegroundColor Blue
}

function Test-Prerequisites {
    Write-Info "Checking prerequisites..."
    
    # Check for git
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "git is required but not installed. Please install git first."
        Write-Info "Download from: https://git-scm.com/download/win"
        exit 1
    }
    Write-Success "git is installed"
    
    # Check for Node.js/npm
    if (!(Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Error "npm is required but not installed. Please install Node.js first."
        Write-Info "Download from: https://nodejs.org/"
        exit 1
    }
    Write-Success "npm is installed"
    
    # Check for OpenCode config directory
    if (!(Test-Path $Script:ConfigDir)) {
        Write-Warning "OpenCode config directory not found. Creating..."
        New-Item -ItemType Directory -Path $Script:ConfigDir -Force | Out-Null
    }
    Write-Success "OpenCode config directory exists"
}

function Install-EntireCLI {
    if ($SkipEntire) {
        Write-Info "Skipping Entire CLI installation (--SkipEntire specified)"
        return
    }
    
    Write-Info "Checking Entire CLI installation..."
    
    if (Get-Command entire -ErrorAction SilentlyContinue) {
        Write-Success "Entire CLI is already installed"
        entire --version
        return
    }
    
    Write-Info "Installing Entire CLI..."
    Write-Warning "Windows installation requires manual steps"
    Write-Info "Please follow these steps:"
    Write-Host ""
    Write-Host "1. Download the latest Windows release:"
    Write-Host "   https://github.com/entireio/cli/releases/latest"
    Write-Host ""
    Write-Host "2. Extract the archive and move 'entire.exe' to a folder in your PATH"
    Write-Host "   Recommended: C:\Program Files\Entire\entire.exe"
    Write-Host ""
    Write-Host "3. Or use scoop (if installed):"
    Write-Host "   scoop install entire"
    Write-Host ""
    Write-Host "4. Verify installation:"
    Write-Host "   entire --version"
    Write-Host ""
    
    $response = Read-Host "Would you like to open the download page? (Y/n)"
    if ($response -ne 'n' -and $response -ne 'N') {
        Start-Process "https://github.com/entireio/cli/releases/latest"
    }
}

function Install-Plugin {
    Write-Info "Installing OpenCode Auto-Entire Plugin..."
    
    # Create plugin directory
    if (Test-Path $Script:PluginDir) {
        if (!$Force) {
            Write-Warning "Plugin directory already exists. Use -Force to overwrite."
            return
        }
        Write-Warning "Plugin directory already exists. Backing up..."
        $backupName = "$Script:PluginDir.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Move-Item $Script:PluginDir $backupName
    }
    
    New-Item -ItemType Directory -Path $Script:PluginDir -Force | Out-Null
    
    # Copy plugin files
    $sourceDir = $PSScriptRoot
    if (!$sourceDir) {
        $sourceDir = (Get-Location).Path
    }
    
    if (Test-Path (Join-Path $sourceDir "src")) {
        Copy-Item -Path "$sourceDir\src" -Destination $Script:PluginDir -Recurse
        Copy-Item -Path "$sourceDir\package.json" -Destination $Script:PluginDir
        Copy-Item -Path "$sourceDir\tsconfig.json" -Destination $Script:PluginDir
    } else {
        Write-Error "Plugin source files not found in $sourceDir"
        Write-Info "Make sure you're running this script from the plugin directory"
        exit 1
    }
    
    # Install dependencies
    Write-Info "Installing plugin dependencies..."
    Push-Location $Script:PluginDir
    try {
        npm install 2>&1 | Out-Null
    } finally {
        Pop-Location
    }
    
    Write-Success "Plugin installed to $Script:PluginDir"
}

function Configure-OpenCode {
    Write-Info "Configuring OpenCode..."
    
    $configFile = Join-Path $Script:ConfigDir "opencode.json"
    $pluginPath = "file:///$($Script:PluginDir -replace '\\', '/')/src/plugin.ts"
    
    # Check if config exists
    if (!(Test-Path $configFile)) {
        Write-Warning "OpenCode config not found. Creating new config..."
        $config = @{
            '`$schema' = "https://opencode.ai/config.json"
            plugin = @($pluginPath)
        } | ConvertTo-Json -Depth 10
        
        # Fix the escaped $ in schema
        $config = $config -replace '"`$schema"', '"$schema"'
        
        $config | Out-File -FilePath $configFile -Encoding UTF8
    } else {
        Write-Warning "Please manually add the following to your OpenCode config ($configFile):"
        Write-Host ""
        Write-Host '"plugin": ['
        Write-Host "  \"$pluginPath\""
        Write-Host ']'
        Write-Host ""
    }
}

function New-Config {
    Write-Info "Creating default configuration..."
    
    $configFile = Join-Path $Script:ConfigDir "entire-check.json"
    
    if (Test-Path $configFile) {
        Write-Warning "Configuration already exists at $configFile"
        return
    }
    
    $config = @{
        enabled = $true
        mode = "prompt"
        checkGitRepo = $true
        showStatus = $true
    } | ConvertTo-Json -Depth 10
    
    $config | Out-File -FilePath $configFile -Encoding UTF8
    
    Write-Success "Default configuration created at $configFile"
}

function Write-Summary {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║              Installation Complete!                        ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Success "OpenCode Auto-Entire Plugin installed"
    if (!$SkipEntire) {
        Write-Success "Entire CLI installation instructions provided"
    }
    Write-Success "Default configuration created"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Install Entire CLI (if not done already)"
    Write-Host "  2. Restart OpenCode to load the plugin"
    Write-Host "  3. Open a project: cd C:\path\to\your\project"
    Write-Host "  4. Start OpenCode - you'll see the memory stack check"
    Write-Host ""
    Write-Host "Configuration:"
    Write-Host "  • Plugin location: $Script:PluginDir"
    Write-Host "  • Config file: $Script:ConfigDir\entire-check.json"
    Write-Host ""
    Write-Host "To enable Entire in a project:"
    Write-Host "  cd your-project && entire enable --strategy auto-commit"
    Write-Host ""
}

function Show-Help {
    Write-Host @"
OpenCode Auto-Entire Plugin Installer for Windows

Usage: .\install.ps1 [Options]

Options:
    -Force          Overwrite existing plugin installation
    -SkipEntire     Skip Entire CLI installation (manual install)
    -Help           Show this help message

Examples:
    .\install.ps1                    # Standard installation
    .\install.ps1 -Force             # Overwrite existing installation
    .\install.ps1 -SkipEntire        # Install only the plugin

Note: Entire CLI on Windows requires manual installation.
Download from: https://github.com/entireio/cli/releases/latest
"@
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

Write-Header
Test-Prerequisites
Install-EntireCLI
Install-Plugin
Configure-OpenCode
New-Config
Write-Summary
