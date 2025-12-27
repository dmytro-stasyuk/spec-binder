Feature: MappingFeatureBackgroundBlock
  As a developer
  I want feature Background sections to be mapped to @BeforeEach methods in the generated test classes
  So that setup steps run automatically before each test method in the generated class

  Rule: Background keyword should be mapped to a @BeforeEach method in the generated class
    - Background section doesn't have to have steps, it can be empty
    - Background name is put into the @DisplayName of the @BeforeEach method

    Scenario: with just the keyword
      Given the following feature file:
      """
      Feature: feature with background

        Background:
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
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
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @BeforeEach
          @DisplayName("Background: setup test data")
          public void featureBackground(TestInfo testInfo) {
          }
      }
      """

  Rule: steps in Background section should be mapped to calls within the @BeforeEach method

    Scenario: with multiple steps
      Given the following feature file:
      """
      Feature: feature with background

        Background:
          Given precondition one
          And precondition two
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenPreconditionOne();

          public abstract void givenPreconditionTwo();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /*
               * Given precondition one
               */
              givenPreconditionOne();
              /*
               * And precondition two
               */
              givenPreconditionTwo();
          }
      }
      """

  Rule: background steps can be the same steps as in the Scenario section

    Scenario: with steps that are also in Scenarios
      Given the following feature file:
      """
      Feature: feature with background

        Background:
          Given shared precondition

        Scenario: first scenario
          When action one is performed
          Then outcome one is expected

        Scenario: second scenario
          Given shared precondition
          When action two is performed
          Then outcome two is expected
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenSharedPrecondition();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /*
               * Given shared precondition
               */
              givenSharedPrecondition();
          }

          public abstract void whenActionOneIsPerformed();

          public abstract void thenOutcomeOneIsExpected();

          @Test
          @Order(1)
          @DisplayName("Scenario: first scenario")
          public void scenario_1() {
              /*
               * When action one is performed
               */
              whenActionOneIsPerformed();
              /*
               * Then outcome one is expected
               */
              thenOutcomeOneIsExpected();
          }

          public abstract void whenActionTwoIsPerformed();

          public abstract void thenOutcomeTwoIsExpected();

          @Test
          @Order(2)
          @DisplayName("Scenario: second scenario")
          public void scenario_2() {
              /*
               * Given shared precondition
               */
              givenSharedPrecondition();
              /*
               * When action two is performed
               */
              whenActionTwoIsPerformed();
              /*
               * Then outcome two is expected
               */
              thenOutcomeTwoIsExpected();
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
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: feature with background
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
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
      import dev.specbinder.annotations.output.FeatureFilePath;
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
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenCustomerDatabaseIsConnected();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /*
               * Given customer database is connected
               */
              givenCustomerDatabaseIsConnected();
          }

          public abstract void whenNewCustomerIsCreated();

          public abstract void thenCustomerShouldExistInDatabase();

          @Test
          @Order(1)
          @DisplayName("Scenario: create customer at feature level")
          public void scenario_1() {
              /*
               * When new customer is created
               */
              whenNewCustomerIsCreated();
              /*
               * Then customer should exist in database
               */
              thenCustomerShouldExistInDatabase();
          }

          public abstract void whenCustomerDetailsAreUpdated();

          public abstract void thenChangesShouldBeSaved();

          public abstract void whenCustomerIsDeleted();

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
                  /*
                   * When customer details are updated
                   */
                  whenCustomerDetailsAreUpdated();
                  /*
                   * Then changes should be saved
                   */
                  thenChangesShouldBeSaved();
              }

              @Test
              @Order(2)
              @DisplayName("Scenario: delete customer at feature level")
              public void scenario_2() {
                  /*
                   * When customer is deleted
                   */
                  whenCustomerIsDeleted();
                  /*
                   * Then customer should be removed
                   */
                  thenCustomerShouldBeRemoved();
              }
          }
      }
      """
