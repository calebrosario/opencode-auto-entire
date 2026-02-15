# Platform Support

OpenCode Auto-Entire supports multiple platforms with different installation methods.

## Supported Platforms

| Platform | Status | Installation Method | Entire CLI |
|----------|--------|---------------------|------------|
| macOS | ✅ Fully Supported | One-command install | ✅ Homebrew |
| Linux | ✅ Fully Supported | One-command install | ✅ Binary releases |
| Windows | ✅ Supported | PowerShell script | ⚠️ Manual install |
| WSL | ✅ Supported | Linux script | ✅ Binary releases |

## Platform-Specific Instructions

### macOS

#### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer
./scripts/install.sh
```

#### Entire CLI

```bash
brew tap entireio/tap
brew install entireio/tap/entire
```

#### Requirements

- macOS 10.15+ (Catalina or later)
- Homebrew
- Node.js 18+
- Git

#### Known Issues

None. macOS is the primary development platform.

### Linux

#### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer
./scripts/install.sh
```

#### Entire CLI

Download the latest release from [Entire CLI releases](https://github.com/entireio/cli/releases):

```bash
# Download binary (example for x86_64)
wget https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64

# Make executable
chmod +x entire-linux-amd64

# Move to PATH
sudo mv entire-linux-amd64 /usr/local/bin/entire
```

#### Requirements

- Linux distribution with standard tools
- Node.js 18+
- Git
- curl or wget

#### Tested Distributions

- Ubuntu 20.04, 22.04
- Debian 11, 12
- Fedora 36, 37
- Arch Linux
- AlmaLinux 8, 9

#### Known Issues

- Some distributions may require additional dependencies for Entire CLI
- WSL users should use the Linux installation method

### Windows

#### Installation

```powershell
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the PowerShell installer
.\scripts\install.ps1
```

#### Entire CLI

Download the latest Windows binary from [Entire CLI releases](https://github.com/entireio/cli/releases):

1. Download `entire-windows-amd64.exe`
2. Rename to `entire.exe`
3. Add to your PATH or place in a directory on your PATH

```powershell
# Example: Add to user PATH
$env:PATH += ";C:\Users\YourName\bin"
[Environment]::SetEnvironmentVariable("Path", $env:PATH, "User")
```

#### Requirements

- Windows 10 or later
- PowerShell 5.1+
- Node.js 18+
- Git for Windows

#### Known Issues

- PowerShell execution policy may need to be adjusted:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```
- Entire CLI requires manual installation (no package manager yet)
- Some Git configurations may require adjustment

#### Workarounds

**PowerShell Execution Policy:**
```powershell
# Temporary (current session only)
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Permanent for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### WSL (Windows Subsystem for Linux)

#### Installation

Use the Linux installation method inside WSL:

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the Linux installer
./scripts/install.sh
```

#### Entire CLI

Use the Linux binary inside WSL (same as native Linux):

```bash
# Download binary
wget https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64

# Make executable
chmod +x entire-linux-amd64

# Move to PATH
sudo mv entire-linux-amd64 /usr/local/bin/entire
```

#### Requirements

- WSL 2 with Ubuntu, Debian, or similar distribution
- Node.js 18+
- Git

#### Known Issues

- File system performance between Windows and WSL
- Path handling for Windows files from WSL
- Entire CLI should be run from within WSL for best results

## Version Compatibility

### Node.js

| OpenCode Auto-Entire | Node.js Support |
|----------------------|----------------|
| 1.0.x | 18.x, 20.x, 22.x |
| Future versions | Will maintain support for latest LTS |

### OpenCode

| OpenCode Auto-Entire | OpenCode Support |
|----------------------|------------------|
| 1.0.x | Latest version with plugin support |

### Claude Code

| OpenCode Auto-Entire | Claude Code Support |
|----------------------|-------------------|
| 1.0.x | Latest version with plugin support |

## Dependency Matrix

### macOS

```yaml
dependencies:
  - name: "Entire CLI"
    install: "brew install entireio/tap/entire"
    required: true
    optional: false
  - name: "Claude-Mem"
    install: "npm install -g @claude/mem"
    required: false
    optional: true
  - name: "RTK"
    install: "npm install -g rtk-ai/rtk"
    required: false
    optional: true
```

### Linux

```yaml
dependencies:
  - name: "Entire CLI"
    install: "Download from releases"
    required: true
    optional: false
  - name: "Claude-Mem"
    install: "npm install -g @claude/mem"
    required: false
    optional: true
  - name: "RTK"
    install: "npm install -g rtk-ai/rtk"
    required: false
    optional: true
```

### Windows

```yaml
dependencies:
  - name: "Entire CLI"
    install: "Download from releases"
    required: true
    optional: false
  - name: "Claude-Mem"
    install: "npm install -g @claude/mem"
    required: false
    optional: true
  - name: "RTK"
    install: "npm install -g rtk-ai/rtk"
    required: false
    optional: true
```

## Package Manager Support

### npm

```bash
npm install -g opencode-auto-entire
```

*Note: Not currently published to npm registry*

### bun

```bash
bun install -g opencode-auto-entire
```

*Note: Not currently published to npm registry*

### yarn

```bash
yarn global add opencode-auto-entire
```

*Note: Not currently published to npm registry*

## Container Support

### Docker

The plugin can be run in Docker containers with proper mounting:

```bash
docker run -it \
  -v ~/.config/opencode:/root/.config/opencode \
  -v $(pwd):/workspace \
  node:18 bash
```

Then install the plugin inside the container.

### Docker Compose

```yaml
version: '3.8'
services:
  opencode:
    image: node:18
    volumes:
      - ~/.config/opencode:/root/.config/opencode
      - .:/workspace
    working_dir: /workspace
    command: opencode
```

## Troubleshooting by Platform

### macOS

**Issue:** "command not found: entire"
**Solution:** Ensure Homebrew is installed and Entire CLI is in your PATH:
```bash
brew --prefix entireio/tap/entire
export PATH="/usr/local/bin:$PATH"
```

### Linux

**Issue:** Permission denied when installing Entire CLI
**Solution:** Use sudo or install to user directory:
```bash
# System-wide
sudo mv entire-linux-amd64 /usr/local/bin/entire

# User directory
mkdir -p ~/.local/bin
mv entire-linux-amd64 ~/.local/bin/entire
export PATH="$HOME/.local/bin:$PATH"
```

### Windows

**Issue:** PowerShell script execution blocked
**Solution:** Adjust execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Issue:** Git not found
**Solution:** Install Git for Windows and ensure it's in your PATH

### WSL

**Issue:** Slow file system performance
**Solution:** Keep files in WSL filesystem (not mounted Windows drives)

## Testing Your Installation

After installation, verify everything works:

```bash
# Check Entire CLI
entire --version

# Check Claude-Mem (if installed)
claude-mem --version

# Check RTK (if installed)
rtk --version

# Start OpenCode
opencode
```

You should see the memory stack check at session start.

## Getting Help

If you encounter platform-specific issues:

1. Check this documentation first
2. Review platform-specific troubleshooting sections
3. Check [GitHub Issues](https://github.com/yourusername/opencode-auto-entire/issues)
4. Include your platform information when reporting issues

## Next Steps

- Set up Claude Code: [Claude Code Integration](claude-code.md)
- Understand plugin architecture: [Architecture](architecture.md)
- Learn configuration: [Configuration](../user-guide/configuration.md)
