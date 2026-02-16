#!/bin/bash

# Codex CLI wrapper script for automatic memory stack checking
# Usage: alias codex='~/.codex/plugins/opencode-auto-entire/scripts/codex-wrapper.sh'

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECK_SCRIPT="$PLUGIN_DIR/.agents/skills/auto-entire/scripts/check-memory.js"

# Run memory stack check before launching Codex
if [ -f "$CHECK_SCRIPT" ]; then
  node "$CHECK_SCRIPT"
  CHECK_EXIT_CODE=$?

  if [ $CHECK_EXIT_CODE -ne 0 ]; then
    # Check failed (Entire not enabled)
    echo ""
    echo "⚠️  Memory stack check failed. Please fix the issues above before continuing."
    echo "Press Enter to continue anyway, or Ctrl+C to cancel..."
    read
  fi
else
  echo "Warning: Check script not found at $CHECK_SCRIPT"
fi

# Launch Codex with original arguments
exec codex "$@"
