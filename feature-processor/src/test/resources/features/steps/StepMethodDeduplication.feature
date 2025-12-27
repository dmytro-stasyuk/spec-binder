Feature: StepMethodDeduplication
  As a developer
  I want the generator to detect and skip duplicate step method declarations
  So that I can reuse steps across scenarios and inherit step implementations from base classes without compilation errors

  Rule: Step method signatures are deduplicated
  Before adding a step method to the generated class, the generator checks if a method with the same name already exists.
  If the method exists in the current class or base class, generation is skipped.
  This prevents duplicate method declarations.

    Scenario: Same step appears multiple times in one feature
      Given the following feature file:
        """
        Feature: Duplicate Steps
          Scenario: First scenario
            Given user exists

          Scenario: Second scenario
            Given user exists
        """
      When the generator is run
      Then the content of the generated class should be:
        """
        import dev.specbinder.annotations.output.FeatureFilePath;
        import javax.annotation.processing.Generated;
        import org.junit.jupiter.api.DisplayName;
        import org.junit.jupiter.api.MethodOrderer;
        import org.junit.jupiter.api.Order;
        import org.junit.jupiter.api.Test;
        import org.junit.jupiter.api.TestMethodOrder;

        /**
         * Feature: Duplicate Steps
         */
        @DisplayName("MockedAnnotatedTestClass")
        @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
        @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
        @FeatureFilePath("MockedAnnotatedTestClass.feature")
        public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
            public abstract void givenUserExists();

            @Test
            @Order(1)
            @DisplayName("Scenario: First scenario")
            public void scenario_1() {
                /*
                 * Given user exists
                 */
                givenUserExists();
            }

            @Test
            @Order(2)
            @DisplayName("Scenario: Second scenario")
            public void scenario_2() {
                /*
                 * Given user exists
                 */
                givenUserExists();
            }
        }
        """

    @todo
    Scenario: Step method exists in base class

    @todo
    Scenario: Step method exists in ancestor class
