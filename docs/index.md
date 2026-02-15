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

## What It Does

On every session start in a git repository:

**OpenCode:**
- ✅ Automatically checks for Entire CLI on session start
- ✅ Displays memory stack status (Entire + Claude-Mem + RTK)
- ✅ Prompts with instructions if Entire is not enabled
- ✅ Supports auto-init mode for automatic setup

**Claude Code:**
- ✅ Provides MCP tools for memory stack checks
- ✅ Use "Check memory stack with auto-entire" to see status
- ✅ Use "Enable Entire with auto-entire" to auto-initialize
- ✅ Manual tools available anytime via Claude Code's MCP interface

## Quick Start

### For OpenCode

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer
./scripts/install.sh

# Restart OpenCode
```

### For Claude Code

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the Claude Code installer
./scripts/install-claude.sh

# Restart Claude Code
```

See [Quick Start Guide](getting-started/quickstart.md) for detailed installation instructions.

## Documentation

- **[Getting Started](getting-started/README.md)** - Installation, setup, and initial configuration
- **[Claude Code Setup](CLAUDE_CODE.md)** - Claude Code MCP server configuration and usage
- **[Claude Code Wrapper](CLAUDE_WRAPPER.md)** - Wrapper script for automatic memory stack checking
- **[User Guide](user-guide/README.md)** - Configuration options, usage patterns, troubleshooting
- **[Integration](integration/README.md)** - Architecture, and platform support
- **[Development](development/README.md)** - Contributing guidelines and changelog

## Status When Enabled

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

## Memory Management Stack

This plugin monitors three critical components of AI-assisted development:

| Component | Purpose | Benefit |
|-----------|---------|---------|
| **Entire CLI** | Session checkpoint/recovery | Crash protection, audit trail |
| **Claude-Mem** | Cross-session memory | Context persistence across sessions |
| **RTK** | Token optimization | 60-90% token savings |

## Requirements

- **OpenCode** with plugin support OR **Claude Code** with MCP support
- Node.js 18+ and npm
- Git (for repository detection)
- Optional: Entire CLI (will be prompted to install if missing)
- Optional: @modelcontextprotocol/sdk (for Claude Code)

## Related Projects

- [Entire CLI](https://github.com/entireio/cli) - Session persistence and checkpoint recovery
- [Claude-Mem](https://github.com/thedotmack/claude-mem) - Cross-session memory for Claude Code
- [RTK](https://github.com/rtk-ai/rtk) - Token optimization for AI workflows
- [Superpowers](https://github.com/obra/superpowers) - Workflow patterns for AI agents

## License

MIT License - see [LICENSE](development/license.md) for details.
