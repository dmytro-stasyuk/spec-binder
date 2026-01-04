package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates how Gherkin Scenario Outlines are converted to JUnit @ParameterizedTest methods.
 * Examples tables are mapped to @CsvSource, enabling data-driven testing with multiple input combinations.
 */
@Feature2JUnit("specs/ScenarioOutline.feature")
public abstract class ScenarioOutlineFeature {
}
