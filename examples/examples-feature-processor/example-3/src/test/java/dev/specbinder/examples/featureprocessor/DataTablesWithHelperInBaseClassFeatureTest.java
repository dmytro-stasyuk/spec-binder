package dev.specbinder.examples.featureprocessor;

import specs.DataTablesWithHelperInBaseClassFeatureScenarios;

import java.util.List;

/**
 * Implements the test steps for the {@link DataTablesWithHelperInBaseClassFeatureScenarios} feature.
 */
public class DataTablesWithHelperInBaseClassFeatureTest extends DataTablesWithHelperInBaseClassFeatureScenarios {

    @Override
    public void givenICreateTheFollowingUsers(List<UsersParam> users) {
        // TODO: Implement step with parameter: users
    }

    @Override
    public void thenTheSystemShouldHave$p1Users(String p1) {
        // TODO: Implement step with parameter: p1
    }

    @Override
    public void whenICheckTheInventory(List<InventoryParam> inventory) {
        // TODO: Implement step with parameter: inventory
    }

    @Override
    public void thenAllProductsShouldBeInStock() {
        // TODO: Implement step
    }
}
