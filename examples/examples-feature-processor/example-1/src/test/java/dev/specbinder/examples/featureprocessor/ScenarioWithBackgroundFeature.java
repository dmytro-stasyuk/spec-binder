package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates how Gherkin Background sections are converted to JUnit @BeforeEach methods.
 * The Background steps execute before each scenario in the feature, providing common setup logic.
 */
@Feature2JUnit("specs/ScenarioWithBackground.feature")
public abstract class ScenarioWithBackgroundFeature {
}
