package dev.specbinder.examples.featureprocessor.steps;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

public interface ShoppingCartSteps {

    @When("^I add (?<p1>.*) to the cart$")
    default void whenIAdd$p1ToTheCart(String p1) {
        // TODO: Implement step
    }

    @Then("^I should see (?<p1>.*) item in my cart$")
    default void thenIShouldSee$p1ItemInMyCart(String p1) {
        // TODO: Implement step
    }

    @When("^I add (?<p1>.*) priced at (?<p2>.*) to the cart$")
    default void whenIAdd$p1PricedAt$p2ToTheCart(String p1, String p2) {
        // TODO: Implement step
    }

    @Then("^the discounted price should be (?<p1>.*)$")
    default void thenTheDiscountedPriceShouldBe$p1(String p1) {
        // TODO: Implement step
    }

    @Then("^I should earn (?<p1>.*) reward points$")
    default void thenIShouldEarn$p1RewardPoints(String p1) {
        // TODO: Implement step
    }

    @Given("^I have a shopping cart$")
    default void givenIHaveAShoppingCart() {
        // TODO: Implement step
    }

    @Given("^the cart is empty$")
    default void givenTheCartIsEmpty() {
        // TODO: Implement step
    }

    @Then("^the cart should contain (?<p1>.*) item$")
    default void thenTheCartShouldContain$p1Item(String p1) {
        // TODO: Implement step
    }

    @Then("^the cart should contain (?<p1>.*) items$")
    default void thenTheCartShouldContain$p1Items(String p1) {
        // TODO: Implement step
    }
}