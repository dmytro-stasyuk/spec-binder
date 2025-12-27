Feature: MappingStepDocStrings
  As a developer
  I want Gherkin DocStrings to be mapped to String parameters in generated step methods
  So that I can work with multi-line text content in my tests

  Rule: DocString parameters are added as the last parameter of type String
  - if a step has a DocString, a parameter of type String named "docString" is added
  - the DocString content is passed as a text block (triple quotes """ """)

    Scenario: Step with DocString and no quoted parameters
      Given the following feature file:
        """
        Feature: Document Processing
          Scenario: Process document
            Given document contains:
              \"\"\"
              Hello World
              This is a test document
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Document Processing
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
            @DisplayName("Scenario: Process document")
            public void scenario_1() {
                /**
                 * Given document contains:
                 */
                givenDocumentContains(\"\"\"
                        Hello World
                        This is a test document
                        \"\"\");
            }
        }
        """

    Scenario: Step with DocString and one quoted parameter
      Given the following feature file:
        """
        Feature: User Documents
          Scenario: Save user document
            When user "Alice" saves document:
              \"\"\"
              Meeting notes:
              - Discuss project timeline
              - Review budget
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: User Documents
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user (?<p1>.*) saves document:$")
            public abstract void whenUser$p1SavesDocument(String p1, String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Save user document")
            public void scenario_1() {
                /**
                 * When user "Alice" saves document:
                 */
                whenUser$p1SavesDocument("Alice", \"\"\"
                        Meeting notes:
                        - Discuss project timeline
                        - Review budget
                        \"\"\");
            }
        }
        """

    Scenario: Step with DocString and multiple quoted parameters
      Given the following feature file:
        """
        Feature: Email System
          Scenario: Send email
            When user "Bob" sends email to "alice@example.com" with content:
              \"\"\"
              Dear Alice,

              Please review the attached document.

              Best regards,
              Bob
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Email System
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user (?<p1>.*) sends email to (?<p2>.*) with content:$")
            public abstract void whenUser$p1SendsEmailTo$p2WithContent(String p1, String p2,
                    String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Send email")
            public void scenario_1() {
                /**
                 * When user "Bob" sends email to "alice@example.com" with content:
                 */
                whenUser$p1SendsEmailTo$p2WithContent("Bob", "alice@example.com", \"\"\"
                        Dear Alice,

                        Please review the attached document.

                        Best regards,
                        Bob
                        \"\"\");
            }
        }
        """

  Rule: Triple quotes in output are escaped but cannot be tested due to Gherkin limitation
  - When DocString content contains triple quotes in source feature files, they are escaped as \\\"\\\"\\\" in generated Java code
  - This escaping prevents breaking Java text block syntax
  - NOTE: This cannot be demonstrated in test scenarios because Gherkin does not support triple quotes inside DocStrings
  - The Gherkin parser would interpret """ inside a DocString as the end delimiter, making it impossible to write valid test cases
  - This is a known limitation of the Gherkin specification, not a limitation of the code generator

    Rule: Multi-line content in DocStrings is preserved exactly as written
    - indentation is preserved
    - blank lines are preserved
    - special characters are preserved
    - line breaks are maintained

    Scenario: DocString with complex formatting is preserved
      Given the following feature file:
        """
        Feature: File Content
          Scenario: Verify file structure
            Then file should contain:
              \"\"\"
              {
                "name": "project",
                "version": "1.0.0",

                "dependencies": {
                  "lib1": "^2.0.0"
                }
              }
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Then;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: File Content
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^file should contain:$")
            public abstract void thenFileShouldContain(String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Verify file structure")
            public void scenario_1() {
                /**
                 * Then file should contain:
                 */
                thenFileShouldContain(\"\"\"
                        {
                          "name": "project",
                          "version": "1.0.0",

                          "dependencies": {
                            "lib1": "^2.0.0"
                          }
                        }
                        \"\"\");
            }
        }
        """

    Scenario: DocString with special characters and symbols
      Given the following feature file:
        """
        Feature: Special Characters
          Scenario: Handle special text
            Given text with symbols:
              \"\"\"
              Special chars: @#$%^&*()
              Quotes: "single" and 'double'
              Backslash: \\path\\to\\file
              Unicode: café, naïve, 日本語
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Special Characters
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^text with symbols:$")
            public abstract void givenTextWithSymbols(String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Handle special text")
            public void scenario_1() {
                /**
                 * Given text with symbols:
                 */
                givenTextWithSymbols(\"\"\"
                        Special chars: @#$%^&*()
                        Quotes: "single" and 'double'
                        Backslash: \\path\\to\\file
                        Unicode: café, naïve, 日本語
                        \"\"\");
            }
        }
        """

  Rule: Scenario Outline parameters are replaced in DocStrings
  - angle bracket parameters <param> in DocStrings are replaced with actual values
  - the replacement happens at the method call site, not in the method signature
  - DocString parameter type remains String in method signature
  - each example row gets its own DocString with substituted values

    Scenario: Scenario Outline with DocString containing one parameter
      Given the following feature file:
        """
        Feature: Template Messages
          Scenario Outline: Send template message
            When user sends message:
              \"\"\"
              Hello <recipient>,

              This is an automated message.
              \"\"\"

          Examples:
            | recipient |
            | Alice     |
            | Bob       |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.TestMethodOrder;
        import org.junit.jupiter.params.ParameterizedTest;
        import org.junit.jupiter.params.provider.CsvSource;

        /**
         * Feature: Template Messages
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user sends message:$")
            public abstract void whenUserSendsMessage(String docString);

            @ParameterizedTest(
                    name = "Example {index}: [{arguments}]"
            )
            @CsvSource(
                    useHeadersInDisplayName = true,
                    delimiter = '|',
                    textBlock = \"\"\"
                            recipient
                            Alice
                            Bob
                            \"\"\"
            )
            @Order(1)
            @DisplayName("Scenario Outline: Send template message")
            public void scenario_1(String recipient) {
                /**
                 * When user sends message:
                 */
                whenUserSendsMessage(\"\"\"
                        Hello <recipient>,

                        This is an automated message.
                        \"\"\"
                        .replaceAll("<recipient>", recipient));
            }
        }
        """

    Scenario: Scenario Outline with DocString containing multiple parameters
      Given the following feature file:
        """
        Feature: Email Templates
          Scenario Outline: Generate email
            Given email template:
              \"\"\"
              From: <sender>
              To: <recipient>
              Subject: <subject>

              Dear <recipient>,

              <body>

              Regards,
              <sender>
              \"\"\"

          Examples:
            | sender | recipient | subject       | body               |
            | Alice  | Bob       | Meeting       | See you tomorrow   |
            | Carol  | Dave      | Project Update| Status is green    |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.TestMethodOrder;
        import org.junit.jupiter.params.ParameterizedTest;
        import org.junit.jupiter.params.provider.CsvSource;

        /**
         * Feature: Email Templates
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^email template:$")
            public abstract void givenEmailTemplate(String docString);

            @ParameterizedTest(
                    name = "Example {index}: [{arguments}]"
            )
            @CsvSource(
                    useHeadersInDisplayName = true,
                    delimiter = '|',
                    textBlock = \"\"\"
                            sender | recipient | subject        | body
                            Alice  | Bob       | Meeting        | See you tomorrow
                            Carol  | Dave      | Project Update | Status is green
                            \"\"\"
            )
            @Order(1)
            @DisplayName("Scenario Outline: Generate email")
            public void scenario_1(String sender, String recipient, String subject, String body) {
                /**
                 * Given email template:
                 */
                givenEmailTemplate(\"\"\"
                        From: <sender>
                        To: <recipient>
                        Subject: <subject>

                        Dear <recipient>,

                        <body>

                        Regards,
                        <sender>
                        \"\"\"
                        .replaceAll("<sender>", sender)
                        .replaceAll("<recipient>", recipient)
                        .replaceAll("<subject>", subject)
                        .replaceAll("<body>", body));
            }
        }
        """

    Scenario: Scenario Outline mixing quoted parameters and DocString with placeholders
      Given the following feature file:
        """
        Feature: Notifications
          Scenario Outline: User receives notification
            When user "admin" sends notification of type "<type>" with message:
              \"\"\"
              Notification: <type>

              <message>
              \"\"\"

          Examples:
            | type    | message                |
            | warning | System will restart    |
            | info    | Update available       |
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.TestMethodOrder;
        import org.junit.jupiter.params.ParameterizedTest;
        import org.junit.jupiter.params.provider.CsvSource;

        /**
         * Feature: Notifications
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^user (?<p1>.*) sends notification of type (?<p2>.*) with message:$")
            public abstract void whenUser$p1SendsNotificationOfType$p2WithMessage(String p1, String p2,
                    String docString);

            @ParameterizedTest(
                    name = "Example {index}: [{arguments}]"
            )
            @CsvSource(
                    useHeadersInDisplayName = true,
                    delimiter = '|',
                    textBlock = \"\"\"
                            type    | message
                            warning | System will restart
                            info    | Update available
                            \"\"\"
            )
            @Order(1)
            @DisplayName("Scenario Outline: User receives notification")
            public void scenario_1(String type, String message) {
                /**
                 * When user "admin" sends notification of type "<type>" with message:
                 */
                whenUser$p1SendsNotificationOfType$p2WithMessage("admin", type, \"\"\"
                        Notification: <type>

                        <message>
                        \"\"\"
                        .replaceAll("<type>", type)
                        .replaceAll("<message>", message));
            }
        }
        """

  Rule: DocString content type markers are ignored by the generator
  - DocStrings can have optional content type markers (e.g., ```json, ```xml).
  - These markers are stripped out by the generator

    Scenario: DocString with json content type marker
      Given the following feature file:
        """
        Feature: API Testing
          Scenario: Send JSON request
            Given the following JSON payload:
              \"\"\"json
              {
                "userId": 123,
                "action": "create",
                "data": {
                  "name": "Test Item"
                }
              }
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: API Testing
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^the following JSON payload:$")
            public abstract void givenTheFollowingJsonPayload(String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Send JSON request")
            public void scenario_1() {
                /**
                 * Given the following JSON payload:
                 */
                givenTheFollowingJsonPayload(\"\"\"
                        {
                          "userId": 123,
                          "action": "create",
                          "data": {
                            "name": "Test Item"
                          }
                        }
                        \"\"\");
            }
        }
        """

    Scenario: DocString with xml content type marker
      Given the following feature file:
        """
        Feature: XML Processing
          Scenario: Parse XML document
            When system processes XML:
              \"\"\"xml
              <?xml version="1.0" encoding="UTF-8"?>
              <document>
                <title>Sample Document</title>
                <content>This is a test</content>
              </document>
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: XML Processing
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^system processes XML:$")
            public abstract void whenSystemProcessesXml(String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Parse XML document")
            public void scenario_1() {
                /**
                 * When system processes XML:
                 */
                whenSystemProcessesXml(\"\"\"
                        <?xml version="1.0" encoding="UTF-8"?>
                        <document>
                          <title>Sample Document</title>
                          <content>This is a test</content>
                        </document>
                        \"\"\");
            }
        }
        """

    Scenario: DocString with custom content type marker
      Given the following feature file:
        """
        Feature: Custom Format
          Scenario: Process custom data
            Then output should match:
              \"\"\"yaml
              version: 2.0
              services:
                web:
                  image: nginx
                  ports:
                    - "80:80"
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Then;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Custom Format
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^output should match:$")
            public abstract void thenOutputShouldMatch(String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Process custom data")
            public void scenario_1() {
                /**
                 * Then output should match:
                 */
                thenOutputShouldMatch(\"\"\"
                        version: 2.0
                        services:
                          web:
                            image: nginx
                            ports:
                              - "80:80"
                        \"\"\");
            }
        }
        """