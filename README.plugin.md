# Entire Check Plugin for OpenCode

Automatically checks if Entire CLI is enabled on session start and prompts you to initialize it for session persistence.

## Why This Matters

Without Entire CLI enabled:
- Session crashes = lost context and work
- No checkpoint recovery
- No audit trail of agent decisions

With Entire CLI enabled:
- Automatic checkpoint creation
- Session recovery with `entire resume`
- Full session history preserved

## Installation

### 1. Install Dependencies

```bash
cd ~/.config/opencode/plugins/entire-check
npm install
```

### 2. Add to OpenCode Configuration

Edit `~/.config/opencode/opencode.json`:

```json
{
  "plugin": [
    "oh-my-opencode",
    "opencode-rate-limit-fallback",
    "file:///Users/calebrosario/.config/opencode/plugins/entire-check/src/plugin.ts"
  ]
}
```

### 3. Restart OpenCode

The plugin will activate on the next session start.

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
| `mode` | `"prompt"` \| `"auto-init"` \| `"silent"` | `"prompt"` | How to handle missing Entire |
| `checkGitRepo` | boolean | `true` | Only check in git repositories |
| `showStatus` | boolean | `true` | Show memory stack status when Entire is enabled |

### Modes

**prompt** (default): Shows a reminder message at session start if Entire is not enabled

**auto-init**: Automatically runs `entire enable --strategy auto-commit` (use with caution)

**silent**: Only logs to console, no user notification

## What It Checks

On every session start in a git repository:

1. **Entire CLI**: Looks for `.entire/settings.json`
2. **Claude-Mem**: Checks if `~/.claude-mem/claude-mem.db` exists
3. **RTK**: Verifies RTK is installed and gets efficiency stats

## Example Output

### When Entire is Not Enabled

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

### When All Systems Are Go

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

## Requirements

- OpenCode with plugin support
- Git repository (when `checkGitRepo: true`)
- Optional: Entire CLI installed (`brew install entireio/tap/entire`)

## Troubleshooting

### Plugin Not Activating

1. Verify plugin path in `opencode.json`
2. Check that `dist/index.js` exists (run `npm run build`)
3. Restart OpenCode completely

### False Positives

If you're in a directory that shouldn't need Entire:

```json
{
  "checkGitRepo": true
}
```

This limits checks to actual git repositories.

### Disabling Notifications

```json
{
  "mode": "silent"
}
```

## See Also

- [Entire CLI](https://github.com/entireio/cli) - Session persistence
- [Claude-Mem](https://github.com/thedotmack/claude-mem) - Cross-session memory
- [RTK](https://github.com/rtk-ai/rtk) - Token optimization
- [MemoryManagement.md](~/.config/opencode/MemoryManagement.md) - Full stack documentation
