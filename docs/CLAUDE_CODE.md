# Claude Code Installation Guide

This guide explains how to install and configure the OpenCode Auto-Entire plugin for Claude Code.

## Overview

While this plugin was designed for OpenCode, it can also work with Claude Code with some modifications. Claude Code uses a different plugin architecture based on MCP (Model Context Protocol) servers and hooks.

## Installation

### Step 1: Install Entire CLI

First, install Entire CLI on your system:

**macOS:**
```bash
brew tap entireio/tap
brew install entireio/tap/entire
```

**Linux:**
```bash
curl -fsSL https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64.tar.gz | tar -xz
sudo mv entire /usr/local/bin/
```

**Windows:**
Download the latest release from https://github.com/entireio/cli/releases/latest and add to your PATH.

### Step 2: Install the Plugin

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git

# Create Claude plugins directory
mkdir -p ~/.claude/plugins/

# Copy plugin
cp -r opencode-auto-entire ~/.claude/plugins/

# Install dependencies
cd ~/.claude/plugins/opencode-auto-entire
npm install
```

### Step 3: Configure Claude Code

Edit `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "opencode-auto-entire": true
  },
  "mcpServers": {
    "auto-entire": {
      "type": "local",
      "command": [
        "node",
        "/Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/plugin.js"
      ]
    }
  }
}
```

**Note:** Replace `YOUR_USERNAME` with your actual username.

### Step 4: Create Hook Script (if needed)

Claude Code may require a different hook approach. Create `~/.claude/hooks/session-start.sh`:

```bash
#!/bin/bash
# Claude Code session start hook

# Check if we're in a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
    # Check Entire status
    if [ ! -f ".entire/settings.json" ]; then
        echo "⚠️  Entire CLI not enabled in this repository"
        echo "Run: entire enable --strategy auto-commit"
    fi
fi
```

Make it executable:
```bash
chmod +x ~/.claude/hooks/session-start.sh
```

### Step 5: Restart Claude Code

Exit Claude Code completely and restart it:

```bash
claude
```

## Differences from OpenCode

### Architecture

**OpenCode:**
- Uses `session.created` event hook
- Direct plugin API with `context.client`
- TypeScript plugin files

**Claude Code:**
- Uses MCP (Model Context Protocol) servers
- Hook-based system with shell scripts
- May require different entry points

### Configuration

**OpenCode:** `~/.config/opencode/opencode.json`
**Claude Code:** `~/.claude/settings.json`

### Plugin Location

**OpenCode:** `~/.config/opencode/plugins/`
**Claude Code:** `~/.claude/plugins/`

## Adapting the Plugin for Claude Code

The current plugin code uses OpenCode-specific APIs. To fully adapt it for Claude Code:

1. **Create an MCP Server wrapper:**
   ```typescript
   // src/claude-plugin.ts
   import { Server } from '@modelcontextprotocol/sdk/server/index.js';
   
   // Wrap the plugin logic for MCP
   ```

2. **Use Claude Code hooks:**
   - `session-start`: Runs when session begins
   - `pre-command`: Before each command
   - `post-command`: After each command

3. **Configuration via environment variables:**
   ```bash
   export AUTO_ENTIRE_MODE=prompt
   export AUTO_ENTIRE_CHECK_GIT=true
   ```

## Testing

To verify the installation:

1. Start Claude Code in a git repository without Entire enabled:
   ```bash
   cd /path/to/project
   claude
   ```

2. You should see a notification about Entire not being enabled.

3. Enable Entire:
   ```bash
   entire enable --strategy auto-commit
   ```

4. Restart Claude Code - you should see the "All systems operational" message.

## Troubleshooting

### Plugin Not Loading

Check Claude Code logs:
```bash
# Logs are typically in
~/.claude/logs/
```

### MCP Server Connection Failed

Verify the path in `settings.json`:
```bash
ls -la ~/.claude/plugins/opencode-auto-entire/src/
```

### Hook Not Running

Ensure the hook script is executable:
```bash
chmod +x ~/.claude/hooks/session-start.sh
```

## Alternative: Simple Hook Approach

For a simpler solution without the full plugin, use this hook script:

```bash
#!/bin/bash
# ~/.claude/hooks/session-start.sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Only run in git repos
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    exit 0
fi

# Check Entire
if [ -f ".entire/settings.json" ]; then
    echo -e "${GREEN}✓${NC} Entire CLI: Enabled"
else
    echo -e "${YELLOW}⚠${NC} Entire CLI: Not initialized"
    echo "   Run: entire enable --strategy auto-commit"
fi

# Check Claude-Mem
if [ -f "$HOME/.claude-mem/claude-mem.db" ]; then
    echo -e "${GREEN}✓${NC} Claude-Mem: Active"
else
    echo -e "${YELLOW}⚠${NC} Claude-Mem: Not installed"
fi

echo ""
```

## Future Improvements

The Claude Code integration could be improved by:

1. Native MCP server implementation
2. Better hook integration
3. Configuration UI in Claude Code
4. Cross-platform hook support

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io/)
- [Claude-Mem](https://github.com/thedotmack/claude-mem) - Example of Claude Code plugin
- [Entire CLI](https://github.com/entireio/cli)
