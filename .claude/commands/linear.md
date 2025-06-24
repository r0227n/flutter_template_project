# Linear Issue Processing Command - Claude 4 Best Practices

**IMPORTANT**: This command implements AI Review-First design following Claude 4 best practices for high-quality Flutter development.

## Overview

Process Linear Issues using AI Review-First methodology. This command creates isolated work environments, applies structured review cycles, and ensures quality standards through automated validation.

## Core Principles (Claude 4 Best Practices)

**Reference**: `docs/CLAUDE_4_BEST_PRACTICES.md`

### AI Review-First Methodology

- **Pattern**: Small draft → Critical review → Regenerate → Release
- **Approach**: Use AI as "Senior Reviewer" not "Junior Designer"
- **Cycles**: 3-4 iterative review cycles for quality improvement
- **Priority**: Security (High) → SOLID Principles (Medium) → Performance (Low)

### Clear Instructions

- Eliminate ambiguity in task definitions
- Define specific deliverables and quality criteria
- Provide structured review templates with evaluation categories

### Structured Quality Assessment

Apply consistent evaluation framework:

```
1. Security vulnerabilities (HIGH PRIORITY)
2. SOLID principle violations (MEDIUM PRIORITY)
3. Performance optimization (LOW PRIORITY)
Constraint: Summarize findings within 400 characters
```

## Execution Modes

### Interactive Mode (No Arguments)

```bash
/linear
```

**Behavior**:

1. Fetch Issues assigned to current user via Linear API
2. Display interactive Issue selection list (title, priority, status)
3. Support multiple Issue selection
4. Confirm selections before parallel execution

### Automatic Mode (With Arguments)

```bash
/linear ABC-123 XYZ-456
```

**Behavior**:

- **No confirmation prompts** - immediate execution
- Validate Issue IDs via Linear API
- Create isolated work environments automatically
- Begin background processing with completion notifications

## AI Review-First Processing Flow

### Phase 1: Minimal Implementation

**Objective**: Create walking skeleton for review

**Actions**:

- Configure Flutter version using mise
- Create dedicated branch via git worktree
- Implement ONLY core functionality per Issue requirements
- Create basic test cases

**Quality Gate**: Compilable code with basic functionality

### Phase 2: Critical Review Cycles (3-4 Iterations)

**Review Template** (Use this exact format):

```
Please review the following code implementation.

Evaluation Categories:
1. Security vulnerabilities (high priority)
2. SOLID principle violations (medium priority)
3. Performance optimization opportunities (low priority)

Constraint: Provide specific, actionable feedback within 400 characters.
Focus on the highest priority issues first.
```

**Iterative Improvement Process**:

1. **Cycle 1**: Address ALL high priority security issues
2. **Cycle 2**: Fix major SOLID principle violations
3. **Cycle 3**: Optimize performance within feasible scope
4. **Final Validation**: Human review of AI recommendations

**Quality Gates**:

- Security: Zero high-severity vulnerabilities
- Architecture: Major design principle violations resolved
- Performance: Identified bottlenecks addressed

### Phase 3: Release Preparation

**Actions**:

- Execute code quality checks: `dart analyze`, `dart format`
- Run automated and manual test suites
- Create Pull Request with detailed description
- Monitor GitHub Actions: `.github/workflows/check-pr.yml`
- Update Linear Issue status to "In Review"
- Send completion notification with alarm

**Quality Gate**: All CI/CD checks pass, human validation complete

## Completion Criteria

Task completion requires ALL conditions met:

### 1. AI Review-First Standards

- ✅ **3-4 review cycles completed successfully**
- ✅ **Security**: All high priority vulnerabilities resolved
- ✅ **SOLID Principles**: Major architectural issues fixed
- ✅ **Performance**: Optimization opportunities addressed within scope

### 2. Implementation Quality Standards

- ✅ **Feature Complete**: All Issue requirements implemented
- ✅ **Test Coverage**: Automated and manual tests passing
- ✅ **Code Quality**: Static analysis and formatting checks pass
- ✅ **Human Validation**: Final review confirms AI recommendations

### 3. Release Readiness

- ✅ **Documentation**: Pull Request with comprehensive description
- ✅ **CI/CD Pipeline**: All GitHub Actions checks successful
- ✅ **Issue Management**: Linear Issue status updated to "In Review"

### 4. Failure Recovery

- ✅ **Automatic Correction**: Attempt fixes for common CI failures
- ✅ **Quality Assurance**: Re-validate after corrections

## GitHub Actions Integration

### Quality Assurance Pipeline

```
AI Review-First → PR Creation → CI/CD Validation → Quality Gates
     ↓              ↓              ↓               ↓
Draft Code → Critical Review → Automated Checks → Release Ready
```

**Monitoring Process**:

- Track `.github/workflows/check-pr.yml` execution
- Analyze failure patterns for automatic correction
- Ensure all quality gates pass before completion

### Automatic Failure Response

```bash
# Failure Detection and Recovery
❌ CI/CD Failure Detected
📋 Analyze failure type and root cause
🔧 Apply targeted corrections:
   - Test failures → Fix test implementation
   - Lint errors → Apply dart format
   - Build errors → Resolve dependencies
📤 Commit corrections and re-trigger pipeline
🔄 Monitor re-execution until success
✅ Confirm all checks pass before completion
```

## Parallel Execution with Quality Isolation

### Workspace Isolation Strategy

**Problem**: Prevent quality degradation when processing multiple Issues simultaneously

**Solution**: Project-internal isolated environments

```bash
project-root/
├── .claude-workspaces/          # Isolated work areas (gitignored)
│   ├── ABC-123/                # Issue A workspace
│   │   ├── .claude-session     # Session isolation
│   │   └── [git worktree]      # feature/ABC-123 branch
│   └── XYZ-456/                # Issue B workspace
│       ├── .claude-session     # Independent session
│       └── [git worktree]      # feature/XYZ-456 branch
```

### Quality Management for Parallel Execution

```bash
# Multiple Issue processing with unified quality standards
/linear ABC-123 XYZ-456

# Execution flow:
# 📁 ABC-123: Independent AI Review-First cycle in .claude-workspaces/ABC-123/
# 📁 XYZ-456: Independent AI Review-First cycle in .claude-workspaces/XYZ-456/
# 🔄 Each workspace runs 3-4 review cycles independently
# ✅ Completion notification after ALL Issues meet quality standards
```

### Conflict Prevention

- **Duplicate Check**: Prevent concurrent processing of same Issue ID
- **Resource Monitoring**: Queue execution when CPU/memory exceeds 80%
- **File Locking**: Use .lock files for exclusive workspace access
- **Git Isolation**: Exclude `.claude-workspaces/` from version control

### Workspace Management

```bash
# Monitor active workspaces
/linear-running

# Cleanup completed workspaces
ls .claude-workspaces/
# ABC-123/ (completed)  XYZ-456/ (in-progress)
```

## Execution Examples

### Interactive Selection

```bash
/linear

📋 Available Issues:
1) ABC-123: User authentication feature implementation (High, To Do)
2) XYZ-456: Bug fix: Login error handling (Urgent, In Progress)
3) FEAT-789: New feature: Push notifications (Normal, To Do)

? Select Issues to process [1-3, or multiple]: 1,3
? Execute with selected Issues: ABC-123, FEAT-789? [Y/n]: y

🚀 Starting parallel execution with AI Review-First...
```

### Direct Execution

```bash
/linear ABC-123

✅ Issue validation: ABC-123 confirmed in Linear
✅ Workspace creation: .claude-workspaces/ABC-123
✅ Git worktree: feature/ABC-123
✅ Flutter environment: mise setup complete
✅ AI Review-First: Quality standards configured
🚀 Background execution started...
📝 Implementing: User authentication feature
⏰ Completion alarm scheduled
```

## Error Handling and Recovery

### Input Validation Errors

```bash
/linear INVALID-123
❌ Error: Issue 'INVALID-123' not found in Linear
💡 Use /linear-list to view available Issues
```

### Review Cycle Failures

```bash
❌ Review cycle failed: Security vulnerabilities persist
🔧 Re-analyzing high priority issues
🔄 Continuing review cycle with additional focus
📋 Will escalate to human review if unresolvable
```

### Quality Standard Violations

```bash
❌ Quality standards not met: Multiple SOLID violations detected
📋 Detailed issue analysis:
    - Single Responsibility: 3 violations
    - Open/Closed Principle: 1 violation
🎯 Initiating additional review cycle
☝️ Human intervention required if standards remain unmet
```

## Best Practices and Limitations

### Optimal Use Cases

- **Well-defined Issue requirements** with clear acceptance criteria
- **Feature additions** to existing Flutter codebase
- **Bug fixes** with reproducible steps
- **Code quality improvements** and refactoring
- **Test case creation** and coverage improvement

### Limitations (When NOT to Use)

- **Large-scale system design** (1000+ lines) - requires human architecture
- **Domain-specific complex logic** - needs specialized knowledge
- **Cutting-edge technology** - outside AI training data
- **Performance-critical optimizations** - requires deep system knowledge

### Success Factors

1. **Clear Issue descriptions** with specific requirements
2. **Existing code patterns** for AI to follow
3. **Comprehensive test coverage** for validation
4. **Well-defined quality metrics** for objective assessment

## Project Dependencies and Configuration

### Required Technology Stack

- **Framework**: Flutter (Workspace/Monorepo structure)
- **Version Management**: mise (polyglot tool version manager)
- **Task Management**: Linear (MCP integrated)
- **Development Workflow**: git worktree for parallel development
- **State Management**: Riverpod (hooks_riverpod, riverpod_annotation)
- **Navigation**: go_router (declarative routing)
- **Internationalization**: slang (type-safe translations)
- **Build Tools**: build_runner, freezed
- **Monorepo Management**: Melos + pub workspace

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
export AUTO_CONFIRM_WITH_ARGS=true
export SILENT_MODE_WITH_ARGS=false
export ERROR_ONLY_OUTPUT=false
export CLAUDE_ISOLATION_MODE=true
export CLAUDE_WORKSPACE_DIR=".claude-workspaces"
export CLAUDE_MEMORY_ISOLATION=true
export GITHUB_ACTIONS_CHECK=true
export CHECK_PR_WORKFLOW="check-pr.yml"
```

### .gitignore Setup

```
.claude-workspaces/
*.lock
.claude-session
```

### Flutter Commands Integration

#### Melos Commands (Primary)

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

#### Direct Flutter Commands (Fallback)

```bash
# Run application
cd app && flutter run

# Run tests (single file)
cd app && flutter test test/widget_test.dart

# Build
cd app && flutter build apk
cd app && flutter build ios --no-codesign
```

### PR Creation Template

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

### Troubleshooting Guide

#### Linear API Connection Error

```bash
# If MCP configuration re-check needed
/config
```

#### mise Version Conflict

```bash
# Reset Flutter version
mise install
flutter clean
flutter pub get
```

#### git worktree Creation Failure

```bash
# Check and delete existing worktrees
git worktree list
git worktree remove [worktree_path]
```

#### Background Tasks Not Working

```bash
# Check environment variables
echo $ENABLE_BACKGROUND_TASKS
export ENABLE_BACKGROUND_TASKS=true
```

### Performance Optimization Settings

- Parallel execution limit: Adjust according to CPU usage
- Memory usage monitoring: Control when creating large numbers of worktrees
- Resource monitoring: CPU/memory usage 80% threshold

### Security Considerations

- Safe management of Linear API keys
- Proper configuration of git authentication credentials
- Careful handling of code containing sensitive information

---

**Note**: This command prioritizes code quality through AI Review-First methodology and requires git worktree support for parallel execution. Expect 3-4 review iterations per Issue to achieve production-ready standards.
