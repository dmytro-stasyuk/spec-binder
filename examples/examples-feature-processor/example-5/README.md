# Spec Binder Advanced Examples - Glob Pattern Matching

This module demonstrates using glob patterns in the `@Feature2JUnit` annotation to automatically discover and generate test classes for multiple feature files without requiring individual annotations for each feature.

## Core Concepts

### 1. Glob Pattern in @Feature2JUnit Annotation
Instead of specifying a single feature file path, you can use glob patterns with wildcards:
- `*` - Matches any characters within a single directory level
- `**` - Matches any characters across multiple directory levels

Example: `@Feature2JUnit("specs/**")` matches all `.feature` files in the `specs` directory and all its subdirectories.

### 2. Automatic Class Generation for Each Matching File
When a glob pattern is used, the annotation processor:
1. Finds all feature files matching the pattern
2. Generates a separate abstract test class for each feature file
3. Names each generated class based on the feature file name (e.g., `Login.feature` → `LoginScenarios`)
4. All generated classes extend the base class annotated with `@Feature2JUnit`

### 3. Single Annotation Point for Multiple Features
This example contains 10 feature files organized in subdirectories:

**User Features** (`specs/user/`):
- `Login.feature` → `LoginScenarios` → `LoginTest`
- `Registration.feature` → `RegistrationScenarios` → `RegistrationTest`
- `Profile.feature` → `ProfileScenarios` → `ProfileTest`

**Product Features** (`specs/product/`):
- `Search.feature` → `SearchScenarios` → `SearchTest`
- `Checkout.feature` → `CheckoutScenarios` → `CheckoutTest`

**Admin Features** (`specs/admin/`):
- `Dashboard.feature` → `DashboardScenarios` → `DashboardTest`
- `UserManagement.feature` → `UserManagementScenarios` → `UserManagementTest`

**Account Features** (`specs/account/`):
- `ResetPassword.feature` → `ResetPasswordScenarios` → `ResetPasswordTest`
- `UpdateEmail.feature` → `UpdateEmailScenarios` → `UpdateEmailTest`

All 10 feature files are discovered and processed through a **single annotation** on `AllFeatures.java`.

## Project Structure

```
src/test/
├── resources/specs/        # Hierarchical feature file organization
│   ├── user/
│   │   ├── Login.feature
│   │   ├── Registration.feature
│   │   └── Profile.feature
│   ├── product/
│   │   ├── Search.feature
│   │   └── Checkout.feature
│   ├── admin/
│   │   ├── Dashboard.feature
│   │   └── UserManagement.feature
│   └── account/
│       ├── ResetPassword.feature
│       └── UpdateEmail.feature
└── java/.../featureprocessor/
    ├── AllFeatures.java            # Single base class with @Feature2JUnit("specs/**")
    ├── LoginTest.java              # Implements LoginScenarios
    ├── RegistrationTest.java       # Implements RegistrationScenarios
    ├── ProfileTest.java            # Implements ProfileScenarios
    ├── SearchTest.java             # Implements SearchScenarios
    ├── CheckoutTest.java           # Implements CheckoutScenarios
    ├── DashboardTest.java          # Implements DashboardScenarios
    ├── UserManagementTest.java     # Implements UserManagementScenarios
    ├── ResetPasswordTest.java      # Implements ResetPasswordScenarios
    └── UpdateEmailTest.java        # Implements UpdateEmailScenarios
```

## Generated Files

The annotation processor generates 10 abstract test classes in:
```
target/generated-test-sources/test-annotations/.../featureprocessor/
├── LoginScenarios.java
├── RegistrationScenarios.java
├── ProfileScenarios.java
├── SearchScenarios.java
├── CheckoutScenarios.java
├── DashboardScenarios.java
├── UserManagementScenarios.java
├── ResetPasswordScenarios.java
└── UpdateEmailScenarios.java
```

Each generated class:
- Extends `AllFeatures` (the annotated base class)
- Contains abstract step methods extracted from its corresponding feature file
- Is annotated with `@FeatureFilePath` indicating which feature file it was generated from

## Pattern Syntax Examples

Different pattern styles you can use:

| Pattern | Matches |
|---------|---------|
| `specs/*.feature` | All `.feature` files directly in the `specs` directory |
| `specs/**/*.feature` | All `.feature` files in `specs` and any subdirectories |
| `specs/**` | All `.feature` files in `specs` and subdirectories (`.feature` extension implied) |
| `specs/user/**` | All `.feature` files under `specs/user` and its subdirectories |
| `**/*.feature` | All `.feature` files in any directory |

## Benefits

1. **Reduced Boilerplate**: No need to create a separate marker class for each feature file
2. **Better Organization**: Feature files can be organized in a hierarchical directory structure
3. **Automatic Discovery**: New feature files matching the pattern are automatically included
4. **Shared Configuration**: All generated classes inherit settings from the single base class
5. **Maintainability**: Adding new features requires only creating the `.feature` file and corresponding test implementation

## Important Constraints

### File Name Uniqueness
All feature files matched by a pattern must have **unique file names**, even if they're in different directories. For example, this would cause an error:
```
specs/user/Login.feature
specs/admin/Login.feature  # ERROR: duplicate name "Login"
```

Both files would generate a class named `LoginScenarios`, causing a conflict. Use distinct names like `UserLogin.feature` and `AdminLogin.feature` instead.

## Dependencies

This example does **not** require a dependency on the `cucumber-java` library.
The feature2junit processor generates pure JUnit 5 test classes that are independent
of Cucumber's runtime.

## Running

This module is configured to skip test execution (`skipTests=true`) as it serves
as a reference implementation demonstrating code generation patterns.
