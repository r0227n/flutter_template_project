# CLAUDE.md - Maestro UI Testing with Claude Code

This file provides guidance for Claude Code when working with Maestro UI tests in this Flutter project. The maestro directory contains an automated UI testing framework designed for iterative development with Claude Code assistance.

## Project Context: Maestro UI Testing Framework

### Technology Stack

- **UI Testing**: Maestro (mobile UI automation)
- **Test Execution**: Custom `execute.sh` script optimized for Claude Code workflows
- **Environment Management**: dart_define JSON configurations
- **Artifact Management**: Automated test output and screenshot collection
- **Development Approach**: Iterative, failure-tolerant testing

### Directory Structure Understanding

```
app/test/maestro/
├── execute.sh              # Main test execution script (Claude Code optimized)
├── counter_test.yaml       # Sample Maestro test file
├── test-output/           # Generated test artifacts and logs
│   └── YYYYMMDD-HHMMSS/   # Timestamped test runs
├── scripts/               # Legacy and utility scripts
└── docs/                  # Documentation (README.md, this file)
```

## Claude Code Integration Points

### 1. Primary Test Execution Script: `execute.sh`

**Purpose**: Optimized for Claude Code's iterative UI testing workflow where test failures are expected and used for improvement.

**Key Features for Claude Code**:

- **Failure-tolerant**: Continues execution after test failures (default behavior)
- **Rich debugging output**: Provides detailed failure analysis for Claude Code to understand issues
- **Artifact collection**: Saves logs and screenshots for Claude Code analysis
- **Environment variable integration**: Automatically loads dart_define configurations

**Claude Code Usage Patterns**:

```bash
# Standard testing workflow with Claude Code
./execute.sh counter_test.yaml

# Debug mode for detailed analysis
./execute.sh --verbose --debug counter_test.yaml

# Watch mode for continuous development
./execute.sh --watch counter_test.yaml

# Validation before testing
./execute.sh --validate-only counter_test.yaml
```

### 2. Test Failure Analysis Workflow

When tests fail, Claude Code should follow this analysis pattern:

#### Step 1: Examine Test Output

```bash
# Location of latest test output
./test-output/[latest-timestamp]/maestro-output.log
```

#### Step 2: Analyze Screenshots

```bash
# Maestro generates screenshots in ~/.maestro/tests/
# Check the debug output section in logs for exact path
```

#### Step 3: Common Failure Patterns to Look For

1. **Element Not Found**:
   - Check UI element IDs and text
   - Verify element visibility timing
   - Consider animation completion waiting

2. **App Launch Issues**:
   - Verify `FULL_APP_ID` environment variable
   - Check device/simulator status
   - Validate dart_define configuration

3. **Timing Issues**:
   - Add `waitForAnimationToEnd` steps
   - Implement explicit waits
   - Consider device performance factors

### 3. Dynamic Environment Variable System

**Automatic Loading**: The execute.sh script automatically loads environment variables from:

- `app/.dart_define/development.json` (default)
- `app/.dart_define/staging.json` (with --flavor staging)
- `app/.dart_define/production.json` (with --flavor production)

**Dynamic Variable Generation**: The system automatically detects patterns in JSON keys and generates combined variables without hardcoding specific key names.

#### Pattern Detection Rules

**Pattern 1: `*_ID` + `*_ID_SUFFIX` → `FULL_*_ID`**

```json
{
  "APP_ID": "com.example.app",
  "APP_ID_SUFFIX": ".development"
}
// Generates: FULL_APP_ID=com.example.app.development
```

**Pattern 2: `*_PREFIX` + `*_SUFFIX` → `FULL_*`**

```json
{
  "URL_PREFIX": "https://api.example.com",
  "URL_SUFFIX": "/v1/staging"
}
// Generates: FULL_URL=https://api.example.com/v1/staging
```

#### Example Environment Variables

```bash
# From development.json
{
  "FLAVOR": "development",
  "APP_ID": "com.example.app",
  "APP_ID_SUFFIX": ".development",
  "APP_NAME": "Template Development",
  "DATABASE_ID": "mydb",
  "DATABASE_ID_SUFFIX": "_dev",
  "API_PREFIX": "https://api.staging",
  "API_SUFFIX": ".example.com"
}

# Results in these environment variables:
FLAVOR=development
APP_ID=com.example.app
APP_ID_SUFFIX=.development
APP_NAME=Template Development
DATABASE_ID=mydb
DATABASE_ID_SUFFIX=_dev
API_PREFIX=https://api.staging
API_SUFFIX=.example.com

# Plus automatically generated:
FULL_APP_ID=com.example.app.development
FULL_DATABASE_ID=mydb_dev
FULL_API=https://api.staging.example.com
```

#### Usage in Maestro YAML

**Direct Variable Reference**:

```yaml
# Simple direct reference
appId: ${FULL_APP_ID}
```

## Claude Code Workflow Instructions

### Iterative UI Testing Process

When Claude Code is asked to test or improve UI functionality:

#### Phase 1: Initial Analysis

1. **Understand the requirement**: What UI functionality needs testing?
2. **Check existing tests**: Review current YAML files for similar patterns
3. **Validate environment**: Ensure dart_define configuration is correct

#### Phase 2: Test Creation/Modification

1. **Create/modify YAML test file** using current patterns:

   ```yaml
   # Modern template structure with dynamic variables
   appId: ${FULL_APP_ID}
   ---
   - launchApp
   - waitForAnimationToEnd
   - assertVisible: 'Expected UI Element'
   - tapOn: 'Button ID or Text'
   ```

2. **Use dynamic environment variables** based on JSON patterns:
   - Always use `${FULL_APP_ID}` instead of hardcoded app IDs
   - Reference other generated variables like `${FULL_DATABASE_ID}`

3. **Add appropriate wait conditions** for animations and loading

#### Phase 3: Test Execution

```bash
# Run the test with execute.sh
./execute.sh new_test.yaml

# For debugging, use verbose mode
./execute.sh --verbose new_test.yaml
```

#### Phase 4: Failure Analysis and Iteration

1. **Analyze output logs**: Check `test-output/latest/maestro-output.log`
2. **Review screenshots**: Look at Maestro's debug artifacts
3. **Identify issues**:
   - UI element problems → Update Flutter code
   - Test logic problems → Update YAML
   - Timing problems → Add waits or delays
4. **Apply fixes and re-test**

#### Phase 5: Continuous Improvement

- Use `--watch` mode for rapid iteration
- Document test intentions in YAML comments
- Ensure tests are maintainable and readable

### Common Claude Code Tasks

#### Creating New Tests

**Modern Test Template**:

```yaml
# Use the current simplified structure
appId: ${FULL_APP_ID}
---
- launchApp
- assertVisible: 'Expected UI Element'
- tapOn:
    text: 'Button Text'
- assertVisible: 'Result State'
```

**Validation and Execution**:

```bash
# Validate syntax before running
./execute.sh --validate-only new_test.yaml

# Run with full debugging
./execute.sh --debug new_test.yaml
```

**Current Counter Test Example**:

```yaml
# Actual structure from counter_test.yaml
appId: ${FULL_APP_ID}
---
- launchApp
- assertVisible: 'Flutter Demo Home Page'
- assertVisible: 'カウンター: 0'
- tapOn:
    text: 'Increment'
- assertVisible: 'カウンター: 1'
- tapOn:
    text: 'Increment'
- assertVisible: 'カウンター: 2'
```

#### Debugging Failed Tests

1. **Check latest output**:

   ```bash
   # Find most recent test output
   ls -la test-output/ | tail -1

   # Read the full log
   cat test-output/[timestamp]/maestro-output.log
   ```

2. **Analyze UI state**: Look at screenshots in Maestro's debug output directory
3. **Update test or UI code** based on findings

### Best Practices for Claude Code

#### Test Design Principles

1. **One test, one feature**: Each YAML file should test a single feature
2. **Use descriptive names**: File names should clearly indicate what's being tested
3. **Environment variable usage**: Always use env vars instead of hardcoded values
4. **Proper error handling**: Include appropriate waits and error conditions

#### Code Maintenance

1. **Keep tests simple**: Avoid complex logic in YAML files
2. **Comment intentions**: Explain what each test step accomplishes
3. **Regular validation**: Run `--validate-only` before committing changes
4. **Artifact review**: Regularly check test-output for debugging insights

#### Performance Considerations

1. **Minimize test execution time**: Use efficient selectors and minimal waits
2. **Batch related tests**: Group related functionality in single test files
3. **Clean up artifacts**: Regularly clean old test-output directories

### Error Resolution Patterns

When encountering common errors, Claude Code should apply these resolution patterns:

#### "Element not found" errors:

1. Check UI element IDs in Flutter code
2. Verify element text matches exactly (case-sensitive)
3. Add `waitForAnimationToEnd` before assertions
4. Consider using more specific selectors

#### "App launch failed" errors:

1. Verify `FULL_APP_ID` matches the installed app
2. Check device/simulator connection
3. Ensure app is properly built for the target platform

#### "Timeout" errors:

1. Increase timeout values in test steps
2. Add explicit wait conditions
3. Check for network dependencies
4. Consider device performance limitations

## Integration with Main Project

### Relationship to Project Structure

- Tests use the same environment configuration as the Flutter app
- `dart_define` files ensure consistency between build and test configurations
- Test artifacts integrate with CI/CD workflows (when present)

### Coordination with Other Tools

- **Melos**: Test execution can be integrated into workspace scripts
- **mise**: Environment management aligns with project tooling
- **GitHub Actions**: Test results can be used in CI workflows

## Advanced Usage

### Custom Test Scenarios

```bash
# Test with specific environment variables
CUSTOM_VAR=value ./execute.sh custom_test.yaml

# Run multiple tests in sequence
for test in *.yaml; do ./execute.sh "$test"; done

# Continuous testing with file watching
./execute.sh --watch main_flow_test.yaml
```

### Debugging Complex Issues

```bash
# Full verbose output with debug artifacts
./execute.sh --verbose --debug problematic_test.yaml

# Dry run to verify command construction
./execute.sh --dry-run test.yaml

# Validation-only mode for syntax checking
./execute.sh --validate-only all_tests.yaml
```

## Expected Claude Code Behaviors

### When Asked to Create Tests

1. Always start with `./execute.sh --validate-only` approach
2. Use environment variables from dart_define
3. Follow established YAML patterns
4. Include appropriate wait conditions
5. Add descriptive comments

### When Debugging Test Failures

1. Read and analyze the full test-output log
2. Look for common failure patterns
3. Check screenshots if available
4. Propose specific fixes for identified issues
5. Re-run tests after fixes

### When Improving Existing Tests

1. Understand current test logic before modifying
2. Maintain backward compatibility where possible
3. Improve reliability (better selectors, proper waits)
4. Enhance maintainability (better comments, structure)

This framework enables Claude Code to effectively develop, test, and maintain UI functionality through automated testing cycles, making the development process more reliable and efficient.
