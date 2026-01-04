package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates how Gherkin tags can be applied at multiple levels: Feature, Rule, and Scenario.
 * Feature-level tags apply to the entire test class, Rule-level tags apply to nested classes,
 * and Scenario-level tags apply to individual test methods.
 */
@Feature2JUnit("specs/TaggedFeatureAndRules.feature")
public abstract class TaggedFeatureAndRulesFeature {
}
