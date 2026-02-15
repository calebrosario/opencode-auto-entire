# Troubleshooting

Common issues and solutions for OpenCode Auto-Entire.

## Quick Fixes

| Problem | Solution |
|---------|----------|
| Plugin not activating | Check path in opencode.json |
| "Cannot find module" error | Run `npm install` in plugin directory |
| Entire not detected | Run `entire status` to verify |
| Too many notifications | Set `mode` to `"silent"` |

## Common Issues

### Plugin Not Activating

**Symptoms:**
- No memory stack check on session start
- No output when starting OpenCode
- Plugin appears inactive

**Solutions:**

1. **Verify plugin path in opencode.json:**
   ```bash
   cat ~/.config/opencode/opencode.json
   ```
   
   Ensure the path matches your username:
   ```json
   {
     "plugin": [
       "file:///Users/YOUR_USERNAME/.config/opencode/plugins/opencode-auto-entire/src/plugin.ts"
     ]
   }
   ```

2. **Check that plugin files exist:**
   ```bash
   ls ~/.config/opencode/plugins/opencode-auto-entire/src/
   ```
   
   You should see `plugin.ts` and other files.

3. **Restart OpenCode completely:**
   - Close all OpenCode windows
   - Restart the application
   - Open a new session in a git repository

4. **Verify dependencies are installed:**
   ```bash
   cd ~/.config/opencode/plugins/opencode-auto-entire
   npm install
   ```

### "Cannot find module" Error

**Symptoms:**
- Error message about missing module
- Plugin fails to load
- Stack trace showing module resolution errors

**Solutions:**

1. **Navigate to plugin directory and install dependencies:**
   ```bash
   cd ~/.config/opencode/plugins/opencode-auto-entire
   npm install
   ```

2. **Check package.json exists:**
   ```bash
   ls ~/.config/opencode/plugins/opencode-auto-entire/package.json
   ```

3. **Verify Node.js version:**
   ```bash
   node --version
   ```
   
   Should be Node.js 18+.

4. **Clear npm cache if needed:**
   ```bash
   npm cache clean --force
   npm install
   ```

### Entire CLI Not Found

**Symptoms:**
- Plugin reports "Entire CLI: Not initialized"
- Running `entire status` fails
- `command not found: entire`

**Solutions:**

1. **Install Entire CLI:**
   
   **macOS:**
   ```bash
   brew tap entireio/tap
   brew install entireio/tap/entire
   ```
   
   **Linux:**
   Download from [Entire CLI releases](https://github.com/entireio/cli/releases)
   
   **Windows:**
   Download from [Entire CLI releases](https://github.com/entireio/cli/releases)

2. **Verify installation:**
   ```bash
   entire --version
   ```

3. **Enable Entire in your project:**
   ```bash
   cd your-project
   entire enable --strategy auto-commit
   ```

4. **Verify .entire directory exists:**
   ```bash
   ls -la .entire/settings.json
   ```

### Claude-Mem Not Detected

**Symptoms:**
- Plugin reports "Claude-Mem: Not installed"
- Claude-Mem commands not working
- Cross-session memory not available

**Solutions:**

1. **Install Claude-Mem:**
   ```bash
   git clone https://github.com/thedotmack/claude-mem.git
   cd claude-mem
   npm install
   npm link
   ```

2. **Verify installation:**
   ```bash
   claude-mem --version
   ```

3. **Configure Claude-Mem if needed:**
   ```bash
   claude-mem init
   ```

### RTK Not Detected

**Symptoms:**
- Plugin reports "RTK: Not found"
- RTK commands not working
- Token optimization not available

**Solutions:**

1. **Install RTK:**
   ```bash
   git clone https://github.com/rtk-ai/rtk.git
   cd rtk
   npm install
   npm link
   ```

2. **Verify installation:**
   ```bash
   rtk --version
   ```

3. **Check RTK efficiency:**
   ```bash
   rtk gain
   ```

### Too Many Notifications

**Symptoms:**
- Constant status updates
- Distracting notifications
- Disruptive to workflow

**Solutions:**

1. **Switch to silent mode:**
   ```json
   {
     "mode": "silent"
   }
   ```

2. **Disable status display:**
   ```json
   {
     "showStatus": false
   }
   ```

3. **Only check in git repositories:**
   ```json
   {
     "checkGitRepo": true
   }
   ```

4. **Disable plugin entirely:**
   ```json
   {
     "enabled": false
   }
   ```

### Plugin Runs in Non-Git Directories

**Symptoms:**
- Memory check appears in non-git directories
- Unwanted notifications
- Plugin active where not needed

**Solutions:**

1. **Enable git repository check:**
   ```json
   {
     "checkGitRepo": true
   }
   ```

2. **Verify you're in a git repository:**
   ```bash
   git status
   ```

### Configuration Not Applied

**Symptoms:**
- Changes to config file not taking effect
- Default behavior persists
- Settings ignored

**Solutions:**

1. **Verify config file location:**
   ```bash
   ls ~/.config/opencode/entire-check.json
   ```

2. **Check JSON syntax:**
   ```bash
   cat ~/.config/opencode/entire-check.json | jq .
   ```
   
   If `jq` is not available, use a JSON validator.

3. **Restart OpenCode completely:**
   - Close all windows
   - Restart the application

4. **Check for environment variable overrides:**
   ```bash
   env | grep OPENCODE_ENTIRE
   ```

## Advanced Troubleshooting

### Enable Debug Logging

Set environment variable for detailed logs:

```bash
export OPENCODE_ENTIRE_DEBUG=true
opencode
```

### Check Plugin Loading

Verify the plugin is loaded correctly:

```bash
# Check OpenCode logs
cat ~/.config/opencode/logs/opencode.log

# Look for plugin initialization messages
grep "entire-check" ~/.config/opencode/logs/opencode.log
```

### Test Plugin Directly

Test the plugin logic:

```bash
cd ~/.config/opencode/plugins/opencode-auto-entire
npm test
```

### Verify File Permissions

Ensure proper permissions:

```bash
ls -la ~/.config/opencode/plugins/opencode-auto-entire/
chmod -R 755 ~/.config/opencode/plugins/opencode-auto-entire/
```

## Getting Help

If you're still experiencing issues:

1. **Check the documentation:**
   - [Configuration](configuration.md)
   - [Usage](usage.md)
   - [Modes](modes.md)

2. **Review logs:**
   ```bash
   cat ~/.config/opencode/logs/opencode.log
   ```

3. **Report an issue:**
   - Check [GitHub Issues](https://github.com/yourusername/opencode-auto-entire/issues)
   - Include error messages and configuration
   - Describe your environment (OS, Node.js version, etc.)

4. **Community resources:**
   - [OpenCode documentation](https://opencode.ai)
   - [Entire CLI documentation](https://github.com/entireio/cli)

## Recovery Procedures

### Restore Default Configuration

If configuration is corrupted:

1. Backup current config:
   ```bash
   cp ~/.config/opencode/entire-check.json ~/.config/opencode/entire-check.json.backup
   ```

2. Delete config file:
   ```bash
   rm ~/.config/opencode/entire-check.json
   ```

3. Restart OpenCode (defaults will be used)

### Reinstall Plugin

If plugin files are corrupted:

1. Remove plugin directory:
   ```bash
   rm -rf ~/.config/opencode/plugins/opencode-auto-entire
   ```

2. Reinstall from source:
   ```bash
   cd opencode-auto-entire
   ./scripts/install.sh
   ```

### Reset Git Hooks

If Entire CLI integration is broken:

1. Remove .entire directory:
   ```bash
   rm -rf .entire
   ```

2. Re-enable Entire:
   ```bash
   entire enable --strategy auto-commit
   ```

## Next Steps

- Learn configuration options: [Configuration](configuration.md)
- Understand usage patterns: [Usage](usage.md)
- Explore operation modes: [Modes](modes.md)
