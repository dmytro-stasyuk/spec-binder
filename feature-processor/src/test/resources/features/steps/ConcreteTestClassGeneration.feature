Feature: ConcreteTestClassGeneration
  As a developer
  I want step method bodies to be generated based on the shouldBeAbstract option
  So that I can choose between abstract step methods or concrete methods with fail() statements

  Rule: When shouldBeAbstract is true (default), step methods are abstract with no body
  - method has the abstract modifier
  - method has no body implementation

    Scenario: Abstract step method generation
      Given the following feature file:
        """
        Feature: Abstract Steps
          Scenario: Test
            Given user exists
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
         * Feature: Abstract Steps
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            @Given("^user exists$")
            public abstract void givenUserExists();

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given user exists
                 */
                givenUserExists();
            }
        }
        """

  Rule: When shouldBeAbstract is false, step methods are concrete with Assertions.fail() body
  - method does NOT have the abstract modifier
  - method body contains: Assertions.fail("Step is not yet implemented")

    Scenario: Concrete step method with fail() statement
      Given the following base class:
        """
        import dev.spec2test.feature2junit.Feature2JUnit;
        import dev.spec2test.feature2junit.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(shouldBeAbstract = false)
        public class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Concrete Steps
          Scenario: Test
            Given user exists
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.Given;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.Assertions;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Concrete Steps
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public class MockedAnnotatedTestClassTest extends MockedAnnotatedTestClass {
            @Given("^user exists$")
            public void givenUserExists() {
                Assertions.fail("Step is not yet implemented");
            }

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * Given user exists
                 */
                givenUserExists();
            }
        }
        """

    Scenario: Concrete step method with parameters and fail() statement
      Given the following base class:
        """
        import dev.spec2test.feature2junit.Feature2JUnit;
        import dev.spec2test.feature2junit.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(shouldBeAbstract = false)
        public class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: Concrete Steps With Parameters
          Scenario: Test
            When user "Alice" logs in with password "secret123"
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.spec2test.feature2junit.FeatureFilePath;
        import io.cucumber.java.en.When;
        import java.lang.String;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.Assertions;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Concrete Steps With Parameters
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public class MockedAnnotatedTestClassTest extends MockedAnnotatedTestClass {
            @When("^user (?<p1>.*) logs in with password (?<p2>.*)$")
            public void whenUser$p1LogsInWithPassword$p2(String p1, String p2) {
                Assertions.fail("Step is not yet implemented");
            }

            @Test
            @Order(1)
            @DisplayName("Scenario: Test")
            public void scenario_1() {
                /**
                 * When user "Alice" logs in with password "secret123"
                 */
                whenUser$p1LogsInWithPassword$p2("Alice", "secret123");
            }
        }
        """
