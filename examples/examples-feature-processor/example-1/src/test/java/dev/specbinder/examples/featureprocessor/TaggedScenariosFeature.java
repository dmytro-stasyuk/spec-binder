package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates how Gherkin tags are converted to JUnit @Tag annotations.
 * Tags enable selective test execution and categorization (e.g., @smoke, @regression, @critical).
 */
@Feature2JUnit("specs/TaggedScenarios.feature")
public abstract class TaggedScenariosFeature {
}
