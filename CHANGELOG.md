# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-15

### Added
- Initial release of OpenCode Auto-Entire plugin
- Automatic Entire CLI detection on session start
- Full memory stack monitoring (Entire + Claude-Mem + RTK)
- Three modes: prompt, auto-init, silent
- Cross-platform install scripts (macOS, Linux, Windows)
- Configuration file support
- Git repository detection
- Status display when all systems are operational
- Comprehensive documentation
- Claude Code installation instructions

### Features
- **Prompt Mode**: Shows friendly reminder with fix instructions
- **Auto-init Mode**: Automatically enables Entire (use with caution)
- **Silent Mode**: Logs only, no UI notification
- **Stack Monitoring**: Checks Entire, Claude-Mem, and RTK status
- **Configurable**: JSON configuration file support

[1.0.0]: https://github.com/yourusername/opencode-auto-entire/releases/tag/v1.0.0

## [1.0.1] - 2026-02-17

### Fixes
- Fixed grammar in subtitle (changed "&" to "and")
- Added "usage" to Codex setup guide link for clarity

### Documentation
- Clarified Requirements section to distinguish required vs optional tools
- Added GitHub links to Entire CLI, Claude-Mem, and RTK
- Removed all references to non-existent GitHub Copilot documentation
- Updated Platform Support Options table (removed VS Code)
- Updated Integration Comparison table (removed GitHub Copilot)
- Fixed duplicate/confusing recommendation sections
