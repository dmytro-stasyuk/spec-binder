Feature: StepMethodName
  As a developer
  I want step keywords and text automatically converted to camelCase method names
  So that I get consistent and predictable method signatures

  Rule: Step text is converted to method name using camelCase convention
  The step keyword (Given, When, Then) becomes the first word in lowercase.
  Each subsequent word in the step text is split by whitespace and converted to camelCase:
    - First character of each word is capitalized
    - Remaining characters are lowercase
    - Only Java identifier-compliant characters are retained
    - Non-identifier characters are skipped entirely

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
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
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
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^user$")
          public abstract void givenUser();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /**
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
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.When;
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
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @When("^the user clicks the button$")
          public abstract void whenTheUserClicksTheButton();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /**
               * When the user clicks the button
               */
              whenTheUserClicksTheButton();
          }
      }
      """

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
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Then;
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
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Then("^the user's email@domain\\.com is verified!$")
          public abstract void thenTheUsersEmailDomainComIsVerified();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /**
               * Then the user's email@domain.com is verified!
               */
              thenTheUsersEmailDomainComIsVerified();
          }
      }
      """

    Scenario: Step with numbers
      Given the following feature file:
      """
      Feature: Numbers
        Scenario: Test
          Given user123 exists
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
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
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^user123 exists$")
          public abstract void givenUser123Exists();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /**
               * Given user123 exists
               */
              givenUser123Exists();
          }
      }
      """

    Scenario: Step with numbers at the start of a word
      Given the following feature file:
      """
      Feature: Numbers at Start
        Scenario: Test
          Given 3 users exist in the system
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
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
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^3 users exist in the system$")
          public abstract void given3UsersExistInTheSystem();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /**
               * Given 3 users exist in the system
               */
              given3UsersExistInTheSystem();
          }
      }
      """

    Scenario: Step with special characters
      Given the following feature file:
      """
      Feature: Special Characters
        Scenario: Test
          When I enter "hello@world.com" with $100 & tax!
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.When;
      import java.lang.String;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Special Characters
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @When("^I enter (?<p1>.*) with \\$100 & tax!$")
          public abstract void whenIEnter$p1With$100Tax(String p1);

          @Test
          @Order(1)
          @DisplayName("Scenario: Test")
          public void scenario_1() {
              /**
               * When I enter "hello@world.com" with $100 & tax!
               */
              whenIEnter$p1With$100Tax("hello@world.com");
          }
      }
      """

  Rule: And, But, and * keywords inherit the previous step's keyword
    The method name generation uses the inherited keyword as the first word
    If there is no previous step, processing throws an exception

    Scenario: And keyword inherits from Given
      Given the following feature file:
        """
        Feature: And Inheritance
          Scenario: Test
            Given user exists
            And user is authenticated
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: And Inheritance
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user exists$")
            public abstract void givenUserExists();

            @Given("^user is authenticated$")
            public abstract void givenUserIsAuthenticated();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given user exists
                 */
                givenUserExists();
                /**
                 * And user is authenticated
                 */
                givenUserIsAuthenticated();
            }
        }
        """

    Scenario: And keyword inherits from When
      Given the following feature file:
        """
        Feature: And Inheritance When
          Scenario: Test
            When user logs in
            And user clicks button
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: And Inheritance When
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user logs in$")
            public abstract void whenUserLogsIn();

            @When("^user clicks button$")
            public abstract void whenUserClicksButton();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * When user logs in
                 */
                whenUserLogsIn();
                /**
                 * And user clicks button
                 */
                whenUserClicksButton();
            }
        }
        """

    Scenario: But keyword inherits from Then
      Given the following feature file:
        """
        Feature: But Inheritance
          Scenario: Test
            Then password is visible
            But username is not visible
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Then;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: But Inheritance
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^password is visible$")
            public abstract void thenPasswordIsVisible();

            @Then("^username is not visible$")
            public abstract void thenUsernameIsNotVisible();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Then password is visible
                 */
                thenPasswordIsVisible();
                /**
                 * But username is not visible
                 */
                thenUsernameIsNotVisible();
            }
        }
        """

    Scenario: Asterisk keyword inherits from previous step
      Given the following feature file:
        """
        Feature: Asterisk Inheritance
          Scenario: Test
            Given system is ready
            * database is connected
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Asterisk Inheritance
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^system is ready$")
            public abstract void givenSystemIsReady();

            @Given("^database is connected$")
            public abstract void givenDatabaseIsConnected();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given system is ready
                 */
                givenSystemIsReady();
                /**
                 * * database is connected
                 */
                givenDatabaseIsConnected();
            }
        }
        """

    Scenario: Multiple And keywords chain inheritance
      Given the following feature file:
        """
        Feature: Multiple And Chain
          Scenario: Test
            Given user exists
            And user is active
            And user has permissions
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Multiple And Chain
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user exists$")
            public abstract void givenUserExists();

            @Given("^user is active$")
            public abstract void givenUserIsActive();

            @Given("^user has permissions$")
            public abstract void givenUserHasPermissions();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given user exists
                 */
                givenUserExists();
                /**
                 * And user is active
                 */
                givenUserIsActive();
                /**
                 * And user has permissions
                 */
                givenUserHasPermissions();
            }
        }
        """

    Scenario: If And, But and * are all used after a step with Given/When/Then keyword they all chain inheritance
      Given the following feature file:
        """
        Feature: Mixed Keywords Chain
          Scenario: Test
            Given user exists
            And user is active
            But user is not locked
            * user has permissions
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Mixed Keywords Chain
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user exists$")
            public abstract void givenUserExists();

            @Given("^user is active$")
            public abstract void givenUserIsActive();

            @Given("^user is not locked$")
            public abstract void givenUserIsNotLocked();

            @Given("^user has permissions$")
            public abstract void givenUserHasPermissions();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given user exists
                 */
                givenUserExists();
                /**
                 * And user is active
                 */
                givenUserIsActive();
                /**
                 * But user is not locked
                 */
                givenUserIsNotLocked();
                /**
                 * * user has permissions
                 */
                givenUserHasPermissions();
            }
        }
        """