# OpenCode Auto-Entire for Codex CLI

This plugin provides memory stack checking (Entire CLI, Claude-Mem, RTK) for OpenAI's Codex CLI tool.

## Installation

### Option 1: MCP Server (Recommended for On-Demand Tools)

The MCP server provides tools that Codex can use during conversations:

1. **Clone and install:**
   ```bash
   git clone https://github.com/yourusername/opencode-auto-entire.git
   cd opencode-auto-entire

   # Install for Codex
   mkdir -p ~/.codex/plugins/
   cp -r . ~/.codex/plugins/opencode-auto-entire
   cd ~/.codex/plugins/opencode-auto-entire
   npm install
   ```

2. **Configure MCP server in `~/.codex/config.toml`:**
   ```toml
   [mcp_servers.auto-entire]
   command = "node"
   args = ["/Users/YOUR_USERNAME/.codex/plugins/opencode-auto-entire/src/claude-code.ts"]
   ```

3. **Verify installation:**
   ```bash
   # List MCP servers
   codex mcp list

   # Check tools
   codex mcp list-tools auto-entire
   ```

**Usage in Codex:**
- Codex will automatically use MCP tools when helpful
- You can also explicitly mention: "Check memory stack with auto-entire"

### Option 2: Codex Skill (For Auto-Invoke)

The Codex Skill uses description-based auto-invocation to trigger checks:

1. **Install skill:**
   ```bash
   # Repository-level skill (available in this repo)
   # Already installed at .agents/skills/auto-entire/

   # Or install globally
   mkdir -p ~/.agents/skills/
   cp -r .agents/skills/auto-entire ~/.agents/skills/
   ```

2. **Codex automatically discovers skills** in these locations:
   - `$CWD/.agents/skills` (current directory)
   - `$CWD/../.agents/skills` (parent in repos)
   - `$REPO_ROOT/.agents/skills` (repository root)
   - `$HOME/.agents/skills` (user-specific)

3. **Skill auto-invokes** when your prompt matches description:
   - "Check memory before coding"
   - "Start a new coding session"
   - "Verify memory systems are running"
   - Or any prompt mentioning "memory", "context", or "persistence"

**Usage in Codex:**
```
User: I need to work on the auth module
Codex: [Auto-invokes auto-entire skill]
[Skill Output]
🧠 Memory Stack Status

✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

All systems operational.

Codex: Great! All systems are operational. Let's work on the auth module...
```

### Option 3: Wrapper Script (For True Automatic Checking)

The wrapper script runs memory checks before launching Codex:

1. **Set up alias in `~/.bashrc` or `~/.zshrc`:**
   ```bash
   alias codex='~/.codex/plugins/opencode-auto-entire/scripts/codex-wrapper.sh'
   ```

2. **Reload shell:**
   ```bash
   source ~/.bashrc
   ```

3. **Use Codex normally - automatic checking!**
   ```bash
   codex
   ```

**That's it!** Memory stack checks run automatically every time you launch Codex.

## Configuration

Configuration works across all platforms. Create `~/.config/opencode/entire-check.json`:

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
| `enabled` | boolean | `true` | Enable/disable plugin |
| `mode` | `"prompt"` \| `"auto-init"` \| `"silent"` | `"prompt"` | Behavior when Entire not enabled |
| `checkGitRepo` | boolean | `true` | Only check in git repositories |
| `showStatus` | boolean | `true` | Show status even when Entire is enabled |

### Modes

**prompt** (default):
Shows a friendly reminder with instructions.

**auto-init**:
Automatically runs `entire enable --strategy auto-commit` without asking.
⚠️ **Use with caution** - modifies repositories without explicit confirmation!

**silent**:
Only logs to console, no UI notification.

## Which Option Should I Choose?

| Scenario | Recommended Option |
|----------|------------------|
| **Auto-invoke based on prompt matching** | **Codex Skill** |
| **On-demand tools during conversations** | **MCP Server** |
| **True automatic checking on launch** | **Wrapper Script** |
| **Standard workflow** | **MCP Server** |
| **Same experience as OpenCode** | **Wrapper Script** |

**Recommendation:** Use **Codex Skill** for auto-invocation based on your prompts, keep **MCP server** for on-demand tools, and use **wrapper script** for automatic checking on every launch.

## What It Does

### Memory Stack Components

- **Entire CLI**: Session checkpoint and recovery (crash protection)
- **Claude-Mem**: Cross-session memory (context persistence)
- **RTK**: Token optimization (60-90% savings)

### When Entire is Not Enabled

You'll see:
```
📝 Memory Management Check

⚠️ Entire CLI: Not initialized
   → Run: entire enable --strategy auto-commit

✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

Why this matters:
• Entire = Session checkpoint/recovery (crash protection)
• Claude-Mem = Cross-session memory (context persistence)
• RTK = Token optimization (60-90% savings)

Recommendation: Enable Entire to prevent context loss on crashes.
```

### When All Systems Are Operational

You'll see:
```
🧠 Memory Stack Status

✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

All systems operational.
```

## Troubleshooting

### MCP Server Not Appearing

Verify MCP server configuration:
```bash
cat ~/.codex/config.toml
```

Check if server starts:
```bash
node ~/.codex/plugins/opencode-auto-entire/src/claude-code.ts
```

### Skill Not Auto-Invoking

1. Check if skill is in a scanned location:
   ```bash
   # List skills in current directory
   ls .agents/skills/

   # List global skills
   ls ~/.agents/skills/
   ```

2. Restart Codex to refresh skill cache

3. Check skill description matches your intent:
   ```bash
   cat .agents/skills/auto-entire/SKILL.md
   ```

### Wrapper Script Not Working

Verify alias is set:
```bash
alias codex
```

Check if script is executable:
```bash
ls -la ~/.codex/plugins/opencode-auto-entire/scripts/codex-wrapper.sh
```

Test script directly:
```bash
~/.codex/plugins/opencode-auto-entire/scripts/codex-wrapper.sh
```

### "Cannot find module" Error

Install dependencies:
```bash
cd ~/.codex/plugins/opencode-auto-entire
npm install
```

## Advanced Configuration

### MCP Server Options

See `codex.example.toml` for all available options:

```toml
[mcp_servers.auto-entire]
command = "node"
args = ["/Users/YOUR_USERNAME/.codex/plugins/opencode-auto-entire/src/claude-code.ts"]
startup_timeout_sec = 20
tool_timeout_sec = 45
enabled = true
required = false
```

### Skill Auto-Invoke Control

Create `agents/openai.yaml` in the skill directory to control auto-invocation:

```yaml
policy:
  allow_implicit_invocation: true
```

## Platform Support

| Platform | MCP Server | Skill | Wrapper Script |
|----------|-------------|--------|----------------|
| macOS | ✅ | ✅ | ✅ |
| Linux | ✅ | ✅ | ✅ |
| Windows | ⚠️ WSL only | ⚠️ WSL only | ⚠️ WSL only |

## Related Documentation

- [OpenCode Setup](/docs/OPENCODE.md)
- [Claude Code Setup](/docs/CLAUDE_CODE.md)
- [Cursor Setup](/docs/CURSOR.md)
- [Codex Skill Documentation](/docs/CODEX_SKILL.md)

## Requirements

- **Codex CLI** with MCP and/or Skills support
- Node.js 18+ and npm
- Git (for repository detection)
- Optional: Entire CLI (will be prompted to install if missing)

## License

MIT License - see [LICENSE](/LICENSE) for details.
