# Related Projects

OpenCode Auto-Entire is part of a larger ecosystem of tools for AI-assisted development.

## Core Memory Management Stack

### [Entire CLI](https://github.com/entireio/cli)

Session persistence and checkpoint recovery for AI development sessions.

**Key Features:**
- Automatic checkpoint creation on commits
- Session recovery after crashes
- Audit trail of agent decisions
- Multiple backup strategies

**Integration:** OpenCode Auto-Entire automatically checks if Entire is enabled.

**Installation:**
```bash
# macOS
brew tap entireio/tap
brew install entireio/tap/entire

# Linux
# Download from https://github.com/entireio/cli/releases
```

### [Claude-Mem](https://github.com/thedotmack/claude-mem)

Cross-session memory for Claude Code and OpenCode.

**Key Features:**
- Persistent memory across sessions
- Context retention for complex tasks
- Knowledge base building
- Semantic search capabilities

**Integration:** OpenCode Auto-Entire monitors Claude-Mem status.

**Installation:**
```bash
git clone https://github.com/thedotmack/claude-mem.git
cd claude-mem
npm install
npm link
```

### [RTK](https://github.com/rtk-ai/rtk)

Token optimization for AI workflows with 60-90% token savings.

**Key Features:**
- Intelligent token compression
- CLI command optimization
- Detailed efficiency statistics
- Multi-tool support

**Integration:** OpenCode Auto-Entire monitors RTK status and efficiency.

**Installation:**
```bash
git clone https://github.com/rtk-ai/rtk.git
cd rtk
npm install
npm link
```

## AI Development Tools

### [Superpowers](https://github.com/obra/superpowers)

Workflow patterns and best practices for AI agents.

**Key Features:**
- Reusable agent patterns
- Task decomposition templates
- Quality assurance checklists
- Documentation standards

**Relationship:** Inspirational source for this plugin's design.

### [OpenCode](https://opencode.ai)

AI-powered code editor and development environment.

**Key Features:**
- Built-in AI assistance
- Plugin system
- Session management
- Multi-language support

**Relationship:** Primary target platform for this plugin.

### [Claude Code](https://claude.ai/code)

AI-powered development environment by Anthropic.

**Key Features:**
- Claude integration
- Multi-file editing
- Terminal integration
- Plugin support

**Relationship:** Supported alternative platform for this plugin.

## Complementary Tools

### [Git Worktrees](https://git-scm.com/docs/git-worktree)

Multiple working directories for a single git repository.

**Use Case:** Work on multiple branches simultaneously.

**Integration:** Works seamlessly with Entire CLI for isolated development environments.

### [Docker](https://www.docker.com)

Containerized development environments.

**Use Case:** Consistent development environments across platforms.

**Integration:** OpenCode Auto-Entire can run in containerized environments.

### [VS Code](https://code.visualstudio.com)

Popular code editor with extensive plugin ecosystem.

**Use Case:** Alternative IDE for development.

**Integration:** While not directly supported, concepts apply to VS Code workflows.

## Learning Resources

### [OpenCode Documentation](https://opencode.ai/docs)

Official documentation for OpenCode platform.

**Topics:**
- Plugin development
- Session management
- AI agent configuration
- Best practices

### [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)

Official documentation for Claude Code.

**Topics:**
- Getting started
- Plugin system
- Configuration
- Tips and tricks

### [Entire CLI Documentation](https://github.com/entireio/cli)

Complete documentation for Entire CLI.

**Topics:**
- Installation guides
- Backup strategies
- Recovery procedures
- Troubleshooting

## Community Projects

### [AI Development Starter Kit](https://github.com/example/ai-dev-starter)

Example project showcasing AI development best practices.

### [OpenCode Plugins Collection](https://github.com/example/opencode-plugins)

Community-maintained collection of OpenCode plugins.

### [Memory Management Patterns](https://github.com/example/mem-management-patterns)

Patterns and practices for managing context in AI development.

## Contributing to the Ecosystem

The AI development ecosystem thrives on community contributions. Consider:

1. **Building new plugins** for OpenCode or Claude Code
2. **Sharing patterns** and best practices
3. **Improving documentation** for existing tools
4. **Reporting bugs** and suggesting features
5. **Helping others** learn these tools

## Integration Examples

### Full Stack Example

```bash
# 1. Enable Entire for session persistence
entire enable --strategy auto-commit

# 2. Start Claude-Mem for cross-session memory
claude-mem init

# 3. Use RTK for token optimization
# (RTK automatically optimizes CLI commands)

# 4. Start OpenCode with Auto-Entire plugin
# Plugin automatically monitors all three components
opencode
```

### CI/CD Integration

```yaml
# Example CI/CD with memory management
steps:
  - name: Enable Entire
    run: entire enable --strategy auto-commit
  
  - name: Run OpenCode with plugin
    run: opencode --auto-entire-mode=auto-init
  
  - name: Backup session
    run: entire backup
```

## Ecosystem Roadmap

The memory management ecosystem is evolving:

- **Better integration** between tools
- **Unified configuration** across components
- **Standardized interfaces** for plugins
- **Enhanced monitoring** and metrics
- **Community collaboration** on shared patterns

## Stay Connected

- **GitHub Discussions:** Share ideas and ask questions
- **Discord/Slack:** Community chat (if available)
- **Twitter/X:** Follow for updates
- **Newsletter:** Subscribe for ecosystem news

## Contributing to Related Projects

Consider contributing to these projects:

- [Entire CLI](https://github.com/entireio/cli) - Contribute features, fixes, documentation
- [Claude-Mem](https://github.com/thedotmack/claude-mem) - Improve memory management
- [RTK](https://github.com/rtk-ai/rtk) - Add new optimizations
- [OpenCode](https://github.com/opencode/opencode) - Enhance the platform

## Acknowledgments

OpenCode Auto-Entire was inspired by and built upon these amazing tools:

- **Entire CLI** for making session persistence possible
- **Claude-Mem** for cross-session memory capabilities
- **RTK** for demonstrating token optimization value
- **Superpowers** for workflow pattern insights
- **OpenCode community** for feedback and testing

---

**Note:** This list is not exhaustive. New tools and projects are constantly being added to the ecosystem.

## Suggest a Project

Know of a project that should be listed here? Open an issue or pull request to add it!
