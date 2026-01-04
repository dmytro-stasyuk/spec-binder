package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates the simplest example of Gherkin-to-JUnit conversion.
 * Shows how basic Given/When/Then steps are converted to abstract method calls in a generated test class.
 */
@Feature2JUnit("specs/SimpleScenario.feature")
public abstract class SimpleScenarioFeature {
}
