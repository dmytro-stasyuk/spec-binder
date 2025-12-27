Feature: MappingRuleBackgroundBlock
  As a developer
  I want Rule Background to execute before each scenario within that Rule
  So that common setup logic is reused across scenarios in the Rule

  Rule: Rule-level Background should be mapped to @BeforeEach in the nested Rule class

    Scenario: Rule with its own Background
      Given the following feature file:
      """
      Feature: payment processing

        Rule: payment validation

          Background:
            Given payment gateway is configured

          Scenario: valid payment
            When user submits valid payment
            Then payment should be processed
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: payment processing
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^payment gateway is configured$")
          public abstract void givenPaymentGatewayIsConfigured();

          @When("^user submits valid payment$")
          public abstract void whenUserSubmitsValidPayment();

          @Then("^payment should be processed$")
          public abstract void thenPaymentShouldBeProcessed();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: payment validation")
          public class Rule_1 {
              @BeforeEach
              @DisplayName("Background:")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given payment gateway is configured
                   */
                  givenPaymentGatewayIsConfigured();
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: valid payment")
              public void scenario_1() {
                  /**
                   * When user submits valid payment
                   */
                  whenUserSubmitsValidPayment();
                  /**
                   * Then payment should be processed
                   */
                  thenPaymentShouldBeProcessed();
              }
          }
      }
      """

    Scenario: Multiple scenarios in same Rule with Background
      Given the following feature file:
      """
      Feature: order processing

        Rule: order validation

          Background:
            Given order system is initialized

          Scenario: valid order
            When user submits valid order
            Then order should be accepted

          Scenario: invalid order
            When user submits invalid order
            Then order should be rejected
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: order processing
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^order system is initialized$")
          public abstract void givenOrderSystemIsInitialized();

          @When("^user submits valid order$")
          public abstract void whenUserSubmitsValidOrder();

          @Then("^order should be accepted$")
          public abstract void thenOrderShouldBeAccepted();

          @When("^user submits invalid order$")
          public abstract void whenUserSubmitsInvalidOrder();

          @Then("^order should be rejected$")
          public abstract void thenOrderShouldBeRejected();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: order validation")
          public class Rule_1 {
              @BeforeEach
              @DisplayName("Background:")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given order system is initialized
                   */
                  givenOrderSystemIsInitialized();
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: valid order")
              public void scenario_1() {
                  /**
                   * When user submits valid order
                   */
                  whenUserSubmitsValidOrder();
                  /**
                   * Then order should be accepted
                   */
                  thenOrderShouldBeAccepted();
              }

              @Test
              @Order(2)
              @DisplayName("Scenario: invalid order")
              public void scenario_2() {
                  /**
                   * When user submits invalid order
                   */
                  whenUserSubmitsInvalidOrder();
                  /**
                   * Then order should be rejected
                   */
                  thenOrderShouldBeRejected();
              }
          }
      }
      """

    Scenario: Multiple steps in Rule Background
      Given the following feature file:
      """
      Feature: authentication

        Rule: login validation

          Background:
            Given authentication service is started
            And user database is connected
            And session manager is initialized

          Scenario: successful login
            When user logs in with valid credentials
            Then user should be authenticated
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: authentication
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^authentication service is started$")
          public abstract void givenAuthenticationServiceIsStarted();

          @Given("^user database is connected$")
          public abstract void givenUserDatabaseIsConnected();

          @Given("^session manager is initialized$")
          public abstract void givenSessionManagerIsInitialized();

          @When("^user logs in with valid credentials$")
          public abstract void whenUserLogsInWithValidCredentials();

          @Then("^user should be authenticated$")
          public abstract void thenUserShouldBeAuthenticated();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: login validation")
          public class Rule_1 {
              @BeforeEach
              @DisplayName("Background:")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given authentication service is started
                   */
                  givenAuthenticationServiceIsStarted();
                  /**
                   * And user database is connected
                   */
                  givenUserDatabaseIsConnected();
                  /**
                   * And session manager is initialized
                   */
                  givenSessionManagerIsInitialized();
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: successful login")
              public void scenario_1() {
                  /**
                   * When user logs in with valid credentials
                   */
                  whenUserLogsInWithValidCredentials();
                  /**
                   * Then user should be authenticated
                   */
                  thenUserShouldBeAuthenticated();
              }
          }
      }
      """

    Scenario: Rule Background with description
      Given the following feature file:
      """
      Feature: notification system

        Rule: email notification

          Background: Setup email infrastructure
            This ensures the email service is properly configured
            before sending notifications
            Given email server is configured
            And email templates are loaded

          Scenario: send welcome email
            When new user registers
            Then welcome email should be sent
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: notification system
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^email server is configured$")
          public abstract void givenEmailServerIsConfigured();

          @Given("^email templates are loaded$")
          public abstract void givenEmailTemplatesAreLoaded();

          @When("^new user registers$")
          public abstract void whenNewUserRegisters();

          @Then("^welcome email should be sent$")
          public abstract void thenWelcomeEmailShouldBeSent();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: email notification")
          public class Rule_1 {
              /**
               * This ensures the email service is properly configured
               * before sending notifications
               */
              @BeforeEach
              @DisplayName("Background: Setup email infrastructure")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given email server is configured
                   */
                  givenEmailServerIsConfigured();
                  /**
                   * And email templates are loaded
                   */
                  givenEmailTemplatesAreLoaded();
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: send welcome email")
              public void scenario_1() {
                  /**
                   * When new user registers
                   */
                  whenNewUserRegisters();
                  /**
                   * Then welcome email should be sent
                   */
                  thenWelcomeEmailShouldBeSent();
              }
          }
      }
      """

    Scenario: Scenario Outline in Rule with Background
      Given the following feature file:
      """
      Feature: data validation

        Rule: input validation

          Background:
            Given validation rules are loaded

          Scenario Outline: validate input values
            When user enters "<input>"
            Then validation result should be "<result>"
            Examples:
              | input | result  |
              | valid | pass    |
              | bad   | fail    |
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import java.lang.String;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;
      import org.junit.jupiter.params.ParameterizedTest;
      import org.junit.jupiter.params.provider.CsvSource;

      /**
       * Feature: data validation
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^validation rules are loaded$")
          public abstract void givenValidationRulesAreLoaded();

          @When("^user enters (?<p1>.*)$")
          public abstract void whenUserEnters$p1(String p1);

          @Then("^validation result should be (?<p1>.*)$")
          public abstract void thenValidationResultShouldBe$p1(String p1);

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: input validation")
          public class Rule_1 {
              @BeforeEach
              @DisplayName("Background:")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given validation rules are loaded
                   */
                  givenValidationRulesAreLoaded();
              }

              @ParameterizedTest(
                      name = "Example {index}: [{arguments}]"
              )
              @CsvSource(
                      useHeadersInDisplayName = true,
                      delimiter = '|',
                      textBlock = \"\"\"
                              input | result
                              valid | pass
                              bad   | fail
                              \"\"\"
              )
              @Order(1)
              @DisplayName("Scenario Outline: validate input values")
              public void scenario_1(String input, String result) {
                  /**
                   * When user enters "<input>"
                   */
                  whenUserEnters$p1(input);
                  /**
                   * Then validation result should be "<result>"
                   */
                  thenValidationResultShouldBe$p1(result);
              }
          }
      }
      """

    Scenario: Rule with Background containing DataTable
      Given the following feature file:
      """
      Feature: configuration management

        Rule: service configuration

          Background:
            Given the following services are configured:
              | service   | port |
              | api       | 8080 |
              | database  | 5432 |

          Scenario: check configuration
            When configuration is validated
            Then all services should be ready
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.datatable.DataTable;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import java.lang.String;
      import java.util.ArrayList;
      import java.util.List;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: configuration management
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^the following services are configured:$")
          public abstract void givenTheFollowingServicesAreConfigured(DataTable dataTable);

          @When("^configuration is validated$")
          public abstract void whenConfigurationIsValidated();

          @Then("^all services should be ready$")
          public abstract void thenAllServicesShouldBeReady();

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

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: service configuration")
          public class Rule_1 {
              @BeforeEach
              @DisplayName("Background:")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given the following services are configured:
                   */
                  givenTheFollowingServicesAreConfigured(createDataTable(\"\"\"
                          | service  | port |
                          | api      | 8080 |
                          | database | 5432 |
                          \"\"\"));
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: check configuration")
              public void scenario_1() {
                  /**
                   * When configuration is validated
                   */
                  whenConfigurationIsValidated();
                  /**
                   * Then all services should be ready
                   */
                  thenAllServicesShouldBeReady();
              }
          }
      }
      """

  Rule: Feature and Rule Background interaction - both @BeforeEach methods coexist
  - Feature Background generates featureBackground() @BeforeEach at the outer class level
  - Rule Background generates ruleBackground() @BeforeEach in the nested Rule class
  - JUnit's @BeforeEach execution order ensures proper setup layering

    Scenario: Feature-level Background and Rule-level Background both present
      Given the following feature file:
      """
      Feature: inventory management

        Background:
          Given system is initialized

        Rule: stock validation

          Background:
            Given inventory database is connected

          Scenario: check stock
            When user checks stock for product
            Then stock level should be displayed
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: inventory management
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^system is initialized$")
          public abstract void givenSystemIsInitialized();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given system is initialized
               */
              givenSystemIsInitialized();
          }

          @Given("^inventory database is connected$")
          public abstract void givenInventoryDatabaseIsConnected();

          @When("^user checks stock for product$")
          public abstract void whenUserChecksStockForProduct();

          @Then("^stock level should be displayed$")
          public abstract void thenStockLevelShouldBeDisplayed();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: stock validation")
          public class Rule_1 {
              @BeforeEach
              @DisplayName("Background:")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given inventory database is connected
                   */
                  givenInventoryDatabaseIsConnected();
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: check stock")
              public void scenario_1() {
                  /**
                   * When user checks stock for product
                   */
                  whenUserChecksStockForProduct();
                  /**
                   * Then stock level should be displayed
                   */
                  thenStockLevelShouldBeDisplayed();
              }
          }
      }
      """

  Rule: Multiple Rules with different Backgrounds should each have isolated @BeforeEach methods

    Scenario: Multiple Rules each with different Backgrounds
      Given the following feature file:
      """
      Feature: e-commerce platform

        Rule: cart management

          Background: rule 1 background
            Given shopping cart service is initialized

          Scenario: add to cart
            When user adds item to cart
            Then item should be in cart

        Rule: checkout process

          Background: rule 2 background
            Given payment processor is initialized

          Scenario: complete checkout
            When user completes checkout
            Then order should be confirmed
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import io.cucumber.java.en.Then;
      import io.cucumber.java.en.When;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestInfo;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: e-commerce platform
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^shopping cart service is initialized$")
          public abstract void givenShoppingCartServiceIsInitialized();

          @When("^user adds item to cart$")
          public abstract void whenUserAddsItemToCart();

          @Then("^item should be in cart$")
          public abstract void thenItemShouldBeInCart();

          @Given("^payment processor is initialized$")
          public abstract void givenPaymentProcessorIsInitialized();

          @When("^user completes checkout$")
          public abstract void whenUserCompletesCheckout();

          @Then("^order should be confirmed$")
          public abstract void thenOrderShouldBeConfirmed();

          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: cart management")
          public class Rule_1 {
              @BeforeEach
              @DisplayName("Background: rule 1 background")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given shopping cart service is initialized
                   */
                  givenShoppingCartServiceIsInitialized();
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: add to cart")
              public void scenario_1() {
                  /**
                   * When user adds item to cart
                   */
                  whenUserAddsItemToCart();
                  /**
                   * Then item should be in cart
                   */
                  thenItemShouldBeInCart();
              }
          }

          @Nested
          @Order(2)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: checkout process")
          public class Rule_2 {
              @BeforeEach
              @DisplayName("Background: rule 2 background")
              public void ruleBackground(TestInfo testInfo) {
                  /**
                   * Given payment processor is initialized
                   */
                  givenPaymentProcessorIsInitialized();
              }

              @Test
              @Order(1)
              @DisplayName("Scenario: complete checkout")
              public void scenario_1() {
                  /**
                   * When user completes checkout
                   */
                  whenUserCompletesCheckout();
                  /**
                   * Then order should be confirmed
                   */
                  thenOrderShouldBeConfirmed();
              }
          }
      }
      """

