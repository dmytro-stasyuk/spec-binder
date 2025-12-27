Feature: StepKeywordErrorHandling
  As a developer
  I want proper error messages when And/But/* keywords are used incorrectly
  So that I can quickly identify and fix issues in my feature files

  Rule: And, But, and * keywords require a previous step with a GWT annotation
  - If And/But/* is the first step in a scenario, a ProcessingException is thrown
  - If the previous step has no GWT annotation, a ProcessingException is thrown
  - Error messages include the line number where the issue occurred

    Scenario: And keyword without any previous step should fail
      Given the following feature file:
        """
        Feature: And Without Previous Step
          Scenario: Test
            And user is authenticated
        """
      When the generator is run
      Then the generator should report an error:
        """
        Step on line - 3 starts with 'And', but there are no previous scenario steps defined
        """

    @error
    Scenario: But keyword without any previous step should fail
      Given the following feature file:
        """
        Feature: But Without Previous Step
          Scenario: Test
            But user is not admin
        """
      When the generator is run
      Then the generator should report an error:
        """
        Step on line - 3 starts with 'And', but there are no previous scenario steps defined
        """

    @error
    Scenario: Asterisk keyword without any previous step should fail
      Given the following feature file:
        """
        Feature: Asterisk Without Previous Step
          Scenario: Test
            * system is ready
        """
      When the generator is run
      Then the generator should report an error:
        """
        Step on line - 3 starts with 'And', but there are no previous scenario steps defined
        """

  Rule: When addCucumberStepAnnotations is disabled, And/But/* inheritance still requires a previous step
  - The previous step must exist even if annotations are not generated
  - The error message indicates no annotated previous step was found

    @error
    Scenario: And keyword without annotated previous step when annotations disabled
      Given the following base class:
        """
        import dev.specbinder.feature2junit.Feature2JUnit;
        import dev.specbinder.feature2junit.Feature2JUnitOptions;

        @Feature2JUnit
        @Feature2JUnitOptions(addCucumberStepAnnotations = false)
        public abstract class MockedAnnotatedTestClass {
        }
        """
      Given the following feature file:
        """
        Feature: And Without Annotations
          Scenario: Test
            And user is authenticated
        """
      When the generator is run
      Then the generator should report an error:
        """
        Step on line - 3 starts with 'And', but there are no previous scenario steps defined
        """

  Rule: Invalid step keywords that are not Given/When/Then/And/But/* result in error
  - Any unrecognized keyword should throw a ProcessingException
  - Error message should indicate the invalid keyword

    Scenario: Invalid step keyword
      Given the following feature file:
        """
        Feature: Invalid Keyword
          Scenario: Test
            Given user exists
            Invalid user clicks button
        """
      When the generator is run
      Then the generator should report an error:
        """
        Unable to parse Feature from the specified gherkin document: MockedAnnotatedTestClass.feature
        """
