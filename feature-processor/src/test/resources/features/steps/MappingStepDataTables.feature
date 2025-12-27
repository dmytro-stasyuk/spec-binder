Feature: MappingStepDataTables
  As a developer
  I want Gherkin data tables to be mapped to DataTable parameters in generated step methods
  So that I benefit from compile-time validation and can use tabular structured data in my tests

  Rule: DataTable parameters are added as the last parameter when present
  - if a step has a DataTable, a parameter of type io.cucumber.datatable.DataTable named "dataTable" is added
  - the DataTable is formatted with pipe delimiters and passed via createDataTable() helper method
  - columns properly aligned with spaces for readability

    Scenario: Step with DataTable and no quoted parameters
      Given the following feature file:
        """
        Feature: Users Management
          Scenario: Create users
            Given the following users exist:
              | name  | role  |
              | Alice | Admin |
              | Bob   | User  |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
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
         * Feature: Users Management
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
            @DisplayName("Scenario: Create users")
            public void scenario_1() {
                /**
                 * Given the following users exist:
                 */
                givenTheFollowingUsersExist(createDataTable(\"\"\"
                        | name  | role  |
                        | Alice | Admin |
                        | Bob   | User  |
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

    Scenario: Step with DataTable and one quoted parameter
      Given the following feature file:
        """
        Feature: Permissions Management
          Scenario: Set permissions
            When user "Alice" has permissions:
              | permission | enabled |
              | read       | true    |
              | write      | false   |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.datatable.DataTable;
        import io.cucumber.java.en.When;
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
         * Feature: Permissions Management
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user (?<p1>.*) has permissions:$")
            public abstract void whenUser$p1HasPermissions(String p1, DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Set permissions")
            public void scenario_1() {
                /**
                 * When user "Alice" has permissions:
                 */
                whenUser$p1HasPermissions("Alice", createDataTable(\"\"\"
                        | permission | enabled |
                        | read       | true    |
                        | write      | false   |
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

    Scenario: Step with DataTable and multiple quoted parameters
      Given the following feature file:
        """
        Feature: Order Management
          Scenario: View order details
            Then order "12345" for customer "Bob" contains:
              | product | quantity |
              | Laptop  | 1        |
              | Mouse   | 2        |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.datatable.DataTable;
        import io.cucumber.java.en.Then;
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
         * Feature: Order Management
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^order (?<p1>.*) for customer (?<p2>.*) contains:$")
            public abstract void thenOrder$p1ForCustomer$p2Contains(String p1, String p2,
                    DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: View order details")
            public void scenario_1() {
                /**
                 * Then order "12345" for customer "Bob" contains:
                 */
                thenOrder$p1ForCustomer$p2Contains("12345", "Bob", createDataTable(\"\"\"
                        | product | quantity |
                        | Laptop  | 1        |
                        | Mouse   | 2        |
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

  Rule: DataTable works with all step keywords - Given, When, Then, And, But, and *

    Scenario: DataTable in And step
      Given the following feature file:
        """
        Feature: And Step
          Scenario: Test
            Given initial state
            And an And step has a DataTable:
              | col |
              | val |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
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
         * Feature: And Step
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^initial state$")
            public abstract void givenInitialState();

            @Given("^an And step has a DataTable:$")
            public abstract void givenAnAndStepHasADatatable(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given initial state
                 */
                givenInitialState();
                /**
                 * And an And step has a DataTable:
                 */
                givenAnAndStepHasADatatable(createDataTable(\"\"\"
                        | col |
                        | val |
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

    Scenario: DataTable in But step
      Given the following feature file:
        """
        Feature: But Step
          Scenario: Test
            Given initial state
            When action is performed
            Then result is verified
            But exceptions exist:
              | exception | reason     |
              | error1    | invalid    |
              | error2    | not found  |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.datatable.DataTable;
        import io.cucumber.java.en.Given;
        import io.cucumber.java.en.Then;
        import io.cucumber.java.en.When;
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
         * Feature: But Step
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^initial state$")
            public abstract void givenInitialState();

            @When("^action is performed$")
            public abstract void whenActionIsPerformed();

            @Then("^result is verified$")
            public abstract void thenResultIsVerified();

            @Then("^exceptions exist:$")
            public abstract void thenExceptionsExist(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given initial state
                 */
                givenInitialState();
                /**
                 * When action is performed
                 */
                whenActionIsPerformed();
                /**
                 * Then result is verified
                 */
                thenResultIsVerified();
                /**
                 * But exceptions exist:
                 */
                thenExceptionsExist(createDataTable(\"\"\"
                        | exception | reason    |
                        | error1    | invalid   |
                        | error2    | not found |
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

    Scenario: DataTable in * step
      Given the following feature file:
        """
        Feature: Asterisk Step
          Scenario: Test
            Given initial context
            * a wildcard step has a DataTable:
              | item  | value |
              | key1  | val1  |
              | key2  | val2  |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
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
         * Feature: Asterisk Step
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^initial context$")
            public abstract void givenInitialContext();

            @Given("^a wildcard step has a DataTable:$")
            public abstract void givenAWildcardStepHasADatatable(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given initial context
                 */
                givenInitialContext();
                /**
                 * * a wildcard step has a DataTable:
                 */
                givenAWildcardStepHasADatatable(createDataTable(\"\"\"
                        | item | value |
                        | key1 | val1  |
                        | key2 | val2  |
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

  Rule: data tables may contain references to the values from the examples table via the <param> syntax
  - angle bracket parameters <param> in data tables are replaced with actual values
  - the replacement happens at the method call site, not in the method signature

    Scenario: DataTable with single parameter reference from Examples
      Given the following feature file:
        """
        Feature: Product Inventory
          Scenario Outline: Check product availability
            When checking inventory for product:
              | name   | status   |
              | <name> | <status> |
            Examples:
              | name   | status      |
              | Laptop | Available   |
              | Mouse  | Out of Stock|
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.datatable.DataTable;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.List;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.TestMethodOrder;
        import org.junit.jupiter.params.ParameterizedTest;
        import org.junit.jupiter.params.provider.CsvSource;

        /**
         * Feature: Product Inventory
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^checking inventory for product:$")
            public abstract void whenCheckingInventoryForProduct(DataTable dataTable);

            @ParameterizedTest(
                    name = "Example {index}: [{arguments}]"
            )
            @CsvSource(
                    useHeadersInDisplayName = true,
                    delimiter = '|',
                    textBlock = \"\"\"
                            name   | status
                            Laptop | Available
                            Mouse  | Out of Stock
                            \"\"\"
            )
            @Order(1)
            @DisplayName("Scenario Outline: Check product availability")
            public void scenario_1(String name, String status) {
                /**
                 * When checking inventory for product:
                 */
                whenCheckingInventoryForProduct(createDataTable(\"\"\"
                        | name   | status   |
                        | <name> | <status> |
                        \"\"\"
                        .replaceAll("<name>", name)
                        .replaceAll("<status>", status)));
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

    Scenario: DataTable with multiple parameter references
      Given the following feature file:
        """
        Feature: User Management
          Scenario Outline: Create user with permissions
            Given user with credentials:
              | username   | role   | department   |
              | <username> | <role> | <department> |
            Examples:
              | username | role  | department |
              | alice    | admin | IT         |
              | bob      | user  | Sales      |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.datatable.DataTable;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.List;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.TestMethodOrder;
        import org.junit.jupiter.params.ParameterizedTest;
        import org.junit.jupiter.params.provider.CsvSource;

        /**
         * Feature: User Management
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user with credentials:$")
            public abstract void givenUserWithCredentials(DataTable dataTable);

            @ParameterizedTest(
                    name = "Example {index}: [{arguments}]"
            )
            @CsvSource(
                    useHeadersInDisplayName = true,
                    delimiter = '|',
                    textBlock = \"\"\"
                            username | role  | department
                            alice    | admin | IT
                            bob      | user  | Sales
                            \"\"\"
            )
            @Order(1)
            @DisplayName("Scenario Outline: Create user with permissions")
            public void scenario_1(String username, String role, String department) {
                /**
                 * Given user with credentials:
                 */
                givenUserWithCredentials(createDataTable(\"\"\"
                        | username   | role   | department   |
                        | <username> | <role> | <department> |
                        \"\"\"
                        .replaceAll("<username>", username)
                        .replaceAll("<role>", role)
                        .replaceAll("<department>", department)));
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

    Scenario: DataTable with mixed static values and parameter references
      Given the following feature file:
        """
        Feature: Order Processing
          Scenario Outline: Process order with items
            Then order "<orderId>" contains items:
              | product   | quantity | status    |
              | <product> | <qty>    | pending   |
              | Keyboard  | 1        | <status>  |
            Examples:
              | orderId | product | qty | status    |
              | ORD-001 | Monitor | 2   | confirmed |
              | ORD-002 | Mouse   | 5   | shipped   |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.datatable.DataTable;
        import io.cucumber.java.en.Then;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.List;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.TestMethodOrder;
        import org.junit.jupiter.params.ParameterizedTest;
        import org.junit.jupiter.params.provider.CsvSource;

        /**
         * Feature: Order Processing
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^order (?<p1>.*) contains items:$")
            public abstract void thenOrder$p1ContainsItems(String p1, DataTable dataTable);

            @ParameterizedTest(
                    name = "Example {index}: [{arguments}]"
            )
            @CsvSource(
                    useHeadersInDisplayName = true,
                    delimiter = '|',
                    textBlock = \"\"\"
                            orderId | product | qty | status
                            ORD-001 | Monitor | 2   | confirmed
                            ORD-002 | Mouse   | 5   | shipped
                            \"\"\"
            )
            @Order(1)
            @DisplayName("Scenario Outline: Process order with items")
            public void scenario_1(String orderId, String product, String qty, String status) {
                /**
                 * Then order "<orderId>" contains items:
                 */
                thenOrder$p1ContainsItems(orderId, createDataTable(\"\"\"
                        | product   | quantity | status   |
                        | <product> | <qty>    | pending  |
                        | Keyboard  | 1        | <status> |
                        \"\"\"
                        .replaceAll("<orderId>", orderId)
                        .replaceAll("<product>", product)
                        .replaceAll("<qty>", qty)
                        .replaceAll("<status>", status)));
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

  Rule: DataTable is formatted with pipe delimiters and aligned columns

    Scenario: DataTable with single column
      Given the following feature file:
        """
        Feature: Permissions
          Scenario: List permissions
            Given available permissions:
              | permission |
              | read       |
              | write      |
              | delete     |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
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
         * Feature: Permissions
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^available permissions:$")
            public abstract void givenAvailablePermissions(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: List permissions")
            public void scenario_1() {
                /**
                 * Given available permissions:
                 */
                givenAvailablePermissions(createDataTable(\"\"\"
                        | permission |
                        | read       |
                        | write      |
                        | delete     |
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

    Scenario: DataTable with misaligned columns
      Given the following feature file:
        """
        Feature: Column Alignment
          Scenario: Test alignment
            Given data with varying widths:
              | short | very long column name | mid    |
              | x    | value                    | abc    |
              | y        | another value     | defghi |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
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
         * Feature: Column Alignment
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^data with varying widths:$")
            public abstract void givenDataWithVaryingWidths(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test alignment")
            public void scenario_1() {
                /**
                 * Given data with varying widths:
                 */
                givenDataWithVaryingWidths(createDataTable(\"\"\"
                        | short | very long column name | mid    |
                        | x     | value                 | abc    |
                        | y     | another value         | defghi |
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

  Rule: DataTable helper method is used for table creation
  - the generator uses a createDataTable() helper method to convert string representation to DataTable object
  - this helper method handles the parsing and DataTable instantiation

    Scenario: Multiple steps with DataTables share the same helper method
      Given the following feature file:
        """
        Feature: Shared Helper
          Scenario: Multiple tables
            Given scenario has step 1 with a DataTable:
              | col1 | col2 |
              | a    | b    |
            And scenario has step 2 with a DataTable:
              | col3 | col4 |
              | c    | d    |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
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
         * Feature: Shared Helper
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^scenario has step 1 with a DataTable:$")
            public abstract void givenScenarioHasStep1WithADatatable(DataTable dataTable);

            @Given("^scenario has step 2 with a DataTable:$")
            public abstract void givenScenarioHasStep2WithADatatable(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Multiple tables")
            public void scenario_1() {
                /**
                 * Given scenario has step 1 with a DataTable:
                 */
                givenScenarioHasStep1WithADatatable(createDataTable(\"\"\"
                        | col1 | col2 |
                        | a    | b    |
                        \"\"\"));
                /**
                 * And scenario has step 2 with a DataTable:
                 */
                givenScenarioHasStep2WithADatatable(createDataTable(\"\"\"
                        | col3 | col4 |
                        | c    | d    |
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

  Rule: DataTables with only headers (i.e. empty) are still passed as parameters.
  - these may be converted to a simple list of values by the step implementation

    Scenario: DataTable with headers only
      Given the following feature file:
        """
        Feature: Header Only
          Scenario: Test
            Given a DataTable:
              | name | email |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
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
         * Feature: Header Only
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^a DataTable:$")
            public abstract void givenADatatable(DataTable dataTable);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given a DataTable:
                 */
                givenADatatable(createDataTable(\"\"\"
                        | name | email |
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
