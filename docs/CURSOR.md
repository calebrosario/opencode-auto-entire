# Cursor Setup Guide

OpenCode Auto-Entire works with Cursor IDE using Model Context Protocol (MCP) through Cursor's built-in MCP client.

## Overview

Cursor IDE has native MCP (Model Context Protocol) support built-in. Unlike Claude Code where you need to configure MCP servers manually, Cursor manages MCP servers automatically through its `agent mcp` CLI commands.

### How It Works

1. **OpenCode Auto-Entire** provides an MCP server with tools:
   - `check_memory_stack` - Check status of Entire, Claude-Mem, RTK
   - `enable_entire` - Auto-initialize Entire in current directory

2. **Cursor's agent** automatically discovers and uses MCP tools when helpful in conversations

3. **No manual configuration needed** - Cursor handles MCP server lifecycle

## Installation

### Step 1: Install OpenCode Auto-Entire

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Run the installer (includes dependencies and MCP setup)
./scripts/install-claude.sh
```

This installs:
- The plugin files to `~/.claude/plugins/opencode-auto-entire/`
- The MCP server (`auto-entire-mcp`)
- Dependencies including `@modelcontextprotocol/sdk`

### Step 2: Configure MCP Server in Cursor

There are **two ways** to add the MCP server to Cursor:

#### Option 1: Via Cursor CLI (Recommended)

1. Open Cursor IDE
2. Press `Cmd+Shift+P` to open Command Palette
3. Type "MCP" to open MCP management
4. Click "Add New Server"
5. Enter configuration:
   ```
   {
     "command": "node",
     "args": ["/Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/claude-code.ts"]
   }
   ```
6. Click "Connect"

#### Option 2: Via Configuration File

If you prefer using configuration files:

1. Navigate to Cursor → Settings → Advanced → MCP
2. Click "Add Server"
3. Enter configuration:
   ```json
   {
     "name": "auto-entire",
     "description": "Memory stack monitoring for OpenCode Auto-Entire",
     "command": "node",
     "args": ["/Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/claude-code.ts"],
     "env": {
       "NODE_ENV": "production"
     }
   }
   ```
4. Click "Connect"

## Verification

### Check MCP Server Connection

1. In Cursor, press `Cmd+Shift+P`
2. Type "MCP" to open MCP management
3. Verify "auto-entire" server shows as "Connected"
4. Click on the server to view available tools:
   - `check_memory_stack`
   - `enable_entire`

### Test Tools

You can test the MCP tools are available:

1. Open Cursor in your project directory
2. Type `Cmd+Shift+P`, type "MCP"
3. Select "auto-entire" server
4. Use "Check memory stack with auto-entire" in the agent prompt

**Example prompt:**
```
Please check my memory stack with auto-entire
```

Cursor will invoke the MCP tool and display the results.

## Usage

### Using Tools Automatically

Cursor's agent will automatically use MCP tools when helpful in your conversations:

```
User: "Check my entire status"
Cursor: [Invokes check_memory_stack tool, shows results]

User: "What's my memory stack?"
Cursor: [Invokes check_memory_stack tool, shows results]

User: "Enable entire in this project"
Cursor: [Invokes enable_entire tool, runs entire enable command]
```

### Using Tools Manually

You can also invoke tools explicitly:

```
User: "I want to check my memory stack"
Cursor: [You can ask: "Check memory stack with auto-entire"]
```

## Troubleshooting

### MCP Server Not Showing

If the MCP server doesn't appear in Cursor's MCP management:

1. **Check installation**: Verify plugin is installed correctly
   ```bash
   ls ~/.claude/plugins/opencode-auto-entire/src/claude-code.ts
   ```
   File should exist

2. **Restart Cursor**: Close and reopen Cursor IDE

3. **Verify MCP client**: Ensure Cursor's MCP client is enabled
   - Cursor → Settings → Advanced → MCP
   - Verify MCP is enabled

4. **Manual configuration**: Try using configuration file method (Option 2 above)

### Tools Not Available

If tools don't appear when MCP server is connected:

1. **Check MCP server is connected**: Verify status shows "Connected"
2. **Verify server is running**: MCP server should be active
3. **Restart Cursor MCP client**: 
   - Cursor → Settings → Advanced → MCP
   - Click "Restart MCP Client"
   - Wait a few seconds

### Connection Errors

If you see connection errors:

1. **"Command failed"**: Check the MCP server command is correct
   - Should be: `node /path/to/src/claude-code.ts`
   - Verify Node.js is installed: `node --version`

2. **"Server not responding"**: MCP server might be down or not running
   - Check if server process is running: `ps aux | grep claude-code`

3. **"Timeout"**: MCP server took too long to respond
   - This could be a network or performance issue
   - Try again after a moment

## Advanced Configuration

### Environment Variables

You can pass environment variables to the MCP server in Cursor configuration:

```json
{
  "name": "auto-entire",
  "description": "Memory stack monitoring for OpenCode Auto-Entire",
  "command": "node",
  "args": ["/Users/YOUR_USERNAME/.claude/plugins/opencode-auto-entire/src/claude-code.ts"],
  "env": {
    "AUTO_ENTIRE_MODE": "prompt",
    "AUTO_ENTIRE_CHECK_GIT": "true",
    "AUTO_ENTIRE_SHOW_STATUS": "true"
  }
}
```

The MCP server will read these environment variables to configure behavior.

### Working Directory

By default, the MCP server uses the current working directory. If you want to ensure it checks a specific project:

1. Set `WORKING_DIR` environment variable:
   ```json
   "env": {
     "WORKING_DIR": "/path/to/your/project"
   }
   }
   ```

## Comparison with Other Platforms

| Feature | OpenCode | Claude Code | Cursor |
|----------|-----------|-------------|----------|
| **Installation** | Plugin file | MCP server config | Cursor MCP UI/CLI |
| **Configuration** | `~/.config/opencode/entire-check.json` | `~/.claude/settings.json` | Cursor Settings → MCP |
| **Automatic checking** | ✅ Hook on session.start | ❌ Manual tool invoke | ✅ Agent auto-invoke |
| **Tool access** | Native | Manual | Semi-auto | ✅ Agent uses tools |
| **Setup complexity** | Simple | Medium | Very simple |
| **Configuration** | JSON file | JSON file | UI configuration |

## Comparison Summary

**OpenCode**: Plugin system, hooks into lifecycle events
**Claude Code**: Manual MCP server configuration, tools must be invoked
**Cursor**: Built-in MCP client, automatic tool usage, no configuration files needed

**Recommendation**: Cursor provides the best user experience with automatic tool usage, no configuration required, and simple setup process.

## See Also

- [Cursor MCP Documentation](https://cursor.com/docs/cli/mcp) - Official Cursor MCP documentation
- [Getting Started](../getting-started/README.md) - Installation for all platforms
- [Configuration Guide](../user-guide/configuration.md) - Configuration options
- [OpenCode Setup](../README.md#open-code-installation) - OpenCode-specific setup
- [Claude Code Setup](CLAUDE_CODE.md) - Claude Code MCP server setup
- [Claude Code Wrapper](CLAUDE_WRAPPER.md) - Automatic checking for Claude Code
