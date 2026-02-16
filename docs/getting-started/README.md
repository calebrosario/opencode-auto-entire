# Getting Started

Welcome to OpenCode Auto-Entire! This guide will help you get up and running quickly.

## Installation Methods

Choose the installation method that works best for your platform and preferred AI coding tool:

- [Quick Start](quickstart.md) - One-command installation (macOS/Linux)
- [Manual Installation](installation.md) - Step-by-step manual setup
- [Setup Guide](setup.md) - Post-installation configuration

## Platform-Specific Setup

Choose your AI coding tool:

| Platform | OpenCode | Claude Code | Cursor | Codex |
|----------|-----------|-------------|----------|--------|
| **macOS** | ✅ One-command install | ✅ One-command install | ✅ MCP UI setup | ✅ Skill + MCP |
| **Linux** | ✅ One-command install | ✅ One-command install | ✅ MCP UI setup | ✅ Skill + MCP |
| **Windows** | ✅ PowerShell script | ❌ Coming soon | ❌ Coming soon | ⚠️ WSL only |
| **Setup** | `opencode.json` | `claude-code.example.json` | Settings → MCP | `codex.example.toml` |

### For OpenCode

See "Quick Start" section above.

### For Claude Code

See "Quick Start" section above.

### For Cursor IDE

Cursor IDE has **native MCP support** - no configuration files needed!

### For Codex CLI

Codex CLI supports **three integration methods**:

**Option 1: Codex Skill (Recommended for Auto-Invoke)**
- Auto-invokes based on prompt matching
- Works in any git repository
- No configuration needed

```bash
# Install skill globally
mkdir -p ~/.agents/skills/
cp -r .agents/skills/auto-entire ~/.agents/skills/
```

**Option 2: MCP Server**
- Provides on-demand tools
- Configured in `~/.codex/config.toml`
- Manual or auto-invoke

```bash
# Install for Codex
mkdir -p ~/.codex/plugins/
cp -r . ~/.codex/plugins/opencode-auto-entire
cd ~/.codex/plugins/opencode-auto-entire
npm install
```

Then add to `~/.codex/config.toml`:
```toml
[mcp_servers.auto-entire]
command = "node"
args = ["/Users/YOUR_USERNAME/.codex/plugins/opencode-auto-entire/src/claude-code.ts"]
```

**Option 3: Wrapper Script (True Automatic)**
- Runs checks before launching Codex
- Requires alias setup
- Same as OpenCode behavior

```bash
# Add alias to ~/.bashrc or ~/.zshrc
alias codex='~/.codex/plugins/opencode-auto-entire/scripts/codex-wrapper.sh'

# Reload shell
source ~/.bashrc
```

See [Codex Setup Guide](../CODEX.md) for detailed instructions.

1. **Install OpenCode Auto-Entire**:
   ```bash
   git clone https://github.com/yourusername/opencode-auto-entire.git
   cd opencode-auto-entire
   ./scripts/install-claude.sh
   ```

2. **Configure MCP Server in Cursor**:

   **Option 1: Via Cursor UI (Recommended)**
   
   a. Open Cursor IDE
   b. Press `Cmd+Shift+P` to open Command Palette
   c. Type "MCP" to open MCP management
   d. Click "Add New Server"
   e. Enter configuration:
      ```json
      {
        "command": "node",
        "args": ["/Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/claude-code.ts"]
      }
      ```
   f. Click "Connect"

   **Option 2: Via Cursor CLI**
   
   Use Cursor's MCP CLI commands:
   ```bash
   # List available MCP servers
   agent mcp list
   
   # Check tools for a server
   agent mcp list-tools <identifier>
   
   # Login to server
   agent mcp login <identifier>
   ```

3. **Verify Installation**:
   
   In Cursor, press `Cmd+Shift+P`
   - Type "MCP"
   - Verify "auto-entire" server shows as "Connected"
   - Click server to view tools

4. **Done!**
   
   Cursor's agent will automatically use MCP tools when helpful in your conversations.

   See [Cursor Setup Guide](../CURSOR.md) for detailed usage and troubleshooting.

## What You'll Need

Before installing, make sure you have:

- **For All Platforms**:
  - Node.js 18+ and npm
  - Git (for repository detection)
  - Entire CLI (will be prompted to install during setup)

- **For Cursor**: Nothing extra needed - Cursor handles MCP automatically!
- **For Codex**: Install skill or MCP server - auto-invokes based on prompts

## Next Steps

After installation, learn more about using the plugin:

- [Configuration Guide](../user-guide/configuration.md) - Customize plugin behavior
- [Integration](../integration/README.md) - Architecture details
- [Platform-Specific Setup](../platforms.md) - Platform-specific information
- [Development](../development/README.md) - Contributing guidelines

## What You'll Need

Before installing, make sure you have:

- **OpenCode** with plugin support installed
- **Node.js 18+** and npm
- **Git** for repository detection
- **Entire CLI** (will be prompted to install during setup)

## Installation Overview

1. **Clone the repository** or download the plugin
2. **Install dependencies** using npm
3. **Configure OpenCode** to load the plugin
4. **Restart OpenCode** to activate the plugin

## Verification

After installation, you can verify everything is working:

1. Open any git repository in OpenCode
2. You'll see the memory management check at session start
3. If Entire is not enabled, you'll get clear instructions to enable it

## Next Steps

- Configure plugin to match your workflow: [Configuration](../user-guide/configuration.md)
- Learn about different operation modes: [Modes](../user-guide/modes.md)
- Set up Claude Code integration: [Claude Code Setup](../CLAUDE_CODE.md)

## Claude Code Installation Options

For Claude Code, you have **two ways** to use OpenCode Auto-Entire:

### Option 1: Wrapper Script (Recommended)

The wrapper script provides automatic memory stack checking that matches OpenCode plugin behavior:

- ✅ Automatically checks on every launch
- ✅ Simple alias setup
- ✅ Same experience as OpenCode

[Learn more](../CLAUDE_WRAPPER.md)

### Option 2: MCP Server

The MCP server provides on-demand tools that you can invoke during conversations:

- ✅ Check memory stack anytime
- ✅ Enable Entire automatically
- ✅ No alias setup required

[Learn more](../CLAUDE_CODE.md)

### Which Should You Choose?

| Need | Use |
|-------|------|
| Automatic checking like OpenCode | **Wrapper Script** |
| On-demand tools during conversations | **MCP Server** |
| Can't use shell aliases | **MCP Server** |

You can install **both** - use the wrapper for automatic checking and MCP tools when needed!
