# Contributing to DockerCraft SMP

Thank you for your interest in contributing to DockerCraft SMP! This document provides guidelines for contributing.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:

- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Your environment (OS, Docker version, etc.)
- Relevant logs

### Suggesting Features

We welcome feature suggestions! Please:

- Check if the feature has already been suggested
- Describe the use case
- Explain why it would be useful

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit with clear messages
5. Push to your fork
6. Open a Pull Request

### Code Style

- Use shellcheck for bash scripts
- Follow existing code patterns
- Comment complex logic
- Update documentation for new features

## Development Setup

```bash
# Clone your fork
git clone https://github.com/your-username/dockercraft-smp.git
cd dockercraft-smp

# Run locally
docker-compose up -d --build

# Test changes
./scripts/test.sh
```

## Questions?

Feel free to open a discussion for questions or join our community.

Thank you for contributing! 🎮
