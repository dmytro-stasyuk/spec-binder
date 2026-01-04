package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Illustrates the mapping of Gherkin Rules to JUnit @Nested test classes, enabling hierarchical grouping
 * of related scenarios.
 * Each Rule's Background section becomes a @BeforeEach method within its corresponding nested class.
 */
@Feature2JUnit("specs/FeatureWithRules.feature")
public abstract class FeatureWithRulesFeature {
}
