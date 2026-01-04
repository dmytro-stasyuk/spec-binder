# Spec Binder Examples

This module contains basic examples demonstrating how the feature2junit generator converts Gherkin feature files into JUnit 5 test classes.

## Core Examples

### 1. SimpleScenario
Basic Given/When/Then steps converted to method calls in a test class.

### 2. ScenarioWithBackground
Background sections converted to `@BeforeEach` methods that execute before each scenario.

### 3. ScenarioOutline
Scenario Outlines with Examples tables converted to `@ParameterizedTest` methods with `@CsvSource`.

### 4. TaggedScenarios
Gherkin tags converted to JUnit `@Tag` annotations for selective test execution.

### 5. TaggedFeatureAndRules
Tags applied at Feature, Rule, and Scenario levels, demonstrating multi-level tag propagation.

### 6. FeatureWithRules
Gherkin Rules converted to `@Nested` test classes with optional Rule-specific Background sections.

### 7. DataTables
Data tables converted to `DataTable` parameters with POJO mapping examples.

### 8. DocStrings
Doc strings (multi-line text blocks) converted to String parameters in step methods.

## Project Structure

```
src/test/
├── resources/specs/        # Gherkin .feature files
└── java/.../featureprocessor/
    ├── *Feature.java       # Marker classes with @Feature2JUnit annotation
    └── *FeatureTest.java   # Test implementations with step method stubs
```

## Generated Files

The annotation processor generates abstract test classes in:
```
target/generated-test-sources/test-annotations/.../featureprocessor/
└── *FeatureScenarios.java  # Generated abstract test classes
```

## Dependencies

This example does **not** require a dependency on the `cucumber-java` library. 
The feature2junit processor generates pure JUnit 5 test classes that are independent 
of Cucumber's runtime.

## Running

This module is configured to skip test execution (`skipTests=true`) as it serves 
as a reference implementation demonstrating code generation patterns.
