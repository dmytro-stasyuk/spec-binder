# Spec Binder Advanced Examples - Concrete Test Classes with Interface Delegation

This module demonstrates generating concrete, executable test classes using the `shouldBeConcrete = true` option combined with step method delegation to interfaces implementing default methods.

## Core Concepts

### 1. Concrete Test Class Generation
By default, the feature2junit processor generates abstract test classes requiring a subclass implementation. With `@Feature2JUnitOptions(shouldBeConcrete = true)`, the processor generates concrete classes that can be executed directly as JUnit tests without additional implementation.

### 2. Step Method Resolution Workflow
When the processor encounters a step from a feature file:
- It first searches the annotated class hierarchy for a matching method
- If found, the generated class delegates to that existing method
- If not found, it adds a stub method with a failing assumption statement to the generated class

Developers move these failing stubs into the base class hierarchy and implement them. On the next generation run, the processor detects the implementation and excludes the method from the generated output.

### 3. Interface-Based Step Implementation
Step methods can be implemented as default methods in interfaces that the annotated class implements. This example demonstrates this pattern with three step interfaces:
- `ShoppingCartSteps` - Shopping cart operations
- `LoginSteps` - User authentication steps
- `CalculatorSteps` - Calculator functionality steps

The annotated class `GeneratedClassIsConcreteExample` implements these interfaces, making all their default methods available to the generated test classes.

### 4. Glob Pattern Matching with Test Suites
This example uses `@Feature2JUnit("specs/*.feature")` to match multiple feature files. When using glob patterns, it's recommended to create a JUnit suite class (like `TestSuite.java`) that explicitly references each generated test class. This provides:
- Better organization for running tests in logical groups
- An early warning system for generation failures (missing generated classes trigger compile-time errors)

## Project Structure

```
src/test/
├── resources/specs/                              # Feature files
│   ├── SimpleCalculator.feature
│   ├── ScenarioWithBackground.feature
│   └── AnotherFeatureWithRule.feature
└── java/.../featureprocessor/
    ├── GeneratedClassIsConcreteExample.java      # Base class with @Feature2JUnit
    ├── TestSuite.java                            # JUnit suite referencing generated tests
    └── steps/
        ├── CalculatorSteps.java                  # Calculator step implementations
        ├── LoginSteps.java                       # Login step implementations
        └── ShoppingCartSteps.java                # Shopping cart step implementations
```

## Generated Files

The annotation processor generates concrete test classes in:
```
target/generated-test-sources/test-annotations/.../featureprocessor/
├── SimpleCalculatorTest.java                     # Concrete test class
├── ScenarioWithBackgroundTest.java               # Concrete test class
└── AnotherFeatureWithRuleTest.java               # Concrete test class
```

Each generated class:
- Extends `GeneratedClassIsConcreteExample`
- Is a concrete class (not abstract) due to `shouldBeConcrete = true`
- Contains step method implementations that delegate to the step interfaces
- Can be executed directly as a JUnit 5 test

## Configuration

The example uses the following annotation configuration:
```java
@Feature2JUnitOptions(shouldBeConcrete = true)
@Feature2JUnit("specs/*.feature")
public abstract class GeneratedClassIsConcreteExample
        implements ShoppingCartSteps, LoginSteps, CalculatorSteps {
}
```

## Benefits

1. **Immediate Execution**: Generated classes are ready to run without creating test implementations
2. **Modular Step Libraries**: Step methods organized in focused interfaces by domain
3. **Code Reuse**: Multiple generated classes share the same step implementations via interfaces
4. **Compile-Time Safety**: Missing step implementations cause failing tests, not compilation errors
5. **Iterative Development**: Start with failing stubs, implement gradually, re-generate automatically
6. **Explicit Test Organization**: Test suite provides clear structure and catches generation issues early

## Dependencies

This example does **not** require a dependency on the `cucumber-java` library.
The feature2junit processor generates pure JUnit 5 test classes that are independent
of Cucumber's runtime.

## Running

This module is configured to skip test execution (`skipTests=true`) as it serves
as a reference implementation demonstrating code generation patterns.
