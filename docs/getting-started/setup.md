# Setup Guide

This guide helps you configure OpenCode Auto-Entire after installation.

## Initial Configuration

Create the configuration file at `~/.config/opencode/entire-check.json`:

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enabled` | boolean | `true` | Enable/disable the plugin |
| `mode` | `"prompt"` \| `"auto-init"` \| `"silent"` | `"prompt"` | Behavior when Entire not enabled |
| `checkGitRepo` | boolean | `true` | Only check in git repositories |
| `showStatus` | boolean | `true` | Show status even when Entire is enabled |

## Operation Modes

### prompt (default)

Shows a friendly reminder if Entire is not enabled:

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

### auto-init

Automatically runs `entire enable --strategy auto-commit` without asking.

⚠️ **Use with caution** - modifies repositories without explicit confirmation!

### silent

Only logs to console, no UI notification.

## Testing the Setup

After configuration, test the plugin:

1. Open a git repository in OpenCode
2. If Entire is not enabled, you'll see the prompt
3. If Entire is enabled, you'll see the status check
4. Adjust configuration as needed

## Example Configuration Files

### Development Mode

```json
{
  "enabled": true,
  "mode": "auto-init",
  "checkGitRepo": true,
  "showStatus": false
}
```

### Production Mode

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

### Minimal Mode

```json
{
  "enabled": true,
  "mode": "silent",
  "checkGitRepo": false,
  "showStatus": false
}
```

## Next Steps

- [Learn about Configuration](../user-guide/configuration.md)
- [Understand the Different Modes](../user-guide/modes.md)
- [Troubleshoot Issues](../user-guide/troubleshooting.md)
