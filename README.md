# OpenCode Auto-Entire

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/opencode-auto-entire)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![OpenCode](https://img.shields.io/badge/OpenCode-plugin-orange.svg)](https://opencode.ai)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-MCP%20Server-blue.svg)](https://docs.anthropic.com)
[![Codex CLI](https://img.shields.io/badge/Codex%20CLI-Skill%20%26%20MCP-green.svg)](https://developers.openai.com/codex)

> 🧠 Automatic Entire CLI monitoring for OpenCode, Claude Code & Codex - Never lose session context again

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
- ✅ Works with **OpenCode**, **Claude Code**, and **Codex**

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

# Restart Claude Code
# Then open any git project and you can use MCP tools
```

### For Cursor IDE

**✨ Cursor has native MCP support - no configuration needed!**

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer (includes MCP setup)
./scripts/install-claude.sh
```

**Configure in Cursor (2 options):**

**Option 1: Via Cursor UI (Recommended)**
1. Open Cursor
2. Press `Cmd+Shift+P`
3. Type "MCP" to open MCP management
4. Click "Add New Server"
5. Enter:
   ```json
   {
     "command": "node",
     "args": ["/Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/claude-code.ts"]
   }
   ```
6. Click "Connect"

**Option 2: Via Cursor CLI**
```bash
# List MCP servers
agent mcp list

# Check tools
agent mcp list-tools auto-entire

# Login (if needed)
agent mcp login auto-entire
```

**That's it!** Cursor's agent will automatically use MCP tools when helpful.

See [Cursor Setup Guide](docs/CURSOR.md) for detailed usage and troubleshooting.

**⭐ Automatic Checking (Recommended):**

For the same automatic behavior as OpenCode, use the wrapper script:

```bash
# Add alias to ~/.bashrc or ~/.zshrc
alias claude='~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh'

# Reload shell
source ~/.bashrc

# Use claude normally - it will automatically check your memory stack!
claude
```

See [docs/CLAUDE_WRAPPER.md](docs/CLAUDE_WRAPPER.md) for full documentation.

### For Codex CLI

Codex CLI supports **three integration methods**:

**Option 1: Codex Skill (Recommended for Auto-Invoke)**
```bash
# Install skill globally
mkdir -p ~/.agents/skills/
cp -r .agents/skills/auto-entire ~/.agents/skills/
```

Codex auto-invokes the skill based on your prompts! Just start coding normally.

**Option 2: MCP Server**
```bash
# Install for Codex
mkdir -p ~/.codex/plugins/
cp -r . ~/.codex/plugins/opencode-auto-entire
cd ~/.codex/plugins/opencode-auto-entire
npm install
```

Add to `~/.codex/config.toml`:
```toml
[mcp_servers.auto-entire]
command = "node"
args = ["/Users/YOUR_USERNAME/.codex/plugins/opencode-auto-entire/src/claude-code.ts"]
```

**Option 3: Wrapper Script (True Automatic)**
```bash
# Add alias to ~/.bashrc or ~/.zshrc
alias codex='~/.codex/plugins/opencode-auto-entire/scripts/codex-wrapper.sh'

# Reload shell
source ~/.bashrc

# Use codex normally - automatic checking!
codex
```

See [Codex Setup Guide](docs/CODEX.md) for detailed instructions.

## Platform Support Options

| Platform | OpenCode | Claude Code | Cursor | Codex |
|----------|-----------|-------------|----------|--------|
| **macOS** | ✅ One-command install | ✅ One-command install | ✅ MCP UI setup | ✅ Skill + MCP |
| **Linux** | ✅ One-command install | ✅ One-command install | ✅ MCP UI setup | ✅ Skill + MCP |
| **Windows** | ✅ PowerShell script | ❌ Coming soon | ❌ Coming soon | ⚠️ WSL only |
| **Setup** | `opencode.json` | `claude-code.example.json` | Settings → MCP | `codex.example.toml` |

## Integration Comparison

| Platform | Auto-Invoke Method | Lifecycle Events | Best For |
|----------|-------------------|-----------------|-----------|
| **OpenCode** | Plugin event hook | ✅ session.created | Automatic checking |
| **Codex Skill** | Description matching | ❌ None | Prompt-based auto-invoke |
| **Claude Code** | Manual tool invocation | ❌ None | On-demand tools |
| **Cursor MCP** | Auto-invoke when helpful | ❌ None | Smart auto-invoke |

## Claude Code & Codex: Wrapper Script vs MCP Server

You have **two options** for using OpenCode Auto-Entire with Claude Code:

### Option 1: Wrapper Script (Recommended for Automatic Checking)

**What it does:**
- ✅ Automatically checks memory stack BEFORE launching Claude Code
- ✅ Displays status with the same formatting as OpenCode
- ✅ Prompts you with instructions if Entire is missing
- ✅ Supports auto-init mode to automatically enable Entire
- ✅ Works exactly like OpenCode plugin (automatic on every launch)

**Setup:**
```bash
# Add alias to ~/.bashrc or ~/.zshrc
alias claude='~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh'

# Reload shell
source ~/.bashrc

# Now use claude normally - automatic checking!
claude
```

**Pros:**
- ✅ Same automatic behavior as OpenCode
- ✅ Simple one-time setup
- ✅ No need to remember to run tools
- ✅ Works for both new and existing Claude Code sessions

**Cons:**
- ⚠️ Requires alias setup
- ⚠️ Needs to add wrapper to PATH if using custom installation location

### Option 2: MCP Server (For On-Demand Checks)

**What it does:**
- ✅ Provides `check_memory_stack` tool to check status anytime
- ✅ Provides `enable_entire` tool to auto-initialize Entire
- ✅ Tools available during Claude Code conversations
- ✅ No automatic checking (MCP servers are passive)

**Setup:**
```bash
# Follow installation instructions above
# Already configured in ~/.claude/settings.json
```

**Usage in Claude Code:**
```
User: Check memory stack with auto-entire
Claude: [runs tool, shows status]

User: Enable Entire with auto-entire
Claude: [auto-initializes Entire]
```

**Pros:**
- ✅ Tools available during any conversation
- ✅ No alias setup required
- ✅ Standard MCP integration

**Cons:**
- ⚠️ No automatic checking (must manually invoke tools)
- ⚠️ Must remember to run tools each time

### Which Should You Choose?

| Scenario | Recommended Option |
|----------|------------------|
| **Automatic checking wanted** | **Wrapper Script** |
| **On-demand tools preferred** | **MCP Server** |
| **Can't use aliases** | **MCP Server** |
| **Standard workflow** | **MCP Server** |
| **Same experience as OpenCode** | **Wrapper Script** |

**Recommendation:** Use the **wrapper script** for automatic checking. Keep the **MCP server** installed for on-demand tools during conversations.

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

**Cursor IDE:**
1. ✅ Native MCP support - no configuration needed!
2. ✅ Cursor's agent automatically uses MCP tools when helpful in conversations
3. ✅ Provides same memory stack checking as OpenCode and Claude Code
4. ✅ Zero setup complexity - just install and connect

**Codex CLI:**
1. ✅ Skill auto-invokes based on prompt matching
2. ✅ MCP server provides on-demand tools
3. ✅ Wrapper script provides true automatic checking
4. ✅ Three flexible integration options

## Configuration

Configuration works for OpenCode, Claude Code, Cursor IDE, and Codex CLI:

Create `~/.config/opencode/entire-check.json`, `~/.claude/entire-check.json`, or `~/.codex/entire-check.json`:

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

### For Codex CLI

After installation, you have **three options**:

**Option 1: Skill (Auto-Invoke)**
Just start coding normally. Codex auto-invokes the skill when your prompt matches:
```
User: I need to work on the auth module
Codex: [Auto-invokes auto-entire skill]
🧠 Memory Stack Status

✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

All systems operational.

Codex: Great! Let's work on the auth module...
```

**Option 2: MCP Server**
Codex's agent automatically uses MCP tools when helpful:
```
User: Check my memory stack
Codex: [Uses MCP tool]
🧠 Memory Stack Status

✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (89.3% efficiency)

All systems operational.
```

**Option 3: Wrapper Script (Automatic)**
If you set up the alias, memory stack checks run automatically:
```bash
codex  # Wrapper checks memory stack before launching
```

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

| Platform | OpenCode Install | Claude Code Install | Claude Code MCP UI | Claude Code Wrapper | Cursor | Codex | Entire CLI |
|----------|------------------|---------------------|-----------------|------------------|--------|--------|------------------|
| macOS | ✅ One-command install | ✅ One-command install | ✅ Built-in MCP | ✅ Script + alias | ✅ MCP UI | ✅ Skill + MCP | ✅ Homebrew |
| Linux | ✅ One-command install | ✅ One-command install | ✅ Built-in MCP | ✅ Script + alias | ✅ MCP UI | ✅ Skill + MCP | ✅ Binary releases |
| Windows | ✅ PowerShell script | ❌ Coming soon | ❌ Coming soon | ⚠️ Manual install | ❌ Coming soon | ⚠️ WSL only | ⚠️ WSL only |
| WSL | ✅ Use Linux script | ✅ Use Linux script | ✅ Script + alias | ✅ Binary releases | ✅ MCP UI | ✅ Skill + MCP | ✅ Binary releases |

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
    └──► MCP Server (auto-entire) ──► Provides tools
        ├──► check_memory_stack
        └──► enable_entire
```

**Cursor IDE MCP Client:**
```
Cursor IDE
    │
    └──► MCP Client ──► Auto-discovers MCP servers
            └──► Auto-invokes tools when helpful
                ├──► check_memory_stack
                └──► enable_entire
```

**Codex CLI Skill:**
```
Codex CLI
    │
    └──► Skill System ──► Auto-invokes based on prompt matching
            └──► auto-entire skill
                ├──► Check memory on prompt match
                └──► Auto-initialize Entire (optional)
```

**Codex CLI MCP Server:**
```
Codex CLI
    │
    └──► MCP Server (auto-entire) ──► Provides tools
            ├──► check_memory_stack ──► Check status
            └──► enable_entire ──► Auto-initialize
```

**Codex CLI Wrapper (Automatic):**
```
codex command
    │
    └──► Wrapper script ──► Run check BEFORE launching Codex
            └──► Display memory stack status
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

- **OpenCode** with plugin support OR **Claude Code** with MCP support OR **Cursor IDE** with native MCP support
- Node.js 18+ and npm
- Git (for repository detection)
- Optional: Entire CLI (will be prompted to install if missing)

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
