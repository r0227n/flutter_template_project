#!/bin/bash

# Maestro UI Test Execution Script for Iterative Development
# This script is designed for UI testing workflows where failures are expected
# and iterative improvements are made to UI and test YAML files.

# Remove strict error handling for iterative workflow
set -uo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Default values
FLAVOR="development"
VERBOSE=false
CONTINUE_ON_FAIL=true
WATCH_MODE=false
DEBUG_MODE=false
SCREENSHOT_ON_FAIL=true

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Output functions
print_header() {
    echo ""
    echo -e "${CYAN}===== $1 =====${NC}"
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_debug() {
    if [ "$DEBUG_MODE" = true ]; then
        echo -e "${BLUE}[DEBUG]${NC} $1"
    fi
}

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Show detailed usage for iterative development
show_usage() {
    cat << EOF
Usage: $0 [options] <yaml_file>

This script is designed for iterative UI testing workflows where test failures
are expected during development and debugging.

Arguments:
  yaml_file           Path to Maestro test YAML file (required)

Options:
  --flavor <flavor>   Specify the flavor (default: development)
                      Available: development, staging, production
  --verbose           Enable verbose output
  --debug             Enable debug mode with detailed logging
  --no-continue       Exit immediately on test failure (default: continue)
  --watch             Watch mode - monitor file changes and re-run tests
  --no-screenshot     Disable automatic screenshots on failure
  -h, --help          Show this help message

Development Workflow Options:
  --dry-run          Show what would be executed without running tests
  --validate-only    Only validate YAML syntax and environment setup

Examples:
  # Basic test execution (continues on failure for debugging)
  $0 counter_test.yaml
  
  # Verbose mode for detailed debugging
  $0 --verbose --debug counter_test.yaml
  
  # Production flavor testing
  $0 --flavor production counter_test.yaml
  
  # Watch mode for continuous development
  $0 --watch counter_test.yaml
  
  # Strict mode (exit on first failure)
  $0 --no-continue counter_test.yaml

Development Tips:
  - Test failures are expected during UI development
  - Use --debug for detailed maestro command output
  - Check generated screenshots in maestro output for UI issues
  - Use --dry-run to verify environment variables before testing

EOF
}

# Enhanced requirements check
check_requirements() {
    print_step "Checking requirements..."
    local missing_tools=()
    
    # Check if Maestro is installed
    if ! command -v maestro &> /dev/null; then
        missing_tools+=("maestro")
        print_error "Maestro is not installed"
        echo "  Installation: curl -Ls https://get.maestro.mobile.dev | bash"
    else
        local maestro_version=$(maestro --version 2>/dev/null || echo "unknown")
        print_debug "Maestro version: $maestro_version"
    fi
    
    # Check if jq is installed for JSON parsing
    if ! command -v jq &> /dev/null; then
        missing_tools+=("jq")
        print_error "jq is not installed"
        echo "  Installation: brew install jq (macOS) or apt-get install jq (Linux)"
    else
        local jq_version=$(jq --version 2>/dev/null || echo "unknown")
        print_debug "jq version: $jq_version"
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        return 1
    fi
    
    print_info "All requirements satisfied"
    return 0
}

# Validate YAML file syntax
validate_yaml_syntax() {
    local yaml_file="$1"
    print_step "Validating YAML syntax..."
    
    # Basic YAML syntax check (if yq is available, use it; otherwise skip)
    if command -v yq &> /dev/null; then
        if yq eval '.' "$yaml_file" >/dev/null 2>&1; then
            print_info "YAML syntax is valid"
        else
            print_error "YAML syntax validation failed"
            return 1
        fi
    else
        print_debug "yq not available, skipping YAML syntax validation"
    fi
    
    # Check for common Maestro YAML patterns
    if grep -q "appId\|launchApp" "$yaml_file"; then
        print_debug "Found Maestro-specific commands in YAML"
    else
        print_warning "No Maestro-specific commands found in YAML file"
    fi
    
    return 0
}

# Enhanced environment parsing with validation
parse_and_validate_environment() {
    local dart_define_file="$1"
    
    print_step "Parsing and validating environment configuration..."
    
    if [ ! -f "$dart_define_file" ]; then
        print_error "dart_define file not found: $dart_define_file"
        return 1
    fi
    
    # Validate JSON syntax
    if ! jq empty "$dart_define_file" 2>/dev/null; then
        print_error "Invalid JSON syntax in dart_define file"
        return 1
    fi
    
    # Display parsed environment for debugging
    print_info "Environment configuration from: $(basename "$dart_define_file")"
    
    local env_count=0
    while IFS= read -r key && IFS= read -r value; do
        if [ "$value" != "null" ] && [ -n "$value" ]; then
            echo "  ${key}=${value}"
            ((env_count++))
        fi
    done < <(jq -r 'to_entries[] | .key, .value' "$dart_define_file")
    
    # Dynamic computation of combined IDs
    local computed_vars=$(compute_dynamic_variables "$dart_define_file")
    if [ -n "$computed_vars" ]; then
        while IFS= read -r computed_var; do
            if [ -n "$computed_var" ]; then
                echo "  $computed_var (computed)"
                ((env_count++))
            fi
        done <<< "$computed_vars"
    fi
    
    print_info "Loaded $env_count environment variables"
    return 0
}

# Compute dynamic variables based on JSON content
compute_dynamic_variables() {
    local dart_define_file="$1"
    local computed_vars=""
    
    # Get all keys that might be base IDs (ending with _ID)
    local base_id_keys=$(jq -r 'to_entries[] | select(.key | endswith("_ID") and (. != "FULL_APP_ID")) | .key' "$dart_define_file")
    
    # Get all keys that might be suffixes (ending with _SUFFIX)
    local suffix_keys=$(jq -r 'to_entries[] | select(.key | endswith("_SUFFIX")) | .key' "$dart_define_file")
    
    # Generate combinations of base_id + suffix
    while IFS= read -r base_key; do
        if [ -n "$base_key" ]; then
            local base_value=$(jq -r ".$base_key // empty" "$dart_define_file")
            if [ -n "$base_value" ]; then
                # Look for corresponding suffix (same base name + _SUFFIX)
                local suffix_key="${base_key}_SUFFIX"
                local suffix_value=$(jq -r ".$suffix_key // empty" "$dart_define_file")
                
                if [ -n "$suffix_value" ]; then
                    # Create FULL_{BASE_KEY}
                    local base_prefix=$(echo "$base_key" | sed 's/_ID$//')
                    local full_key="FULL_${base_prefix}_ID"
                    local full_value="${base_value}${suffix_value}"
                    computed_vars="${computed_vars}${full_key}=${full_value}\n"
                fi
            fi
        fi
    done <<< "$base_id_keys"
    
    # Also look for other common combination patterns
    # Check for any keys that end with _PREFIX and _SUFFIX combinations
    local prefix_keys=$(jq -r 'to_entries[] | select(.key | endswith("_PREFIX")) | .key' "$dart_define_file")
    
    while IFS= read -r prefix_key; do
        if [ -n "$prefix_key" ]; then
            local prefix_value=$(jq -r ".$prefix_key // empty" "$dart_define_file")
            if [ -n "$prefix_value" ]; then
                local base_prefix=$(echo "$prefix_key" | sed 's/_PREFIX$//')
                local suffix_key="${base_prefix}_SUFFIX"
                local suffix_value=$(jq -r ".$suffix_key // empty" "$dart_define_file")
                
                if [ -n "$suffix_value" ]; then
                    local combined_key="FULL_${base_prefix}"
                    local combined_value="${prefix_value}${suffix_value}"
                    computed_vars="${computed_vars}${combined_key}=${combined_value}\n"
                fi
            fi
        fi
    done <<< "$prefix_keys"
    
    # Output computed variables
    if [ -n "$computed_vars" ]; then
        echo -e "$computed_vars" | grep -v '^$'
    fi
}

# Build maestro command with proper error handling
build_maestro_command() {
    local dart_define_file="$1"
    local yaml_file="$2"
    
    # Build maestro command as an array
    maestro_cmd=("maestro" "test")
    
    # Add debug flag if in debug mode
    if [ "$DEBUG_MODE" = true ]; then
        maestro_cmd+=("--debug-output")
    fi
    
    # Read each key-value pair from JSON and add to command
    while IFS= read -r key && IFS= read -r value; do
        if [ "$value" != "null" ] && [ -n "$value" ]; then
            maestro_cmd+=("--env" "${key}=${value}")
        fi
    done < <(jq -r 'to_entries[] | .key, .value' "$dart_define_file")
    
    # Add dynamically computed variables
    local computed_vars=$(compute_dynamic_variables "$dart_define_file")
    if [ -n "$computed_vars" ]; then
        while IFS= read -r computed_var; do
            if [ -n "$computed_var" ]; then
                maestro_cmd+=("--env" "$computed_var")
            fi
        done <<< "$computed_vars"
    fi
    
    # Add the yaml file to the command
    maestro_cmd+=("$yaml_file")
}

# Execute test with detailed error reporting
execute_test() {
    local yaml_file="$1"
    
    print_header "EXECUTING MAESTRO TEST"
    
    if [ "$VERBOSE" = true ]; then
        print_info "Command: ${maestro_cmd[*]}"
    fi
    
    # Create output directory for artifacts
    local output_dir="${SCRIPT_DIR}/test-output/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$output_dir"
    
    print_info "Test artifacts will be saved to: $output_dir"
    
    # Execute maestro command with output capture
    print_step "Running Maestro test..."
    
    local start_time=$(date +%s)
    
    # Run maestro and capture both stdout and stderr
    if [ "$VERBOSE" = true ]; then
        "${maestro_cmd[@]}" 2>&1 | tee "$output_dir/maestro-output.log"
        local test_result=${PIPESTATUS[0]}
    else
        "${maestro_cmd[@]}" > "$output_dir/maestro-output.log" 2>&1
        local test_result=$?
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Report results
    print_header "TEST RESULTS"
    print_info "Test duration: ${duration} seconds"
    print_info "Output saved to: $output_dir/maestro-output.log"
    
    if [ $test_result -eq 0 ]; then
        print_info "✅ Test PASSED"
        return 0
    else
        print_error "❌ Test FAILED (exit code: $test_result)"
        
        # Enhanced failure analysis
        print_header "FAILURE ANALYSIS"
        
        # Show last few lines of output for quick debugging
        if [ -f "$output_dir/maestro-output.log" ]; then
            print_info "Last 10 lines of output:"
            tail -10 "$output_dir/maestro-output.log" | while read -r line; do
                echo "  $line"
            done
        fi
        
        # Provide debugging suggestions
        print_header "DEBUGGING SUGGESTIONS"
        echo "1. Check the full output in: $output_dir/maestro-output.log"
        echo "2. Verify app is installed and running on the device/simulator"
        echo "3. Check if UI elements exist with correct IDs/text"
        echo "4. Review YAML file syntax and step definitions"
        echo "5. Use --debug flag for more detailed output"
        
        if [ "$CONTINUE_ON_FAIL" = true ]; then
            print_warning "Continuing execution (use --no-continue to exit on failure)"
            return 0
        else
            return $test_result
        fi
    fi
}

# Watch mode for continuous testing
watch_mode() {
    local yaml_file="$1"
    
    print_header "WATCH MODE ENABLED"
    print_info "Monitoring file changes for: $yaml_file"
    print_info "Press Ctrl+C to exit watch mode"
    
    # Check if fswatch is available
    if command -v fswatch &> /dev/null; then
        while true; do
            print_info "Running test ($(date))..."
            execute_test "$yaml_file"
            print_info "Waiting for file changes..."
            fswatch -1 "$yaml_file"
        done
    else
        print_warning "fswatch not available, using basic polling"
        local last_modified=$(stat -f "%m" "$yaml_file" 2>/dev/null || stat -c "%Y" "$yaml_file" 2>/dev/null)
        
        while true; do
            sleep 2
            local current_modified=$(stat -f "%m" "$yaml_file" 2>/dev/null || stat -c "%Y" "$yaml_file" 2>/dev/null)
            
            if [ "$current_modified" != "$last_modified" ]; then
                print_info "File changed, running test..."
                execute_test "$yaml_file"
                last_modified="$current_modified"
            fi
        done
    fi
}

# Main execution function
main() {
    local yaml_file=""
    local dry_run=false
    local validate_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --flavor)
                if [ -z "${2:-}" ]; then
                    print_error "Missing value for --flavor option"
                    show_usage
                    exit 1
                fi
                FLAVOR="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --debug)
                DEBUG_MODE=true
                VERBOSE=true
                shift
                ;;
            --no-continue)
                CONTINUE_ON_FAIL=false
                shift
                ;;
            --watch)
                WATCH_MODE=true
                shift
                ;;
            --no-screenshot)
                SCREENSHOT_ON_FAIL=false
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --validate-only)
                validate_only=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            -*)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                yaml_file="$1"
                shift
                ;;
        esac
    done
    
    # Validation
    if [ -z "$yaml_file" ]; then
        print_error "YAML file path is required"
        show_usage
        exit 1
    fi
    
    if [ ! -f "$yaml_file" ]; then
        print_error "YAML file not found: $yaml_file"
        exit 1
    fi
    
    # Display configuration
    print_header "MAESTRO UI TEST RUNNER"
    print_info "Flavor: $FLAVOR"
    print_info "YAML file: $yaml_file"
    print_info "Mode: $([ "$WATCH_MODE" = true ] && echo "Watch" || echo "Single run")"
    print_info "Failure handling: $([ "$CONTINUE_ON_FAIL" = true ] && echo "Continue" || echo "Exit")"
    
    # Check requirements
    if ! check_requirements; then
        exit 1
    fi
    
    # Validate YAML syntax
    if ! validate_yaml_syntax "$yaml_file"; then
        if [ "$CONTINUE_ON_FAIL" = false ]; then
            exit 1
        fi
    fi
    
    # Parse and validate environment
    local dart_define_file="${APP_ROOT}/.dart_define/${FLAVOR}.json"
    if ! parse_and_validate_environment "$dart_define_file"; then
        exit 1
    fi
    
    # Build maestro command
    build_maestro_command "$dart_define_file" "$yaml_file"
    
    # Handle special modes
    if [ "$dry_run" = true ]; then
        print_header "DRY RUN MODE"
        print_info "Would execute: ${maestro_cmd[*]}"
        exit 0
    fi
    
    if [ "$validate_only" = true ]; then
        print_header "VALIDATION COMPLETE"
        print_info "All validations passed"
        exit 0
    fi
    
    # Execute tests
    if [ "$WATCH_MODE" = true ]; then
        watch_mode "$yaml_file"
    else
        execute_test "$yaml_file"
    fi
}

# Handle interruption gracefully
trap 'print_warning "Test execution interrupted"; exit 130' INT TERM

# Run main function
main "$@"