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

## What It Does

On every session start in a git repository:

1. ✅ Checks if **Entire CLI** is enabled (looks for `.entire/settings.json`)
2. ✅ Checks if **Claude-Mem** is installed and active
3. ✅ Checks if **RTK** is installed and gets efficiency stats
4. ✅ Prompts you with clear instructions if anything is missing

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer
./scripts/install.sh

# Restart OpenCode
```

See [Quick Start Guide](getting-started/quickstart.md) for detailed installation instructions.

## Documentation

- **[Getting Started](getting-started/README.md)** - Installation, setup, and initial configuration
- **[User Guide](user-guide/README.md)** - Configuration options, usage patterns, troubleshooting
- **[Integration](integration/README.md)** - Claude Code setup, architecture, and platform support
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

- OpenCode with plugin support
- Node.js 18+ and npm
- Git (for repository detection)
- Optional: Entire CLI (will be prompted to install if missing)

## Related Projects

- [Entire CLI](https://github.com/entireio/cli) - Session persistence and checkpoint recovery
- [Claude-Mem](https://github.com/thedotmack/claude-mem) - Cross-session memory for Claude Code
- [RTK](https://github.com/rtk-ai/rtk) - Token optimization for AI workflows
- [Superpowers](https://github.com/obra/superpowers) - Workflow patterns for AI agents

## License

MIT License - see [LICENSE](development/license.md) for details.
