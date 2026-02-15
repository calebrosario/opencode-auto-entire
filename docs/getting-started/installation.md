# Manual Installation

This guide walks you through installing OpenCode Auto-Entire manually.

## Step 1: Install Entire CLI

### macOS

```bash
brew tap entireio/tap
brew install entireio/tap/entire
```

### Linux

Visit [Entire CLI Installation](https://github.com/entireio/cli#installation) for platform-specific instructions.

### Windows

Download the latest release from [Entire CLI Releases](https://github.com/entireio/cli/releases/latest).

## Step 2: Install the Plugin

```bash
# Create plugins directory
mkdir -p ~/.config/opencode/plugins/

# Copy plugin to plugins directory
cp -r . ~/.config/opencode/plugins/opencode-auto-entire

# Navigate to plugin directory and install dependencies
cd ~/.config/opencode/plugins/opencode-auto-entire
npm install
```

## Step 3: Configure OpenCode

Add the plugin to your OpenCode configuration file (`~/.config/opencode/opencode.json`):

```json
{
  "plugin": [
    "file:///Users/YOUR_USERNAME/.config/opencode/plugins/opencode-auto-entire/src/plugin.ts"
  ]
}
```

**Important:** Replace `YOUR_USERNAME` with your actual username.

## Step 4: Restart OpenCode

Completely restart OpenCode to activate the plugin.

## Step 5: Verify Installation

Open any git repository in OpenCode. You should see the memory management check at session start.

## Troubleshooting

### Plugin Not Activating

1. Verify the plugin path in `opencode.json`:
   ```bash
   cat ~/.config/opencode/opencode.json
   ```

2. Check that files exist:
   ```bash
   ls ~/.config/opencode/plugins/opencode-auto-entire/src/
   ```

3. Restart OpenCode completely

### "Cannot find module" Error

Make sure you ran `npm install` in the plugin directory:
```bash
cd ~/.config/opencode/plugins/opencode-auto-entire
npm install
```

## Uninstallation

To remove the plugin:

```bash
# Remove plugin directory
rm -rf ~/.config/opencode/plugins/opencode-auto-entire

# Remove from opencode.json
# Edit ~/.config/opencode/opencode.json and remove the plugin reference
```
