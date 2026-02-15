#!/bin/bash
#
# Claude Code Auto-Entire Plugin Installer
# macOS, Linux, Windows (via WSL/Git Bash)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration
PLUGIN_NAME="opencode-auto-entire"
CLAUDE_DIR="${HOME}/.claude/plugins/${PLUGIN_NAME}"
ENTIRE_CMD="entire"

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║    Claude Code Auto-Entire Plugin Installer v1.0.0           ║"
    echo "║    Automatic Entire CLI monitoring for Claude Code              ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "$1"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    print_info "Detected OS: $OS"
}

check_prerequisites() {
    print_section "Checking Prerequisites"

    if ! command -v npm &> /dev/null; then
        print_error "npm is required but not installed. Please install Node.js first."
        print_info "Visit: https://nodejs.org/"
        exit 1
    fi
    print_success "npm is installed"

    if [[ ! -d "${HOME}/.claude" ]]; then
        print_info "Creating Claude Code config directory..."
        mkdir -p "${HOME}/.claude"
    fi
    print_success "Claude Code config directory exists"
}

install_entire_cli() {
    print_section "Installing Entire CLI"

    if command -v $ENTIRE_CMD &> /dev/null; then
        print_success "Entire CLI is already installed"
        entire --version
        return 0
    fi

    print_info "Installing Entire CLI..."

    case $OS in
        macos)
            if ! command -v brew &> /dev/null; then
                print_error "Homebrew is required but not installed on macOS"
                print_info "Visit: https://brew.sh/"
                exit 1
            fi
            brew tap entireio/tap
            brew install entireio/tap/entire
            ;;

        linux)
            print_info "Downloading Entire CLI for Linux..."
            curl -fsSL https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64.tar.gz -o /tmp/entire.tar.gz
            sudo tar -xz -C /usr/local/bin -f /tmp/entire.tar.gz entire
            rm /tmp/entire.tar.gz
            ;;

        windows)
            print_error "Please install Entire CLI manually on Windows"
            print_info "Visit: https://github.com/entireio/cli/releases/latest"
            exit 1
            ;;

        *)
            print_error "Unsupported OS: $OS"
            exit 1
            ;;
    esac

    print_success "Entire CLI installed successfully"
    entire --version
}

install_plugin() {
    print_section "Installing Plugin"

    print_info "Creating Claude Code plugin directory..."
    mkdir -p "$CLAUDE_DIR"

    print_info "Copying plugin files..."
    cp -r "$SCRIPT_DIR/.." "$CLAUDE_DIR"

    print_info "Installing dependencies..."
    cd "$CLAUDE_DIR"
    npm install

    print_success "Plugin files installed"
}

configure_mcp_server() {
    print_section "Configuring MCP Server"

    CONFIG_FILE="${HOME}/.claude/settings.json"

    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_info "Creating Claude Code settings file..."
        echo '{"mcpServers": {}}' > "$CONFIG_FILE"
    fi

    MCP_PATH="${HOME}/.claude/plugins/opencode-auto-entire/src/claude-code.ts"

    if grep -q "auto-entire" "$CONFIG_FILE"; then
        print_info "MCP server already configured"
    else
        print_info "Adding MCP server to Claude Code configuration..."
        if command -v jq &> /dev/null; then
            tmp=$(mktemp)
            jq --arg mcp_path "$MCP_PATH" '.mcpServers += {"auto-entire": {"command": "node", "args": [$mcp_path]}}' "$CONFIG_FILE" > "$tmp"
            mv "$tmp" "$CONFIG_FILE"
            print_success "MCP server configured"
        else
            print_warning "jq not found. Please configure MCP server manually."
            print_info "Edit $CONFIG_FILE and add to 'mcpServers':"
            cat <<EOF
  "auto-entire": {
    "command": "node",
    "args": ["${MCP_PATH}"]
  }
EOF
        fi
    fi
}

create_config_example() {
    print_section "Creating Configuration"

    CONFIG_PATH="${HOME}/.claude/entire-check.json"

    if [[ -f "$CONFIG_PATH" ]]; then
        print_info "Configuration file already exists: $CONFIG_PATH"
        return
    fi

    print_info "Creating default configuration..."
    cat > "$CONFIG_PATH" << 'EOF'
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
EOF

    print_success "Configuration created: $CONFIG_PATH"
    print_info "You can edit this file to customize behavior"
}

suggest_wrapper() {
    print_section "Wrapper Script Option"

    print_info "For automatic memory stack checking like OpenCode:"
    print_info ""
    print_info "Add this alias to ~/.bashrc or ~/.zshrc:"
    echo ""
    echo "  ${GREEN}alias claude='~/.claude/plugins/opencode-auto-entire/scripts/claude-wrapper.sh'${NC}"
    echo ""
    print_info "Then reload: ${GREEN}source ~/.bashrc${NC}"
    echo ""
    print_info "See docs/CLAUDE_WRAPPER.md for full documentation"
}

print_completion() {
    print_section "Installation Complete!"

    echo ""
    print_success "Claude Code Auto-Entire is now installed and ready to use."
    echo ""
    print_info "Configuration: ${HOME}/.claude/entire-check.json"
    print_info "Documentation: ${CLAUDE_DIR}/docs/CLAUDE_CODE.md"
    echo ""
    print_info "Available MCP tools:"
    echo "  • check_memory_stack - Check Entire, Claude-Mem, and RTK status"
    echo "  • enable_entire - Auto-initialize Entire CLI in current directory"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart Claude Code"
    echo "  2. Open a git repository"
    echo "  3. Use: \"Check memory stack with auto-entire\" to see status"
    echo "  4. Use: \"Enable Entire with auto-entire\" to initialize Entire"
    echo ""
    print_info "To disable notifications, edit config file and set:"
    echo "  {\"mode\": \"silent\"}"
    echo ""
}

# Main installation flow
main() {
    print_header
    detect_os
    check_prerequisites
    install_entire_cli
    install_plugin
    configure_mcp_server
    create_config_example
    suggest_wrapper
    print_completion
}

# Run main function
main
