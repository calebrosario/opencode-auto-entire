#!/bin/bash
#
# Claude Code Wrapper with Automatic Memory Stack Checking
# Checks memory stack before launching Claude Code
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONFIG_PATH="${HOME}/.claude/entire-check.json"
WORKING_DIR="$(pwd)"

# Load configuration
load_config() {
    if [[ -f "$CONFIG_PATH" ]]; then
        ENABLED=$(jq -r '.enabled // true' "$CONFIG_PATH" 2>/dev/null || echo "true")
        MODE=$(jq -r '.mode // "prompt"' "$CONFIG_PATH" 2>/dev/null || echo "prompt")
        CHECK_GIT=$(jq -r '.checkGitRepo // true' "$CONFIG_PATH" 2>/dev/null || echo "true")
        AUTO_INIT=false
    else
        ENABLED="true"
        MODE="prompt"
        CHECK_GIT="true"
        AUTO_INIT=false
    fi
}

# Check if directory is a git repository
is_git_repo() {
    if [[ "$CHECK_GIT" == "false" ]]; then
        return 0
    fi

    if git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Check if Entire CLI is enabled
is_entire_enabled() {
    [[ -f "$WORKING_DIR/.entire/settings.json" ]]
}

# Check if Claude-Mem is installed
is_claude_mem_installed() {
    [[ -f "$HOME/.claude-mem/claude-mem.db" ]]
}

# Check if RTK is installed
is_rtk_installed() {
    command -v rtk &> /dev/null
}

# Get RTK efficiency
get_rtk_efficiency() {
    if is_rtk_installed; then
        rtk gain --json 2>/dev/null | jq -r '.efficiency // "N/A"' 2>/dev/null || echo "N/A"
    else
        echo "Not installed"
    fi
}

# Display memory stack status
show_memory_status() {
    local entire_enabled=$1
    local show_warning=$2

    if [[ "$entire_enabled" == "true" ]] && [[ "$show_warning" == "false" ]]; then
        return
    fi

    local entire_status
    local claude_mem_status
    local rtk_status

    if is_entire_enabled; then
        entire_status="${GREEN}✅${NC} Enabled"
    else
        entire_status="${YELLOW}⚠️${NC} Not initialized"
    fi

    if is_claude_mem_installed; then
        claude_mem_status="${GREEN}✅${NC} Active"
    else
        claude_mem_status="${RED}❌${NC} Not installed"
    fi

    if is_rtk_installed; then
        local efficiency=$(get_rtk_efficiency)
        rtk_status="${GREEN}✅${NC} Active ($efficiency)"
    else
        rtk_status="${RED}❌${NC} Not installed"
    fi

    if [[ "$entire_enabled" == "true" ]] && [[ "$show_warning" == "false" ]]; then
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}🧠 Memory Stack Status${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "$entire_status   Entire CLI"
        echo -e "$claude_mem_status   Claude-Mem"
        echo -e "$rtk_status   RTK"
        echo ""
        echo -e "${GREEN}All systems operational. 🚀${NC}"
    else
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}📝 Memory Management Check${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "$entire_status   **Entire CLI**"
        if ! is_entire_enabled; then
            echo -e "   ${YELLOW}→${NC} Run: ${GREEN}entire enable --strategy auto-commit${NC}"
        fi
        echo ""
        echo -e "$claude_mem_status   **Claude-Mem**"
        echo ""
        echo -e "$rtk_status   **RTK**"
        echo ""
        echo -e "${BLUE}**Why this matters:**${NC}"
        echo -e "• Entire = Session checkpoint/recovery (crash protection)"
        echo -e "• Claude-Mem = Cross-session memory (context persistence)"
        echo -e "• RTK = Token optimization (60-90% savings)"
        echo ""

        if ! is_entire_enabled; then
            echo -e "${YELLOW}**Recommendation:**${NC} Enable Entire to prevent context loss on crashes."
        fi

        echo ""
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi
}

# Auto-initialize Entire
auto_init_entire() {
    if [[ "$MODE" != "auto-init" ]]; then
        return 1
    fi

    if is_entire_enabled; then
        return 0
    fi

    echo -e "${BLUE}Auto-initializing Entire CLI...${NC}"

    if entire enable --strategy auto-commit; then
        echo -e "${GREEN}✓${NC} Entire CLI initialized successfully"
        return 0
    else
        echo -e "${RED}✗${NC} Failed to initialize Entire CLI"
        return 1
    fi
}

# Main execution
main() {
    load_config

    if [[ "$ENABLED" == "false" ]]; then
        exec claude "$@"
    fi

    if ! is_git_repo; then
        exec claude "$@"
    fi

    local entire_enabled=false
    is_entire_enabled && entire_enabled=true

    show_memory_status "$entire_enabled" "false"

    if [[ "$MODE" == "auto-init" ]]; then
        auto_init_entire
        if [[ $? -eq 0 ]]; then
            show_memory_status "true" "false"
        else
            echo ""
            echo -e "${YELLOW}Press Enter to continue...${NC}"
            read -r
        fi
    elif [[ ! "$entire_enabled" ]]; then
        if [[ "$MODE" == "silent" ]]; then
            echo -e "${YELLOW}[entire-check] Entire not enabled in $WORKING_DIR${NC}"
        else
            echo ""
            echo -e "${YELLOW}Press Enter to continue...${NC}"
            read -r
        fi
    fi

    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Starting Claude Code...${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    exec claude "$@"
}

# Run main function
main "$@"
