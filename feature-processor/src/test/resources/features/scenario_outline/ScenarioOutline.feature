Feature: ScenarioOutline
  As a test developer using Gherkin
  I want Scenario Outlines to be converted to parameterized JUnit tests
  So that I can write data-driven tests with Examples tables

  Rule: Scenario Outline is converted to a method with @ParameterizedTest annotation instead of @Test
  - Examples table is converted to @CsvSource annotation with pipe-delimited data
  - @ParameterizedTest name format is "Example {index}: [{arguments}]"
  - Examples table column headers become method parameters with String type
  - Parameters are named like this:
  -- Column headers from Examples table are split by whitespace
  -- First word is converted to lowercase
  -- Subsequent words have their first character capitalized, rest lowercase (camelCase).
  -- Only Java identifier-compliant characters are retained.
  - since the method argument names are positional when using @CSVSource, so the values are propagated based on position
  - so the name of the arguments doesn't have to match the column names in @CSVSource table exactly

    Scenario: A basic scenario outline generates @ParameterizedTest method
      Given the following feature file:
      """
      Feature: Calculator
        Scenario Outline: Adding numbers
          Given I have <a> and <b>
          When I add them
          Then the result is <sum>
          Examples:
            | a | b | sum |
            | 1 | 2 | 3   |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Calculator
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenIHave$p1And$p2(String p1, String p2);

          public abstract void whenIAddThem();

          public abstract void thenTheResultIs$p1(String p1);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          a | b | sum
                          1 | 2 | 3
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Adding numbers")
          public void scenario_1(String a, String b, String sum) {
              /*
               * Given I have <a> and <b>
               */
              givenIHave$p1And$p2(a, b);
              /*
               * When I add them
               */
              whenIAddThem();
              /*
               * Then the result is <sum>
               */
              thenTheResultIs$p1(sum);
          }
      }
      """

  Rule: Examples table is formatted with aligned columns using pipe separators

    Scenario: Different length values are properly aligned
      Given the following feature file:
      """
      Feature: Formatting
        Scenario Outline: Mixed lengths
          Given <shortValue> and <mediumValue> and <veryLongValue>
          Examples:
            | shortValue | mediumValue | veryLongValue      |
            | x          | medium      | this is very long  |
            | abc        | test        | y                  |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Formatting
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2And$p3(String p1, String p2, String p3);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          shortValue | mediumValue | veryLongValue
                          x          | medium      | this is very long
                          abc        | test        | y
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Mixed lengths")
          public void scenario_1(String shortValue, String mediumValue, String veryLongValue) {
              /*
               * Given <shortValue> and <mediumValue> and <veryLongValue>
               */
              given$p1And$p2And$p3(shortValue, mediumValue, veryLongValue);
          }
      }
      """

  Rule: Examples table column names are converted to @CSVSource annotation and preserved as is

    Scenario: examples table column headers with spaces
      Given the following feature file:
      """
      Feature: Naming
        Scenario Outline: Column name conversion
          Given user <first name> has <last name> and <user id>
          Examples:
            | first name | last name | user id |
            | John       | Doe       | 123     |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Naming
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenUser$p1Has$p2And$p3(String p1, String p2, String p3);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          first name | last name | user id
                          John       | Doe       | 123
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column name conversion")
          public void scenario_1(String firstName, String lastName, String userId) {
              /*
               * Given user <first name> has <last name> and <user id>
               */
              givenUser$p1Has$p2And$p3(firstName, lastName, userId);
          }
      }
      """

    Scenario: examples table column headers with underscores
      Given the following feature file:
      """
      Feature: Naming
        Scenario Outline: Column name conversion
          Given user <first_name> has <last_name> and <user_id>
          Examples:
            | first_name | last_name | user_id |
            | John       | Doe       | 123     |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Naming
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenUser$p1Has$p2And$p3(String p1, String p2, String p3);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          first_name | last_name | user_id
                          John       | Doe       | 123
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column name conversion")
          public void scenario_1(String first_name, String last_name, String user_id) {
              /*
               * Given user <first_name> has <last_name> and <user_id>
               */
              givenUser$p1Has$p2And$p3(first_name, last_name, user_id);
          }
      }
      """

    Scenario: Non-identifier characters are removed from argument names but continue to be present in @CSVSource
      Given the following feature file:
      """
      Feature: Special Characters
        Scenario Outline: Column names with special characters
          Given user <user-id> has <user.name> and <order#number>
          Examples:
            | user-id | user.name | order#number |
            | 123     | John      | 456          |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Special Characters
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenUser$p1Has$p2And$p3(String p1, String p2, String p3);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          user-id | user.name | order#number
                          123     | John      | 456
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column names with special characters")
          public void scenario_1(String userid, String username, String ordernumber) {
              /*
               * Given user <user-id> has <user.name> and <order#number>
               */
              givenUser$p1Has$p2And$p3(userid, username, ordernumber);
          }
      }
      """

    Scenario: All uppercase column names are converted to camelCase
      Given the following feature file:
      """
      Feature: Uppercase Names
        Scenario Outline: SCREAMING_SNAKE_CASE column names
          Given <USER_ID> and <FIRST_NAME>
          Examples:
            | USER_ID | FIRST_NAME |
            | 123     | John       |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Uppercase Names
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2(String p1, String p2);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          USER_ID | FIRST_NAME
                          123     | John
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: SCREAMING_SNAKE_CASE column names")
          public void scenario_1(String user_id, String first_name) {
              /*
               * Given <USER_ID> and <FIRST_NAME>
               */
              given$p1And$p2(user_id, first_name);
          }
      }
      """

    Scenario: Multiple consecutive separators are handled correctly
      Given the following feature file:
      """
      Feature: Multiple Separators
        Scenario Outline: Column names with multiple consecutive separators
          Given <first  name> and <user__id>
          Examples:
            | first  name | user__id |
            | John        | 123      |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Multiple Separators
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2(String p1, String p2);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          first  name | user__id
                          John        | 123
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column names with multiple consecutive separators")
          public void scenario_1(String firstName, String user__id) {
              /*
               * Given <first  name> and <user__id>
               */
              given$p1And$p2(firstName, user__id);
          }
      }
      """

    Scenario: Leading and trailing non-identifier characters are removed
      Given the following feature file:
      """
      Feature: Leading Trailing
        Scenario Outline: Column names with leading/trailing characters
          Given <!firstName> and <lastName@> and <_userId_>
          Examples:
            |  !firstName | lastName@  | _userId_ |
            | John        | Doe        | 123      |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Leading Trailing
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2And$p3(String p1, String p2, String p3);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          !firstName | lastName@ | _userId_
                          John       | Doe       | 123
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column names with leading/trailing characters")
          public void scenario_1(String firstname, String lastname, String _userid_) {
              /*
               * Given <!firstName> and <lastName@> and <_userId_>
               */
              given$p1And$p2And$p3(firstname, lastname, _userid_);
          }
      }
      """

    Scenario: Mixed separators are handled correctly
      Given the following feature file:
      """
      Feature: Mixed Separators
        Scenario Outline: Column names with mixed separator types
          Given <first-name_value> and <user.id-number>
          Examples:
            | first-name_value | user.id-number |
            | John             | 123            |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Mixed Separators
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2(String p1, String p2);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          first-name_value | user.id-number
                          John             | 123
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column names with mixed separator types")
          public void scenario_1(String firstname_value, String useridnumber) {
              /*
               * Given <first-name_value> and <user.id-number>
               */
              given$p1And$p2(firstname_value, useridnumber);
          }
      }
      """

    Scenario: Column names with numbers are handled correctly
      Given the following feature file:
      """
      Feature: Numbers
        Scenario Outline: Column names containing numbers
          Given <value1> and <user 2 id> and <test_3_name>
          Examples:
            | value1 | user 2 id | test_3_name |
            | abc    | 123       | xyz         |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Numbers
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2And$p3(String p1, String p2, String p3);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          value1 | user 2 id | test_3_name
                          abc    | 123       | xyz
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column names containing numbers")
          public void scenario_1(String value1, String user2Id, String test_3_name) {
              /*
               * Given <value1> and <user 2 id> and <test_3_name>
               */
              given$p1And$p2And$p3(value1, user2Id, test_3_name);
          }
      }
      """

    Scenario: Already camelCase column names remain unchanged
      Given the following feature file:
      """
      Feature: CamelCase
        Scenario Outline: Column names already in camelCase
          Given <firstName> and <userId> and <orderTotal>
          Examples:
            | firstName | userId | orderTotal |
            | John      | 123    | 99.99      |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: CamelCase
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2And$p3(String p1, String p2, String p3);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          firstName | userId | orderTotal
                          John      | 123    | 99.99
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Column names already in camelCase")
          public void scenario_1(String firstName, String userId, String orderTotal) {
              /*
               * Given <firstName> and <userId> and <orderTotal>
               */
              given$p1And$p2And$p3(firstName, userId, orderTotal);
          }
      }
      """

    Scenario: Single character column names are handled correctly
      Given the following feature file:
      """
      Feature: Single Chars
        Scenario Outline: Single character column names
          Given <a> and <x y z>
          Examples:
            | a   | x y z |
            | abc | xyz   |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Single Chars
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void given$p1And$p2(String p1, String p2);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          a   | x y z
                          abc | xyz
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Outline: Single character column names")
          public void scenario_1(String a, String xYZ) {
              /*
               * Given <a> and <x y z>
               */
              given$p1And$p2(a, xYZ);
          }
      }
      """

  Rule: Having more than one Examples section is not supported and should generate an error

    Scenario: Scenario Outline with two Examples sections should fail during generation
      Given the following feature file:
      """
      Feature: Multiple Examples
        Scenario Outline: Test with multiple examples
          Given value <value>
          Examples:
            | value |
            | 1     |
          Examples:
            | value |
            | 2     |
      """
      When the generator is run
      Then the generator should report an error:
      """
      ERROR: Multiple Examples sections are not supported. Only one Examples section is allowed per Scenario Outline but found = 2
      """

  Rule: the "Scenario Template" keyword (synonym for "Scenario Outline") should be mapped to a test method similarly to Scenario Outline

    Scenario: A basic scenario template generates @ParameterizedTest method
      Given the following feature file:
      """
      Feature: Calculator
        Scenario Template: Adding numbers
          Given I have <a> and <b>
          When I add them
          Then the result is <sum>
          Examples:
            | a | b | sum |
            | 1 | 2 | 3   |
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
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: Calculator
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          public abstract void givenIHave$p1And$p2(String p1, String p2);

          public abstract void whenIAddThem();

          public abstract void thenTheResultIs$p1(String p1);

          @ParameterizedTest(
                  name = "Example {index}: [{arguments}]"
          )
          @CsvSource(
                  useHeadersInDisplayName = true,
                  delimiter = '|',
                  textBlock = \"\"\"
                          a | b | sum
                          1 | 2 | 3
                          \"\"\"
          )
          @Order(1)
          @DisplayName("Scenario Template: Adding numbers")
          public void scenario_1(String a, String b, String sum) {
              /*
               * Given I have <a> and <b>
               */
              givenIHave$p1And$p2(a, b);
              /*
               * When I add them
               */
              whenIAddThem();
              /*
               * Then the result is <sum>
               */
              thenTheResultIs$p1(sum);
          }
      }
      """


