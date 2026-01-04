package dev.specbinder.feature2junit.steps;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class for generating complete base class stubs for compilation verification.
 * Extracts methods from source code and adds necessary imports to ensure the stub compiles.
 */
public class BaseClassStubGenerator {

    /**
     * Creates a complete stub for the base class including methods from the source code.
     * This ensures the generated code compiles successfully with proper inheritance hierarchies.
     *
     * @param sourceCode    the original source code (may have incomplete imports)
     * @param extendsClause the extends clause (e.g., " extends SuperClass") or empty string
     * @return the source code for the complete base class stub with all necessary imports
     */
    public static String createCompleteStub(String sourceCode, String extendsClause) {
        StringBuilder stub = new StringBuilder();

        // Extract package name
        String packageName = extractPackage(sourceCode);
        if (packageName != null && !packageName.isEmpty()) {
            stub.append("package ").append(packageName).append(";\n\n");
        }

        // Extract and add imports from source code
        // Filter out incorrect imports for annotations (they should come from dev.specbinder.annotations)
        List<String> imports = extractImports(sourceCode);
        for (String importStmt : imports) {
            // Skip incorrect annotation imports
            if (importStmt.contains("Feature2JUnit") && !importStmt.contains("dev.specbinder.annotations")) {
                continue;
            }
            if (importStmt.contains("Feature2JUnitOptions") && !importStmt.contains("dev.specbinder.annotations")) {
                continue;
            }
            stub.append(importStmt).append("\n");
        }

        // Add necessary imports (standardized set for all test scenarios)
        // Only add if not already present with correct package
        if (!imports.stream().anyMatch(i -> i.contains("dev.specbinder.annotations.Feature2JUnit"))) {
            stub.append("import dev.specbinder.annotations.Feature2JUnit;\n");
        }
        if (!imports.stream().anyMatch(i -> i.contains("dev.specbinder.annotations.Feature2JUnitOptions"))) {
            stub.append("import dev.specbinder.annotations.Feature2JUnitOptions;\n");
        }
        if (!imports.stream().anyMatch(i -> i.contains("DataTable"))) {
            stub.append("import io.cucumber.datatable.DataTable;\n");
        }
        stub.append("\n");

        // Extract class declaration
        String className = extractClassName(sourceCode);
        String classModifiers = extractClassModifiers(sourceCode);

        // Create class declaration with extends clause
        stub.append(classModifiers).append("class ").append(className).append(extendsClause).append(" {\n");

        // Extract and add methods from source code
        List<String> methods = extractMethods(sourceCode);
        for (String method : methods) {
            stub.append("    ").append(method).append("\n");
        }

        stub.append("}\n");

        return stub.toString();
    }

    /**
     * Extracts the package declaration from source code.
     */
    private static String extractPackage(String sourceCode) {
        Pattern pattern = Pattern.compile("package\\s+([\\w.]+)\\s*;");
        Matcher matcher = pattern.matcher(sourceCode);
        return matcher.find() ? matcher.group(1) : null;
    }

    /**
     * Extracts import statements from source code.
     */
    private static List<String> extractImports(String sourceCode) {
        List<String> imports = new ArrayList<>();
        Pattern pattern = Pattern.compile("^\\s*import\\s+(?:static\\s+)?[\\w.*]+(?:\\.\\w+)*\\s*;", Pattern.MULTILINE);
        Matcher matcher = pattern.matcher(sourceCode);
        while (matcher.find()) {
            imports.add(matcher.group().trim());
        }
        return imports;
    }

    /**
     * Extracts the class name from source code.
     */
    private static String extractClassName(String sourceCode) {
        Pattern pattern = Pattern.compile("(?:public|private|protected)?\\s*(?:abstract)?\\s*class\\s+(\\w+)");
        Matcher matcher = pattern.matcher(sourceCode);
        return matcher.find() ? matcher.group(1) : "UnknownClass";
    }

    /**
     * Extracts class modifiers (public, abstract, etc.) from source code.
     */
    private static String extractClassModifiers(String sourceCode) {
        Pattern pattern = Pattern.compile("((?:public|private|protected)?\\s*(?:abstract)?\\s*)class\\s+\\w+");
        Matcher matcher = pattern.matcher(sourceCode);
        if (matcher.find()) {
            String modifiers = matcher.group(1).trim();
            return modifiers.isEmpty() ? "" : modifiers + " ";
        }
        return "public abstract ";
    }

    /**
     * Extracts complete method declarations from source code.
     * Returns method signature and body.
     */
    private static List<String> extractMethods(String sourceCode) {
        List<String> methods = new ArrayList<>();

        // Find the class body (everything between class declaration and the last closing brace)
        int classStart = sourceCode.indexOf("{");
        int classEnd = sourceCode.lastIndexOf("}");

        if (classStart == -1 || classEnd == -1 || classStart >= classEnd) {
            return methods;
        }

        String classBody = sourceCode.substring(classStart + 1, classEnd);

        // Match methods with a more robust pattern that handles nested braces
        // Look for: [modifiers] returnType methodName(params) { body }
        int i = 0;
        while (i < classBody.length()) {
            // Skip whitespace
            while (i < classBody.length() && Character.isWhitespace(classBody.charAt(i))) {
                i++;
            }
            if (i >= classBody.length()) break;

            // Try to find method signature (ending with opening brace or semicolon)
            int methodStart = i;
            int parenDepth = 0;
            boolean inParams = false;
            int bodyStart = -1;

            // Scan for method pattern: modifiers returnType methodName(params)
            while (i < classBody.length()) {
                char c = classBody.charAt(i);

                if (c == '(') {
                    inParams = true;
                    parenDepth++;
                } else if (c == ')' && inParams) {
                    parenDepth--;
                    if (parenDepth == 0) {
                        inParams = false;
                    }
                } else if (c == '{' && !inParams && parenDepth == 0) {
                    bodyStart = i;
                    break;
                } else if (c == ';' && !inParams && parenDepth == 0) {
                    // Abstract method or field - skip it
                    i++;
                    break;
                }
                i++;
            }

            if (bodyStart == -1) {
                // No body found, skip to next potential method
                continue;
            }

            // Extract method body (count braces to find matching closing brace)
            int braceDepth = 1;
            i = bodyStart + 1;
            while (i < classBody.length() && braceDepth > 0) {
                char c = classBody.charAt(i);
                if (c == '{') braceDepth++;
                else if (c == '}') braceDepth--;
                i++;
            }

            if (braceDepth == 0) {
                // Found complete method
                String method = classBody.substring(methodStart, i).trim();
                methods.add(method);
            }
        }

        return methods;
    }
}
