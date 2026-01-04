package dev.specbinder.feature2junit.steps;

import org.junit.jupiter.api.Assertions;

import javax.tools.*;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class for verifying that generated Java source code compiles successfully.
 * Uses the Java Compiler API to perform in-memory compilation.
 */
class CompilationVerifier {

    /**
     * Extracts the fully qualified class name from Java source code.
     *
     * @param sourceCode the Java source code
     * @return the fully qualified class name, or null if it cannot be determined
     */
    static String extractFullyQualifiedClassName(String sourceCode) {
        String packageName = null;
        String className = null;

        // Extract package name
        Pattern packagePattern = Pattern.compile("^\\s*package\\s+([\\w.]+)\\s*;", Pattern.MULTILINE);
        Matcher packageMatcher = packagePattern.matcher(sourceCode);
        if (packageMatcher.find()) {
            packageName = packageMatcher.group(1);
        }

        // Extract class name (supports class, abstract class, interface, enum, record)
        Pattern classPattern = Pattern.compile(
                "^\\s*(?:public\\s+)?(?:abstract\\s+)?(?:final\\s+)?(?:class|interface|enum|record)\\s+(\\w+)",
                Pattern.MULTILINE
        );
        Matcher classMatcher = classPattern.matcher(sourceCode);
        if (classMatcher.find()) {
            className = classMatcher.group(1);
        }

        if (className == null) {
            return null;
        }

        return packageName != null ? packageName + "." + className : className;
    }

    /**
     * Verifies that the given Java source code compiles successfully.
     * This version accepts a map of class names to source code, allowing compilation of multiple files together.
     *
     * @param sourceFiles map of fully qualified class names to their source code
     * @param featureFilePath optional path to the feature file (used to organize output directories)
     * @throws AssertionError if compilation fails
     */
    static void verifyCompilation(Map<String, String> sourceFiles, String featureFilePath) {
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        Assertions.assertNotNull(compiler, "Java compiler not available. Ensure you're running with JDK, not JRE.");

        DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<>();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(diagnostics, null, null);

        // Create in-memory Java file objects for all source files
        List<JavaFileObject> compilationUnits = new ArrayList<>();
        for (Map.Entry<String, String> entry : sourceFiles.entrySet()) {
            compilationUnits.add(new InMemoryJavaFileObject(entry.getKey(), entry.getValue()));
        }

        // Create output directory for compiled classes
        File outputDir = createOutputDirectory(featureFilePath);
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }

        // Get the current classpath to resolve dependencies
        String classpath = System.getProperty("java.class.path");

        // Compiler options: disable annotation processing, use current classpath, and set output directory
        List<String> options = Arrays.asList(
                "-proc:none", // Disable annotation processing to avoid warnings
                "-classpath", classpath, // Use current classpath to resolve annotations
                "-d", outputDir.getAbsolutePath() // Output directory for compiled classes
        );

        // Compile the source code
        JavaCompiler.CompilationTask task = compiler.getTask(
                null, // Writer for additional output
                fileManager, // File manager
                diagnostics, // Diagnostic collector
                options, // Compiler options
                null, // Classes for annotation processing
                compilationUnits // Compilation units
        );

        boolean success = task.call();

        if (!success) {
            StringBuilder errorMessage = new StringBuilder("Generated code failed to compile:\n");
            for (Diagnostic<? extends JavaFileObject> diagnostic : diagnostics.getDiagnostics()) {
                // Skip warnings
                if (diagnostic.getKind() == Diagnostic.Kind.WARNING) {
                    continue;
                }

                errorMessage.append(String.format(
                        "Line %d: %s%n",
                        diagnostic.getLineNumber(),
                        diagnostic.getMessage(null)
                ));
            }
            Assertions.fail(errorMessage.toString());
        }

        try {
            fileManager.close();
        } catch (IOException e) {
            // Ignore close errors
        }
    }

    /**
     * Creates the output directory based on the feature file path.
     * Extracts the relative path from the feature file and creates a directory structure under target/temp.
     *
     * @param featureFilePath path to the feature file (can be null)
     * @return the output directory for compiled classes
     */
    private static File createOutputDirectory(String featureFilePath) {
        if (featureFilePath == null || featureFilePath.isEmpty()) {
            return new File("target/temp");
        }

        // Remove .feature extension if present
        String pathWithoutExtension = featureFilePath.endsWith(".feature")
                ? featureFilePath.substring(0, featureFilePath.length() - ".feature".length())
                : featureFilePath;

        // Extract relative path after "features/" if present
        String relativePath;
        int featuresIndex = pathWithoutExtension.indexOf("features/");
        if (featuresIndex != -1) {
            relativePath = pathWithoutExtension.substring(featuresIndex);
        } else {
            // If "features/" not found, use the entire path
            relativePath = pathWithoutExtension;
        }

        // Create the full output path: target/temp/<relative-path>/
        return new File("target/temp/" + relativePath);
    }

    /**
     * Verifies that the given Java source code compiles successfully.
     * This version accepts a map of class names to source code, allowing compilation of multiple files together.
     *
     * @param sourceFiles map of fully qualified class names to their source code
     * @throws AssertionError if compilation fails
     */
    static void verifyCompilation(Map<String, String> sourceFiles) {
        verifyCompilation(sourceFiles, null);
    }

    /**
     * Verifies that the given Java source code compiles successfully.
     *
     * @param className fully qualified class name (e.g., "com.example.MyClass")
     * @param sourceCode the Java source code to compile
     * @throws AssertionError if compilation fails
     */
    static void verifyCompilation(String className, String sourceCode) {
        Map<String, String> sourceFiles = new HashMap<>();
        sourceFiles.put(className, sourceCode);
        verifyCompilation(sourceFiles);
    }

    /**
     * In-memory representation of a Java source file for compilation.
     */
    private static class InMemoryJavaFileObject extends SimpleJavaFileObject {
        private final String sourceCode;

        public InMemoryJavaFileObject(String className, String sourceCode) {
            super(URI.create("string:///" + className.replace('.', '/') + JavaFileObject.Kind.SOURCE.extension),
                    JavaFileObject.Kind.SOURCE);
            this.sourceCode = sourceCode;
        }

        @Override
        public CharSequence getCharContent(boolean ignoreEncodingErrors) {
            return sourceCode;
        }
    }
}
