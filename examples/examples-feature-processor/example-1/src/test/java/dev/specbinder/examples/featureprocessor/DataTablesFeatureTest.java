package dev.specbinder.examples.featureprocessor;

import specs.DataTablesFeatureScenarios;

import java.util.List;
import java.util.Map;

/**
 * Implements the test steps for the {@link DataTablesFeatureScenarios} feature.
 */
public class DataTablesFeatureTest extends DataTablesFeatureScenarios {

    @Override
    public void givenICreateTheFollowingUsers(List<Map<String, String>> data) {
        // TODO: Implement step with List<Map<String, String>> parameter
    }

    @Override
    public void thenTheSystemShouldHave$p1Users(String p1) {
        // TODO: Implement step with parameter: p1
    }

    @Override
    public void whenICheckTheInventory(List<Map<String, String>> data) {
        // TODO: Implement step with List<Map<String, String>> parameter
    }

    @Override
    public void thenAllProductsShouldBeInStock() {
        // TODO: Implement step
    }

}
