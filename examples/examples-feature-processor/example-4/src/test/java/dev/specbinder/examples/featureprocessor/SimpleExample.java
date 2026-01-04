package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates using {@code @Feature2JUnit} without an explicit path value.
 * When the annotation value is omitted, the processor looks for a feature file
 * with the same name as the class (SimpleExample.feature) in the same package.
 * The feature file is placed in src/test/java alongside this class, enabled by
 * configuring the pom.xml to treat .feature files as test resources.
 */
@Feature2JUnit
public abstract class SimpleExample {
}
