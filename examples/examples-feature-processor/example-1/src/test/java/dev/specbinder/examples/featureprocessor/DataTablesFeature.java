package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

/**
 * Demonstrates how Gherkin data tables are converted to DataTable parameters in step methods.
 * Data tables allow passing structured tabular data to steps for complex test scenarios.
 */
@Feature2JUnit("specs/DataTables.feature")
public abstract class DataTablesFeature {
}
