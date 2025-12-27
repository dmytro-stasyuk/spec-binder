Feature: BackgroundWithDocString
  As a spec2junit user
  I want the generator to convert Background steps with DocStrings into @BeforeEach methods with String parameters
  So that I can set up multi-line test data before each scenario with compile-time type safety

  Rule: Background steps with DocStrings should generate methods accepting String parameter

    Scenario: Background with a DocString step
      Given the following feature file:
      """
      Feature: API testing
        Background:
          Given the server responds with:
            \"\"\"
            {
              "status": "ok",
              "version": "1.0"
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
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: API testing
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^the server responds with:$")
          public abstract void givenTheServerRespondsWith(String docString);

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given the server responds with:
               */
              givenTheServerRespondsWith(\"\"\"
                      {
                        "status": "ok",
                        "version": "1.0"
                      }
                      \"\"\");
          }
      }
      """

    Scenario: Background with multiple steps including DocString
      Given the following feature file:
      """
      Feature: email testing
        Background:
          Given the email service is available
          And the email template is:
            \"\"\"
            Dear User,
            Welcome to our service!
            \"\"\"
          And email sending is enabled
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      import dev.specbinder.feature2junit.FeatureFilePath;
      import io.cucumber.java.en.Given;
      import java.lang.String;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.BeforeEach;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.TestInfo;

      /**
       * Feature: email testing
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
          @Given("^the email service is available$")
          public abstract void givenTheEmailServiceIsAvailable();

          @Given("^the email template is:$")
          public abstract void givenTheEmailTemplateIs(String docString);

          @Given("^email sending is enabled$")
          public abstract void givenEmailSendingIsEnabled();

          @BeforeEach
          @DisplayName("Background:")
          public void featureBackground(TestInfo testInfo) {
              /**
               * Given the email service is available
               */
              givenTheEmailServiceIsAvailable();
              /**
               * And the email template is:
               */
              givenTheEmailTemplateIs(\"\"\"
                      Dear User,
                      Welcome to our service!
                      \"\"\");
              /**
               * And email sending is enabled
               */
              givenEmailSendingIsEnabled();
          }
      }
      """
