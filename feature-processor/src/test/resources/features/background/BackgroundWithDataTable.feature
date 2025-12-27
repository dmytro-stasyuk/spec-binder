Feature: BackgroundWithDataTable
  As a test developer using spec2junit
  I want the generator to convert Background steps with DataTables into @BeforeEach methods
  So that I can declare complex tabular test data in feature files that runs before each scenario

  Rule: Background steps with DataTables should generate methods accepting DataTable parameter

    Scenario: Background with a DataTable step
      Given the following feature file:
      """
      Feature: product catalog
        Background:
          Given the following products exist:
            | name    | price |
            | Apple   | 1.50  |
            | Orange  | 2.00  |
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
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: product catalog
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^the following products exist:$")
          public abstract void givenTheFollowingProductsExist(DataTable dataTable);

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given the following products exist:
               */
              givenTheFollowingProductsExist(createDataTable(\"\"\"
                      | name   | price |
                      | Apple  | 1.50  |
                      | Orange | 2.00  |
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

    Scenario: Background with multiple steps including DataTable
      Given the following feature file:
      """
      Feature: user permissions
        Background:
          Given the system is initialized
          And the following users are created:
            | username | role  |
            | alice    | admin |
            | bob      | user  |
          And permissions are loaded
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
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: user permissions
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^the system is initialized$")
          public abstract void givenTheSystemIsInitialized();

          @Given("^the following users are created:$")
          public abstract void givenTheFollowingUsersAreCreated(DataTable dataTable);

          @Given("^permissions are loaded$")
          public abstract void givenPermissionsAreLoaded();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given the system is initialized
               */
              givenTheSystemIsInitialized();
              /**
               * And the following users are created:
               */
              givenTheFollowingUsersAreCreated(createDataTable(\"\"\"
                      | username | role  |
                      | alice    | admin |
                      | bob      | user  |
                      \"\"\"));
              /**
               * And permissions are loaded
               */
              givenPermissionsAreLoaded();
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
