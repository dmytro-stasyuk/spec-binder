package dev.specbinder.examples.featureprocessor.steps;

import io.cucumber.java.en.Given;

public interface LoginSteps {

    @Given("^I am not logged in$")
    default void givenIAmNotLoggedIn() {
        // TODO: Implement step
    }

    @Given("^I am logged in as a member$")
    default void givenIAmLoggedInAsAMember() {
        // TODO: Implement step
    }
}
