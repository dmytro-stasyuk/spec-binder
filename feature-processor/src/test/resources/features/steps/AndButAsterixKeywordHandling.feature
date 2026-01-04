Feature: AndButAsterixKeywordHandling
  As a developer writing feature files with multiple step keywords
  I want the generator to correctly inherit step keywords for And, But, and *
  So that the generated method names accurately reflect the intended behavior

  Rule: And, But, and * keywords inherit the previous step's keyword
  - the method name generation uses the inherited keyword as the first word
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
        import dev.specbinder.annotations.output.FeatureFilePath;
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
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenUserExists();

            public abstract void givenUserIsAuthenticated();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user exists
                 */
                givenUserExists();
                /*
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
        import dev.specbinder.annotations.output.FeatureFilePath;
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
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void whenUserLogsIn();

            public abstract void whenUserClicksButton();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * When user logs in
                 */
                whenUserLogsIn();
                /*
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
        import dev.specbinder.annotations.output.FeatureFilePath;
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
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void thenPasswordIsVisible();

            public abstract void thenUsernameIsNotVisible();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Then password is visible
                 */
                thenPasswordIsVisible();
                /*
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
        import dev.specbinder.annotations.output.FeatureFilePath;
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
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenSystemIsReady();

            public abstract void givenDatabaseIsConnected();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given system is ready
                 */
                givenSystemIsReady();
                /*
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
        import dev.specbinder.annotations.output.FeatureFilePath;
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
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenUserExists();

            public abstract void givenUserIsActive();

            public abstract void givenUserHasPermissions();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user exists
                 */
                givenUserExists();
                /*
                 * And user is active
                 */
                givenUserIsActive();
                /*
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
        import dev.specbinder.annotations.output.FeatureFilePath;
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
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenUserExists();

            public abstract void givenUserIsActive();

            public abstract void givenUserIsNotLocked();

            public abstract void givenUserHasPermissions();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user exists
                 */
                givenUserExists();
                /*
                 * And user is active
                 */
                givenUserIsActive();
                /*
                 * But user is not locked
                 */
                givenUserIsNotLocked();
                /*
                 * * user has permissions
                 */
                givenUserHasPermissions();
            }
        }
        """

  Rule: And, But, and * keywords require a previous step with a GWT annotation
  - If And/But/* is the first step in a scenario, an error is reported
  - Error messages include the line number where the issue occurred

    Scenario: And keyword without any previous step should fail
      Given the following feature file:
        """
        Feature: And Without Previous Step
          Scenario: Test
            And user is authenticated
        """
      When the generator is run
      Then the generator should report an error:
        """
        Step on line - 3 starts with 'And', but there are no previous scenario steps defined
        """

    Scenario: But keyword without any previous step should fail
      Given the following feature file:
        """
        Feature: But Without Previous Step
          Scenario: Test
            But user is not admin
        """
      When the generator is run
      Then the generator should report an error:
        """
        Step on line - 3 starts with 'And', but there are no previous scenario steps defined
        """

    Scenario: Asterisk keyword without any previous step should fail
      Given the following feature file:
        """
        Feature: Asterisk Without Previous Step
          Scenario: Test
            * system is ready
        """
      When the generator is run
      Then the generator should report an error:
        """
        Step on line - 3 starts with 'And', but there are no previous scenario steps defined
        """