---
name: auto-entire
description: Check and verify memory stack health (Entire CLI, Claude-Mem, RTK) before starting coding tasks. Automatically monitor session persistence and context recovery systems. Run this at the start of development sessions, when working in git repositories, or before making significant code changes to ensure session safety and context preservation.
---

# Auto-Entire Memory Stack Checker

Automatically check and monitor your memory management stack to prevent session context loss.

## What This Checks

- **Entire CLI**: Session checkpoint and recovery (crash protection)
- **Claude-Mem**: Cross-session memory (context persistence)
- **RTK**: Token optimization (60-90% savings)

## When to Use

This skill activates automatically when:
- You start coding in a git repository
- You begin making significant code changes
- You mention session context, memory, or persistence
- You ask about checking or enabling Entire

## Instructions

### Step 1: Check Memory Stack Status

Always check the memory stack status first:

```bash
# Run the check script
node ~/.agents/skills/auto-entire/scripts/check-memory.js
```

Or if you have the skill installed in this repository:

```bash
node .agents/skills/auto-entire/scripts/check-memory.js
```

### Step 2: Interpret Results

**If all systems are operational:**
```
✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

All systems operational.
```
→ Continue working normally.

**If Entire is not initialized:**
```
⚠️ Entire CLI: Not initialized
✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

→ Run: entire enable --strategy auto-commit
```
→ Enable Entire to prevent context loss on crashes.

**If systems are missing:**
```
⚠️ Entire CLI: Not initialized
❌ Claude-Mem: Not installed
✅ RTK: Active

→ Enable Entire, then consider installing Claude-Mem for cross-session memory.
```

### Step 3: Fix Issues (If Needed)

**Enable Entire:**
```bash
entire enable --strategy auto-commit
```

**Install Claude-Mem:**
```bash
npm install -g claude-mem
```

**Install RTK:**
```bash
npm install -g rtk-ai/rtk
```

### Step 4: Continue Coding

After enabling systems, run the check again to verify:

```bash
node ~/.agents/skills/auto-entire/scripts/check-memory.js
```

## Configuration

Create `~/.config/opencode/entire-check.json` to customize behavior:

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

### Modes

- **prompt** (default): Show reminder with instructions
- **auto-init**: Automatically enable Entire without asking
- **silent**: Only log to console, no UI notification

### Options

- `enabled`: Enable/disable the checker
- `mode`: Behavior when Entire is not enabled
- `checkGitRepo`: Only check in git repositories
- `showStatus`: Show status even when Entire is enabled

## Why This Matters

**Without Entire CLI:**
- ❌ Session crashes = lost context and work
- ❌ No checkpoint recovery
- ❌ No audit trail of agent decisions

**With Auto-Entire:**
- ✅ Automatically detects missing Entire on session start
- ✅ Prompts with actionable fix instructions
- ✅ Monitors full memory stack (Entire + Claude-Mem + RTK)
- ✅ Configurable behavior (prompt / auto-init / silent)
- ✅ Works with OpenCode, Claude Code, Cursor, and Codex

## Best Practices

1. **Check at session start**: Always run the check script when starting a new coding session
2. **Enable in git repos**: Entire works best with git repositories (uses auto-commit strategy)
3. **Monitor RTK efficiency**: Check RTK efficiency regularly (aim for 80%+ savings)
4. **Use auto-commit**: Recommended strategy for Entire to automatically save checkpoints

## Troubleshooting

### Script Not Found

Make sure the skill is installed correctly:
```bash
# Check if skill directory exists
ls -la ~/.agents/skills/auto-entire/

# Or check repository-local skill
ls -la .agents/skills/auto-entire/
```

### Entire Not Detected

Verify Entire is enabled:
```bash
entire status

# Check if .entire directory exists
ls -la .entire/
```

### Disable Notifications

Create `~/.config/opencode/entire-check.json`:
```json
{
  "mode": "silent"
}
```

## Related Tools

- [Entire CLI](https://github.com/entireio/cli) - Session persistence and checkpoint recovery
- [Claude-Mem](https://github.com/thedotmack/claude-mem) - Cross-session memory
- [RTK](https://github.com/rtk-ai/rtk) - Token optimization

---

**Remember**: This skill auto-activates when you start coding tasks. You can also explicitly invoke it with `$auto-entire` or by mentioning memory stack checking in your prompt.
