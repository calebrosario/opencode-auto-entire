#!/bin/bash
#
# OpenCode Auto-Entire Plugin Installer
# Supports: macOS, Linux, Windows (via WSL/Git Bash)
# This script installs both the plugin and Entire CLI
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
PLUGIN_DIR="${HOME}/.config/opencode/plugins/${PLUGIN_NAME}"
ENTIRE_CMD="entire"

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     OpenCode Auto-Entire Plugin Installer v1.0.0          ║"
    echo "║     Automatic Entire CLI monitoring for OpenCode          ║"
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
    print_info "Checking prerequisites..."
    
    # Check for git
    if ! command -v git &> /dev/null; then
        print_error "git is required but not installed. Please install git first."
        exit 1
    fi
    print_success "git is installed"
    
    # Check for Node.js/npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is required but not installed. Please install Node.js first."
        print_info "Visit: https://nodejs.org/"
        exit 1
    fi
    print_success "npm is installed"
    
    # Check for OpenCode config directory
    if [[ ! -d "${HOME}/.config/opencode" ]]; then
        print_warning "OpenCode config directory not found. Creating..."
        mkdir -p "${HOME}/.config/opencode"
    fi
    print_success "OpenCode config directory exists"
}

install_entire_cli() {
    print_info "Checking Entire CLI installation..."
    
    if command -v $ENTIRE_CMD &> /dev/null; then
        print_success "Entire CLI is already installed"
        entire --version
        return 0
    fi
    
    print_info "Installing Entire CLI..."
    
    case $OS in
        macos)
            if command -v brew &> /dev/null; then
                print_info "Installing via Homebrew..."
                brew tap entireio/tap
                brew install entireio/tap/entire
            else
                print_warning "Homebrew not found. Attempting to install Homebrew first..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                brew tap entireio/tap
                brew install entireio/tap/entire
            fi
            ;;
        linux)
            # Try various package managers
            if command -v brew &> /dev/null; then
                print_info "Installing via Linuxbrew..."
                brew tap entireio/tap
                brew install entireio/tap/entire
            elif command -v apt-get &> /dev/null; then
                print_info "Installing via apt (Debian/Ubuntu)..."
                # Download latest release
                curl -fsSL https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64.tar.gz | tar -xz
                sudo mv entire /usr/local/bin/
            elif command -v yum &> /dev/null; then
                print_info "Installing via yum (RHEL/CentOS)..."
                curl -fsSL https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64.tar.gz | tar -xz
                sudo mv entire /usr/local/bin/
            elif command -v pacman &> /dev/null; then
                print_info "Installing via pacman (Arch)..."
                curl -fsSL https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64.tar.gz | tar -xz
                sudo mv entire /usr/local/bin/
            else
                print_info "Installing from binary..."
                curl -fsSL https://github.com/entireio/cli/releases/latest/download/entire-linux-amd64.tar.gz | tar -xz
                sudo mv entire /usr/local/bin/
            fi
            ;;
        *)
            print_error "Automatic installation not supported for this OS."
            print_info "Please install Entire CLI manually: https://github.com/entireio/cli"
            return 1
            ;;
    esac
    
    if command -v $ENTIRE_CMD &> /dev/null; then
        print_success "Entire CLI installed successfully"
        entire --version
    else
        print_error "Entire CLI installation failed"
        return 1
    fi
}

install_plugin() {
    print_info "Installing OpenCode Auto-Entire Plugin..."
    
    # Create plugin directory
    if [[ -d "$PLUGIN_DIR" ]]; then
        print_warning "Plugin directory already exists. Backing up..."
        mv "$PLUGIN_DIR" "${PLUGIN_DIR}.backup.$(date +%Y%m%d%H%M%S)"
    fi
    
    mkdir -p "$PLUGIN_DIR"
    
    # Copy plugin files
    if [[ -d "${SCRIPT_DIR}/src" ]]; then
        cp -r "${SCRIPT_DIR}/src" "$PLUGIN_DIR/"
        cp "${SCRIPT_DIR}/package.json" "$PLUGIN_DIR/"
        cp "${SCRIPT_DIR}/tsconfig.json" "$PLUGIN_DIR/"
    else
        print_error "Plugin source files not found in ${SCRIPT_DIR}"
        print_info "Make sure you're running this script from the plugin directory"
        exit 1
    fi
    
    # Install dependencies
    print_info "Installing plugin dependencies..."
    cd "$PLUGIN_DIR"
    npm install
    
    print_success "Plugin installed to $PLUGIN_DIR"
}

configure_opencode() {
    print_info "Configuring OpenCode..."
    
    local config_file="${HOME}/.config/opencode/opencode.json"
    local plugin_path="file://${PLUGIN_DIR}/src/plugin.ts"
    
    # Check if config exists
    if [[ ! -f "$config_file" ]]; then
        print_warning "OpenCode config not found. Creating new config..."
        cat > "$config_file" << EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "plugin": [
    "${plugin_path}"
  ]
}
EOF
    else
        # Check if plugin is already registered
        if grep -q "opencode-auto-entire" "$config_file"; then
            print_warning "Plugin already registered in OpenCode config"
        else
            print_info "Adding plugin to OpenCode config..."
            # This is a simple approach - in reality might need jq for proper JSON manipulation
            print_warning "Please manually add the following to your ~/.config/opencode/opencode.json:"
            echo ""
            echo "\"plugin\": ["
            echo "  \"${plugin_path}\""
            echo "]"
            echo ""
        fi
    fi
}

create_config() {
    print_info "Creating default configuration..."
    
    local config_file="${HOME}/.config/opencode/entire-check.json"
    
    if [[ -f "$config_file" ]]; then
        print_warning "Configuration already exists at $config_file"
        return 0
    fi
    
    cat > "$config_file" << 'EOF'
{
  "enabled": true,
  "mode": "prompt",
  "checkGitRepo": true,
  "showStatus": true
}
EOF
    
    print_success "Default configuration created at $config_file"
}

print_summary() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║              Installation Complete!                        ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    print_success "Entire CLI installed and ready"
    print_success "OpenCode Auto-Entire Plugin installed"
    print_success "Default configuration created"
    echo ""
    echo "Next steps:"
    echo "  1. Restart OpenCode to load the plugin"
    echo "  2. Open a project: cd /path/to/your/project"
    echo "  3. Start OpenCode - you'll see the memory stack check"
    echo ""
    echo "Configuration:"
    echo "  • Plugin location: ${PLUGIN_DIR}"
    echo "  • Config file: ~/.config/opencode/entire-check.json"
    echo ""
    echo "Documentation:"
    echo "  • Plugin README: ${PLUGIN_DIR}/README.md"
    echo "  • Entire CLI: https://github.com/entireio/cli"
    echo ""
    echo "To enable Entire in a project:"
    echo "  cd your-project && entire enable --strategy auto-commit"
    echo ""
}

main() {
    print_header
    detect_os
    check_prerequisites
    install_entire_cli
    install_plugin
    configure_opencode
    create_config
    print_summary
}

# Run main function
main "$@"
