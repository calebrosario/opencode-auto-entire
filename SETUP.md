# Entire Check Plugin - Setup Complete

## Status

✅ **Plugin Created** and configured successfully!

## What Was Created

```
~/.config/opencode/plugins/entire-check/
├── src/
│   └── plugin.ts          # Main plugin logic
├── package.json           # Dependencies
├── tsconfig.json          # TypeScript config
├── README.md              # Documentation
└── entire-check.example.json  # Example config
```

## Configuration Added

Updated `~/.config/opencode/opencode.json`:

```json
{
  "plugin": [
    "oh-my-opencode",
    "opencode-rate-limit-fallback",
    "file:///Users/calebrosario/.config/opencode/plugins/entire-check/src/plugin.ts"
  ]
}
```

## What It Does

On every session start in a git repository:

1. ✅ Checks if **Entire CLI** is enabled (looks for `.entire/settings.json`)
2. ✅ Checks if **Claude-Mem** is installed
3. ✅ Checks **RTK** status and efficiency
4. ✅ Prompts you to initialize Entire if not enabled

## Modes

The plugin supports three modes (configurable in `~/.config/opencode/entire-check.json`):

### 1. **prompt** (default)
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
```

### 2. **auto-init**
Automatically runs `entire enable --strategy auto-commit` if not enabled.

⚠️ **Use with caution** - this modifies your repositories without asking!

### 3. **silent**
Only logs to console, no user notification.

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

| Option | Description |
|--------|-------------|
| `enabled` | Enable/disable the plugin |
| `mode` | `"prompt"`, `"auto-init"`, or `"silent"` |
| `checkGitRepo` | Only check in git repositories |
| `showStatus` | Show status even when Entire is enabled |

## Next Steps

1. **Restart OpenCode** to activate the plugin
2. **Start a new session** in a git repository
3. **See the notification** if Entire is not enabled
4. **Install Entire** (if you haven't):
   ```bash
   brew tap entireio/tap
   brew install entireio/tap/entire
   ```
5. **Enable Entire** in your project:
   ```bash
   cd your-project
   entire enable --strategy auto-commit
   ```

## Testing

After restarting OpenCode, start a session in any git repository without Entire enabled. You should see:

```
Memory Management Check

Entire CLI: Not initialized
Run: `entire enable --strategy auto-commit`
...
```

Once you enable Entire, future sessions will show:

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

## Troubleshooting

### Plugin Not Activating

1. Verify the path in `opencode.json` is correct
2. Check that the file exists: `ls ~/.config/opencode/plugins/entire-check/src/plugin.ts`
3. Restart OpenCode completely

### Disable Notifications

Create `~/.config/opencode/entire-check.json`:
```json
{
  "mode": "silent"
}
```

## Files Modified

- `~/.config/opencode/opencode.json` - Added plugin reference
- `~/.config/opencode/plugins/entire-check/*` - New plugin files

## Resources

- Full documentation: `~/.config/opencode/plugins/entire-check/README.md`
- Memory management guide: `~/.config/opencode/MemoryManagement.md`
- Entire CLI: https://github.com/entireio/cli
