# Configuration

Detailed configuration options for OpenCode Auto-Entire.

## Configuration File

Create a configuration file at `~/.config/opencode/entire-check.json`:

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

## Options Reference

### enabled

- **Type:** `boolean`
- **Default:** `true`
- **Description:** Enable or disable the plugin globally

```json
{
  "enabled": false
}
```

### mode

- **Type:** `"prompt"` | `"auto-init"` | `"silent"`
- **Default:** `"prompt"`
- **Description:** Behavior when Entire CLI is not enabled

| Mode | Behavior | Use Case |
|------|----------|----------|
| `prompt` | Show interactive reminder | Default, recommended |
| `auto-init` | Automatically enable Entire | Automated environments |
| `silent` | Log to console only | Background monitoring |

```json
{
  "mode": "auto-init"
}
```

### checkGitRepo

- **Type:** `boolean`
- **Default:** `true`
- **Description:** Only run checks in git repositories

```json
{
  "checkGitRepo": false
}
```

### showStatus

- **Type:** `boolean`
- **Default:** `true`
- **Description:** Show status even when all systems are operational

```json
{
  "showStatus": false
}
```

## Configuration Examples

### Default Configuration

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

**Use case:** Standard development workflow with interactive prompts

### Automated Workflow

```json
{
  "enabled": true,
  "mode": "auto-init",
  "checkGitRepo": true,
  "showStatus": false
}
```

**Use case:** CI/CD environments or fully automated setups

### Minimal Monitoring

```json
{
  "enabled": true,
  "mode": "silent",
  "checkGitRepo": false,
  "showStatus": false
}
```

**Use case:** Background monitoring without user interruptions

### Development Setup

```json
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
```

**Use case:** Active development with full visibility

## Environment Variables

The plugin also supports environment variables (takes precedence over config file):

- `OPENCODE_ENTIRE_ENABLED` - Override `enabled` option
- `OPENCODE_ENTIRE_MODE` - Override `mode` option
- `OPENCODE_ENTIRE_SHOW_STATUS` - Override `showStatus` option

Example:

```bash
export OPENCODE_ENTIRE_MODE=silent
export OPENCODE_ENTIRE_SHOW_STATUS=false
```

## Configuration File Location

The configuration file can be placed in one of these locations (in order of priority):

1. `~/.config/opencode/entire-check.json` - User-specific configuration
2. Project root `entire-check.json` - Project-specific configuration
3. Default configuration - Built-in defaults

## Reloading Configuration

After changing the configuration:

1. Save the configuration file
2. Restart OpenCode completely
3. Open a new session in a git repository

The new configuration will take effect on the next session start.

## Validation

The plugin validates configuration on startup. Invalid configurations will be logged with warnings.

Common validation errors:

- Invalid `mode` value (must be `"prompt"`, `"auto-init"`, or `"silent"`)
- Non-boolean `enabled` or `checkGitRepo` values
- JSON syntax errors in configuration file

## Next Steps

- Learn about different modes: [Modes](modes.md)
- Troubleshoot configuration issues: [Troubleshooting](troubleshooting.md)
