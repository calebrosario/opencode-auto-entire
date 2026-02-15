# Contributing

Thank you for your interest in contributing to OpenCode Auto-Entire!

## Getting Started

### Prerequisites

- Node.js 18+
- Git
- TypeScript knowledge
- Familiarity with OpenCode or Claude Code plugin system

### Development Setup

```bash
# 1. Fork the repository
# Click "Fork" on GitHub

# 2. Clone your fork
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# 3. Add upstream remote
git remote add upstream https://github.com/original-owner/opencode-auto-entire.git

# 4. Install dependencies
npm install

# 5. Link for local development
npm link
```

## Development Workflow

### 1. Create a Branch

```bash
# Update your local main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
```

### 2. Make Changes

- Write clear, concise code
- Add tests for new functionality
- Update documentation as needed
- Follow existing code style

### 3. Run Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run linter
npm run lint

# Run type check
npm run type-check
```

### 4. Commit Changes

```bash
# Stage your changes
git add .

# Commit with clear message
git commit -m "feat: add support for new component X"

# Follow conventional commits:
# feat: new feature
# fix: bug fix
# docs: documentation changes
# style: formatting, etc.
# refactor: code refactoring
# test: adding or updating tests
# chore: maintenance tasks
```

### 5. Push and Create PR

```bash
# Push to your fork
git push origin feature/your-feature-name

# Create pull request on GitHub
# Include:
# - Clear description of changes
# - Related issues (fixes #123)
# - Screenshots if applicable
# - Testing instructions
```

## Code Style Guidelines

### TypeScript

- Use TypeScript for all new code
- Enable strict mode in tsconfig.json
- Avoid `any` types
- Use interfaces for type definitions
- Add JSDoc comments for public APIs

### Code Organization

- Keep functions small and focused
- Use meaningful variable names
- Avoid deep nesting
- Extract reusable logic into utility functions

### Testing

- Write tests for new functionality
- Aim for high code coverage
- Test both happy path and error cases
- Use descriptive test names

### Documentation

- Update README.md if user-facing changes
- Add inline comments for complex logic
- Update documentation in docs/ folder
- Keep examples up-to-date

## Types of Contributions

### Bug Fixes

1. Check existing issues first
2. Reproduce the bug
3. Write a test that fails
4. Fix the bug
5. Ensure tests pass

### New Features

1. Open an issue to discuss first
2. Get feedback from maintainers
3. Implement the feature
4. Add tests and documentation
5. Submit PR

### Documentation

1. Fix typos or clarify confusing sections
2. Add missing information
3. Create new guides or tutorials
4. Improve examples

### Bug Reports

When reporting bugs, include:

- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment information (OS, Node.js version, etc.)
- Screenshots if applicable

### Feature Requests

When requesting features, include:

- Clear description of the feature
- Why you need it
- Proposed solution (if you have one)
- Alternatives you've considered

## Pull Request Guidelines

### PR Checklist

Before submitting a PR, ensure:

- [ ] Tests pass locally
- [ ] Code follows project style
- [ ] Documentation is updated
- [ ] Commit messages follow conventional commits
- [ ] PR description is clear and complete

### PR Review Process

1. Automated checks (CI/CD)
2. Code review by maintainers
3. Requested changes (if any)
4. Approval
5. Merge to main branch

### Expected Timeline

- Initial review: 2-3 business days
- Simple changes: merged quickly
- Complex changes: may require discussion
- All PRs receive feedback

## Project Goals

### Current Focus

- Improving plugin reliability
- Adding support for more platforms
- Enhancing user experience
- Performance optimization

### Future Roadmap

See [GitHub Issues](https://github.com/yourusername/opencode-auto-entire/issues) for current roadmap items.

## Community Guidelines

### Be Respectful

- Treat everyone with respect
- Welcome newcomers
- Assume good intentions
- Focus on constructive feedback

### Be Collaborative

- Work openly and transparently
- Share knowledge freely
- Help others learn
- Give credit where due

### Be Inclusive

- Welcome diverse perspectives
- Use inclusive language
- Be patient with language barriers
- Accommodate different time zones

## Getting Help

### Questions

- Check existing documentation first
- Search GitHub issues
- Ask in discussions (if available)
- Contact maintainers privately only for sensitive issues

### Issues

- Use GitHub Issues for bug reports and feature requests
- Provide clear, reproducible examples
- Include environment information
- Check for duplicates first

### Discussions

- Use GitHub Discussions for questions and ideas
- Be specific about your problem
- Share what you've tried already
- Help others when you can

## Recognition

Contributors are recognized in:

- CONTRIBUTORS.md file
- GitHub contributors list
- Release notes
- Project documentation

Thank you for contributing! 🎉

## Resources

- [Project Repository](https://github.com/yourusername/opencode-auto-entire)
- [Issue Tracker](https://github.com/yourusername/opencode-auto-entire/issues)
- [Pull Requests](https://github.com/yourusername/opencode-auto-entire/pulls)
- [Documentation](../index.md)
