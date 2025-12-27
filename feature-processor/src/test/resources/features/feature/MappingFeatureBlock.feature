Feature: MappingFeatureBlock
  As a developer reviewing or maintaining generated test code
  I want the feature description and user story to appear as JavaDoc comments in the generated class
  So that I can quickly understand the purpose and intended users without switching to the original feature file

  Rule: "Feature:" keyword should be mapped to a javadoc comment in the generated class followed by the feature name
  and description lines verbatim

    Scenario: with the keyword and name
      Given the following feature file:
      """
      Feature: feature name
      """

      When the generator is run

      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: feature name
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
      }
      """

    Scenario: with the keyword, name and description lines
      Given the following feature file:
      """
      Feature: feature name
        feature description line 1
        feature description line 2
      """

      When the generator is run

      Then the content of the generated class should be:
      """
      import dev.spec2test.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: feature name
       *   feature description line 1
       *   feature description line 2
       */
      @DisplayName("MockedAnnotatedTestClass")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("MockedAnnotatedTestClass.feature")
      public abstract class MockedAnnotatedTestClassScenarios extends MockedAnnotatedTestClass {
      }
      """