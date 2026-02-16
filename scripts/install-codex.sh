#!/bin/bash

# OpenCode Auto-Entire Codex CLI Installer
# Installs the plugin for Codex CLI with MCP server and Skill support

set -e

echo "🚀 Installing OpenCode Auto-Entire for Codex CLI..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux*)     MACHINE=Linux;;
  Darwin*)    MACHINE=Mac;;
  *)          MACHINE="UNKNOWN:${OS}"
esac

echo "📱 Detected: $MACHINE"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
  echo "❌ Node.js is not installed. Please install Node.js 18+ first."
  echo "   Visit: https://nodejs.org/"
  exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f1 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  echo "❌ Node.js version $NODE_VERSION is too old. Please upgrade to 18+."
  exit 1
fi

echo "✅ Node.js $(node -v) detected"
echo ""

# Create Codex plugin directory
CODEX_PLUGIN_DIR="$HOME/.codex/plugins/opencode-auto-entire"
echo "📦 Installing to: $CODEX_PLUGIN_DIR"

mkdir -p "$CODEX_PLUGIN_DIR"

# Copy plugin files
echo "📋 Copying plugin files..."
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cp -r "$REPO_DIR/"* "$CODEX_PLUGIN_DIR/"
cd "$CODEX_PLUGIN_DIR"

# Install dependencies
echo "📦 Installing dependencies..."
npm install --silent

if [ $? -ne 0 ]; then
  echo "❌ Failed to install dependencies."
  exit 1
fi

echo "✅ Dependencies installed"
echo ""

# Create config.toml.example
CONFIG_EXAMPLE="$REPO_DIR/codex.example.toml"
if [ -f "$CONFIG_EXAMPLE" ]; then
  echo "📝 Codex configuration example created at: $CONFIG_EXAMPLE"
  echo ""
  echo "To configure MCP server, add to ~/.codex/config.toml:"
  echo ""
  cat "$CONFIG_EXAMPLE"
  echo ""
  echo "Replace YOUR_USERNAME with your actual username."
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📚 Next steps:"
echo ""
echo "1. ${GREEN}Option 1: Codex Skill (Auto-Invoke)${NC}"
echo "   Skill is already installed at: .agents/skills/auto-entire/"
echo "   Codex will auto-invoke based on prompt matching."
echo ""
echo "2. ${BLUE}Option 2: MCP Server${NC}"
echo "   Add to ~/.codex/config.toml:"
echo "   [mcp_servers.auto-entire]"
echo "   command = \"node\""
echo "   args = [\"$CODEX_PLUGIN_DIR/src/claude-code.ts\"]"
echo ""
echo "3. ${YELLOW}Option 3: Wrapper Script (Automatic)${NC}"
echo "   Add alias to ~/.bashrc or ~/.zshrc:"
echo "   alias codex='$CODEX_PLUGIN_DIR/scripts/codex-wrapper.sh'"
echo "   source ~/.bashrc  # or ~/.zshrc"
echo ""
echo "📖 See docs/CODEX.md for detailed usage instructions."
echo ""
echo "✨ Happy coding!"
