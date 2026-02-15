# User Guide

This guide covers configuration, usage, and troubleshooting for OpenCode Auto-Entire.

## Table of Contents

- [Configuration](configuration.md) - Detailed configuration options
- [Usage](usage.md) - How to use the plugin effectively
- [Modes](modes.md) - Understanding the different operation modes
- [Troubleshooting](troubleshooting.md) - Common issues and solutions

## Overview

OpenCode Auto-Entire monitors your memory management stack:

1. **Entire CLI** - Session checkpoint/recovery
2. **Claude-Mem** - Cross-session memory
3. **RTK** - Token optimization

## When It Runs

The plugin checks your memory stack:

### For OpenCode

- At the start of every OpenCode session
- Only in git repositories (configurable)
- Before any work begins

### For Claude Code

You have **two approaches** for using OpenCode Auto-Entire with Claude Code:

#### Approach 1: Wrapper Script (Automatic Checking)

The wrapper script (`claude-wrapper.sh`) provides automatic memory stack checking:

- ✅ Checks memory stack BEFORE launching Claude Code
- ✅ Displays status with same formatting as OpenCode
- ✅ Supports prompt/auto-init/silent modes
- ✅ Works exactly like OpenCode plugin

**Setup:** Add alias to ~/.bashrc: `alias claude='~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh'`

#### Approach 2: MCP Server (On-Demand Tools)

The MCP server provides tools you can invoke during Claude Code conversations:

- ✅ `check_memory_stack` - Check status anytime
- ✅ `enable_entire` - Auto-initialize Entire
- ✅ Available during any conversation
- ✅ No alias setup required

**Usage in Claude Code:**
```
User: Check memory stack with auto-entire
Claude: [tool runs, shows status]

User: Enable Entire with auto-entire
Claude: [auto-initializes]
```

#### Which Should You Use?

| Scenario | Recommended |
|----------|-------------|
| Automatic checking wanted | **Wrapper Script** |
| On-demand tools preferred | **MCP Server** |
| Can't use aliases | **MCP Server** |

**Recommendation:** Use the **wrapper script** for automatic checking. Keep the **MCP server** installed for on-demand tools. You can install both!

## Status Indicators

The plugin provides clear status indicators:

- ✅ **Enabled** - All systems operational
- ⚠️ **Not initialized** - Action required
- ❌ **Missing component** - Install recommended

## Quick Reference

### OpenCode

| Scenario | Action |
|----------|--------|
| Entire not enabled | Run `entire enable --strategy auto-commit` |
| Claude-Mem missing | Install Claude-Mem from GitHub |
| RTK not found | Install RTK for token optimization |
| Too many notifications | Set `mode` to `"silent"` |

### Claude Code Wrapper Script

| Scenario | Action |
|----------|--------|
| Wrapper not found | Check alias in ~/.bashrc or run directly: `~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh` |
| Not checking | Check config: `cat ~/.claude/entire-check.json` |
| Disable temporarily | `export AUTO_ENTIRE_DISABLED=1` |
| Disable git check | `export AUTO_ENTIRE_SKIP_GIT=1` |

### Claude Code MCP Tools

| Scenario | Action |
|----------|--------|
| Check status | Ask Claude: "Check memory stack with auto-entire" |
| Enable Entire | Ask Claude: "Enable Entire with auto-entire" |
| Tools not found | Check ~/.claude/settings.json configuration |

## Next Steps

- Configure plugin: [Configuration](configuration.md)
- Learn about modes: [Modes](modes.md)
- Solve issues: [Troubleshooting](troubleshooting.md)
- Choose Claude Code approach: [Wrapper Script](../CLAUDE_WRAPPER.md) or [MCP Server](../CLAUDE_CODE.md)
