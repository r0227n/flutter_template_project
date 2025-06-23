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
- **Version Management**: fvm (Flutter Version Management)
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

- Flutter SDK (managed by fvm)
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

### Direct Flutter Commands (using fvm)

```bash
# Run application
cd app && fvm flutter run

# Run tests (single file)
cd app && fvm flutter test test/widget_test.dart

# Build
cd app && fvm flutter build apk
cd app && fvm flutter build ios --no-codesign
```

### Node.js Related Commands

```bash
# YAML/Markdown lint
npm run lint

# YAML/Markdown format
npm run format
```

### Environment Variables

```bash
export ENABLE_BACKGROUND_TASKS=true
export FLUTTER_VERSION_MANAGEMENT=fvm
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

- `/linear` - Linear Issue processing (interactive & automatic execution)

### Command File Placement

```
.claude/
└── commands/
    └── linear.md          # Main Issue processing command
```

## Workflow Definition

### Basic Flow (using /linear command)

1. **Command Execution**: `claude` → `/linear` or `/linear <Issue ID>` execution
2. **Issue Selection**: Interactive Issue ID selection (skip when argument specified)
3. **Branch Creation**: Create new working branch with git worktree
4. **Parallel Execution**: Execute tasks asynchronously
5. **Automatic PR Creation**: Create PR in Japanese upon work completion
6. **Completion Notification**: Notify work completion with alarm

### Detailed Workflow

#### Phase 1: Task Initialization

```
INPUT:
- Interactive mode: `/linear` → Issue ID selection prompt
- Automatic execution: `/linear ABC-123` → Start immediately without confirmation
↓
1. Issue ID validation (no confirmation prompt in automatic execution)
2. Retrieve Issue details via Linear API
3. Analyze Issue content to understand task requirements
4. Generate appropriate branch name (feature/ISSUE_ID) ※No Japanese used
5. Start execution (skip confirmation prompt in automatic execution)
```

#### Phase 2: Environment Preparation (Isolated Execution)

```
1. Create independent working directory based on Issue ID (within project)
   - .claude-workspaces/ABC-123/ (Task A dedicated)
   - .claude-workspaces/XYZ-456/ (Task B dedicated)
2. Execute git worktree add in each directory
3. Independent Claude Code process and memory space
4. Set project-specified Flutter version with fvm use
5. Install dependencies (flutter pub get)
6. Create session identifier (.claude-session)
```

#### Phase 3: AI Review-First Execution

```
ENABLE_BACKGROUND_TASKS = true executes the following in review-first cycle:

1. Initial Draft Creation:
   - Minimal feature implementation
   - Basic test creation

2. AI Critical Review (3-4 cycles):
   Evaluation Categories:
   - Security vulnerabilities (high priority)
   - SOLID principle violations (medium priority)
   - Performance optimization (low priority)
   Constraint: Each review within 400 characters

3. Iterative Improvement:
   - Fix high priority issues
   - Fix medium priority issues
   - Fix low priority issues

4. Final Quality Check:
   - dart analyze
   - dart format
   - Test execution
   - Documentation update
```

#### Phase 4: Completion Processing

```
1. Upon completion of all work
2. Commit changes
3. Create PR (description in Japanese)
4. Execute GitHub Actions: Confirm all checks in .github/workflows/check-pr.yml complete successfully
5. Update Linear Issue status to In Review
6. Report completion with alarm notification
```

## Command Execution Examples

### Interactive Execution (Recommended)

```bash
# Start Claude Code interactive mode
claude

# Execute /linear command interactively
/linear

# Execution example:
# 📋 Available Issues:
# 1) ABC-123: User authentication feature implementation (High, To Do)
# 2) XYZ-456: Bug fix: Login error handling (Urgent, In Progress)
# 3) FEAT-789: New feature: Push notifications (Normal, To Do)
#
# ? Select Issues to process [1-3, or multiple selection]: 1,3
# ? Execute with selected Issues: ABC-123, FEAT-789? [Y/n]: y
#
# 🚀 Starting parallel execution...
```

### Direct Specification Execution (Automatic)

```bash
# Claude Code interactive mode
claude

# Specify Issue ID directly (automatic execution without confirmation)
/linear ABC-123
# ✅ Issue validation complete → 🚀 Start automatic execution

# Specify multiple Issue IDs (automatic parallel execution without confirmation)
/linear ABC-123 XYZ-456 FEAT-789
# ✅ 3 Issues validation complete → 🚀 Start parallel automatic execution

# Execution example (automatic mode):
# /linear ABC-123
# ✅ Issue ID validation: ABC-123
# ✅ Linear API check: Existence confirmed
# ✅ Processing permission: OK
# ✅ git worktree creation: feature/ABC-123
# ✅ Flutter environment setup: fvm 3.24.0 applied
# 🚀 Background execution started...
# 📝 Implementing: User authentication feature
# ⏰ Alarm notification scheduled upon completion
```


## Parallel Execution Work Isolation Settings

### Problem: Content Mixing Between Task A and Task B

Countermeasures for the problem of different Issue work content getting mixed when running multiple Claude Code instances in parallel.

### Isolation Strategy

#### 1. Physical Directory Isolation

```bash
# Project structure example (project-internal isolation)
project-root/
├── CLAUDE.md                    # Master configuration
├── .claude/commands/           # Common commands
├── .claude-workspaces/         # Parallel work area (gitignore target)
│   ├── ABC-123/               # Task A dedicated directory
│   │   ├── .claude-session    # Session identifier
│   │   └── [git worktree]     # feature/ABC-123 branch
│   └── XYZ-456/               # Task B dedicated directory
│       ├── .claude-session    # Session identifier
│       └── [git worktree]     # feature/XYZ-456 branch
├── src/                       # Original source code
├── pubspec.yaml              # Flutter configuration
└── .gitignore                # Exclude .claude-workspaces/
```

#### 2. Claude Code Process Isolation

```bash
# Execute each task in separate terminal/process
# Terminal 1: Task A (from project root)
claude
/linear ABC-123
# → Execute in .claude-workspaces/ABC-123/

# Terminal 2: Task B (from project root)
claude
/linear XYZ-456
# → Execute in .claude-workspaces/XYZ-456/
```

#### 3. Memory/Context Isolation

```bash
# Independent memory space for each Claude Code instance
export CLAUDE_MEMORY_ISOLATION=true
export CLAUDE_SESSION_ID="ABC-123"  # Task A
export CLAUDE_SESSION_ID="XYZ-456"  # Task B
```

### Automatic Isolation Implementation

#### Automatic Working Directory Creation

```bash
# Automatic isolation processing when executing /linear command (within project)
function create_isolated_workspace() {
    ISSUE_ID=$1
    PROJECT_ROOT=$(pwd)
    WORKSPACE_DIR=".claude-workspaces/${ISSUE_ID}"

    # 1. Create independent working directory within project
    mkdir -p "${WORKSPACE_DIR}"

    # 2. git worktree setup (branch name is ISSUE_ID only, no Japanese)
    git worktree add "${WORKSPACE_DIR}" -b "feature/${ISSUE_ID}"

    # 3. Create session identifier
    echo "SESSION_${ISSUE_ID}" > "${WORKSPACE_DIR}/.claude-session"
    echo "CREATED_AT=$(date)" >> "${WORKSPACE_DIR}/.claude-session"

    # 4. Flutter environment setup (inherit project configuration)
    cd "${WORKSPACE_DIR}"
    fvm use $(cat "${PROJECT_ROOT}/.fvmrc" 2>/dev/null || echo "stable")
    flutter pub get

    # 5. Working directory information
    echo "Working directory: ${PROJECT_ROOT}/${WORKSPACE_DIR}"
    echo "git worktree: feature/${ISSUE_ID}"
    echo "Session ID: SESSION_${ISSUE_ID}"

    # 6. Return to project root (Claude Code executes from root)
    cd "${PROJECT_ROOT}"
}
```

#### Isolated Execution Log

```bash
# Task A execution log example
🚀 Issue ABC-123 processing started
📁 Working directory: .claude-workspaces/ABC-123
🔗 git worktree: feature/ABC-123
💾 Claude memory isolation: SESSION_ABC-123
✅ Environment isolation complete

# Task B execution log example
🚀 Issue XYZ-456 processing started
📁 Working directory: .claude-workspaces/XYZ-456
🔗 git worktree: feature/XYZ-456
💾 Claude memory isolation: SESSION_XYZ-456
✅ Environment isolation complete
```

### Isolation Verification and Management

#### Check Running Tasks

```bash
# List of running tasks in parallel
/linear-running
📊 Running tasks:
┌──────────┬─────────────────────┬──────────┬──────────────────────┐
│ Issue ID │ Working Directory   │ Progress │ Start Time           │
├──────────┼─────────────────────┼──────────┼──────────────────────┤
│ ABC-123  │ .claude-workspaces/ABC-123│ Implementing│ 2025-06-22 10:30:00  │
│ XYZ-456  │ .claude-workspaces/XYZ-456│ Testing  │ 2025-06-22 10:45:00  │
└──────────┴─────────────────────┴──────────┴──────────────────────┘
```

#### Work Area Cleanup

```bash
# Delete completed task work areas
/linear-cleanup
? Select cleanup targets:
  [x] .claude-workspaces/ABC-123 (completed)
  [ ] .claude-workspaces/XYZ-456 (running)
  [x] .claude-workspaces/OLD-789 (completed 7 days ago)

✅ Cleaned up 2 work areas
```

#### .gitignore Configuration

```bash
# Add to .gitignore
.claude-workspaces/
*.lock
.claude-session
```

### Conflict Avoidance Rules

1. **Duplicate Issue ID Execution Prohibition**: Issues already running cannot be re-executed
2. **File Lock**: Create .lock file in working directory
3. **Resource Monitoring**: Wait for new execution when CPU/memory usage exceeds 80%
4. **Dependency Check**: Verify execution status of related Issues

### Interactive Flow Configuration

```bash
# Interactive mode enabled by default
export INTERACTIVE_MODE=true
export PROMPT_STYLE="enhanced"  # enhanced, simple, minimal
export AUTO_COMPLETION=true     # Issue ID completion feature
export ISSUE_PREVIEW=true       # Issue content preview display
```

### Input Validation and Error Handling

```
Validation items during interaction:
1. Issue ID format check (e.g., ABC-123)
2. Existence check via Linear API
3. Issue status check (warning if already closed)
4. Permission check (confirmation if not assigned)
5. Dependency check (existence of blocker Issues)
```

### Interactive UI Customization

```bash
# Interactive mode (no arguments) - detailed confirmation
/linear
> 📋 Available Issues:
> 1) ABC-123: User authentication feature implementation
>    Status: To Do | Priority: High | Assignee: You
>    📝 Description: OAuth2.0-based login feature implementation
>
> ? Select Issue to process: 1
> ? Process this Issue? [Y/n]: y

# Automatic execution mode (with arguments) - no confirmation
/linear ABC-123
> ✅ Issue ID validation: ABC-123
> ✅ Linear API check: Existence confirmed
> ✅ Processing permission: OK
> 🚀 Automatic execution started...
> 📝 Implementing: User authentication feature implementation
> ⏰ Alarm notification scheduled upon completion

# Stop only on error
/linear INVALID-123
> ❌ Error: Issue ID 'INVALID-123' not found
```

## Automation Rules

### PR Creation Rules

- **Title**: `[ABC-123] Use Issue title as-is`
- **Description**: Include the following content in Japanese

  ```markdown
  ## Changes

  - Details of implemented features
  - Content of fixed bugs

  ## Related Issue

  - Closes #{Linear Issue URL}

  ## Testing

  - Overview of executed tests
  - Test results

  ## Checklist

  - [ ] Code review ready
  - [ ] Tests executed
  - [ ] Documentation updated
  ```

### Parallel Execution Rules

- Each git worktree has independent Flutter environment
- Can process multiple Issues simultaneously
- Adjust priority according to importance to avoid resource conflicts

### Completion Notification Rules

- Notify with system alarm sound
- Notification content: "Work on Issue ABC-123 has been completed. PR has been created."
- **Completion condition**: All checks in `.github/workflows/check-pr.yml` complete successfully

### Workflow Completion Conditions

Task is considered complete when all of the following conditions are met:

1. **AI Review-First Completion**: 3-4 review cycles completed
2. **Code Implementation Complete**: Feature implementation based on Issue requirements
3. **Quality Standards Achieved**:
   - Security vulnerabilities: All high priority issues fixed
   - SOLID principles: Major medium priority issues fixed
   - Performance: Low priority issues fixed within possible scope
4. **Test Execution Success**: Automated and manual tests successful
5. **Code Quality Check**: dart analyze, dart format passed
6. **Human Final Validation**: Validity confirmation of review results
7. **PR Creation**: PR created with Japanese description
8. **GitHub Actions Success**: All checks in `.github/workflows/check-pr.yml` completed successfully
9. **Linear Update**: Issue status updated to In Review

### GitHub Actions Integration

```bash
# Automatic check monitoring after PR creation
1. .github/workflows/check-pr.yml automatically executes when PR is created
2. Claude Code monitors the following check results:
   - Build success
   - Test suite pass
   - Code quality checks
   - Security scans
   - Lint checks
3. Completion notification after confirming all checks complete successfully
4. Attempt automatic correction if any check fails
```

### Automatic Response to Failures

```bash
# When GitHub Actions check fails
❌ GitHub Actions failure detected
📋 Analyze failure content
🔧 Attempt automatic correction:
   - Test failure → Fix test code
   - Lint error → Execute dart format
   - Build error → Check and fix dependencies
📤 Commit and push corrections
🔄 Re-execute checks
✅ Completion notification after all checks complete successfully
```

## Troubleshooting

### Common Problems and Solutions

#### 1. Linear API Connection Error

```bash
# If MCP configuration re-check needed
/config
```

#### 2. fvm Version Conflict

```bash
# Reset Flutter version
fvm use [project_flutter_version]
flutter clean
flutter pub get
```

#### 3. git worktree Creation Failure

```bash
# Check and delete existing worktrees
git worktree list
git worktree remove [worktree_path]
```

#### 4. Background Tasks Not Working

```bash
# Check environment variables
echo $ENABLE_BACKGROUND_TASKS
export ENABLE_BACKGROUND_TASKS=true
```

## Configuration Customization

### Notification Settings

- Alarm sound changes: Adjust in system settings
- Notification timing: Upon PR creation completion

### Quality Management

- Automatic test execution: Execute before all commits
- Code static analysis: Automatic dart analyze execution
- Formatting: Automatic dart format application

### Performance Optimization

- Parallel execution limit: Adjust according to CPU usage
- Memory usage monitoring: Control when creating large numbers of worktrees

## Security Considerations

- Safe management of Linear API keys
- Proper configuration of git authentication credentials
- Careful handling of code containing sensitive information

---

**Note**: This file is an important configuration file that controls Claude Code behavior. Test thoroughly when making changes.

## Development Guidelines

### AI Review-First Practice

Follow these steps for all code changes:

```text
1. Create Minimal Implementation
   - Minimum implementation of Issue requirements
   - Create basic test cases

2. Execute AI Review
   Please review the following code.

   Evaluation Categories:
   1. Security vulnerabilities (high priority)
   2. SOLID principle violations (medium priority)
   3. Performance optimization (low priority)

   Constraint: Summarize within 400 characters

3. Fix Issues and Repeat Review
   - Fix high priority issues first
   - Execute 2-3 review cycles
   - Re-review after each fix

4. Final Validation
   - Human validity confirmation
   - Execute code quality checks
```

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
