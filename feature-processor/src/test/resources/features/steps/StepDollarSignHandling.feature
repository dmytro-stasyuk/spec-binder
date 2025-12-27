Feature: StepDollarSignHandling
  As a developer
  I want dollar signs ($) in step text to be handled correctly in method names
  So that method calls work properly with JavaPoet's formatting system

  Rule: Dollar signs in step text are preserved in method names
  - Dollar signs from literal text are included in method names
  - Dollar signs are escaped properly for JavaPoet code generation
  - Parameter placeholders ($p1, $p2) are handled separately

    Scenario: Step with dollar sign in text
      Given the following feature file:
        """
        Feature: Dollar Sign
          Scenario: Test
            Given price is $100
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Dollar Sign
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^price is \\$100$")
            public abstract void givenPriceIs$100();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given price is $100
                 */
                givenPriceIs$100();
            }
        }
        """

    Scenario: Step with multiple dollar signs
      Given the following feature file:
        """
        Feature: Multiple Dollar Signs
          Scenario: Test
            When converting $50 to $100
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Multiple Dollar Signs
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @When("^converting \\$50 to \\$100$")
            public abstract void whenConverting$50To$100();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * When converting $50 to $100
                 */
                whenConverting$50To$100();
            }
        }
        """

    Scenario: Step with dollar sign and quoted parameter
      Given the following feature file:
        """
        Feature: Dollar Sign With Parameter
          Scenario: Test
            Then balance shows $100 for account "ACC123"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Then;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Dollar Sign With Parameter
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Then("^balance shows \\$100 for account (?<p1>.*)$")
            public abstract void thenBalanceShows$100ForAccount$p1(String p1);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Then balance shows $100 for account "ACC123"
                 */
                thenBalanceShows$100ForAccount$p1("ACC123");
            }
        }
        """

    Scenario: Step with dollar signs at different positions
      Given the following feature file:
        """
        Feature: Dollar Sign Positions
          Scenario: Test
            Given $USD currency with $100 value$
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Dollar Sign Positions
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^\\$USD currency with \\$100 value\\$$")
            public abstract void given$usdCurrencyWith$100Value$();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given $USD currency with $100 value$
                 */
                given$usdCurrencyWith$100Value$();
            }
        }
        """

  Rule: Dollar signs in DocStrings are escaped for JavaPoet
  - Dollar signs in DocString content are doubled ($$) for JavaPoet
  - This ensures JavaPoet doesn't interpret them as format placeholders

    Scenario: DocString with dollar signs
      Given the following feature file:
        """
        Feature: DocString Dollar Signs
          Scenario: Test
            Given document contains:
              \"\"\"
              Price: $100
              Tax: $15
              Total: $115
              \"\"\"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: DocString Dollar Signs
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^document contains:$")
            public abstract void givenDocumentContains(String docString);

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given document contains:
                 */
                givenDocumentContains(\"\"\"
                        Price: $100
                        Tax: $15
                        Total: $115
                        \"\"\");
            }
        }
        """
