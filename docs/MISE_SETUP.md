# mise Setup Guide

This project uses [mise](https://mise.jdx.dev/) for managing development tools and runtime versions.

## What is mise?

mise (formerly known as rtx) is a polyglot tool version manager. It manages development tools like Flutter, Node.js, bun, and more, ensuring consistent versions across all development environments.

## Installation

### macOS/Linux

```bash
curl https://mise.run | sh
```

### Add to shell

Add the following to your shell profile (`.bashrc`, `.zshrc`, etc.):

```bash
eval "$(mise activate bash)"  # for bash
eval "$(mise activate zsh)"   # for zsh
```

## Project Setup

1. **Install project tools**:

   ```bash
   mise install
   ```

2. **Verify installation**:

   ```bash
   mise list
   flutter --version
   bun --version
   ```

3. **Activate environment** (if not using shell integration):
   ```bash
   eval "$(mise activate bash)"
   ```

## Tool Versions

The project uses the following tool versions:

- **Flutter**: 3.32.2
- **bun**: 1.2.17

These versions are defined in:

- `.tool-versions` (asdf/mise format)
- `.mise.toml` (mise configuration with environment variables and tasks)

## Migration from fvm

If you were previously using fvm, you can remove the old configuration:

```bash
# Remove fvm configuration (optional)
rm -rf .fvm/
rm .fvmrc

# Ensure mise tools are installed
mise install
```

## IDE Integration

### VS Code

Install the mise extension for VS Code to automatically activate the mise environment.

### Other IDEs

Make sure your IDE is configured to use the Flutter SDK from mise:

```bash
mise where flutter
```

## CI/CD

The CI/CD pipeline automatically installs and uses mise via the `.github/actions/setup-mise` action.

## Troubleshooting

### Tools not found

Make sure mise is activated in your shell:

```bash
eval "$(mise activate bash)"
```

### Version conflicts

Check if the correct versions are installed:

```bash
mise list
mise install  # reinstall if needed
```

### PATH issues

Verify the mise environment is properly set:

```bash
echo $PATH
which flutter
which bun
```

## Development Workflows

### Code Quality Check

```bash
melos run analyze
melos run test
melos run format:prettier
melos run format
```

### Development Environment Setup

```bash
mise install
eval "$(mise activate bash)"
melos run get
melos run gen
```

### Release Preparation

```bash
melos run analyze
melos run test
melos run ci:format
melos run format:prettier
melos run format
```

## Additional Resources

- [mise Documentation](https://mise.jdx.dev/)
- [mise GitHub Repository](https://github.com/jdx/mise)
- [Configuration Reference](https://mise.jdx.dev/configuration.html)
