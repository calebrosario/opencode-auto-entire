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

- At the start of every OpenCode session
- Only in git repositories (configurable)
- Before any work begins

## Status Indicators

The plugin provides clear status indicators:

- ✅ **Enabled** - All systems operational
- ⚠️ **Not initialized** - Action required
- ❌ **Missing component** - Install recommended

## Quick Reference

| Scenario | Action |
|----------|--------|
| Entire not enabled | Run `entire enable --strategy auto-commit` |
| Claude-Mem missing | Install Claude-Mem from GitHub |
| RTK not found | Install RTK for token optimization |
| Too many notifications | Set `mode` to `"silent"` |

## Next Steps

- Configure the plugin: [Configuration](configuration.md)
- Learn about modes: [Modes](modes.md)
- Solve issues: [Troubleshooting](troubleshooting.md)
