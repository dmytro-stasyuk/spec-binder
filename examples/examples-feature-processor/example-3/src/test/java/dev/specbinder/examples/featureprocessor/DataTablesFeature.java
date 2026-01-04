package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates how Gherkin data tables are converted to List&lt;CustomType&gt; parameters
 * when using LIST_OF_OBJECT_PARAMS mode. The generator creates inner POJO classes
 * in the generated test class, with fields matching the table columns. Each data table
 * becomes a List of these custom object types, providing type-safe access to table columns.
 *
 * Inherits generation options from {@link BaseFeatureTest}.
 */
@Feature2JUnit("specs/DataTables.feature")
public abstract class DataTablesFeature extends BaseFeatureTest {
}
