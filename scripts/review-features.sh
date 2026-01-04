#!/bin/bash
# Review Features - Lists all feature files with their scenarios

set -e

FEATURES_DIR="feature-processor/src/test/resources/features"
SEARCH_PATTERN="${1:-**/*.feature}"

echo "========================================="
echo "Feature Files Review"
echo "========================================="
echo ""

if [ ! -d "$FEATURES_DIR" ]; then
    echo "Error: Features directory not found: $FEATURES_DIR"
    exit 1
fi

# Find and process feature files
find "$FEATURES_DIR" -name "*.feature" -type f | sort | while read -r feature_file; do
    relative_path="${feature_file#$FEATURES_DIR/}"

    echo "📄 $relative_path"
    echo "   Path: $feature_file"

    # Extract feature name
    feature_name=$(grep -m 1 "^Feature:" "$feature_file" | sed 's/Feature: *//' || echo "N/A")
    echo "   Feature: $feature_name"

    # Count scenarios (handle both 2-space and 4-space indentation)
    scenario_count=$(grep -E "^  (  )?Scenario:" "$feature_file" 2>/dev/null | wc -l | tr -d ' ')
    outline_count=$(grep -E "^  (  )?Scenario Outline:" "$feature_file" 2>/dev/null | wc -l | tr -d ' ')

    echo "   Scenarios: $scenario_count regular, $outline_count outline"

    # List scenario names
    if [ "$scenario_count" != "0" ] || [ "$outline_count" != "0" ]; then
        echo "   Scenario list:"
        grep -E "^  (  )?Scenario" "$feature_file" | sed -E 's/^  (  )?Scenario[^:]*: */     - /' || true
    fi

    echo ""
done

echo "========================================="
echo "Use: $0 [pattern] to filter features"
echo "Example: $0 steps"
echo "========================================="
