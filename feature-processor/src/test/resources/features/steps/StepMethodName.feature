Feature: StepMethodName
  As a developer
  I want step keywords and text automatically converted to camelCase method names
  So that I get consistent and predictable method signatures

  Rule: Step text is converted to method name using camelCase convention
  - The step keyword (Given, When, Then) becomes the first word in lowercase.
  - Each subsequent word in the step text is split by whitespace and converted to camelCase:
  -- First character of each word is capitalized
  -- Remaining characters are lowercase

    Scenario: Simple step with one word
      Given the following feature file:
      """
      Feature: Simple
        Scenario: Test
          Given user
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Simple
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenUser();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * Given user
               */
              givenUser();
          }
      }
      """

    Scenario: Step with multiple words
      Given the following feature file:
      """
      Feature: Multiple Words
        Scenario: Test
          When the user clicks the button
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Multiple Words
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void whenTheUserClicksTheButton();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * When the user clicks the button
               */
              whenTheUserClicksTheButton();
          }
      }
      """

    Scenario: Step with some words in all caps
      Given the following feature file:
      """
      Feature: All Caps Words
        Scenario: Test
          Then the API response is successful
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: All Caps Words
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void thenTheApiResponseIsSuccessful();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * Then the API response is successful
               */
              thenTheApiResponseIsSuccessful();
          }
      }
      """

  Rule: Non-identifier characters (e.g., punctuation, symbols) are skipped entirely when generating method names

    Scenario: Step with non-identifier characters
      Given the following feature file:
      """
      Feature: Non-identifier Characters
        Scenario: Test
          Then the user's email@domain.com is verified!
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Non-identifier Characters
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void thenTheUsersEmailDomainComIsVerified();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * Then the user's email@domain.com is verified!
               */
              thenTheUsersEmailDomainComIsVerified();
          }
      }
      """

  Rule: Numbers in step text are preserved in method names

    Scenario: Step with numbers in a step word
      Given the following feature file:
      """
      Feature: Numbers
        Scenario: Test
          Given user123 exists
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Numbers
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenUser123Exists();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * Given user123 exists
               */
              givenUser123Exists();
          }
      }
      """

    Scenario: Step with numbers at the start of a step
      Given the following feature file:
      """
      Feature: Numbers at Start
        Scenario: Test
          Given 3 users exist in the system
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Numbers at Start
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given3UsersExistInTheSystem();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * Given 3 users exist in the system
               */
              given3UsersExistInTheSystem();
          }
      }
      """

  Rule: Dollar signs ($) in step text are preserved in method names

    Scenario: Step with dollar sign in text
      Given the following feature file:
      """
      Feature: Dollar Sign
        Scenario: Test
          Given price is $100
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Dollar Sign
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenPriceIs$100();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * Given price is $100
               */
              givenPriceIs$100();
          }
      }
      """

  Rule: Underscore characters (_) in step text are preserved in method names

    Scenario: Step with underscore characters
      Given the following feature file:
      """
      Feature: Underscore Characters
        Scenario: Test
          When the user_name is valid
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Underscore Characters
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void whenTheUser_nameIsValid();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * When the user_name is valid
               */
              whenTheUser_nameIsValid();
          }
      }
      """

  Rule: Quoted parameters in step text are replaced with placeholder names in method names

    Scenario: Step with quoted parameters
      Given the following feature file:
      """
      Feature: Quoted Parameters
        Scenario: Test
          When I enter "username" and "password"
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.annotations.output.FeatureFilePath;
      import java.lang.String;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Quoted Parameters
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void whenIEnter$p1And$p2(String p1, String p2);

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /*
               * When I enter "username" and "password"
               */
              whenIEnter$p1And$p2("username", "password");
          }
      }
      """