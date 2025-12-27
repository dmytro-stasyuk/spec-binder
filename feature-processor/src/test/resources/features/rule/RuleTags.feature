Feature: RuleTags
  As a test developer using Gherkin
  I want Gherkin tags on Rules to be converted to JUnit @Tag annotations
  So that I can filter and organize test execution by rule categories

  Rule: Single tag on a Rule is converted to a single JUnit @Tag annotation on the nested class

    Scenario: Rule with single tag
      Given the following feature file:
      """
      Feature: feature with tagged rule

        @validation
        Rule: Input validation rules
          Scenario: Validate email format
            Given an email address
            When validation is performed
            Then the email format should be valid
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
       * Feature: feature with tagged rule
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^an email address$")
          public abstract void givenAnEmailAddress();

          @When("^validation is performed$")
          public abstract void whenValidationIsPerformed();

          @Then("^the email format should be valid$")
          public abstract void thenTheEmailFormatShouldBeValid();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @Tag("validation")
          @DisplayName("Rule: Input validation rules")
          public class Rule_1 {
              @Test
              @Order(1)
              @DisplayName("Scenario: Validate email format")
              public void scenario_1() {
                  /**
                   * Given an email address
                   */
                  givenAnEmailAddress();
                  /**
                   * When validation is performed
                   */
                  whenValidationIsPerformed();
                  /**
                   * Then the email format should be valid
                   */
                  thenTheEmailFormatShouldBeValid();
              }
          }
      }
      """

  Rule: Multiple tags on a Rule are converted to a @Tags container annotation with an array of @Tag annotations

    Scenario: Rule with multiple tags
      Given the following feature file:
      """
      Feature: feature with multi-tagged rule

        @validation @important @security
        Rule: Security validation rules
          Scenario: Validate password strength
            Given a password
            When strength validation is performed
            Then the password should meet requirements
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
      import org.junit.jupiter.api.Tags;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: feature with multi-tagged rule
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^a password$")
          public abstract void givenAPassword();

          @When("^strength validation is performed$")
          public abstract void whenStrengthValidationIsPerformed();

          @Then("^the password should meet requirements$")
          public abstract void thenThePasswordShouldMeetRequirements();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @Tags({
                  @Tag("validation"),
                  @Tag("important"),
                  @Tag("security")
          })
          @DisplayName("Rule: Security validation rules")
          public class Rule_1 {
              @Test
              @Order(1)
              @DisplayName("Scenario: Validate password strength")
              public void scenario_1() {
                  /**
                   * Given a password
                   */
                  givenAPassword();
                  /**
                   * When strength validation is performed
                   */
                  whenStrengthValidationIsPerformed();
                  /**
                   * Then the password should meet requirements
                   */
                  thenThePasswordShouldMeetRequirements();
              }
          }
      }
      """

  Rule: Rule tags are independent of Feature-level tags and only apply to the nested Rule class

    Scenario: Feature with tags and Rule with different tags
      Given the following feature file:
      """
      @feature-level @smoke
      Feature: feature with both feature and rule tags

        @rule-level @validation
        Rule: Validation rules
          Scenario: Validate input
            Given valid input
            When validation runs
            Then input should be accepted
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
      import org.junit.jupiter.api.Tags;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: feature with both feature and rule tags
       */
      @Tags({
              @Tag("feature-level"),
              @Tag("smoke")
      })
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^valid input$")
          public abstract void givenValidInput();

          @When("^validation runs$")
          public abstract void whenValidationRuns();

          @Then("^input should be accepted$")
          public abstract void thenInputShouldBeAccepted();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @Tags({
                  @Tag("rule-level"),
                  @Tag("validation")
          })
          @DisplayName("Rule: Validation rules")
          public class Rule_1 {
              @Test
              @Order(1)
              @DisplayName("Scenario: Validate input")
              public void scenario_1() {
                  /**
                   * Given valid input
                   */
                  givenValidInput();
                  /**
                   * When validation runs
                   */
                  whenValidationRuns();
                  /**
                   * Then input should be accepted
                   */
                  thenInputShouldBeAccepted();
              }
          }
      }
      """

