# Architecture

Understanding the internal architecture and design of OpenCode Auto-Entire.

## Overview

OpenCode Auto-Entire is designed as a lightweight plugin that integrates seamlessly with OpenCode's plugin system. It follows a modular architecture with clear separation of concerns.

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   OpenCode / Claude Code                │
│                     (Host Application)                  │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Plugin System
                     ▼
┌─────────────────────────────────────────────────────────┐
│              OpenCode Auto-Entire Plugin               │
│  ┌─────────────────────────────────────────────────┐   │
│  │           Session Start Hook                     │   │
│  │  - Triggers on session initialization          │   │
│  │  - Checks if git repository                     │   │
│  └────────────┬────────────────────────────────────┘   │
│               │                                         │
│               ▼                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │         Memory Stack Checker                     │   │
│  │  - Checks Entire CLI status                     │   │
│  │  - Checks Claude-Mem status                     │   │
│  │  - Checks RTK status                            │   │
│  └────────────┬────────────────────────────────────┘   │
│               │                                         │
│               ▼                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │        Status Aggregator                         │   │
│  │  - Collects status from all components          │   │
│  │  - Formats output messages                      │   │
│  └────────────┬────────────────────────────────────┘   │
│               │                                         │
│               ▼                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │         Mode Handler                            │   │
│  │  - Applies configured mode (prompt/auto/silent) │   │
│  │  - Executes appropriate actions                 │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
    ┌─────────┐ ┌─────────┐ ┌─────────┐
    │ Entire  │ │Claude-  │ │   RTK   │
    │   CLI   │ │  Mem    │ │         │
    └─────────┘ └─────────┘ └─────────┘
```

## Component Breakdown

### 1. Session Start Hook

**Purpose:** Entry point for plugin activation

**Responsibilities:**
- Detects session initialization
- Triggers memory stack check
- Respects `checkGitRepo` configuration

**Lifecycle:**
```
Session Start → Hook Triggered → Git Repo Check → Memory Check
```

### 2. Memory Stack Checker

**Purpose:** Verify status of memory management components

**Checks:**

| Component | Detection Method | Status Conditions |
|-----------|------------------|-------------------|
| Entire CLI | `.entire/settings.json` exists | Enabled / Not initialized |
| Claude-Mem | `claude-mem status` command | Active / Not installed |
| RTK | `rtk --version` command | Active / Not found |

**Implementation:**
- File system checks for Entire CLI
- Command execution for Claude-Mem and RTK
- Graceful handling of missing components

### 3. Status Aggregator

**Purpose:** Collect and format status information

**Responsibilities:**
- Aggregate status from all components
- Format output messages
- Calculate efficiency metrics (RTK)

**Output Format:**

```
Memory Stack Status

Entire CLI: Enabled
Claude-Mem: Active
RTK: Active (91.7% efficiency)

All systems operational.
```

### 4. Mode Handler

**Purpose:** Execute behavior based on configured mode

**Mode Logic:**

| Mode | Action | User Interaction |
|------|--------|------------------|
| `prompt` | Show interactive message | Yes |
| `auto-init` | Run `entire enable` automatically | No |
| `silent` | Log to console only | No |

## Configuration Layer

### Configuration Hierarchy

```
1. Environment Variables (highest priority)
   ↓
2. Project-specific config (./entire-check.json)
   ↓
3. User-specific config (~/.config/opencode/entire-check.json)
   ↓
4. Default configuration (built-in)
```

### Configuration Schema

```typescript
interface EntireCheckConfig {
  enabled: boolean;
  mode: 'prompt' | 'auto-init' | 'silent';
  checkGitRepo: boolean;
  showStatus: boolean;
}
```

## Plugin Interface

### OpenCode Plugin System

```typescript
interface Plugin {
  name: string;
  version: string;
  onSessionStart?(context: SessionContext): Promise<void>;
}
```

### Implementation

```typescript
export const plugin: Plugin = {
  name: 'opencode-auto-entire',
  version: '1.0.0',
  onSessionStart: async (context) => {
    // Memory stack check logic
  }
};
```

## Data Flow

### Happy Path (All Systems Operational)

```
Session Start
    │
    ├─► Git Repo Check ──► Yes
    │
    ├─► Entire Check ──► Enabled
    │
    ├─► Claude-Mem Check ──► Active
    │
    ├─► RTK Check ──► Active
    │
    └─► Mode: prompt ──► Show Status
```

### Missing Component Path

```
Session Start
    │
    ├─► Git Repo Check ──► Yes
    │
    ├─► Entire Check ──► Not initialized
    │
    ├─► Mode: prompt ──► Show instructions
    │
    └─► User action required
```

## Error Handling

### Graceful Degradation

The plugin is designed to fail gracefully:

- If a component is missing, continue checking others
- If configuration is invalid, use defaults
- If checks fail, log warning but don't crash

### Error Scenarios

| Error | Handling |
|-------|----------|
| Entire CLI not found | Report missing, continue |
| Claude-Mem command fails | Report missing, continue |
| RTK command fails | Report missing, continue |
| Config file corrupted | Use defaults, log warning |
| Git repo check fails | Assume not a git repo, skip |

## Performance Considerations

### Optimization Strategies

1. **Lazy Loading:** Only check when needed (session start)
2. **Caching:** Cache configuration after initial load
3. **Non-blocking:** Asynchronous checks don't block session start
4. **Minimal Overhead:** Fast checks (file existence, simple commands)

### Benchmarks

- Entire CLI check: ~10ms (file system)
- Claude-Mem check: ~50ms (command execution)
- RTK check: ~50ms (command execution)
- Total overhead: <100ms per session start

## Extension Points

### Adding New Components

To add a new memory management component:

1. Implement checker in `MemoryStackChecker`
2. Add to `StatusAggregator`
3. Update configuration schema if needed
4. Add to status output format

### Example: Adding New Component

```typescript
async checkNewComponent(): Promise<ComponentStatus> {
  try {
    const result = await exec('new-component status');
    return {
      name: 'New Component',
      status: 'active',
      details: result.stdout
    };
  } catch (error) {
    return {
      name: 'New Component',
      status: 'not-installed',
      details: 'New Component not found'
    };
  }
}
```

## Security Considerations

### Command Execution

- Only execute known, trusted commands
- Validate user input before execution
- Use child_process with proper error handling
- Avoid shell injection vulnerabilities

### File System Access

- Only access expected directories
- Validate file paths before reading
- Handle permission errors gracefully
- Don't expose sensitive information

## Testing Strategy

### Unit Tests

- Component checkers
- Status aggregation
- Mode handling
- Configuration loading

### Integration Tests

- Plugin loading
- Session start hook
- Full workflow end-to-end

### Manual Tests

- Different platforms
- Various configurations
- Edge cases and error scenarios

## Future Enhancements

### Potential Improvements

1. **Custom Components:** Allow users to add custom checks
2. **Webhook Integration:** Send status to external services
3. **Metrics Dashboard:** Historical performance tracking
4. **Auto-Recovery:** Attempt to fix missing components automatically
5. **Team Configuration:** Share configuration across teams

## Next Steps

- Set up Claude Code: [Claude Code Integration](claude-code.md)
- Check platform support: [Platform Support](platforms.md)
- Learn usage: [Usage](../user-guide/usage.md)
