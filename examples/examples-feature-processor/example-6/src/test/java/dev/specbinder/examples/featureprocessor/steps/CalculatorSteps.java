package dev.specbinder.examples.featureprocessor.steps;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

public interface CalculatorSteps {

    @Given("^I have a calculator$")
    default void givenIHaveACalculator() {
        // TODO: Implement step
    }

    @Given("^I have entered (?<p1>.*) into the calculator$")
    default void givenIHaveEntered$p1IntoTheCalculator(String p1) {
        // TODO: Implement step
    }

    @When("^I press add$")
    default void whenIPressAdd() {
        // TODO: Implement step
    }

    @Then("^the result should be (?<p1>.*)$")
    default void thenTheResultShouldBe$p1(String p1) {
        // TODO: Implement step
    }
}
