# Spec Binder Advanced Examples - Configuration Inheritance and Cucumber Integration

This module demonstrates configuration inheritance via `@Feature2JUnitOptions`, Cucumber DataTable integration, and Cucumber annotation generation.

## Core Examples

### 1. DataTables with Cucumber DataTable Parameter Type
When Gherkin feature files contain data tables, the processor can generate step methods with different parameter types. This example uses `dataTableParameterType = CUCUMBER_DATA_TABLE`, which generates step method parameters of type `io.cucumber.datatable.DataTable` from the Cucumber library. This type provides rich table manipulation capabilities including:
- Converting table rows to POJOs using `asList(MyClass.class)`
- Converting tables to maps with `asMap(String.class, String.class)`
- Flexible row and column access with `cells()`, `row(int)`, and `column(int)`
- Direct integration with Cucumber's data transformation features

This contrasts with the simpler `LIST_OF_MAPS` parameter type (used in other examples) which generates basic `List<Map<String>>` parameters without requiring the Cucumber dependency.

### 2. Configuration Inheritance via @Feature2JUnitOptions
The `BaseFeatureTest` class demonstrates centralized configuration using `@Feature2JUnitOptions`. All test classes that extend this base class inherit the configuration:
- `dataTableParameterType = CUCUMBER_DATA_TABLE` - Uses Cucumber's DataTable type for table parameters
- `addCucumberStepAnnotations = true` - Adds @Given, @When, @Then annotations to generated step methods

### 3. Cucumber Step Annotations
Generated abstract step methods include Cucumber annotations (@Given, @When, @Then), enabling integration with Cucumber-related IDE plugins. These annotations allow IDE features such as navigation between feature file steps and their Java implementations and step usage highlighting.

## Project Structure

```
src/test/
├── resources/specs/        # Gherkin .feature files
└── java/.../featureprocessor/
    ├── BaseFeatureTest.java    # Base class with @Feature2JUnitOptions
    ├── *Feature.java           # Marker classes with @Feature2JUnit annotation
    └── *FeatureTest.java       # Test implementations with step method stubs
```

## Generated Files

The annotation processor generates abstract test classes in:
```
target/generated-test-sources/test-annotations/.../featureprocessor/
└── *FeatureScenarios.java  # Generated abstract test classes
```

## Dependencies

This example **requires** a dependency on the `cucumber-java` library because it uses Cucumber's `DataTable` class for table parameter processing. The DataTable type enables POJO mapping and advanced table manipulation in step implementations.

## Running

This module is configured to skip test execution (`skipTests=true`) as it serves
as a reference implementation demonstrating code generation patterns.
