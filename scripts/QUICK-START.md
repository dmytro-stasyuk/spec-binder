# Quick Start Guide - Cucumber Testing Commands

## Common Workflows

### 1. Explore Your Features

```bash
# List all features
./scripts/review-features.sh

# See features in steps directory
./scripts/review-features.sh steps
```

### 2. Create a New Feature Test

```bash
# Create a new feature file
./scripts/new-scenario.sh steps MyCustomSteps

# The script creates:
# - feature-processor/src/test/resources/features/steps/MyCustomSteps.feature
# - Opens it for editing
```

### 3. Run Tests

```bash
# Run all tests
./scripts/run-test.sh --all

# Run specific suite
./scripts/run-test.sh --suite MappingStepsTest

# Run tests matching a name
./scripts/run-test.sh Mapping
```

### 4. Set Up Hooks (One-time)

```bash
# Create hook classes
./scripts/cucumber-hooks.sh

# This creates:
# - TestHooks.java (Before/After each scenario)
# - LoggingHooks.java (Execution time logging)
# - ScreenshotHooks.java (Failure handling)
```

## Example: Adding a New Test

```bash
# 1. Create the feature file
./scripts/new-scenario.sh steps/data_tables CustomDataTableMapping

# 2. Edit the feature file (it's already created with template)
# Add your Gherkin scenarios in:
# feature-processor/src/test/resources/features/steps/data_tables/CustomDataTableMapping.feature

# 3. Create the test class
# Create: feature-processor/src/test/java/dev/specbinder/feature2junit/tests/CustomDataTableMappingTest.java

# 4. Run your test
./scripts/run-test.sh --feature CustomDataTableMapping
```

## Tips

- Feature names must be PascalCase
- Scripts run from project root directory
- Tests compile automatically before execution
- All scripts have `--help` option for details

## Next Steps

- Read `scripts/README.md` for complete documentation
- Check existing features for examples: `./scripts/review-features.sh`
- Run all tests to verify setup: `./scripts/run-test.sh --all`
