#!/bin/bash
# TDD Green Phase: Validate fix works
# F.I.R.S.T. Principles: Fast, Independent, Repeatable, Self-validating, Timely

set -e

echo "=== TDD Green Phase: Validating auto-label fix ==="

# Test Case 1: Verify the fix is applied (this should PASS now)
echo "✅ Test 1: Checking if auto-label.yml uses correct output variable"

# Read the auto-label workflow file
AUTO_LABEL_FILE="../../.github/workflows/auto-label.yml"

if [ ! -f "$AUTO_LABEL_FILE" ]; then
    echo "❌ FAIL: auto-label.yml not found"
    exit 1
fi

# Check if workflow now uses the correct variable name (should pass in Green phase)
if grep -q "changed_workspaces" "$AUTO_LABEL_FILE"; then
    echo "✅ PASS: auto-label.yml correctly uses 'changed_workspaces'"
    
    # Verify it doesn't use the old incorrect variable
    if grep -q "changed_packages" "$AUTO_LABEL_FILE"; then
        echo "❌ FAIL: auto-label.yml still contains 'changed_packages'"
        exit 1
    fi
    
    echo "✅ PASS: Fixed variable reference, app directory changes will now be labeled correctly"
    exit 0
else
    echo "❌ FAIL: auto-label.yml doesn't use 'changed_workspaces'"
    exit 1
fi