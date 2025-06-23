# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Claude 4 Best Practices Application

This project follows the Claude 4 prompt engineering best practices defined in `docs/CLAUDE_4_BEST_PRACTICES.md`. We emphasize the following principles:

1. **AI Review-First Design**: "Small draft → Critical review → Regenerate → Release" cycle
2. **Clear and Specific Instructions**: Eliminate ambiguity and clearly define expected deliverables
3. **Structured Review Templates**: Evaluate code from security, SOLID principles, and performance perspectives
4. **Iterative Improvement**: Enhance quality through 3-4 review cycles

For details, refer to [Claude 4 Best Practices](docs/CLAUDE_4_BEST_PRACTICES.md).

## Project Overview

This is a Flutter mobile application development project using Claude Code with automated development workflow integrated with Linear Issue management system.

### Technology Stack

- **Framework**: Flutter (Workspace/Monorepo structure)
- **Version Management**: mise (polyglot tool version manager)
- **Task Management**: Linear (MCP integrated)
- **Parallel Development**: git worktree
- **Automation**: Claude Code with background tasks
- **State Management**: Riverpod (hooks_riverpod, riverpod_annotation)
- **Navigation**: go_router (declarative routing)
- **Internationalization**: slang (type-safe translations)
- **Build Tools**: build_runner, freezed
- **Monorepo Management**: Melos + pub workspace

## Project Structure

```
flutter_template_project/
├── app/                         # Main Flutter application
│   ├── lib/
│   │   ├── main.dart           # Entry point
│   │   ├── pages/              # UI pages (home_page.dart, settings_page.dart)
│   │   ├── router/             # go_router config and type-safe route definitions
│   │   └── i18n/               # slang-generated multilingual files
│   ├── assets/i18n/            # JSON translation files (ja.i18n.json, en.i18n.json)
│   └── test/                   # Widget tests
├── packages/
│   └── app_preferences/        # Shared preferences management package
│       ├── lib/
│       │   ├── src/
│       │   │   ├── providers/  # Riverpod providers
│       │   │   ├── repositories/
│       │   │   └── theme/
│       │   └── widgets/        # Reusable widgets
│       └── assets/i18n/        # Package-specific translations
├── pubspec.yaml                # Workspace configuration
└── melos.yaml                  # (integrated in pubspec.yaml)
```

## Environment Setup

### Requirements

- Flutter SDK (managed by mise)
- bun (managed by mise)
- Git worktree support
- Linear MCP configuration completed
- Claude Code ENABLE_BACKGROUND_TASKS enabled
- Node.js (for commitlint, prettier)

## Development Commands

### Melos Commands (Recommended)

```bash
# Code generation (freezed, riverpod, go_router, slang)
melos run gen

# Install dependencies
melos run get

# Static analysis
melos run analyze

# slang translation check
melos run analyze:slang

# Code formatting
melos run format

# Run tests
melos run test

# CI format check
melos run ci:format
```

### Direct Flutter Commands (using mise)

```bash
# Activate mise environment first
eval "$(mise activate bash)"

# Run application
cd app && flutter run

# Run tests (single file)
cd app && flutter test test/widget_test.dart

# Build
cd app && flutter build apk
cd app && flutter build ios --no-codesign
```

### Node.js Related Commands

```bash
# YAML/Markdown lint
npm run lint

# YAML/Markdown format
npm run format
```

### Development Workflow Commands

```bash
# Workflow 1: Code Quality Check
melos run analyze
melos run test
melos run format:prettier
melos run format

# Workflow 2: Development Environment Setup
mise install
eval "$(mise activate bash)"
melos run get
melos run gen

# Workflow 3: Release Preparation
melos run analyze
melos run test
melos run ci:format
melos run format:prettier
melos run format
```

### Environment Variables

```bash
export ENABLE_BACKGROUND_TASKS=true
export FLUTTER_VERSION_MANAGEMENT=mise
export TASK_MANAGEMENT_SYSTEM=linear
export PARALLEL_DEVELOPMENT=git_worktree
export PR_LANGUAGE=japanese
export COMPLETION_NOTIFICATION=alarm
export INTERACTIVE_MODE=true
export ISSUE_SELECTION_UI=enabled
export AUTO_CONFIRM_WITH_ARGS=true      # Skip confirmation when arguments provided
export SILENT_MODE_WITH_ARGS=false      # Continue progress display
export ERROR_ONLY_OUTPUT=false          # Display non-error output
export CLAUDE_ISOLATION_MODE=true       # Work isolation during parallel execution
export CLAUDE_WORKSPACE_DIR=".claude-workspaces" # Project-internal working directory
export CLAUDE_MEMORY_ISOLATION=true     # Memory/context isolation
export GITHUB_ACTIONS_CHECK=true        # Enable GitHub Actions completion check
export CHECK_PR_WORKFLOW="check-pr.yml" # Target workflow file to monitor
```

## Architecture Design

### State Management: Riverpod

- **Providers**: Located in `app_preferences/lib/src/providers/`
- **Code Generation**: Use `@riverpod` annotation, generate with `melos run gen`
- **AsyncValue**: Used for asynchronous operation state management
- **Provider Types**:
  - `StateNotifierProvider`: Logic with state changes
  - `FutureProvider`: Asynchronous data retrieval
  - `StreamProvider`: Real-time data streams

### Navigation: go_router

- **Route Definition**: `app/lib/router/app_routes.dart`
- **Type-safe Routing**: Achieve type safety with `@TypedGoRoute` annotation
- **Navigation Example**: `HomePageRoute().go(context)`

### Internationalization: slang

- **Translation Files**: Place `ja.i18n.json` and `en.i18n.json` in `app/assets/i18n/`
- **Type-safe Access**: Access translation strings with `context.i18n.someKey`
- **Dynamic Switching**: Runtime language switching using LocaleSettings

### Theme Management

- **Theme Provider**: Managed by `app_preferences` package
- **Persistence**: Save selected theme using SharedPreferences
- **System Theme**: Material You (Android 12+) support

## Custom Slash Commands Configuration

### Available Commands

- `/linear` - Linear Issue processing command (see `.claude/commands/linear.md` for detailed implementation)

### Command File Placement

```
.claude/
└── commands/
    └── linear.md          # Complete Linear Issue processing implementation
```

## Development Workflow

### Git Worktree Usage (Recommended)

This project uses **git worktree** for parallel development:

1. **Parallel Development**: Multiple Issues can be worked on simultaneously
2. **Branch Isolation**: Each Issue gets its own working directory via git worktree
3. **Environment Independence**: Separate Flutter environments per worktree
4. **Conflict Prevention**: Isolated workspaces prevent interference between tasks

**Basic git worktree commands**:

```bash
# Create new worktree
git worktree add path/to/worktree -b branch-name

# List active worktrees
git worktree list

# Remove completed worktree
git worktree remove path/to/worktree
```

**Note**: The `/linear` command handles git worktree creation automatically for Linear Issue processing.

For detailed Linear Issue processing workflow, execution examples, and configuration options, refer to `.claude/commands/linear.md`.

---

**Note**: This file is an important configuration file that controls Claude Code behavior. Test thoroughly when making changes.

## Development Guidelines

### Code Generation

- Always execute `melos run gen` after adding new model classes or providers
- Do not directly edit generated files (`*.g.dart`, `*.freezed.dart`)

### Testing

- Add corresponding widget tests to `app/test/` when adding new features
- Execute `melos run test` to run tests for all packages
- Include tests as targets for AI Review-First

### Git Workflow

- Use [Conventional Commits](https://www.conventionalcommits.org/) format for commit messages
- **Branch naming**: Use only `feature/ISSUE_ID` format (no Japanese/English descriptions)
- PR checks automatically execute with `.github/workflows/check-pr.yml`
- Includes analysis, formatting, testing, i18n validation

### Package Management

- Add new dependencies to the appropriate package's `pubspec.yaml`
- Same versions used across all packages due to Workspace resolution
- Update all package dependencies collectively with `melos run get`
