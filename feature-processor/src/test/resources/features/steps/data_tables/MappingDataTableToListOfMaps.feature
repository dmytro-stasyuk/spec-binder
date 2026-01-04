Feature: MappingDataTableToListOfMaps
  As a developer using the Feature2JUnit generator
  I want the generator to optionally map data tables to List<Map<String, String>> parameters
  So that I can handle tabular data in my step definitions as a list of maps with header-based field access

  Rule: when "dataTableParameterType" option is set to "LIST_OF_MAPS", data tables are mapped to List<Map<String, String>> parameters
  - if a step has a DataTable, a parameter of type List<Map<String, String>> named "data" is added
  - the data is formatted with pipe delimiters and passed via createListOfMaps() helper method
  - columns properly aligned with spaces for readability
  - dataTables with only headers (i.e. empty) return an empty list when using LIST_OF_MAPS

    Scenario: Step with DataTable and no quoted parameters
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;
      import io.cucumber.datatable.DataTable;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
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
        import com.example.TestFeature;
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
         * Feature: Users Management
         */
        @DisplayName("test")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("test.feature")
        public abstract class TestFeatureScenarios extends TestFeature {
            public abstract void givenTheFollowingUsersExist(List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Create users")
            public void scenario_1() {
                /*
                 * Given the following users exist:
                 */
                givenTheFollowingUsersExist(createListOfMaps(\"\"\"
                        | name  | role  |
                        | Alice | Admin |
                        | Bob   | User  |
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

    Scenario: Step with DataTable and one quoted parameter
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;
      import io.cucumber.datatable.DataTable;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
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
        import com.example.TestFeature;
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
         * Feature: Permissions Management
         */
        @DisplayName("test")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("test.feature")
        public abstract class TestFeatureScenarios extends TestFeature {
            public abstract void whenUser$p1HasPermissions(String p1, List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Set permissions")
            public void scenario_1() {
                /*
                 * When user "Alice" has permissions:
                 */
                whenUser$p1HasPermissions("Alice", createListOfMaps(\"\"\"
                        | permission | enabled |
                        | read       | true    |
                        | write      | false   |
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

  Rule: data tables may contain references to the values from the examples table via the <param> syntax when using LIST_OF_MAPS
  - angle bracket parameters <param> in data tables are replaced with actual values
  - the replacement happens at the method call site, not in the method signature

    Scenario: DataTable with single parameter reference from Examples
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;
      import io.cucumber.datatable.DataTable;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
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
        import com.example.TestFeature;
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
        @DisplayName("test")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("test.feature")
        public abstract class TestFeatureScenarios extends TestFeature {
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

    Scenario: DataTable with mixed static values and parameter references
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;
      import io.cucumber.datatable.DataTable;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
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
      import com.example.TestFeature;
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
      @DisplayName("test")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("test.feature")
      public abstract class TestFeatureScenarios extends TestFeature {
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

  Rule: a helper method is used conversion from string to list of maps creation

    Scenario: Multiple steps with DataTables share the same helper method
      Given the following base class:
        """
        package com.example;

        import dev.specbinder.annotations.Feature2JUnit;
        import dev.specbinder.annotations.Feature2JUnitOptions;
        import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;
        import io.cucumber.datatable.DataTable;

        @Feature2JUnit("test.feature")
        @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
        public abstract class TestFeature {

        }
        """
      And a feature file under path "test.feature" with the following content:
      """
      Feature: Team Management
      Scenario: Add team members
          Given the following team members exist:
          | name   | role    |
          | Charlie| Manager |
          | Dana   | Developer |
          When the following team members are assigned tasks:
          | name   | task         |
          | Charlie| Project Lead |
          | Dana   | Coding       |
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import com.example.TestFeature;
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
       * Feature: Team Management
       */
      @DisplayName("test")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("test.feature")
      public abstract class TestFeatureScenarios extends TestFeature {
          public abstract void givenTheFollowingTeamMembersExist(List<Map<String, String>> data);

          public abstract void whenTheFollowingTeamMembersAreAssignedTasks(
                  List<Map<String, String>> data);

          @Test
          @Order(1)
          @DisplayName("Scenario: Add team members")
          public void scenario_1() {
              /*
               * Given the following team members exist:
               */
              givenTheFollowingTeamMembersExist(createListOfMaps(\"\"\"
                      | name    | role      |
                      | Charlie | Manager   |
                      | Dana    | Developer |
                      \"\"\"));
              /*
               * When the following team members are assigned tasks:
               */
              whenTheFollowingTeamMembersAreAssignedTasks(createListOfMaps(\"\"\"
                      | name    | task         |
                      | Charlie | Project Lead |
                      | Dana    | Coding       |
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

  Rule: Helper methods are generated when not present in class hierarchy

    Scenario: No helper methods in base class
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;
      import io.cucumber.datatable.DataTable;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
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
      import com.example.TestFeature;
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
       * Feature: Permissions Management
       */
      @DisplayName("test")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("test.feature")
      public abstract class TestFeatureScenarios extends TestFeature {
          public abstract void whenUser$p1HasPermissions(String p1, List<Map<String, String>> data);

          @Test
          @Order(1)
          @DisplayName("Scenario: Set permissions")
          public void scenario_1() {
              /*
               * When user "Alice" has permissions:
               */
              whenUser$p1HasPermissions("Alice", createListOfMaps(\"\"\"
                      | permission | enabled |
                      | read       | true    |
                      | write      | false   |
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

    Scenario: helper is present in base class
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;

      import java.util.ArrayList;
      import java.util.HashMap;
      import java.util.List;
      import java.util.Map;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
      public abstract class TestFeature {
          protected List<Map<String, String>> createListOfMaps(String tableLines) {
              // Custom implementation provided by user
              return new ArrayList<>();
          }
      }
      """
      And a feature file under path "test.feature" with the following content:
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
        import com.example.TestFeature;
        import dev.specbinder.annotations.output.FeatureFilePath;
        import java.lang.String;
        import java.util.List;
        import java.util.Map;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Permissions Management
         */
        @DisplayName("test")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("test.feature")
        public abstract class TestFeatureScenarios extends TestFeature {
            public abstract void whenUser$p1HasPermissions(String p1, List<Map<String, String>> data);

            @Test
            @Order(1)
            @DisplayName("Scenario: Set permissions")
            public void scenario_1() {
                /*
                 * When user "Alice" has permissions:
                 */
                whenUser$p1HasPermissions("Alice", createListOfMaps(\"\"\"
                        | permission | enabled |
                        | read       | true    |
                        | write      | false   |
                        \"\"\"));
            }
        }
        """

    Scenario: helper is present in ancestor class
      Given the following base class:
      """
      package com.example;

      import java.util.ArrayList;
      import java.util.HashMap;
      import java.util.List;
      import java.util.Map;

      public abstract class BaseFeature {
          protected List<Map<String, String>> createListOfMaps(String tableLines) {
              // Custom implementation provided by user
              return new ArrayList<>();
          }
      }
      """
      And the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;

      import java.util.ArrayList;
      import java.util.HashMap;
      import java.util.List;
      import java.util.Map;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_MAPS)
      public abstract class TestFeature extends BaseFeature {
      }
      """
      And a feature file under path "test.feature" with the following content:
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
      import com.example.TestFeature;
      import dev.specbinder.annotations.output.FeatureFilePath;
      import java.lang.String;
      import java.util.List;
      import java.util.Map;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Permissions Management
       */
      @DisplayName("test")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("test.feature")
      public abstract class TestFeatureScenarios extends TestFeature {
          public abstract void whenUser$p1HasPermissions(String p1, List<Map<String, String>> data);

          @Test
          @Order(1)
          @DisplayName("Scenario: Set permissions")
          public void scenario_1() {
              /*
               * When user "Alice" has permissions:
               */
              whenUser$p1HasPermissions("Alice", createListOfMaps(\"\"\"
                      | permission | enabled |
                      | read       | true    |
                      | write      | false   |
                      \"\"\"));
          }
      }
      """

