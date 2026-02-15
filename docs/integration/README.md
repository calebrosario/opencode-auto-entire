# Integration

This section covers integrating OpenCode Auto-Entire with different platforms and understanding its architecture.

## Table of Contents

- [Claude Code](claude-code.md) - Integration with Claude Code IDE
- [Architecture](architecture.md) - Plugin architecture and internals
- [Platform Support](platforms.md) - Supported platforms and installation methods

## Integration Overview

OpenCode Auto-Entire integrates with:

- **OpenCode** - Primary target platform
- **Claude Code** - Alternative IDE support
- **Entire CLI** - Session persistence layer
- **Claude-Mem** - Cross-session memory
- **RTK** - Token optimization layer

## Memory Management Stack

```
┌─────────────────────────────────────┐
│     OpenCode Auto-Entire Plugin      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      Memory Management Check        │
└──────┬──────────┬──────────┬────────┘
       │          │          │
       ▼          ▼          ▼
┌──────────┐ ┌──────────┐ ┌─────────┐
│  Entire  │ │Claude-Mem│ │   RTK   │
│   CLI    │ │          │ │         │
└──────────┘ └──────────┘ └─────────┘
```

## Integration Points

### Session Start
- Plugin activates on session initialization
- Checks memory stack status
- Provides user feedback

### Repository Detection
- Detects git repositories
- Runs checks only when appropriate
- Respects `checkGitRepo` configuration

### Configuration Loading
- Loads from `~/.config/opencode/entire-check.json`
- Supports environment variable overrides
- Validates configuration on startup

## Next Steps

- Set up Claude Code: [Claude Code Integration](claude-code.md)
- Understand architecture: [Architecture](architecture.md)
- Check platform support: [Platform Support](platforms.md)
