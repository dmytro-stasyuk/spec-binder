package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates using glob patterns in {@code @Feature2JUnit} annotation to match multiple feature files.
 * The pattern "specs/**" will match all .feature files in the specs directory and its subdirectories.
 * For each matching feature file, the processor generates a separate test class named after the feature file.
 * All generated classes share the same package and extend this base class.
 */
@Feature2JUnit("specs/**/*.feature")
public abstract class AllFeatures {
}
