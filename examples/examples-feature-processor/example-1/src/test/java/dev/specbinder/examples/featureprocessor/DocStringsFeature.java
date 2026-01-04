package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates how Gherkin doc strings are converted to String parameters in step methods.
 * Doc strings enable passing multi-line text content to steps, useful for testing with large text blocks.
 */
@Feature2JUnit("specs/DocStrings.feature")
public abstract class DocStringsFeature {
}
