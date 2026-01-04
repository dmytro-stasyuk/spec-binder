Feature: MappingDataTableDefaultBehavior
  As a developer
  I want data tables to be mapped to List<Map<String, String>> by default
  So that I can work with data tables without needing to explicitly configure the option

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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void givenInitialState();

            public abstract void givenAnAndStepHasADatatable(List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given initial state
                 */
                givenInitialState();
                /*
                 * And an And step has a DataTable:
                 */
                givenAnAndStepHasADatatable(createListOfMaps(\"\"\"
                        | col |
                        | val |
                        \"\"\"));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void givenInitialState();

            public abstract void whenActionIsPerformed();

            public abstract void thenResultIsVerified();

            public abstract void thenExceptionsExist(List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given initial state
                 */
                givenInitialState();
                /*
                 * When action is performed
                 */
                whenActionIsPerformed();
                /*
                 * Then result is verified
                 */
                thenResultIsVerified();
                /*
                 * But exceptions exist:
                 */
                thenExceptionsExist(createListOfMaps(\"\"\"
                        | exception | reason    |
                        | error1    | invalid   |
                        | error2    | not found |
                        \"\"\"));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void givenInitialContext();

            public abstract void givenAWildcardStepHasADatatable(List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given initial context
                 */
                givenInitialContext();
                /*
                 * * a wildcard step has a DataTable:
                 */
                givenAWildcardStepHasADatatable(createListOfMaps(\"\"\"
                        | item | value |
                        | key1 | val1  |
                        | key2 | val2  |
                        \"\"\"));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void whenCheckingInventoryForProduct(List<Map<String, String>> data);

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
                /*
                 * When checking inventory for product:
                 */
                whenCheckingInventoryForProduct(createListOfMaps(\"\"\"
                        | name   | status   |
                        | <name> | <status> |
                        \"\"\"
                        .replaceAll("<name>", name)
                        .replaceAll("<status>", status)));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void givenUserWithCredentials(List<Map<String, String>> data);

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
                /*
                 * Given user with credentials:
                 */
                givenUserWithCredentials(createListOfMaps(\"\"\"
                        | username   | role   | department   |
                        | <username> | <role> | <department> |
                        \"\"\"
                        .replaceAll("<username>", username)
                        .replaceAll("<role>", role)
                        .replaceAll("<department>", department)));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void thenOrder$p1ContainsItems(String p1, List<Map<String, String>> data);

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
                /*
                 * Then order "<orderId>" contains items:
                 */
                thenOrder$p1ContainsItems(orderId, createListOfMaps(\"\"\"
                        | product   | quantity | status   |
                        | <product> | <qty>    | pending  |
                        | Keyboard  | 1        | <status> |
                        \"\"\"
                        .replaceAll("<orderId>", orderId)
                        .replaceAll("<product>", product)
                        .replaceAll("<qty>", qty)
                        .replaceAll("<status>", status)));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void givenAvailablePermissions(List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: List permissions")
            public void scenario_1() {
                /*
                 * Given available permissions:
                 */
                givenAvailablePermissions(createListOfMaps(\"\"\"
                        | permission |
                        | read       |
                        | write      |
                        | delete     |
                        \"\"\"));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void givenDataWithVaryingWidths(List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test alignment")
            public void scenario_1() {
                /*
                 * Given data with varying widths:
                 */
                givenDataWithVaryingWidths(createListOfMaps(\"\"\"
                        | short | very long column name | mid    |
                        | x     | value                 | abc    |
                        | y     | another value         | defghi |
                        \"\"\"));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
            }
        }
        """

  Rule: DataTables with only headers (i.e. empty) are still passed as parameters.
  - these are converted to an empty list when using the default LIST_OF_MAPS parameter type

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
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.Math;
        import java.lang.String;
        import java.util.ArrayList;
        import java.util.HashMap;
        import java.util.List;
        import java.util.Map;
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
            public abstract void givenADatatable(List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /*
                 * Given a DataTable:
                 */
                givenADatatable(createListOfMaps(\"\"\"
                        | name | email |
                        \"\"\"));
            }

            protected List<Map<String, String>> createListOfMaps(String tableLines) {

                String[] tableRows = tableLines.split("\\n");
                List<Map<String, String>> listOfMaps = new ArrayList<>();

                if (tableRows.length < 2) {
                    return listOfMaps;
                }

                String[] headers = null;
                for (int i = 0; i < tableRows.length; i++) {
                    String trimmedLine = tableRows[i].trim();
                    if (!trimmedLine.isEmpty()) {
                        String[] columns = trimmedLine.split("\\|");
                        List<String> rowColumns = new ArrayList<>(columns.length);
                        for (int j = 1; j < columns.length; j++) {
                            String column = columns[j].trim();
                            rowColumns.add(column);
                        }

                        if (headers == null) {
                            headers = rowColumns.toArray(new String[0]);
                        } else {
                            Map<String, String> rowMap = new HashMap<>();
                            for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                                rowMap.put(headers[j], rowColumns.get(j));
                            }
                            listOfMaps.add(rowMap);
                        }
                    }
                }

                return listOfMaps;
            }
        }
        """