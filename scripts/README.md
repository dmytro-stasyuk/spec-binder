# Cucumber Test Helper Scripts

This directory contains custom commands for working with Cucumber-Java testing in the spec-binder project.

## Available Commands

### 1. Review Features (`review-features.sh`)

Lists all feature files with their scenarios, providing a quick overview of your test suite.

```bash
./scripts/review-features.sh

# Filter by pattern
./scripts/review-features.sh steps
```

**Output includes:**
- Feature file path
- Feature name
- Scenario counts (regular and outline)
- List of all scenario names

### 2. Create New Scenario (`new-scenario.sh`)

Generates a new feature file with a scenario template, following the project's naming conventions.

```bash
./scripts/new-scenario.sh <category> <FeatureName>

# Examples:
./scripts/new-scenario.sh steps MyNewStepFeature
./scripts/new-scenario.sh scenario MyScenarioTest
./scripts/new-scenario.sh steps/data_tables MyDataTableTest
```

**Available categories:**
- `background` - Background-related features
- `comments` - Comment handling features
- `feature` - Feature-level tests
- `rule` - Rule block tests
- `scenario` - Scenario tests
- `scenario_outline` - Scenario Outline tests
- `steps` - Step-related tests
- `steps/data_tables` - Data table tests
- `steps/doc_strings` - Doc string tests
- `steps/simple_parameters` - Parameter tests
- `generated_class` - Generated class tests

**Important:** Feature name must be in PascalCase (e.g., `MyFeatureName`)

### 3. Run Tests (`run-test.sh`)

Executes specific tests with various filtering options. Uses the hybrid approach (Maven compile + test execution).

```bash
# Run all tests
./scripts/run-test.sh --all

# Run tests with specific tag
./scripts/run-test.sh --tag @smoke

# Run specific feature
./scripts/run-test.sh --feature StepMethodName

# Run specific test suite
./scripts/run-test.sh --suite MappingStepsTest

# Run tests matching name
./scripts/run-test.sh MappingSteps
```

**Options:**
- `-a, --all` - Run all tests
- `-t, --tag TAG` - Run tests with specific tag
- `-f, --feature` - Run specific feature file
- `-s, --suite` - Run test suite (e.g., MappingStepsTest)
- `-h, --help` - Show help

### 4. Setup Cucumber Hooks (`cucumber-hooks.sh`)

Creates Cucumber hook classes for Before/After test execution.

```bash
./scripts/cucumber-hooks.sh
```

**Creates:**
- `TestHooks.java` - Before/After scenario hooks with tag support
- `LoggingHooks.java` - Execution time logging
- `ScreenshotHooks.java` - Failure handling hooks

**Hook features:**
- Global hooks that run before/after each scenario
- Tagged hooks (e.g., `@database`) for specific scenarios
- Execution time tracking
- Failure detection for screenshots/cleanup

## Quick Start

```bash
# 1. Review existing features
./scripts/review-features.sh

# 2. Create a new feature
./scripts/new-scenario.sh steps MyNewFeature

# 3. Edit the generated feature file
# (Located in feature-processor/src/test/resources/features/steps/MyNewFeature.feature)

# 4. Run your new test
./scripts/run-test.sh --feature MyNewFeature

# 5. Setup hooks if needed
./scripts/cucumber-hooks.sh
```

## Integration with IntelliJ IDEA

While these scripts use Maven commands for compilation and testing, you can also:

1. Use IntelliJ's MCP server tools for better IDE integration
2. Run tests directly from IntelliJ's run configurations
3. Use the `AllTests` configuration to run all tests

See `CLAUDE.md` for details on the hybrid testing approach.

## Notes

- All scripts must be run from the project root directory
- Scripts automatically compile the project before running tests
- Feature names must follow PascalCase convention
- Hook classes are automatically discovered by Cucumber
