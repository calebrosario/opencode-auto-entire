# Development

This section covers contributing to OpenCode Auto-Entire and understanding project development.

## Table of Contents

- [Contributing](contributing.md) - How to contribute to the project
- [Changelog](changelog.md) - Project version history and changes
- [License](license.md) - License information and usage

## Getting Started with Development

### Prerequisites

- Node.js 18+
- Git
- TypeScript knowledge
- OpenCode or Claude Code installed

### Development Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-auto-entire.git
cd opencode-auto-entire

# Install dependencies
npm install

# Link for local development
npm link
```

### Running Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test file
npm test -- plugin.test.ts
```

### Building

```bash
# Build TypeScript
npm run build

# Watch for changes
npm run build -- --watch
```

## Development Workflow

1. Create a feature branch
2. Make your changes
3. Write tests for new functionality
4. Run tests and linting
5. Commit with clear messages
6. Push and create a pull request

## Code Style

- Follow TypeScript best practices
- Use 2-space indentation
- Add JSDoc comments for public APIs
- Keep functions small and focused

## Project Structure

```
opencode-auto-entire/
├── src/
│   ├── plugin.ts           # Main plugin entry point
│   ├── checker.ts          # Memory stack checker
│   ├── config.ts           # Configuration loader
│   └── utils.ts            # Utility functions
├── scripts/
│   ├── install.sh          # macOS/Linux installer
│   └── install.ps1         # Windows installer
├── docs/
│   ├── index.md            # Documentation home
│   └── ...                 # Additional docs
├── tests/
│   ├── plugin.test.ts      # Plugin tests
│   └── checker.test.ts     # Checker tests
├── package.json            # Dependencies
├── tsconfig.json           # TypeScript config
└── README.md               # Project readme
```

## Next Steps

- Contribute to the project: [Contributing](contributing.md)
- Review version history: [Changelog](changelog.md)
- Check license information: [License](license.md)
