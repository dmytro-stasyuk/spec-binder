Feature: ScenarioTags
  As a test developer using Gherkin
  I want tags on Scenarios to be converted to JUnit @Tag annotations
  So that I can filter and selectively execute individual test methods

  Rule: Single tag on a Scenario is converted to a single JUnit @Tag annotation on the test method

    Scenario: Scenario with single tag
      Given the following feature file:
      """
      Feature: feature with tagged scenario

        @critical
        Scenario: Process payment
          Given a payment request
          When payment is processed
          Then payment should succeed
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Tag;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: feature with tagged scenario
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^a payment request$")
          public abstract void givenAPaymentRequest();

          @When("^payment is processed$")
          public abstract void whenPaymentIsProcessed();

          @Then("^payment should succeed$")
          public abstract void thenPaymentShouldSucceed();

          @Test
          @Order(1)
          @Tag("critical")
          @DisplayName("Scenario: Process payment")
          public void scenario_1() {
              /**
               * Given a payment request
               */
              givenAPaymentRequest();
              /**
               * When payment is processed
               */
              whenPaymentIsProcessed();
              /**
               * Then payment should succeed
               */
              thenPaymentShouldSucceed();
          }
      }
      """

  Rule: Multiple tags on a Scenario are converted to a @Tags container annotation with an array of @Tag annotations

    Scenario: Scenario with multiple tags
      Given the following feature file:
      """
      Feature: feature with multi-tagged scenario

        @critical @smoke @regression
        Scenario: Validate user login
          Given a user account
          When user logs in
          Then login should succeed
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Tag;
      import org.junit.jupiter.api.Tags;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: feature with multi-tagged scenario
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^a user account$")
          public abstract void givenAUserAccount();

          @When("^user logs in$")
          public abstract void whenUserLogsIn();

          @Then("^login should succeed$")
          public abstract void thenLoginShouldSucceed();

          @Test
          @Order(1)
          @Tags({
                  @Tag("critical"),
                  @Tag("smoke"),
                  @Tag("regression")
          })
          @DisplayName("Scenario: Validate user login")
          public void scenario_1() {
              /**
               * Given a user account
               */
              givenAUserAccount();
              /**
               * When user logs in
               */
              whenUserLogsIn();
              /**
               * Then login should succeed
               */
              thenLoginShouldSucceed();
          }
      }
      """

  Rule: Scenario tags are independent of Feature-level and Rule-level tags

    Scenario: Feature, Rule, and Scenario each have different tags
      Given the following feature file:
      """
      @feature-tag
      Feature: feature with layered tags

        @rule-tag
        Rule: Processing rules
          @scenario-tag
          Scenario: Process transaction
            Given a transaction
            When processing occurs
            Then transaction completes
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Tag;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: feature with layered tags
       */
      @Tag("feature-tag")
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^a transaction$")
          public abstract void givenATransaction();

          @When("^processing occurs$")
          public abstract void whenProcessingOccurs();

          @Then("^transaction completes$")
          public abstract void thenTransactionCompletes();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @Tag("rule-tag")
          @DisplayName("Rule: Processing rules")
          public class Rule_1 {
              @Test
              @Order(1)
              @Tag("scenario-tag")
              @DisplayName("Scenario: Process transaction")
              public void scenario_1() {
                  /**
                   * Given a transaction
                   */
                  givenATransaction();
                  /**
                   * When processing occurs
                   */
                  whenProcessingOccurs();
                  /**
                   * Then transaction completes
                   */
                  thenTransactionCompletes();
              }
          }
      }
      """

  Rule: Scenario tags apply only to the specific test method, not the entire class

    Scenario: Multiple scenarios with different tags in same class
      Given the following feature file:
      """
      Feature: feature with differently tagged scenarios

        @critical
        Scenario: Critical test
          Given critical setup
          When critical action
          Then critical result

        @optional
        Scenario: Optional test
          Given optional setup
          When optional action
          Then optional result
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Tag;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: feature with differently tagged scenarios
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^critical setup$")
          public abstract void givenCriticalSetup();

          @When("^critical action$")
          public abstract void whenCriticalAction();

          @Then("^critical result$")
          public abstract void thenCriticalResult();

          @Test
          @Order(1)
          @Tag("critical")
          @DisplayName("Scenario: Critical test")
          public void scenario_1() {
              /**
               * Given critical setup
               */
              givenCriticalSetup();
              /**
               * When critical action
               */
              whenCriticalAction();
              /**
               * Then critical result
               */
              thenCriticalResult();
          }

          @Given("^optional setup$")
          public abstract void givenOptionalSetup();

          @When("^optional action$")
          public abstract void whenOptionalAction();

          @Then("^optional result$")
          public abstract void thenOptionalResult();

          @Test
          @Order(2)
          @Tag("optional")
          @DisplayName("Scenario: Optional test")
          public void scenario_2() {
              /**
               * Given optional setup
               */
              givenOptionalSetup();
              /**
               * When optional action
               */
              whenOptionalAction();
              /**
               * Then optional result
               */
              thenOptionalResult();
          }
      }
      """
