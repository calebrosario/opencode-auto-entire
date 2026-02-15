# Claude Code Integration

This plugin also works with Claude Code. Here's how to set it up.

## Quick Setup

1. **Install Entire CLI:**
   ```bash
   brew tap entireio/tap
   brew install entireio/tap/entire
   ```

2. **Copy plugin to Claude Code:**
   ```bash
   mkdir -p ~/.claude/plugins/
   cp -r . ~/.claude/plugins/opencode-auto-entire
   cd ~/.claude/plugins/opencode-auto-entire
   npm install
   ```

3. **Configure Claude Code settings:**

   Edit `~/.claude/settings.json`:
   ```json
   {
     "plugins": [
       "file:///Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/plugin.ts"
     ]
   }
   ```

4. **Restart Claude Code**

## Detailed Installation

### Step 1: Install Dependencies

**Entire CLI:**
```bash
# macOS
brew tap entireio/tap
brew install entireio/tap/entire

# Linux
# Download from https://github.com/entireio/cli/releases
```

**Claude-Mem (optional):**
```bash
git clone https://github.com/thedotmack/claude-mem.git
cd claude-mem
npm install
npm link
```

**RTK (optional):**
```bash
git clone https://github.com/rtk-ai/rtk.git
cd rtk
npm install
npm link
```

### Step 2: Install the Plugin

```bash
# Create plugins directory
mkdir -p ~/.claude/plugins/

# Copy plugin files
cp -r . ~/.claude/plugins/opencode-auto-entire

# Install plugin dependencies
cd ~/.claude/plugins/opencode-auto-entire
npm install
```

### Step 3: Configure Claude Code

Create or edit `~/.claude/settings.json`:

```json
{
  "plugins": [
    "file:///Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/plugin.ts"
  ],
  "autoEntire": {
    "enabled": true,
    "mode": "prompt",
    "checkGitRepo": true,
    "showStatus": true
  }
}
```

**Important:** Replace `YOUR_USERNAME` with your actual username.

### Step 4: Restart Claude Code

Completely restart Claude Code to activate the plugin.

## Configuration

The plugin uses the same configuration format for both OpenCode and Claude Code.

### Configuration Options

```json
{
  "autoEntire": {
    "enabled": true,
    "mode": "prompt",
    "checkGitRepo": true,
    "showStatus": true
  }
}
```

See [Configuration](../user-guide/configuration.md) for detailed options.

## Usage

### Starting a Session

1. Open Claude Code in any git repository
2. The plugin will automatically check your memory stack
3. You'll see status at session start

### Example Output

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

## Differences from OpenCode

While the plugin works similarly in both environments, there are some differences:

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Plugin Loading | opencode.json | settings.json |
| Plugin Path | ~/.config/opencode/plugins/ | ~/.claude/plugins/ |
| Configuration | ~/.config/opencode/entire-check.json | Same or in settings.json |
| Session Lifecycle | Managed by OpenCode | Managed by Claude Code |

## Troubleshooting

### Plugin Not Loading

1. **Verify plugin path:**
   ```bash
   cat ~/.claude/settings.json
   ```

2. **Check plugin files exist:**
   ```bash
   ls ~/.claude/plugins/opencode-auto-entire/src/plugin.ts
   ```

3. **Verify dependencies installed:**
   ```bash
   cd ~/.claude/plugins/opencode-auto-entire
   npm list
   ```

### Entire Not Detected

1. **Verify Entire CLI installed:**
   ```bash
   entire --version
   ```

2. **Check Entire status:**
   ```bash
   entire status
   ```

3. **Enable Entire if needed:**
   ```bash
   entire enable --strategy auto-commit
   ```

### Memory Stack Not Checked

1. **Ensure plugin is enabled:**
   ```bash
   cat ~/.claude/settings.json | grep "opencode-auto-entire"
   ```

2. **Check configuration:**
   ```bash
   cat ~/.claude/settings.json | jq .autoEntire
   ```

3. **Verify you're in a git repository:**
   ```bash
   git status
   ```

## Example Workflows

### New Project Setup

```bash
# 1. Create new project
mkdir my-claude-project
cd my-claude-project
git init

# 2. Enable Entire
entire enable --strategy auto-commit

# 3. Open in Claude Code
# The plugin will show "All systems operational"
```

### Existing Project Integration

```bash
# 1. Navigate to existing project
cd existing-project

# 2. Enable Entire
entire enable --strategy auto-commit

# 3. Open in Claude Code
# Plugin will verify all components are active
```

### Multiple Projects

The plugin works across multiple projects seamlessly:

- Each project has its own Entire configuration
- Claude-Mem provides cross-project memory
- RTK optimizes tokens across all sessions

## Uninstallation

To remove the plugin from Claude Code:

1. **Remove plugin directory:**
   ```bash
   rm -rf ~/.claude/plugins/opencode-auto-entire
   ```

2. **Update settings.json:**
   ```json
   {
     "plugins": []
   }
   ```

3. **Restart Claude Code**

## Next Steps

- Configure plugin behavior: [Configuration](../user-guide/configuration.md)
- Learn about operation modes: [Modes](../user-guide/modes.md)
- Understand plugin architecture: [Architecture](architecture.md)
