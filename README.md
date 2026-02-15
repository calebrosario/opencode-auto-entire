# OpenCode Auto-Entire

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/opencode-auto-entire)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![OpenCode](https://img.shields.io/badge/OpenCode-plugin-orange.svg)](https://opencode.ai)

> 🧠 Automatic Entire CLI monitoring for OpenCode - Never lose session context again

OpenCode Auto-Entire is a plugin that automatically checks if [Entire CLI](https://github.com/entireio/cli) is enabled when you start an OpenCode session. If not, it prompts you with clear instructions to fix it. It also monitors your complete memory management stack including Claude-Mem and RTK.

## Why This Exists

Without Entire CLI enabled:
- ❌ Session crashes = lost context and work
- ❌ No checkpoint recovery
- ❌ No audit trail of agent decisions

With OpenCode Auto-Entire:
- ✅ Automatically detects missing Entire on session start
- ✅ Prompts with actionable fix instructions
- ✅ Monitors full memory stack (Entire + Claude-Mem + RTK)
- ✅ Configurable behavior (prompt / auto-init / silent)

## Quick Start

### macOS / Linux

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer
./scripts/install.sh
```

### Windows (PowerShell)

```powershell
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer
.\scripts\install.ps1
```

### Manual Installation

1. **Install Entire CLI:**
   ```bash
   # macOS
   brew tap entireio/tap
   brew install entireio/tap/entire
   
   # Linux (various methods)
   # See: https://github.com/entireio/cli#installation
   ```

2. **Copy plugin to OpenCode:**
   ```bash
   mkdir -p ~/.config/opencode/plugins/
   cp -r . ~/.config/opencode/plugins/opencode-auto-entire
   cd ~/.config/opencode/plugins/opencode-auto-entire
   npm install
   ```

3. **Add to OpenCode config** (`~/.config/opencode/opencode.json`):
   ```json
   {
     "plugin": [
       "file:///Users/YOUR_USERNAME/.config/opencode/plugins/opencode-auto-entire/src/plugin.ts"
     ]
   }
   ```

4. **Restart OpenCode**

## What It Does

On every session start in a git repository:

1. ✅ Checks if **Entire CLI** is enabled (looks for `.entire/settings.json`)
2. ✅ Checks if **Claude-Mem** is installed and active
3. ✅ Checks if **RTK** is installed and gets efficiency stats
4. ✅ Prompts you with clear instructions if anything is missing

## Configuration

Create `~/.config/opencode/entire-check.json`:

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enabled` | boolean | `true` | Enable/disable the plugin |
| `mode` | `"prompt"` \| `"auto-init"` \| `"silent"` | `"prompt"` | Behavior when Entire not enabled |
| `checkGitRepo` | boolean | `true` | Only check in git repositories |
| `showStatus` | boolean | `true` | Show status even when Entire is enabled |

### Modes

**prompt** (default):
Shows a friendly reminder with instructions:
```
Memory Management Check

Entire CLI: Not initialized
Run: `entire enable --strategy auto-commit`

Claude-Mem: Active
RTK: Active (91.7% efficiency)

Why this matters:
• Entire = Session checkpoint/recovery (crash protection)
• Claude-Mem = Cross-session memory (context persistence)
• RTK = Token optimization (60-90% savings)

Enable Entire to prevent context loss on crashes.
```

**auto-init**:
Automatically runs `entire enable --strategy auto-commit` without asking.

⚠️ **Use with caution** - modifies repositories without explicit confirmation!

**silent**:
Only logs to console, no UI notification.

## Usage

After installation, simply start OpenCode in any git repository:

```bash
cd your-project
opencode
```

You'll see the memory stack check at session start.

### When Entire is Not Enabled

The plugin will prompt you. To fix:

```bash
cd your-project
entire enable --strategy auto-commit
```

Then restart OpenCode.

### When Entire is Enabled

You'll see:
```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active  
RTK: Active (91.7% efficiency)

All systems operational.
```

## Platform Support

| Platform | Installation | Entire CLI |
|----------|--------------|------------|
| macOS | ✅ One-command install | ✅ Homebrew |
| Linux | ✅ One-command install | ✅ Binary releases |
| Windows | ✅ PowerShell script | ⚠️ Manual install |
| WSL | ✅ Use Linux script | ✅ Binary releases |

## Claude Code Installation

This plugin also works with Claude Code. See [docs/CLAUDE_CODE.md](docs/CLAUDE_CODE.md) for detailed instructions.

Quick steps:
1. Install Entire CLI
2. Copy plugin to `~/.claude/plugins/`
3. Configure in `~/.claude/settings.json`
4. Restart Claude Code

## Architecture

```
Session Start
    │
    ├──► Entire Check Plugin ──► Verify memory stack health
    │       ├──► Entire enabled? ──► ✅ Continue / ⚠️ Prompt user
    │       ├──► Claude-Mem active? ──► ✅ Continue / ❌ Warn
    │       └──► RTK installed? ──► ✅ Continue / ❌ Note
```

## Requirements

- OpenCode with plugin support
- Node.js 18+ and npm
- Git (for repository detection)
- Optional: Entire CLI (will be prompted to install if missing)

## Troubleshooting

### Plugin Not Activating

1. Verify plugin path in `opencode.json`:
   ```bash
   cat ~/.config/opencode/opencode.json
   ```

2. Check that files exist:
   ```bash
   ls ~/.config/opencode/plugins/opencode-auto-entire/src/
   ```

3. Restart OpenCode completely

### "Cannot find module" Error

Make sure you ran `npm install` in the plugin directory:
```bash
cd ~/.config/opencode/plugins/opencode-auto-entire
npm install
```

### Entire Not Found

The plugin checks for `.entire/settings.json` in your project root. If you've enabled Entire but the plugin still says it's not enabled:

```bash
# Verify Entire is enabled
entire status

# Check if .entire directory exists
ls -la .entire/
```

### Disable Notifications

Create `~/.config/opencode/entire-check.json`:
```json
{
  "mode": "silent"
}
```

## Related Projects

- [Entire CLI](https://github.com/entireio/cli) - Session persistence and checkpoint recovery
- [Claude-Mem](https://github.com/thedotmack/claude-mem) - Cross-session memory for Claude Code
- [RTK](https://github.com/rtk-ai/rtk) - Token optimization for AI workflows
- [Superpowers](https://github.com/obra/superpowers) - Workflow patterns for AI agents

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Built for the OpenCode ecosystem
- Inspired by the need for better session management in AI-assisted development
- Thanks to the Entire CLI team for making session persistence possible

---

**Note:** This plugin was originally created as a personal tool and extracted into a standalone project for broader use.
