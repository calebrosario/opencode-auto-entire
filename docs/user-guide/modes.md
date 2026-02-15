# Modes

Understanding the three operation modes of OpenCode Auto-Entire.

## Overview

The plugin operates in three distinct modes, each designed for different use cases:

- **prompt** - Interactive reminders (default)
- **auto-init** - Automatic initialization
- **silent** - Background monitoring only

## Mode Comparison

| Mode | User Interaction | Automation | Use Case |
|------|------------------|------------|----------|
| `prompt` | High | None | Default development workflow |
| `auto-init` | None | High | CI/CD, automated environments |
| `silent` | Low | None | Background monitoring, logging |

## 1. Prompt Mode (Default)

### Description

Shows an interactive reminder when Entire CLI is not enabled, requiring user action to proceed.

### Output Example

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

### When Entire is Enabled

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

### Configuration

```json
{
  "mode": "prompt"
}
```

### Use Cases

- Interactive development
- Learning the tool
- Teams requiring explicit confirmation
- Production environments where user awareness is important

### Pros

- Ensures user is aware of memory management
- No automatic repository modifications
- Clear, actionable instructions
- Educational value

### Cons

- Requires user interaction
- Can interrupt workflow
- Not suitable for automation

## 2. Auto-Init Mode

### Description

Automatically runs `entire enable --strategy auto-commit` without asking for confirmation.

### Output Example

```
Memory Stack Status

Entire CLI: Automatically enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

### Configuration

```json
{
  "mode": "auto-init"
}
```

### Use Cases

- CI/CD pipelines
- Automated development environments
- Scripted workflows
- Projects where Entire is always required

### Pros

- Zero user interaction required
- Ensures Entire is always enabled
- Ideal for automation
- Consistent behavior

### Cons

- Modifies repositories without explicit confirmation
- May not be suitable for all projects
- Risk of unintended repository changes
- Less user control

### ⚠️ Important Warnings

- Use with caution in production environments
- Ensure team consensus before enabling
- Test in non-critical projects first
- Consider using `checkGitRepo: true` to limit scope

## 3. Silent Mode

### Description

Only logs to console, no UI notification or user interaction.

### Output Example

```bash
[opencode-auto-entire] Memory stack check: Entire not enabled
```

### Configuration

```json
{
  "mode": "silent"
}
```

### Use Cases

- Background monitoring
- Logging-only requirements
- Development when notifications are distracting
- Debugging plugin behavior

### Pros

- No interruptions to workflow
- Minimal output
- Useful for debugging
- Background compliance checking

### Cons

- No user awareness
- Easy to miss issues
- No actionable prompts
- Reduced visibility

## Choosing the Right Mode

### Decision Flowchart

```
Do you need user interaction?
├─ Yes → Prompt Mode (default)
│   └─ Use case: Interactive development
└─ No → Do you need automatic actions?
    ├─ Yes → Auto-Init Mode
    │   └─ Use case: CI/CD, automation
    └─ No → Silent Mode
        └─ Use case: Background monitoring
```

### Recommendations by Environment

| Environment | Recommended Mode |
|-------------|------------------|
| Personal Development | `prompt` |
| Team Development | `prompt` |
| CI/CD Pipeline | `auto-init` |
| Automated Testing | `auto-init` |
| Production Monitoring | `silent` |
| Background Services | `silent` |

### Example Configurations

### Development Workstation

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

### CI/CD Pipeline

```json
{
  "enabled": true,
  "mode": "auto-init",
  "checkGitRepo": true,
  "showStatus": false
}
```

### Production Server

```json
{
  "enabled": true,
  "mode": "silent",
  "checkGitRepo": true,
  "showStatus": false
}
```

## Switching Modes

To change modes:

1. Update `~/.config/opencode/entire-check.json`
2. Set the new `mode` value
3. Restart OpenCode completely

The new mode takes effect on the next session start.

## Mode-Specific Behavior

### Prompt Mode Behavior

- Shows full status with explanations
- Requires user to enable Entire manually
- Provides clear, actionable instructions
- Displays when all systems are operational

### Auto-Init Mode Behavior

- Runs `entire enable` automatically
- Shows brief status after initialization
- No user interaction required
- May create `.entire` directory

### Silent Mode Behavior

- Logs to console only
- No visual notifications
- No status output
- Minimal disruption

## Troubleshooting

### Auto-Init Not Working

1. Verify mode is set to `"auto-init"`
2. Check that Entire CLI is installed
3. Ensure git repository is initialized
4. Check console logs for errors

### Silent Mode Still Showing Output

1. Verify `mode` is set to `"silent"`
2. Check for conflicting environment variables
3. Restart OpenCode completely

### Prompt Mode Not Appearing

1. Verify `mode` is set to `"prompt"`
2. Check that `showStatus` is `true`
3. Ensure you're in a git repository (if `checkGitRepo` is `true`)

## Next Steps

- Learn configuration options: [Configuration](configuration.md)
- Understand usage patterns: [Usage](usage.md)
- Troubleshoot issues: [Troubleshooting](troubleshooting.md)
