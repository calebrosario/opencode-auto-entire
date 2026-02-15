# Getting Started

Welcome to OpenCode Auto-Entire! This guide will help you get up and running quickly.

## Installation Methods

Choose the installation method that works best for your platform:

- [Quick Start](quickstart.md) - One-command installation (macOS/Linux)
- [Manual Installation](installation.md) - Step-by-step manual setup
- [Setup Guide](setup.md) - Post-installation configuration

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
