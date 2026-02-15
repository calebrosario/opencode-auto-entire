# Claude Code Wrapper Usage

The `claude-wrapper.sh` script provides automatic memory stack checking before launching Claude Code, matching the OpenCode plugin's behavior.

## What It Does

Before launching Claude Code, the wrapper:

1. ✅ Checks if the current directory is a git repository (optional, configurable)
2. ✅ Checks if **Entire CLI** is enabled
3. ✅ Checks if **Claude-Mem** is installed
4. ✅ Checks if **RTK** is installed and gets efficiency stats
5. ✅ Displays memory stack status to the user
6. ✅ Supports auto-init mode to automatically enable Entire
7. ✅ Then launches Claude Code

## Installation

### Option 1: Create an Alias (Recommended)

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
# Claude Code wrapper with automatic memory stack checking
alias claude='~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh'
```

Then reload your shell:

```bash
source ~/.bashrc  # or ~/.zshrc
```

Now use `claude` normally - it will automatically check your memory stack!

### Option 2: Run Directly

```bash
~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh
```

### Option 3: Copy to PATH

```bash
# Copy wrapper to a directory in your PATH
cp ~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh /usr/local/bin/claude-wrapper

# Make it executable
chmod +x /usr/local/bin/claude-wrapper

# Add alias
echo "alias claude='claude-wrapper'" >> ~/.bashrc
```

## Configuration

The wrapper uses the same configuration file as the MCP server:

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

Create at: `~/.claude/entire-check.json`

### Options

| Option | Values | Description |
|---------|----------|-------------|
| `enabled` | `true`, `false` | Enable/disable memory stack checks |
| `mode` | `"prompt"`, `"auto-init"`, `"silent"` | How to handle missing Entire |
| `checkGitRepo` | `true`, `false` | Only check in git repositories |
| `showStatus` | `true`, `false` | Show status even when Entire is enabled |

### Modes

**prompt** (default):
- Shows memory stack status
- Waits for user to press Enter before continuing
- Only shows warning if Entire is not enabled

**auto-init**:
- Shows memory stack status
- Automatically runs `entire enable --strategy auto-commit`
- Shows success/failure message
- Continues to Claude Code automatically

**silent**:
- Only logs to console if Entire is not enabled
- No prompt to press Enter
- Launches Claude Code immediately

## Examples

### Normal Usage (Prompt Mode)

```bash
$ cd my-project
$ claude

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Memory Management Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  **Entire CLI**: Not initialized
   → Run: entire enable --strategy auto-commit

✅  **Claude-Mem**: Active

✅  **RTK**: Active (91.7% efficiency)

**Why this matters:**
• Entire = Session checkpoint/recovery (crash protection)
• Claude-Mem = Cross-session memory (context persistence)
• RTK = Token optimization (60-90% savings)

**Recommendation:** Enable Entire to prevent context loss on crashes.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Press Enter to continue...
```

### Auto-Init Mode

```bash
$ cd my-project
$ claude

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Memory Management Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  **Entire CLI**: Not initialized
   → Run: entire enable --strategy auto-commit

✅  **Claude-Mem**: Active

✅  **RTK**: Active (91.7% efficiency)

**Why this matters:**
• Entire = Session checkpoint/recovery (crash protection)
• Claude-Mem = Cross-session memory (context persistence)
• RTK = Token optimization (60-90% savings)

**Recommendation:** Enable Entire to prevent context loss on crashes.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Auto-initializing Entire CLI...
✓ Entire CLI initialized successfully

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧠 Memory Stack Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅   Entire CLI: Enabled
✅   Claude-Mem: Active
✅   RTK: Active (91.7% efficiency)

All systems operational. 🚀

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Starting Claude Code...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Silent Mode

```bash
$ cd my-project
$ claude

[entire-check] Entire not enabled in /path/to/project

(Immediately launches Claude Code)
```

### When Entire is Already Enabled

```bash
$ cd my-project  # Has .entire/settings.json
$ claude

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧠 Memory Stack Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅   Entire CLI: Enabled
✅   Claude-Mem: Active
✅   RTK: Active (91.7% efficiency)

All systems operational. 🚀

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Starting Claude Code...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

(Immediately launches Claude Code)
```

## Comparison: Wrapper vs MCP Server

| Feature | Wrapper Script | MCP Server |
|----------|----------------|-------------|
| Automatic checks | ✅ Yes (on launch) | ❌ No (manual) |
| Prompt user | ✅ Yes (before Claude) | ❌ No (in Claude) |
| Auto-init | ✅ Yes | ✅ Yes |
| Configurable | ✅ Yes | ✅ Yes |
| Can disable | ✅ Yes | ✅ Yes |
| Requires setup | ✅ Yes (alias) | ✅ Yes (config) |
| Tool access | ❌ No | ✅ Yes |
| Works in Claude | ✅ Yes | ✅ Yes |

**Recommendation**: Use the wrapper script for automatic checking. Keep the MCP server installed for on-demand memory stack checks.

## Passing Arguments

The wrapper forwards all arguments to Claude Code:

```bash
# Start in current directory
claude

# Start with file argument
claude src/main.ts

# Start with Claude Code flags
claude --help
```

## Troubleshooting

### Wrapper Not Found

If you get "command not found: claude":

1. Check if the alias was added correctly:
   ```bash
   grep "alias claude" ~/.bashrc
   ```

2. Reload your shell:
   ```bash
   source ~/.bashrc
   ```

3. Run the wrapper directly:
   ```bash
   ~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh
   ```

### jq Not Found

If you get "jq: command not found":

**macOS:**
```bash
brew install jq
```

**Linux:**
```bash
sudo apt-get install jq
```

Or use the package manager for your distribution.

### Always Checks Even When Disabled

If you've disabled the plugin but the wrapper still checks:

1. Check the config file:
   ```bash
   cat ~/.claude/entire-check.json
   ```

2. Set `enabled: false`:
   ```json
   {
     "enabled": false
   }
   ```

3. Or use the wrapper without checks:
   ```bash
   # Run Claude Code directly, bypassing wrapper
   /path/to/actual/claude "$@"
   ```

## Advanced Usage

### Disable Checks Temporarily

```bash
# Disable for this session
export AUTO_ENTIRE_DISABLED=1
claude  # Will skip checks
```

```bash
# Disable git repo check
export AUTO_ENTIRE_SKIP_GIT=1
claude  # Will check even in non-git directories
```

### Different Configuration File

```bash
# Use custom config file
export AUTO_ENTIRE_CONFIG="/path/to/custom-config.json"
claude
```

## See Also

- [OpenCode Plugin](../README.md) - OpenCode-specific installation and usage
- [MCP Server](CLAUDE_CODE.md) - Claude Code MCP server documentation
- [Configuration Guide](../README.md#configuration) - Full configuration options
