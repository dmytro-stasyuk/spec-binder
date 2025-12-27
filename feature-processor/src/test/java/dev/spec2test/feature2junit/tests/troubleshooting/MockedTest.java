package dev.spec2test.feature2junit.tests.troubleshooting;

import org.junit.jupiter.api.Disabled;

@Disabled
public class MockedTest extends MockedTestClassScenarios {
    @Override
    public void givenCustomerDatabaseIsConnected() {
        throw new UnsupportedOperationException("Not implemented yet");

    }

    @Override
    public void whenNewCustomerIsCreated() {
        throw new UnsupportedOperationException("Not implemented yet");

    }

    @Override
    public void thenCustomerShouldExistInDatabase() {
        throw new UnsupportedOperationException("Not implemented yet");

    }

    @Override
    public void whenCustomerDetailsAreUpdated() {
        throw new UnsupportedOperationException("Not implemented yet");

    }

    @Override
    public void thenChangesShouldBeSaved() {
        throw new UnsupportedOperationException("Not implemented yet");

    }

    @Override
    public void whenCustomerIsDeleted() {
        throw new UnsupportedOperationException("Not implemented yet");

    }

    @Override
    public void thenCustomerShouldBeRemoved() {
        throw new UnsupportedOperationException("Not implemented yet");

    }
}
