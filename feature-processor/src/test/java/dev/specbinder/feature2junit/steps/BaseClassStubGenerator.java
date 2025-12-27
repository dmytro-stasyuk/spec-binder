package dev.specbinder.feature2junit.steps;

/**
 * Utility class for generating minimal base class stubs for compilation verification.
 * These stubs allow generated test code to compile successfully during testing.
 */
public class BaseClassStubGenerator {

    /**
     * Creates a minimal stub for the base class with an optional extends clause.
     * This allows the generated code to compile successfully with inheritance hierarchies.
     *
     * @param packageName   the package name (can be null for default package)
     * @param className     the simple class name
     * @param extendsClause the extends clause (e.g., " extends SuperClass") or empty string
     * @return the source code for the base class stub
     */
    public static String createBaseClassStubWithSuperclass(String packageName, String className, String extendsClause) {
        StringBuilder stub = new StringBuilder();

        // Add package declaration if present
        if (packageName != null && !packageName.isEmpty()) {
            stub.append("package ").append(packageName).append(";\n\n");
        }

        // Create a minimal abstract class stub with optional extends clause
        stub.append("public abstract class ").append(className).append(extendsClause).append(" {\n");
        stub.append("}\n");

        return stub.toString();
    }
}
