# OpenCode Auto-Entire

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/opencode-auto-entire)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![OpenCode](https://img.shields.io/badge/OpenCode-plugin-orange.svg)](https://opencode.ai)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-MCP%20Server-blue.svg)](https://docs.anthropic.com)

> 🧠 Automatic Entire CLI monitoring for OpenCode & Claude Code - Never lose session context again

OpenCode Auto-Entire is a plugin and MCP server that automatically checks if [Entire CLI](https://github.com/entireio/cli) is enabled when you start an AI coding session. If not, it prompts you with clear instructions to fix it. It also monitors your complete memory management stack including Claude-Mem and RTK.

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
- ✅ Works with **OpenCode** and **Claude Code**

## Quick Start

### For OpenCode

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer
./scripts/install.sh
```

### For Claude Code

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the Claude Code installer
./scripts/install-claude.sh
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

2. **Copy plugin:**
    ```bash
    # For OpenCode
    mkdir -p ~/.config/opencode/plugins/
    cp -r . ~/.config/opencode/plugins/opencode-auto-entire
    cd ~/.config/opencode/plugins/opencode-auto-entire
    npm install

    # For Claude Code
    mkdir -p ~/.claude/plugins/
    cp -r . ~/.claude/plugins/opencode-auto-entire
    cd ~/.claude/plugins/opencode-auto-entire
    npm install
    ```

3. **Configure:**
    ```bash
    # For OpenCode - add to ~/.config/opencode/opencode.json
    {
      "plugin": [
        "file:///Users/YOUR_USERNAME/.config/opencode/plugins/opencode-auto-entire/src/plugin.ts"
      ]
    }

    # For Claude Code - add MCP server to ~/.claude/settings.json
    {
      "mcpServers": {
        "auto-entire": {
          "command": "node",
          "args": ["/Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/claude-code.ts"]
        }
      }
    }
    ```

4. **Restart your AI coding tool** (OpenCode or Claude Code)

## What It Does

On every session start in a git repository:

**OpenCode:**
1. ✅ Automatically checks for Entire CLI on session start
2. ✅ Displays memory stack status (Entire + Claude-Mem + RTK)
3. ✅ Prompts with instructions if Entire is not enabled
4. ✅ Supports auto-init mode for automatic setup

**Claude Code:**
1. ✅ Provides MCP tools for memory stack checks
2. ✅ Use "Check memory stack with auto-entire" to see status
3. ✅ Use "Enable Entire with auto-entire" to auto-initialize
4. ✅ Manual tools available anytime via Claude Code's MCP interface

## Configuration

Configuration works for both OpenCode and Claude Code:

Create `~/.config/opencode/entire-check.json` or `~/.claude/entire-check.json`:

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

### For OpenCode

After installation, simply start OpenCode in any git repository:

```bash
cd your-project
opencode
```

You'll see the memory stack check at session start.

When Entire is Not Enabled:
```bash
cd your-project
entire enable --strategy auto-commit
```

### For Claude Code

After installation, start Claude Code in any git repository:

```bash
cd your-project
claude
```

The MCP server provides two tools:
- **Check memory stack with auto-entire** - Shows status of Entire, Claude-Mem, and RTK
- **Enable Entire with auto-entire** - Auto-initializes Entire in current directory

When Entire is Not Enabled:
You can either:
1. Enable manually: `entire enable --strategy auto-commit`
2. Use the MCP tool: "Enable Entire with auto-entire"

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

| Platform | OpenCode Install | Claude Code Install | Entire CLI |
|----------|------------------|---------------------|------------|
| macOS | ✅ One-command install | ✅ One-command install | ✅ Homebrew |
| Linux | ✅ One-command install | ✅ One-command install | ✅ Binary releases |
| Windows | ✅ PowerShell script | ❌ Coming soon | ⚠️ Manual install |
| WSL | ✅ Use Linux script | ✅ Use Linux script | ✅ Binary releases |

## Architecture

**OpenCode Plugin:**
```
Session Start
    │
    ├──► Entire Check Plugin ──► Verify memory stack health
    │       ├──► Entire enabled? ──► ✅ Continue / ⚠️ Prompt user
    │       ├──► Claude-Mem active? ──► ✅ Continue / ❌ Warn
    │       └──► RTK installed? ──► ✅ Continue / ❌ Note
```

**Claude Code MCP Server:**
```
Claude Code
    │
    ├──► MCP Server (auto-entire) ──► Provides tools
    │       ├──► check_memory_stack ──► Check status
    │       └──► enable_entire ──► Auto-initialize
    │
    └──► Tool invocation ──► On-demand checks
```

## Requirements

- **OpenCode** with plugin support OR **Claude Code** with MCP support
- Node.js 18+ and npm
- Git (for repository detection)
- Optional: Entire CLI (will be prompted to install if missing)
- Optional: @modelcontextprotocol/sdk (for Claude Code)

## Troubleshooting

### Plugin Not Activating

**For OpenCode:**
1. Verify plugin path in `opencode.json`:
    ```bash
    cat ~/.config/opencode/opencode.json
    ```

2. Check that files exist:
    ```bash
    ls ~/.config/opencode/plugins/opencode-auto-entire/src/
    ```

3. Restart OpenCode completely

**For Claude Code:**
1. Verify MCP server configuration in `settings.json`:
    ```bash
    cat ~/.claude/settings.json
    ```

2. Check that files exist:
    ```bash
    ls ~/.claude/plugins/opencode-auto-entire/src/
    ```

3. Restart Claude Code completely

### "Cannot find module" Error

Make sure you ran `npm install` in the plugin directory:
```bash
# For OpenCode
cd ~/.config/opencode/plugins/opencode-auto-entire
npm install

# For Claude Code
cd ~/.claude/plugins/opencode-auto-entire
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
