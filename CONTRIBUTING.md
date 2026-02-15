# Contributing to OpenCode Auto-Entire

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Code of Conduct

Be respectful and constructive. We're all here to make AI-assisted development better.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported
2. Create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (OS, OpenCode version, etc.)

### Suggesting Features

1. Open an issue with the "feature request" label
2. Describe the use case and proposed solution
3. Discuss with maintainers before implementing

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Add tests if applicable
5. Update documentation
6. Submit a pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/opencode-auto-entire.git
cd opencode-auto-entire

# Install dependencies
npm install

# Run type check
npm run typecheck

# Test locally
cd ~/.config/opencode/plugins/
ln -s /path/to/opencode-auto-entire
# Add to opencode.json and restart OpenCode
```

## Code Style

- Use TypeScript
- Follow existing patterns
- Add comments for complex logic
- Keep functions focused and small

## Testing

Test your changes:
1. In OpenCode with different modes (prompt/auto-init/silent)
2. In git and non-git repositories
3. With and without Entire enabled
4. On your target platform

## Documentation

Update relevant documentation:
- README.md for user-facing changes
- docs/CLAUDE_CODE.md for Claude-specific info
- This file for contribution process changes

## Release Process

Maintainers will:
1. Update version in package.json
2. Update CHANGELOG.md
3. Create a git tag
4. Push to trigger GitHub Actions release

## Questions?

Open an issue or start a discussion!

Thank you for contributing!
