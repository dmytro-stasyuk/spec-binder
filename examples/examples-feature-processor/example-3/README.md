# Spec Binder Advanced Examples - LIST_OF_OBJECT_PARAMS Mode

This module demonstrates advanced data table processing using the LIST_OF_OBJECT_PARAMS mode, which generates type-safe inner POJO classes for table data without requiring Cucumber dependencies.

## Core Examples

### 1. DataTables with Generated Inner POJOs
When a feature file contains a data table, the processor generates an inner POJO class with fields matching the table's column headers. Step method implementations receive a `List<CustomType>` parameter, where each list element represents one row from the table.

For example, given this Gherkin step with a data table:
```gherkin
Given the following users:
  | name    | age | email              |
  | Alice   | 30  | alice@example.com  |
  | Bob     | 25  | bob@example.com    |
  | Charlie | 35  | charlie@example.com|
```

The processor generates an inner class like:
```java
public static class NameAgeEmail {
    public String name;
    public String age;
    public String email;
}
```

The step method signature becomes:
```java
abstract void givenTheFollowingUsers(List<NameAgeEmail> data);
```

This provides type-safe access to table data (e.g., `data.get(0).name`) without requiring Cucumber's DataTable class or manual parsing.

### 2. Helper Methods in Generated Classes vs Base Class
Two approaches for table-to-map conversion helpers:
- **DataTablesFeature**: The helper method is generated into each scenario class
- **DataTablesWithHelperInBaseClassFeature**: The helper method is defined in the base class for reuse across multiple features

### 3. Configuration Inheritance via @Feature2JUnitOptions
The `BaseFeatureTest` class demonstrates centralized configuration using `@Feature2JUnitOptions`:
- `dataTableParameterType = LIST_OF_OBJECT_PARAMS` - Generates inner POJO classes for table parameters

## Project Structure

```
src/test/
├── resources/specs/        # Gherkin .feature files
└── java/.../featureprocessor/
    ├── BaseFeatureTest.java                            # Base class with @Feature2JUnitOptions
    ├── DataTablesFeature.java                          # Basic approach with generated helpers
    ├── DataTablesWithHelperInBaseClassFeature.java     # Advanced approach with base class helpers
    └── *FeatureTest.java                               # Test implementations with step method stubs
```

## Generated Files

The annotation processor generates abstract test classes in:
```
target/generated-test-sources/test-annotations/.../featureprocessor/
└── *FeatureScenarios.java  # Generated abstract test classes with inner POJO types
```

## Dependencies

This example does **not** require a dependency on the `cucumber-java` library. The LIST_OF_OBJECT_PARAMS mode generates pure Java POJOs as inner classes, making the generated test classes completely independent of Cucumber's runtime.

This is different from example-2, which uses CUCUMBER_DATA_TABLE mode and requires the cucumber-java dependency.

## Running

This module is configured to skip test execution (`skipTests=true`) as it serves
as a reference implementation demonstrating code generation patterns.
