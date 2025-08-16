#!/bin/bash
# TDD Red Phase: Test for auto-label bug - app directory changes not labeled
# F.I.R.S.T. Principles: Fast, Independent, Repeatable, Self-validating, Timely

set -e

echo "=== TDD Red Phase: Testing auto-label bug ==="

# Test Case 1: Verify the bug exists (this should FAIL initially)
echo "🔴 Test 1: Checking if auto-label.yml references correct output variable"

# Read the auto-label workflow file
AUTO_LABEL_FILE="../../.github/workflows/auto-label.yml"

if [ ! -f "$AUTO_LABEL_FILE" ]; then
    echo "❌ FAIL: auto-label.yml not found"
    exit 1
fi

# Check if workflow uses the wrong variable name (should fail in Red phase)
if grep -q "changed_packages" "$AUTO_LABEL_FILE"; then
    echo "❌ FAIL: auto-label.yml still uses 'changed_packages' instead of 'changed_workspaces'"
    echo "   This is the bug - action outputs 'changed_workspaces' but workflow reads 'changed_packages'"
    
    # Also check what the action actually outputs
    ACTION_FILE="../../.github/actions/check-changes/action.yml"
    echo "🔍 Checking action outputs:"
    grep -A 1 "changed_workspaces:" "$ACTION_FILE" || echo "   No changed_workspaces output found"
    grep -A 1 "changed_packages:" "$ACTION_FILE" || echo "   No changed_packages output found"
    
    echo "🎯 Expected behavior: Workflow should read 'changed_workspaces' to get app label"
    exit 1  # This is expected to fail in Red phase
else
    echo "✅ PASS: auto-label.yml correctly uses 'changed_workspaces'"
    exit 0
fi