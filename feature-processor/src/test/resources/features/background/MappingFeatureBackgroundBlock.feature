Feature: MappingFeatureBackgroundBlock
  As a developer
  I want Background sections to be mapped to @BeforeEach methods
  So that setup steps run automatically before each test method in the generated class

  Rule: Background keyword should be mapped to a @BeforeEach method in the generated class

    Scenario: with just the keyword
      Given the following feature file:
      """
      Feature: feature with background

        Background:
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
          }
      }
      """

    Scenario: with the keyword and name
      Given the following feature file:
      """
      Feature: feature with background

        Background: setup test data
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @BeforeEach
          @DisplayName("Background: setup test data")
          public void featureBackground(TestInfo testInfo) {
          }
      }
      """

    Scenario: Scenario Outline with Feature Background
      Given the following feature file:
      """
      Feature: data processing

        Background:
          Given data processor is initialized

        Scenario Outline: process data
          When data "<input>" is processed
          Then result should be "<output>"
          Examples:
            | input | output  |
            | abc   | ABC     |
            | xyz   | XYZ     |
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import java.lang.String;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: data processing
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^data processor is initialized$")
          public abstract void givenDataProcessorIsInitialized();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given data processor is initialized
               */
              givenDataProcessorIsInitialized();
          }

          @When("^data (?<p1>.*) is processed$")
          public abstract void whenData$p1IsProcessed(String p1);

          @Then("^result should be (?<p1>.*)$")
          public abstract void thenResultShouldBe$p1(String p1);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          input | output
                          abc   | ABC
                          xyz   | XYZ
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: process data")
          public void scenario_1(String input, String output) {
              /**
               * When data "<input>" is processed
               */
              whenData$p1IsProcessed(input);
              /**
               * Then result should be "<output>"
               */
              thenResultShouldBe$p1(output);
          }
      }
      """

  Rule: Background description lines should be mapped to JavaDoc comment above the @BeforeEach method

    Scenario: with the keyword, name and description lines
      Given the following feature file:
      """
      Feature: feature with background
        Background: setup test data
          description line 1
          description line 2
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          /**
           * description line 1
           * description line 2
           */
          @BeforeEach
          @DisplayName("Background: setup test data")
          public void featureBackground(TestInfo testInfo) {
          }
      }
      """

  Rule: Background interaction with Feature children

    Scenario: Feature with Background and Rules
      Given the following feature file:
      """
      Feature: product management

        Background:
          Given system is ready

        Rule: product creation

          Scenario: create product
            When new product is created
            Then product should exist

        Rule: product deletion

          Scenario: delete product
            When product is deleted
            Then product should not exist
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: product management
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^system is ready$")
          public abstract void givenSystemIsReady();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given system is ready
               */
              givenSystemIsReady();
          }

          @When("^new product is created$")
          public abstract void whenNewProductIsCreated();

          @Then("^product should exist$")
          public abstract void thenProductShouldExist();

          @When("^product is deleted$")
          public abstract void whenProductIsDeleted();

          @Then("^product should not exist$")
          public abstract void thenProductShouldNotExist();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: product creation")
          public class Rule_1 {
              @Test
              @Order(1)
              @DisplayName("Scenario: create product")
              public void scenario_1() {
                  /**
                   * When new product is created
                   */
                  whenNewProductIsCreated();
                  /**
                   * Then product should exist
                   */
                  thenProductShouldExist();
              }
          }

          @Nested
          @Order(2)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: product deletion")
          public class Rule_2 {
              @Test
              @Order(1)
              @DisplayName("Scenario: delete product")
              public void scenario_1() {
                  /**
                   * When product is deleted
                   */
                  whenProductIsDeleted();
                  /**
                   * Then product should not exist
                   */
                  thenProductShouldNotExist();
              }
          }
      }
      """

    Scenario: Feature with Background and mixed children (Scenarios and Rules)
      Given the following feature file:
      """
      Feature: customer management

        Background:
          Given customer database is connected

        Scenario: create customer at feature level
          When new customer is created
          Then customer should exist in database

        Rule: customer updates

          Scenario: update customer details
            When customer details are updated
            Then changes should be saved

        Scenario: delete customer at feature level
          When customer is deleted
          Then customer should be removed
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: customer management
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^customer database is connected$")
          public abstract void givenCustomerDatabaseIsConnected();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given customer database is connected
               */
              givenCustomerDatabaseIsConnected();
          }

          @When("^new customer is created$")
          public abstract void whenNewCustomerIsCreated();

          @Then("^customer should exist in database$")
          public abstract void thenCustomerShouldExistInDatabase();

          @Test
          @Order(1)
          @DisplayName("Scenario: create customer at feature level")
          public void scenario_1() {
              /**
               * When new customer is created
               */
              whenNewCustomerIsCreated();
              /**
               * Then customer should exist in database
               */
              thenCustomerShouldExistInDatabase();
          }

          @When("^customer details are updated$")
          public abstract void whenCustomerDetailsAreUpdated();

          @Then("^changes should be saved$")
          public abstract void thenChangesShouldBeSaved();

          @When("^customer is deleted$")
          public abstract void whenCustomerIsDeleted();

          @Then("^customer should be removed$")
          public abstract void thenCustomerShouldBeRemoved();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: customer updates")
          public class Rule_1 {
              @Test
              @Order(1)
              @DisplayName("Scenario: update customer details")
              public void scenario_1() {
                  /**
                   * When customer details are updated
                   */
                  whenCustomerDetailsAreUpdated();
                  /**
                   * Then changes should be saved
                   */
                  thenChangesShouldBeSaved();
              }

              @Test
              @Order(2)
              @DisplayName("Scenario: delete customer at feature level")
              public void scenario_2() {
                  /**
                   * When customer is deleted
                   */
                  whenCustomerIsDeleted();
                  /**
                   * Then customer should be removed
                   */
                  thenCustomerShouldBeRemoved();
              }
          }
      }
      """
