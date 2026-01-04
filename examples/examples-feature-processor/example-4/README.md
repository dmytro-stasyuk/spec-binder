# Spec Binder Advanced Examples - Co-located Feature Files

This module demonstrates advanced feature file organization by co-locating `.feature` files with Java source code, enabled by omitting the path in the `@Feature2JUnit` annotation and configuring Maven to treat `.feature` files as test resources.

## Core Examples

### 1. Feature Files in src/test/java
Instead of placing feature files in `src/test/resources/specs/`, this example places them directly in `src/test/java` alongside the Java classes. This approach keeps related files together and reduces cognitive overhead when navigating the codebase.

### 2. @Feature2JUnit Without Explicit Path
When the `@Feature2JUnit` annotation is used without a value (path), the processor looks for a feature file with the same name as the annotated class in the same package. For example, `SimpleExample.java` automatically resolves to `SimpleExample.feature` in the same directory.

### 3. Maven Configuration for Feature Files
The `pom.xml` configures the build to treat `.feature` files in `src/test/java` as test resources:
```xml
<testResources>
    <testResource>
        <directory>src/test/java</directory>
        <includes>
            <include>**/*.feature</include>
        </includes>
    </testResource>
</testResources>
```

## Project Structure

```
src/test/
└── java/.../featureprocessor/
    ├── SimpleExample.feature       # Feature file co-located with Java code
    ├── SimpleExample.java          # Marker class with @Feature2JUnit (no path)
    └── SimpleExampleTest.java      # Test implementation with step method stubs
```

Note: No `resources/specs/` directory is needed - feature files live alongside Java source.

## Generated Files

The annotation processor generates abstract test classes in:
```
target/generated-test-sources/test-annotations/.../featureprocessor/
└── SimpleExampleScenarios.java  # Generated abstract test class
```

## Dependencies

This example does **not** require a dependency on the `cucumber-java` library.
The feature2junit processor generates pure JUnit 5 test classes that are independent
of Cucumber's runtime.

## Benefits of This Approach

- **Improved discoverability**: Feature files are in the same directory as related Java code
- **Simpler navigation**: No need to switch between `src/test/java` and `src/test/resources`
- **Convention over configuration**: Omitting the path relies on naming conventions rather than explicit paths
- **Reduced maintenance**: Renaming a class requires renaming only the feature file, not updating path strings

## Running

This module is configured to skip test execution (`skipTests=true`) as it serves
as a reference implementation demonstrating code generation patterns.
