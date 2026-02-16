# Codex Skill Integration

The Codex Skill provides **automatic invocation** based on prompt matching, giving you the closest experience to OpenCode's automatic checking.

## How Codex Skills Auto-Invoke

Codex Skills use **description-based matching** to automatically trigger. When your prompt matches the skill's description, Codex invokes the skill automatically.

### Auto-Invocation Triggers

The `auto-entire` skill auto-invokes when you:

- Start coding tasks ("Let's work on...", "I need to fix...", "Implement...")
- Mention memory or context ("Check memory", "Verify context", "Session persistence")
- Begin a new coding session ("Start new session", "Begin coding")
- Make significant code changes ("Refactor", "Add feature", "Update")

### Skill Description

The skill's description controls auto-invocation:

```yaml
---
name: auto-entire
description: Check and verify memory stack health (Entire CLI, Claude-Mem, RTK) before starting coding tasks. Automatically monitor session persistence and context recovery systems. Run this at the start of development sessions, when working in git repositories, or before making significant code changes to ensure session safety and context preservation.
---
```

Codex analyzes this description and matches it against your prompts.

## Installation

### Repository-Level Skill (Available in This Repo)

The skill is already installed at `.agents/skills/auto-entire/`.

Codex automatically discovers skills in these locations:
- `$CWD/.agents/skills` (current directory)
- `$CWD/../.agents/skills` (parent in repos)
- `$REPO_ROOT/.agents/skills` (repository root)

### Global Skill Installation

To make the skill available in any repository:

```bash
# Create global skills directory
mkdir -p ~/.agents/skills/

# Copy skill
cp -r .agents/skills/auto-entire ~/.agents/skills/

# Verify installation
ls ~/.agents/skills/auto-entire/
```

## Usage

### Automatic Invocation (Recommended)

Just start coding normally. Codex will auto-invoke the skill when appropriate:

```
User: I need to work on the auth module
Codex: [Analyzes prompt, matches skill description]
[Auto-invokes auto-entire skill]
[Skill Output]
🧠 Memory Stack Status

✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

All systems operational.

Codex: Great! All systems are operational. Let's work on the auth module...
```

### Explicit Invocation

You can also explicitly invoke the skill:

```
User: $auto-entire check memory stack
Codex: [Invokes auto-entire skill]
[Skill Output]
📝 Memory Management Check

⚠️ Entire CLI: Not initialized
   → Run: entire enable --strategy auto-commit

✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

Recommendation: Enable Entire to prevent context loss on crashes.
```

### Prompt Hints

Molde your prompts to match the skill's description:

**Good prompts (trigger auto-invoke):**
- "I want to fix a bug in the user service"
- "Let's implement the new checkout flow"
- "Start working on the backend API"
- "Check my memory stack before coding"
- "Verify that session persistence is enabled"

**Less likely to trigger:**
- "What's the capital of France?" (not a coding task)
- "Write a poem about coding" (not related to memory/checking)

## Skill Script

The skill uses `check-memory.js` to perform the check:

```javascript
// .agents/skills/auto-entire/scripts/check-memory.js
import { runEntireCheck } from '../../core/entire-check.ts'

const result = await runEntireCheck(process.cwd())
console.log(result.message)
```

The script:
1. Uses shared core module (same as OpenCode/Claude Code)
2. Checks current working directory
3. Runs memory stack check
4. Displays formatted results
5. Exits with appropriate status code

## Configuration

The skill uses the same configuration as OpenCode and Claude Code.

Create `~/.config/opencode/entire-check.json`:

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

See [Configuration Documentation](/docs/USER_GUIDE.md#configuration) for details.

## Auto-Invocation Behavior

### How Codex Decides to Invoke

Codex uses a semantic matching algorithm:

1. Analyzes your prompt's intent
2. Compares against all available skills' descriptions
3. Selects best-matching skill(s)
4. Invokes skill before generating response

The `auto-entire` skill's description is tuned to match:
- Coding tasks
- Memory/context mentions
- Session starts
- Development workflows

### Controlling Auto-Invocation

Create `agents/openai.yaml` in the skill directory:

```yaml
policy:
  allow_implicit_invocation: true  # default: true
```

Set to `false` to disable auto-invocation (only explicit `$skill-name` invocation works).

### Improving Match Rate

To improve auto-invocation:

1. **Use natural language about coding:** "Let's implement..." vs "Do X"
2. **Mention context/memory:** "Check my memory" vs "Hello"
3. **Be explicit about starting:** "Start coding on..." vs just stating a task

## Skill Structure

```
.agents/skills/auto-entire/
├── SKILL.md                      # Required: Skill instructions
├── scripts/
│   └── check-memory.js           # Check script
└── agents/
    └── openai.yaml              # Optional: UI metadata
```

### SKILL.md

Contains:
- **Frontmatter**: `name` and `description` (required for auto-invocation)
- **Instructions**: How to use the skill, what it does, when it triggers

### scripts/check-memory.js

Executable JavaScript that:
- Imports core module from `../../core/entire-check.ts`
- Runs memory stack check
- Outputs formatted message
- Returns appropriate exit code

### agents/openai.yaml (Optional)

Controls:
- UI display in Codex app
- Auto-invocation policy
- Tool dependencies

## Troubleshooting

### Skill Not Auto-Invoking

**Check if skill is discovered:**
```bash
# In Codex TUI, run:
/skills
```

**Verify description:**
```bash
# Check skill description
cat .agents/skills/auto-entire/SKILL.md | head -5
```

**Restart Codex:**
- Codex caches skills; restart to refresh

**Check auto-invocation is enabled:**
```bash
# If agents/openai.yaml exists
cat .agents/skills/auto-entire/agents/openai.yaml | grep allow_implicit_invocation
```

### Script Not Executing

**Check script permissions:**
```bash
ls -la .agents/skills/auto-entire/scripts/check-memory.js
```

**Test script directly:**
```bash
node .agents/skills/auto-entire/scripts/check-memory.js
```

**Check core module:**
```bash
# Verify core module exists
ls -la core/entire-check.ts
```

### Configuration Not Applied

**Check config path:**
```bash
# Codex reads from these locations
ls -la ~/.config/opencode/entire-check.json
```

**Create config if missing:**
```bash
mkdir -p ~/.config/opencode/
cat > ~/.config/opencode/entire-check.json << EOF
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
EOF
```

## Best Practices

1. **Start with clear coding intent:** "Let's work on X" triggers auto-invocation
2. **Mention memory when relevant:** "Check memory before refactoring"
3. **Review skill output:** Always review memory stack status before proceeding
4. **Fix issues promptly:** Enable Entire when prompted
5. **Keep skill updated:** Pull latest version from repository

## Examples

### Example 1: Auto-Invocation Success

```
User: I need to refactor the payment service
Codex: [Analyzes prompt: "refactor" matches "significant code changes"]
[Auto-invokes auto-entire skill]

🧠 Memory Stack Status

✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (87.3% efficiency)

All systems operational.

Codex: Perfect! All systems are operational. Let's refactor the payment service...
```

### Example 2: Auto-Invocation with Missing Entire

```
User: Let's implement the new feature
Codex: [Analyzes prompt: "implement" matches "coding tasks"]
[Auto-invokes auto-entire skill]

📝 Memory Management Check

⚠️ Entire CLI: Not initialized
   → Run: entire enable --strategy auto-commit

✅ Claude-Mem: Active
✅ RTK: Active (91.7% efficiency)

Recommendation: Enable Entire to prevent context loss on crashes.

Codex: I notice Entire CLI is not enabled. Would you like me to help you enable it, or shall we proceed without session persistence?
```

### Example 3: Explicit Invocation

```
User: $auto-entire check memory
Codex: [Explicitly invokes auto-entire skill]

🧠 Memory Stack Status

✅ Entire CLI: Enabled
✅ Claude-Mem: Active
✅ RTK: Active (92.1% efficiency)

All systems operational.

Codex: Your memory stack is in great shape! How can I help you today?
```

## Comparison to Other Platforms

| Platform | Auto-Invoke Method | Lifecycle Events | Description Matching |
|----------|-------------------|-----------------|-------------------|
| **OpenCode** | Plugin event hook | ✅ session.created | N/A |
| **Codex Skill** | Description matching | ❌ None | ✅ Yes |
| **Claude Code MCP** | Manual tool invocation | ❌ None | N/A |
| **Cursor MCP** | Auto-invoke when helpful | ❌ None | N/A |

Codex Skills provide automatic invocation through prompt matching, which is different from OpenCode's lifecycle hooks but achieves similar results.

## Related Documentation

- [Codex Setup Guide](/docs/CODEX.md) - Complete Codex integration
- [User Guide](/docs/USER_GUIDE.md) - Configuration and options
- [Skill Documentation](/docs/CODEX_SKILL.md) - This file
