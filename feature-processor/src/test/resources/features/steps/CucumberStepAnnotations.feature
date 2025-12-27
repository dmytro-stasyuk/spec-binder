Feature: CucumberStepAnnotations
  As a developer
  I want Cucumber step annotations to be added to the generated step method signatures
  So that IDE plugins can provide navigation between feature files and step implementations

  Rule: When addCucumberStepAnnotations option is enabled, step methods are annotated with @Given/@When/@Then
  - each annotation includes a regex pattern matching the original step text
  - all step annotation regex patterns start with ^ (caret) and end with $ (dollar sign), this ensures exact matching of the entire step text

    Scenario: Given step generates @Given annotation with simple regex
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Simple Given
          Scenario: Test
            Given user exists
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Simple Given
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user exists$")
            public abstract void givenUserExists();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user exists
                 */
                givenUserExists();
            }
        }
        """

    Scenario: When step generates @When annotation with simple regex
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Simple When
          Scenario: Test
            When user clicks button
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.When;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Simple When
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user clicks button$")
            public abstract void whenUserClicksButton();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * When user clicks button
                 */
                whenUserClicksButton();
            }
        }
        """

    Scenario: Then step generates @Then annotation with simple regex
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Simple Then
          Scenario: Test
            Then result is displayed
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Then;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Simple Then
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^result is displayed$")
            public abstract void thenResultIsDisplayed();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Then result is displayed
                 */
                thenResultIsDisplayed();
            }
        }
        """

  Rule: Steps with And/But/* keywords inherit annotation from the previous step

    Scenario: And step generates annotation according to the keyword from previous step
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: And Inherits Annotation
          Scenario: Test
            Given user exists
            And user is active
            When user logs in
            And user navigates to dashboard
            Then dashboard is displayed
            And user menu is visible
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import io.cucumber.java.en.Then;
        import io.cucumber.java.en.When;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: And Inherits Annotation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user exists$")
            public abstract void givenUserExists();

            @Given("^user is active$")
            public abstract void givenUserIsActive();

            @When("^user logs in$")
            public abstract void whenUserLogsIn();

            @When("^user navigates to dashboard$")
            public abstract void whenUserNavigatesToDashboard();

            @Then("^dashboard is displayed$")
            public abstract void thenDashboardIsDisplayed();

            @Then("^user menu is visible$")
            public abstract void thenUserMenuIsVisible();

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
                 * When user logs in
                 */
                whenUserLogsIn();
                /*
                 * And user navigates to dashboard
                 */
                whenUserNavigatesToDashboard();
                /*
                 * Then dashboard is displayed
                 */
                thenDashboardIsDisplayed();
                /*
                 * And user menu is visible
                 */
                thenUserMenuIsVisible();
            }
        }
        """

    Scenario: But step generates annotation according to the keyword from previous step
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: But Inherits Annotation
          Scenario: Test
            Given user is logged in
            But user is not admin
            When user requests admin page
            But request is denied
            Then error message is shown
            But user remains on current page
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import io.cucumber.java.en.Then;
        import io.cucumber.java.en.When;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: But Inherits Annotation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user is logged in$")
            public abstract void givenUserIsLoggedIn();

            @Given("^user is not admin$")
            public abstract void givenUserIsNotAdmin();

            @When("^user requests admin page$")
            public abstract void whenUserRequestsAdminPage();

            @When("^request is denied$")
            public abstract void whenRequestIsDenied();

            @Then("^error message is shown$")
            public abstract void thenErrorMessageIsShown();

            @Then("^user remains on current page$")
            public abstract void thenUserRemainsOnCurrentPage();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user is logged in
                 */
                givenUserIsLoggedIn();
                /*
                 * But user is not admin
                 */
                givenUserIsNotAdmin();
                /*
                 * When user requests admin page
                 */
                whenUserRequestsAdminPage();
                /*
                 * But request is denied
                 */
                whenRequestIsDenied();
                /*
                 * Then error message is shown
                 */
                thenErrorMessageIsShown();
                /*
                 * But user remains on current page
                 */
                thenUserRemainsOnCurrentPage();
            }
        }
        """

    Scenario: * step generates annotation according to the keyword from previous step
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Asterisk Inherits Annotation
          Scenario: Test
            Given system is ready
            * database is connected
            When user submits form
            * validation passes
            Then form is saved
            * confirmation is sent
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import io.cucumber.java.en.Then;
        import io.cucumber.java.en.When;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Asterisk Inherits Annotation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^system is ready$")
            public abstract void givenSystemIsReady();

            @Given("^database is connected$")
            public abstract void givenDatabaseIsConnected();

            @When("^user submits form$")
            public abstract void whenUserSubmitsForm();

            @When("^validation passes$")
            public abstract void whenValidationPasses();

            @Then("^form is saved$")
            public abstract void thenFormIsSaved();

            @Then("^confirmation is sent$")
            public abstract void thenConfirmationIsSent();

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
                 * When user submits form
                 */
                whenUserSubmitsForm();
                /*
                 * * validation passes
                 */
                whenValidationPasses();
                /*
                 * Then form is saved
                 */
                thenFormIsSaved();
                /*
                 * * confirmation is sent
                 */
                thenConfirmationIsSent();
            }
        }
        """

  Rule: Steps with quoted parameters generate regex with named capture groups: (?<p1>.*), (?<p2>.*), etc.

    Scenario: with one quoted parameter
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Parameter Capture
          Scenario: Test
            Given user "Alice" exists
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Parameter Capture
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user (?<p1>.*) exists$")
            public abstract void givenUser$p1Exists(String p1);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user "Alice" exists
                 */
                givenUser$p1Exists("Alice");
            }
        }
        """

    Scenario: Step with multiple quoted parameters
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Multiple Captures
          Scenario: Test
            When user "Bob" sends message "Hello World" to "Alice"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Multiple Captures
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user (?<p1>.*) sends message (?<p2>.*) to (?<p3>.*)$")
            public abstract void whenUser$p1SendsMessage$p2To$p3(String p1, String p2, String p3);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * When user "Bob" sends message "Hello World" to "Alice"
                 */
                whenUser$p1SendsMessage$p2To$p3("Bob", "Hello World", "Alice");
            }
        }
        """

  Rule: Steps with special regex characters generate regex with those characters escaped

    Scenario: Step with special regex characters
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Regex Escaping
          Scenario: Test
            Then balance is $100.50 (verified)
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Then;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Regex Escaping
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^balance is \\$100\\.50 \\(verified\\)$")
            public abstract void thenBalanceIs$10050Verified();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Then balance is $100.50 (verified)
                 */
                thenBalanceIs$10050Verified();
            }
        }
        """

  Rule: DocString steps generate regex without any marker for the DocString

    Scenario: Step with DocString
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: DocString Annotation
          Scenario: Test
            Given document contains:
              \"\"\"
              Sample content
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: DocString Annotation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^document contains:$")
            public abstract void givenDocumentContains(String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given document contains:
                 */
                givenDocumentContains(\"\"\"
                        Sample content
                        \"\"\");
            }
        }
        """

  Rule: steps with a data table parameter generate regex without any marker for the data table

    Scenario: Step with DataTable
      Given the following base class:
        """
        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = true)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: DataTable Annotation
          Scenario: Test
            Given the following users exist:
              | name  | age |
              | Alice | 30  |
              | Bob   | 25  |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import io.cucumber.datatable.DataTable;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.List;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: DataTable Annotation
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^the following users exist:$")
            public abstract void givenTheFollowingUsersExist(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given the following users exist:
                 */
                givenTheFollowingUsersExist(createDataTable(\"\"\"
                        | name  | age |
                        | Alice | 30  |
                        | Bob   | 25  |
                        \"\"\"));
            }

            protected abstract DataTable.TableConverter getTableConverter();

            protected DataTable createDataTable(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<List<String>> rawDataTable = new ArrayList<>(tableRows.length);

                for (String tableRow : tableRows) {
                    String trimmedLine = tableRow.trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int i = 1; i < columns.length; i++) {
                            String column = columns[i].trim();
                            rowColumns.add(column);
                        }
                        rawDataTable.add(rowColumns);
                    }
                }

                DataTable dataTable = DataTable.create(rawDataTable, getTableConverter());
                return dataTable;
            }
        }
        """

  Rule: when the addCucumberStepAnnotations option is disabled, step methods are not annotated

    Scenario: option is disabled
      Given the following base class:
        """
        import dev.specbinder.feature2junit.Feature2JUnit;
        import dev.specbinder.feature2junit.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = false)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: No Annotations
          Scenario: Test
            Given user exists
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
         * Feature: No Annotations
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenUserExists();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given user exists
                 */
                givenUserExists();
            }
        }
        """
