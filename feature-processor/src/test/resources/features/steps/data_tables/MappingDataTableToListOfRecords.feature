Feature: MappingDataTableToListOfRecords
  As a developer using the Feature2JUnit generator
  I want the generator to optionally map data tables to List<GeneratedRecord> parameters
  So that I can handle tabular data in my step definitions as a list of custom record types with type-safe field access

  Rule: when "dataTableParameterType" option is set to "LIST_OF_OBJECT_PARAMS", data tables are mapped to List<GeneratedRecord> parameters
  - if a step has a DataTable, a generated record type is created with fields matching column headers
  - the record name is derived from the last word of the step's text (capitalised and converted to camel case if necessary) with "Param" suffix added
  - a parameter of type List<GeneratedRecord> is added to the step method, with the name derived from the last word of the step's text (lowercased)
  - the data is formatted with pipe delimiters and passed via createListOf<RecordName>() helper method
  - if another step with a data table has the same last word, the existing record type is reused, but importantly
  --the other step (or more than one) doesn't have to specify the complete list of columns for the record, so long
  --as all columns used across all steps are compatible with the same record type

    Scenario: Step with DataTable and no quoted parameters
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_OBJECT_PARAMS;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_OBJECT_PARAMS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
        """
        Feature: Users Management
          Scenario: Create users
            Given the following users:
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
          public abstract void givenTheFollowingUsers(List<UsersParam> users);

          @Test
          @Order(1)
          @DisplayName("Scenario: Create users")
          public void scenario_1() {
              /*
               * Given the following users:
               */
              givenTheFollowingUsers(createListOfUsersParam(\"\"\"
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

          protected List<UsersParam> createListOfUsersParam(String tableLines) {

              return createListOfMaps(tableLines).stream()
                              .map(row -> new UsersParam(row.get("name"), row.get("role")))
                              .toList();
          }

          public static class UsersParam {
              private final String name;

              private final String role;

              public UsersParam(String name, String role) {
                  this.name = name;
                  this.role = role;
              }

              public String name() {
                  return this.name;
              }

              public String role() {
                  return this.role;
              }
          }
      }
      """

    Scenario: Step with DataTable and one quoted parameter
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_OBJECT_PARAMS;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_OBJECT_PARAMS)
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
            public abstract void whenUser$p1HasPermissions(String p1, List<PermissionsParam> permissions);

            @Test
            @Order(1)
            @DisplayName("Scenario: Set permissions")
            public void scenario_1() {
                /*
                 * When user "Alice" has permissions:
                 */
                whenUser$p1HasPermissions("Alice", createListOfPermissionsParam(\"\"\"
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

            protected List<PermissionsParam> createListOfPermissionsParam(String tableLines) {

                return createListOfMaps(tableLines).stream()
                                .map(row -> new PermissionsParam(row.get("permission"), row.get("enabled")))
                                .toList();
            }

            public static class PermissionsParam {
                private final String permission;

                private final String enabled;

                public PermissionsParam(String permission, String enabled) {
                    this.permission = permission;
                    this.enabled = enabled;
                }

                public String permission() {
                    return this.permission;
                }

                public String enabled() {
                    return this.enabled;
                }
            }
        }
        """

  Rule: different steps that use the same last word for their DataTable result in reusing the same generated record type

    Scenario: Multiple steps ending with same word share record type
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_OBJECT_PARAMS;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_OBJECT_PARAMS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
        """
        Feature: Account Management
          Scenario: Create accounts
            Given the following accounts:
              | name    | email           |
              | Alice   | alice@test.com  |
              | Bob     | bob@test.com    |
            When Update accounts:
              | name    | email           |
              | Alice   | alice@test.com  |
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
         * Feature: Account Management
         */
        @DisplayName("test")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("test.feature")
        public abstract class TestFeatureScenarios extends TestFeature {
            public abstract void givenTheFollowingAccounts(List<AccountsParam> accounts);

            public abstract void whenUpdateAccounts(List<AccountsParam> accounts);

            @Test
            @Order(1)
            @DisplayName("Scenario: Create accounts")
            public void scenario_1() {
                /*
                 * Given the following accounts:
                 */
                givenTheFollowingAccounts(createListOfAccountsParam(\"\"\"
                        | name  | email          |
                        | Alice | alice@test.com |
                        | Bob   | bob@test.com   |
                        \"\"\"));
                /*
                 * When Update accounts:
                 */
                whenUpdateAccounts(createListOfAccountsParam(\"\"\"
                        | name  | email          |
                        | Alice | alice@test.com |
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

            protected List<AccountsParam> createListOfAccountsParam(String tableLines) {

                return createListOfMaps(tableLines).stream()
                                .map(row -> new AccountsParam(row.get("name"), row.get("email")))
                                .toList();
            }

            public static class AccountsParam {
                private final String name;

                private final String email;

                public AccountsParam(String name, String email) {
                    this.name = name;
                    this.email = email;
                }

                public String name() {
                    return this.name;
                }

                public String email() {
                    return this.email;
                }
            }
        }
        """

    Scenario: Multiple steps ending with same word share record type even if different set of columns are used
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_OBJECT_PARAMS;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_OBJECT_PARAMS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
        """
        Feature: Account Management
          Scenario: Create accounts
            Given the following accounts:
              | name    | email           |
              | Alice   | alice@test.com  |
              | Bob     | bob@test.com    |
            When Update accounts:
              | id  | name    | status  |
              | 10  | Alice   | active  |
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
         * Feature: Account Management
         */
        @DisplayName("test")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("test.feature")
        public abstract class TestFeatureScenarios extends TestFeature {
            public abstract void givenTheFollowingAccounts(List<AccountsParam> accounts);

            public abstract void whenUpdateAccounts(List<AccountsParam> accounts);

            @Test
            @Order(1)
            @DisplayName("Scenario: Create accounts")
            public void scenario_1() {
                /*
                 * Given the following accounts:
                 */
                givenTheFollowingAccounts(createListOfAccountsParam(\"\"\"
                        | name  | email          |
                        | Alice | alice@test.com |
                        | Bob   | bob@test.com   |
                        \"\"\"));
                /*
                 * When Update accounts:
                 */
                whenUpdateAccounts(createListOfAccountsParam(\"\"\"
                        | id | name  | status |
                        | 10 | Alice | active |
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

            protected List<AccountsParam> createListOfAccountsParam(String tableLines) {

                return createListOfMaps(tableLines).stream()
                                .map(row -> new AccountsParam(row.get("name"), row.get("email"), row.get("id"), row.get("status")))
                                .toList();
            }

            public static class AccountsParam {
                private final String name;

                private final String email;

                private final String id;

                private final String status;

                public AccountsParam(String name, String email, String id, String status) {
                    this.name = name;
                    this.email = email;
                    this.id = id;
                    this.status = status;
                }

                public String name() {
                    return this.name;
                }

                public String email() {
                    return this.email;
                }

                public String id() {
                    return this.id;
                }

                public String status() {
                    return this.status;
                }
            }
        }
        """

  Rule: a helper method "createListOfMaps" is used for conversion from string to list of maps and is created only once per generated class

    Scenario: multiple steps with DataTables share the same helper method
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_OBJECT_PARAMS;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_OBJECT_PARAMS)
      public abstract class TestFeature {

      }
      """
      And a feature file under path "test.feature" with the following content:
        """
        Feature: Team Management
          Scenario: Add team members
            Given the following team members:
              | name   | role    |
              | Charlie| Manager |
              | Dana   | Developer|
            When assigning tasks:
              | task        | assignee |
              | Design Doc  | Charlie  |
              | Code Review | Dana     |
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
          public abstract void givenTheFollowingTeamMembers(List<MembersParam> members);

          public abstract void whenAssigningTasks(List<TasksParam> tasks);

          @Test
          @Order(1)
          @DisplayName("Scenario: Add team members")
          public void scenario_1() {
              /*
               * Given the following team members:
               */
              givenTheFollowingTeamMembers(createListOfMembersParam(\"\"\"
                      | name    | role      |
                      | Charlie | Manager   |
                      | Dana    | Developer |
                      \"\"\"));
              /*
               * When assigning tasks:
               */
              whenAssigningTasks(createListOfTasksParam(\"\"\"
                      | task        | assignee |
                      | Design Doc  | Charlie  |
                      | Code Review | Dana     |
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

          protected List<MembersParam> createListOfMembersParam(String tableLines) {

              return createListOfMaps(tableLines).stream()
                              .map(row -> new MembersParam(row.get("name"), row.get("role")))
                              .toList();
          }

          protected List<TasksParam> createListOfTasksParam(String tableLines) {

              return createListOfMaps(tableLines).stream()
                              .map(row -> new TasksParam(row.get("task"), row.get("assignee")))
                              .toList();
          }

          public static class MembersParam {
              private final String name;

              private final String role;

              public MembersParam(String name, String role) {
                  this.name = name;
                  this.role = role;
              }

              public String name() {
                  return this.name;
              }

              public String role() {
                  return this.role;
              }
          }

          public static class TasksParam {
              private final String task;

              private final String assignee;

              public TasksParam(String task, String assignee) {
                  this.task = task;
                  this.assignee = assignee;
              }

              public String task() {
                  return this.task;
              }

              public String assignee() {
                  return this.assignee;
              }
          }
      }
      """

  Rule: helper method "createListOfMaps" is generated when not present in class hierarchy

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
      Feature: Project Management
      Scenario: Create projects
          Given the following projects:
          | title       | owner   |
          | Project A   | Alice   |
          | Project B   | Bob     |
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
       * Feature: Project Management
       */
      @DisplayName("test")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("test.feature")
      public abstract class TestFeatureScenarios extends TestFeature {
          public abstract void givenTheFollowingProjects(List<Map<String, String>> data);

          @Test
          @Order(1)
          @DisplayName("Scenario: Create projects")
          public void scenario_1() {
              /*
               * Given the following projects:
               */
              givenTheFollowingProjects(createListOfMaps(\"\"\"
                      | title     | owner |
                      | Project A | Alice |
                      | Project B | Bob   |
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

  Rule: data tables may contain references to the values from the examples table via the <param> syntax when using LIST_OF_OBJECT_PARAMS
  - angle bracket parameters <param> in data tables are replaced with actual values
  - the replacement happens at the method call site, not in the method signature

    Scenario: DataTable with single parameter reference from Examples
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_OBJECT_PARAMS;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_OBJECT_PARAMS)
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
            public abstract void whenCheckingInventoryForProduct(List<ProductParam> product);

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
                whenCheckingInventoryForProduct(createListOfProductParam(\"\"\"
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

            protected List<ProductParam> createListOfProductParam(String tableLines) {

                return createListOfMaps(tableLines).stream()
                                .map(row -> new ProductParam(row.get("name"), row.get("status")))
                                .toList();
            }

            public static class ProductParam {
                private final String name;

                private final String status;

                public ProductParam(String name, String status) {
                    this.name = name;
                    this.status = status;
                }

                public String name() {
                    return this.name;
                }

                public String status() {
                    return this.status;
                }
            }
        }
        """

    Scenario: DataTable with mixed static values and parameter references
      Given the following base class:
      """
      package com.example;

      import dev.specbinder.annotations.Feature2JUnit;
      import dev.specbinder.annotations.Feature2JUnitOptions;
      import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_OBJECT_PARAMS;

      @Feature2JUnit("test.feature")
      @Feature2JUnitOptions(dataTableParameterType = LIST_OF_OBJECT_PARAMS)
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
          public abstract void thenOrder$p1ContainsItems(String p1, List<ItemsParam> items);

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
              thenOrder$p1ContainsItems(orderId, createListOfItemsParam(\"\"\"
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

          protected List<ItemsParam> createListOfItemsParam(String tableLines) {

              return createListOfMaps(tableLines).stream()
                              .map(row -> new ItemsParam(row.get("product"), row.get("quantity"), row.get("status")))
                              .toList();
          }

          public static class ItemsParam {
              private final String product;

              private final String quantity;

              private final String status;

              public ItemsParam(String product, String quantity, String status) {
                  this.product = product;
                  this.quantity = quantity;
                  this.status = status;
              }

              public String product() {
                  return this.product;
              }

              public String quantity() {
                  return this.quantity;
              }

              public String status() {
                  return this.status;
              }
          }
      }
      """
