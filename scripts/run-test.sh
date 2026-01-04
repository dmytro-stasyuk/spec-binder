#!/bin/bash
# Run Test - Executes specific tests by name or tag

set -e

# Function to show usage
usage() {
    echo "Usage: $0 [options] <test-name>"
    echo ""
    echo "Options:"
    echo "  -a, --all         Run all tests"
    echo "  -t, --tag TAG     Run tests with specific tag"
    echo "  -f, --feature     Run specific feature file"
    echo "  -s, --suite       Run test suite (default: MappingStepsTest)"
    echo "  -h, --help        Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 --all                           # Run all tests"
    echo "  $0 --tag @smoke                    # Run tests tagged with @smoke"
    echo "  $0 --feature StepMethodName        # Run specific feature"
    echo "  $0 --suite MappingRuleTest         # Run specific test suite"
    echo "  $0 MappingSteps                    # Run tests matching name"
    exit 1
}

# Default values
RUN_ALL=false
TAG=""
FEATURE=""
SUITE=""
TEST_NAME=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--all)
            RUN_ALL=true
            shift
            ;;
        -t|--tag)
            TAG="$2"
            shift 2
            ;;
        -f|--feature)
            FEATURE="$2"
            shift 2
            ;;
        -s|--suite)
            SUITE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            TEST_NAME="$1"
            shift
            ;;
    esac
done

echo "========================================="
echo "Running Cucumber Tests"
echo "========================================="

# Step 1: Compile first
echo "Step 1: Compiling project..."
mvn test-compile -q

if [ "$RUN_ALL" = true ]; then
    echo "Step 2: Running all tests..."
    mvn test -pl feature-processor
elif [ -n "$TAG" ]; then
    echo "Step 2: Running tests with tag: $TAG"
    mvn test -pl feature-processor -Dcucumber.filter.tags="$TAG"
elif [ -n "$FEATURE" ]; then
    echo "Step 2: Running feature: $FEATURE"
    mvn test -pl feature-processor -Dcucumber.features="src/test/resources/features" -Dcucumber.filter.name="$FEATURE"
elif [ -n "$SUITE" ]; then
    echo "Step 2: Running test suite: $SUITE"
    mvn test -pl feature-processor -Dtest="$SUITE"
elif [ -n "$TEST_NAME" ]; then
    echo "Step 2: Running tests matching: $TEST_NAME"
    mvn test -pl feature-processor -Dtest="*$TEST_NAME*"
else
    usage
fi

echo "========================================="
echo "✅ Test execution complete"
echo "========================================="
