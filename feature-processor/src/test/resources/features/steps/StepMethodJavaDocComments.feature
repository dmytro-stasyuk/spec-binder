Feature: StepMethodJavaDocComments
  As a developer
  I want JavaDoc comments above step method calls to preserve the original Gherkin step text
  So that I can trace generated method calls back to their original feature file steps easier

  Rule: JavaDoc comments in method calls preserve the original Gherkin step text exactly as written
  - each step call is preceded by a JavaDoc comment
  - the comment contains the complete step keyword and text
  - And, But, and * keywords are preserved in comments (not replaced with inherited keyword)

    Scenario: JavaDoc comment preserves exact step text including keyword
      Given the following feature file:
        """
        Feature: JavaDoc Preservation
          Scenario: Test
            Given user "Alice" exists
            When user clicks "Submit" button
            Then message "Success" is displayed
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
         * Feature: JavaDoc Preservation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenUser$p1Exists(String p1);

            public abstract void whenUserClicks$p1Button(String p1);

            public abstract void thenMessage$p1IsDisplayed(String p1);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user "Alice" exists
                 */
                givenUser$p1Exists("Alice");
                /*
                 * When user clicks "Submit" button
                 */
                whenUserClicks$p1Button("Submit");
                /*
                 * Then message "Success" is displayed
                 */
                thenMessage$p1IsDisplayed("Success");
            }
        }
        """

    Scenario: JavaDoc comment preserves And keyword in original form
      Given the following feature file:
        """
        Feature: And Keyword Preservation
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
         * Feature: And Keyword Preservation
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

    Scenario: JavaDoc comment preserves But keyword in original form
      Given the following feature file:
        """
        Feature: But Keyword Preservation
          Scenario: Test
            Then username is visible
            But password is not visible
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
         * Feature: But Keyword Preservation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void thenUsernameIsVisible();

            public abstract void thenPasswordIsNotVisible();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Then username is visible
                 */
                thenUsernameIsVisible();
                /*
                 * But password is not visible
                 */
                thenPasswordIsNotVisible();
            }
        }
        """

    Scenario: JavaDoc comment preserves asterisk keyword in original form
      Given the following feature file:
        """
        Feature: Asterisk Preservation
          Scenario: Test
            Given system is ready
            * database is connected
            * cache is warm
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
         * Feature: Asterisk Preservation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenSystemIsReady();

            public abstract void givenDatabaseIsConnected();

            public abstract void givenCacheIsWarm();

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
                /*
                 * * cache is warm
                 */
                givenCacheIsWarm();
            }
        }
        """

    Rule: when addSourceLineAnnotations is enabled, JavaDoc comments include source line info
      - each step call JavaDoc comment includes source line number in format: (Line: X)
      - line number corresponds to line in original feature file where step is defined

    Scenario: JavaDoc comments include source line numbers when option is enabled
      Given the following base class:
        """
        import dev.specbinder.feature2junit.Feature2JUnit;
        import dev.specbinder.feature2junit.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addSourceLineAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Source Line Annotations
          Scenario: Test
            Given user exists
            When user clicks button
            Then result is displayed
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import dev.specbinder.annotations.output.SourceLine;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Source Line Annotations
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenUserExists();

            public abstract void whenUserClicksButton();

            public abstract void thenResultIsDisplayed();

            @Test
            @Order(1)
            @SourceLine(2)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user exists
                 */
                givenUserExists();
                /*
                 * When user clicks button
                 */
                whenUserClicksButton();
                /*
                 * Then result is displayed
                 */
                thenResultIsDisplayed();
            }
        }
        """