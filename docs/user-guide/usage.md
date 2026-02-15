# Usage

How to use OpenCode Auto-Entire effectively in your daily workflow.

## Starting a Session

After installation, simply start OpenCode in any git repository:

```bash
cd your-project
opencode
```

The plugin will automatically check your memory stack at session start.

## Understanding the Output

### When Everything is Operational

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

This means all memory management tools are working correctly.

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

Follow the instructions to enable Entire.

### When Components are Missing

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Not installed
RTK: Not found

Recommendations:
• Install Claude-Mem for cross-session memory
• Install RTK for token optimization
```

Install the missing components as recommended.

## Enabling Entire in a Project

To enable Entire CLI in your project:

```bash
cd your-project
entire enable --strategy auto-commit
```

This creates a `.entire` directory with configuration for session persistence.

## Checking Status Manually

You can manually check the status of each component:

```bash
# Entire CLI status
entire status

# Claude-Mem status (depends on setup)
claude-mem status

# RTK efficiency
rtk gain
```

## Workflow Examples

### New Project Setup

```bash
# 1. Create new project
mkdir my-project
cd my-project
git init

# 2. Enable Entire
entire enable --strategy auto-commit

# 3. Start OpenCode
opencode

# You'll see: "All systems operational"
```

### Existing Project

```bash
# 1. Navigate to existing project
cd existing-project

# 2. Start OpenCode
opencode

# 3. If prompted, enable Entire
entire enable --strategy auto-commit

# 4. Restart OpenCode
opencode
```

### CI/CD Environment

For automated environments, use `auto-init` mode:

```json
{
  "enabled": true,
  "mode": "auto-init",
  "checkGitRepo": true,
  "showStatus": false
}
```

## Best Practices

1. **Always enable Entire** in production projects
2. **Use prompt mode** for interactive development
3. **Check status regularly** to catch issues early
4. **Keep dependencies updated** for best compatibility
5. **Monitor RTK efficiency** to ensure optimal token usage

## Common Workflows

### Feature Branch Development

```bash
# Create feature branch
git checkout -b feature/new-functionality

# Entire tracks this branch automatically
opencode

# Work on your feature...
# Entire saves checkpoints as you commit
```

### Bug Fix Session

```bash
# Checkout bug branch
git checkout bugfix/issue-123

# Start OpenCode
opencode

# Entire helps you recover if session crashes
# Claude-Mem remembers context across restarts
```

### Pair Programming

```bash
# Both developers enable Entire
entire enable --strategy auto-commit

# Entire tracks changes from both developers
# Claude-Mem provides shared context
```

## Monitoring Token Usage

RTK provides token efficiency statistics:

```bash
# View current efficiency
rtk gain

# View detailed statistics
rtk cc-economics
```

Good efficiency is typically 60%+ savings.

## Session Recovery

If OpenCode crashes or loses context:

1. **With Entire enabled:** Recover from last checkpoint
   ```bash
   entire recover
   ```

2. **With Claude-Mem:** Retrieve cross-session memory
   ```bash
   claude-mem get
   ```

3. **Restart OpenCode:** The plugin will verify all systems

## Next Steps

- Configure plugin behavior: [Configuration](configuration.md)
- Understand operation modes: [Modes](modes.md)
- Solve issues: [Troubleshooting](troubleshooting.md)
