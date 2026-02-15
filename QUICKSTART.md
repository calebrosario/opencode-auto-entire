# Quick Start Guide

Get OpenCode Auto-Entire running in 5 minutes.

## macOS / Linux

```bash
# 1. Clone
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# 2. Install (includes Entire CLI)
./scripts/install.sh

# 3. Restart OpenCode
# Then open any git project and you'll see the check
```

## Windows

```powershell
# 1. Clone
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# 2. Install plugin (Entire CLI manual - see below)
.\scripts\install.ps1

# 3. Download and install Entire CLI manually:
# https://github.com/entireio/cli/releases/latest

# 4. Restart OpenCode
```

## Verify Installation

1. Open a git project:
   ```bash
   cd ~/your-project
   opencode
   ```

2. You'll see one of these:
   ```
   # If Entire not enabled:
   Memory Management Check
   Entire CLI: Not initialized
   Run: `entire enable --strategy auto-commit`
   
   # If Entire enabled:
   Memory Stack Status
   Entire CLI: Enabled
   All systems operational.
   ```

3. If prompted, enable Entire:
   ```bash
   entire enable --strategy auto-commit
   ```

## Next Steps

- [Configuration Guide](README.md#configuration)
- [Claude Code Setup](docs/CLAUDE_CODE.md)
- [Full Documentation](README.md)

## One-Liner Install (macOS/Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/opencode-auto-entire/main/scripts/install.sh | bash
```

**Note:** Review scripts before running remote code.
