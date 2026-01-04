#!/bin/bash
# Create New Scenario - Generates a new feature file with scenario template

set -e

FEATURES_DIR="feature-processor/src/test/resources/features"

# Function to show usage
usage() {
    echo "Usage: $0 <category> <feature-name>"
    echo ""
    echo "Creates a new feature file with scenario template"
    echo ""
    echo "Categories:"
    echo "  - background"
    echo "  - comments"
    echo "  - feature"
    echo "  - rule"
    echo "  - scenario"
    echo "  - scenario_outline"
    echo "  - steps"
    echo "  - steps/data_tables"
    echo "  - steps/doc_strings"
    echo "  - steps/simple_parameters"
    echo "  - generated_class"
    echo ""
    echo "Example: $0 steps MyNewStepFeature"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    usage
fi

CATEGORY="$1"
FEATURE_NAME="$2"

# Validate feature name (PascalCase)
if ! [[ "$FEATURE_NAME" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
    echo "Error: Feature name must be in PascalCase (e.g., MyFeatureName)"
    exit 1
fi

# Create target directory
TARGET_DIR="$FEATURES_DIR/$CATEGORY"
mkdir -p "$TARGET_DIR"

# Create feature file
FEATURE_FILE="$TARGET_DIR/$FEATURE_NAME.feature"

if [ -f "$FEATURE_FILE" ]; then
    echo "Error: Feature file already exists: $FEATURE_FILE"
    exit 1
fi

# Generate feature content (following the naming convention)
cat > "$FEATURE_FILE" << EOF
Feature: $FEATURE_NAME

  As a developer
  I want to test [describe what you want to test]
  So that [describe the benefit]

  Scenario: [Describe your scenario]
    Given [initial context]
    When [action occurs]
    Then [expected outcome]

  # Add more scenarios below
  # Scenario: Another scenario
  #   Given [context]
  #   When [action]
  #   Then [outcome]
EOF

echo "✅ Created feature file: $FEATURE_FILE"
echo ""
echo "Next steps:"
echo "1. Edit the feature file to define your scenarios"
echo "2. Create a test class in: feature-processor/src/test/java/dev/specbinder/feature2junit/tests/"
echo "3. Run tests using: ./scripts/run-test.sh $FEATURE_NAME"
echo ""
echo "Opening file in editor..."
