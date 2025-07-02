# Package Development Guide for Claude Code

**AI-powered package development using Linear Issues for the packages directory**

This document is specifically for developing feature-specific packages in the packages directory. For general project setup and main application development, see [../CLAUDE.md](../CLAUDE.md).

## Reference Documentation

- **Main Project Configuration**: [../CLAUDE.md](../CLAUDE.md)
- **Human-friendly Guide**: [HUMAN.md](HUMAN.md)
- **Claude 4 Best Practices**: [../docs/CLAUDE_4_BEST_PRACTICES.md](../docs/CLAUDE_4_BEST_PRACTICES.md)

## Package-Specific Development

This directory contains feature-specific packages extracted from the main application. Each package follows:

- **Single Responsibility**: One package, one clear functionality
- **Independence**: Minimal dependencies between packages
- **Reusability**: Designed for use across multiple applications
- **AI Review-First**: Follows the review methodology detailed in the main configuration

## Package Development Commands

### Package-Specific Linear Commands

```bash
# Package development (use package-related Issue IDs)
/linear PKG-001    # Create new package
/linear PKG-002    # Add feature to existing package
/linear PKG-003    # Package refactoring/optimization
```

### Current Packages

- **app_preferences**: Application settings (language, theme, persistence)

## Package Creation Workflow

### Manual Package Creation with Flutter Commands

When creating new packages manually (before using Linear automation):

```bash
# 1. Navigate to packages directory
cd packages

# 2. Create new package using Flutter command
flutter create --template=package [package_name]

# 3. Configure package for workspace
cd [package_name]
echo "resolution: workspace" >> pubspec.yaml

# 4. Add standard dependencies
flutter pub add flutter_riverpod riverpod_annotation
flutter pub add --dev build_runner riverpod_generator yumemi_lints

# 5. Set up yumemi_lints configuration
# Get Flutter version for lints compatibility
FLUTTER_VERSION=$(flutter --version | head -n 1 | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")

# Create analysis_options.yaml
cat > analysis_options.yaml << EOF
include: package:yumemi_lints/flutter/\${FLUTTER_VERSION}/recommended.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  plugins:
    - custom_lint

formatter:
  trailing_commas: preserve
EOF

# 6. Register package in workspace
# Add to root pubspec.yaml workspace section:
# workspace:
#   - app
#   - packages/app_preferences
#   - packages/[package_name]  # Add this line

# 7. Install dependencies and generate code
cd ../../
melos run get
melos run gen
```

### Automated Package Development with Linear Issues

For automated package development:

1. **Create Package Issue**: Use PKG-XXX format for package-related Issues
2. **Execute Command**: `/linear PKG-XXX` for automatic package development
3. **AI Review Process**: Automatic 3-4 review cycles for quality assurance
4. **Integration**: Automatic workspace registration and main app integration

## Package Architecture

### Standard Package Structure

```
lib/
├── [package_name].dart     # Public API
├── src/
│   ├── providers/          # Riverpod state management
│   ├── repositories/       # Data access layer
│   ├── models/            # Data models
│   ├── widgets/           # UI components
│   └── utils/             # Utilities
├── assets/                # Static resources
└── test/                  # Tests
```

## AI Review Integration

### Automated Quality Assurance

Package development automatically includes:

1. **Security Review**: Input validation, error handling, data sanitization
2. **Architecture Review**: SOLID principles, dependency management
3. **Performance Review**: Memory usage, async operations, state efficiency
4. **Final Human Verification**: Business requirements and integration testing

### Quality Gates

- Code coverage: 80% minimum
- Static analysis: All checks pass
- Documentation: Complete API documentation
- Tests: Unit, widget, and integration tests

## Package Development Standards

### yumemi_lints Configuration

All packages must include yumemi_lints for consistent code quality:

```yaml
# analysis_options.yaml template for each package
include: package:yumemi_lints/flutter/[FLUTTER_VERSION]/recommended.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  plugins:
    - custom_lint

formatter:
  trailing_commas: preserve
```

### Required Dependencies

Standard dependencies for all packages:

```yaml
# pubspec.yaml dependencies
dependencies:
  flutter:
    sdk: flutter
  hooks_riverpod: ^2.x.x
  riverpod_annotation: ^2.x.x

dev_dependencies:
  build_runner: ^2.x.x
  riverpod_generator: ^2.x.x
  yumemi_lints: ^1.x.x
  custom_lint: ^0.5.x
```

### Design Principles

- **Single Responsibility**: One package = one clear functionality
- **Loose Coupling**: Minimal dependencies between packages
- **High Cohesion**: Related features grouped together
- **Dependency Injection**: Use Riverpod for clean architecture
- **Code Quality**: Enforce yumemi_lints standards across all packages

### Examples

✅ **Good**: `user_authentication` - Authentication only  
✅ **Good**: `payment_processing` - Payment handling only  
❌ **Bad**: `common_utils` - Mixed functionalities

## Development Commands

### Package Development

```bash
# Automatic package development via Linear
claude
/linear PKG-123  # Creates/updates package automatically

# Manual commands (when needed)
cd packages/[package_name]
melos run gen    # Code generation
flutter test     # Run tests
dart analyze     # Static analysis
```

## Package Integration

### Automatic Integration

When using `/linear PKG-XXX`, integration is automatic:

- Workspace registration in root `pubspec.yaml`
- Main app dependency configuration
- Provider setup and initialization
- Documentation updates

### Manual Integration (if needed)

Refer to [../CLAUDE.md](../CLAUDE.md) for detailed integration steps.

## Package Examples

### app_preferences Package

**Purpose**: Application settings management  
**Components**: Locale/theme providers, settings dialogs, preferences repository  
**Integration**: Used in main app for user preferences

For detailed implementation, see the package source code or use `/linear PKG-XXX` to analyze existing packages.

## Package Guidelines

### When to Create a Package

- Used across multiple screens/features
- Can be tested independently
- Potential for reuse in other projects
- Contains specific domain logic

### When NOT to Create a Package

- Single-use, simple functionality
- Tightly coupled to main app logic
- Very small utility functions
- UI components specific to one screen

## Monorepo Commands

### Workspace-wide Commands

```bash
# From project root
melos run gen      # Generate code for all packages
melos run test     # Test all packages
melos run analyze  # Analyze all packages
melos run format   # Format all packages
melos run get      # Get dependencies for all packages
```

## Summary

For package development in this project:

1. **Use Linear Issues**: Create PKG-XXX Issues for package work
2. **Leverage Automation**: Use `/linear PKG-XXX` for automated development
3. **Follow Standards**: Single responsibility, loose coupling, high cohesion
4. **Trust the Process**: AI Review-First ensures quality automatically

For comprehensive project setup, main app development, and detailed workflows, refer to [../CLAUDE.md](../CLAUDE.md) and [../HUMAN.md](../HUMAN.md).
