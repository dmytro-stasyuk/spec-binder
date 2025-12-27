Feature: ClassAnnotationTestClassOrder
  As a developer maintaining features with ordered business rules
  I want @TestClassOrder annotation to be added when the feature contains Rules
  So that the generated nested test classes execute in the same sequence as defined in the feature file

  Rule: @TestClassOrder annotation is added only when the feature contains Rules

    Scenario: feature file without any Rules
      Given the following base class:
      """
      package com.example.simple;

      @Feature2JUnit("simple.feature")
      public abstract class SimpleFeature {
      }
      """
      And the following feature file:
      """
      Feature: Simple Feature
        Scenario: Only scenario
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      package com.example.simple;

      import dev.specbinder.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.Assertions;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Tag;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Simple Feature
       */
      @DisplayName("simple")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("simple.feature")
      public abstract class SimpleFeatureScenarios extends SimpleFeature {
          @Test
          @Order(1)
          @Tag("new")
          @DisplayName("Scenario: Only scenario")
          public void scenario_1() {
              Assertions.fail("Scenario has no steps");
          }
      }
      """

    Scenario: feature file with single rule
      Given the following base class:
      """
      package com.example.rules;

      @Feature2JUnit("business-rules.feature")
      public abstract class BusinessRules {
      }
      """
      And the following feature file:
      """
      Feature: Business Rules
        Rule: First rule
          Scenario: First scenario
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      package com.example.rules;

      import dev.specbinder.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.Assertions;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Tag;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Business Rules
       */
      @DisplayName("business-rules")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("business-rules.feature")
      public abstract class BusinessRulesScenarios extends BusinessRules {
          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: First rule")
          public class Rule_1 {
              @Test
              @Order(1)
              @Tag("new")
              @DisplayName("Scenario: First scenario")
              public void scenario_1() {
                  Assertions.fail("Scenario has no steps");
              }
          }
      }
      """

  Rule: each nested Rule class gets @Order(1), @Order(2), etc., matching their position in the feature file.

    Scenario: feature with 3 rules
      Given the following base class:
      """
      package com.example.workflow;

      @Feature2JUnit("workflow.feature")
      public abstract class WorkflowTests {
      }
      """
      And the following feature file:
      """
      Feature: Workflow Processing
        Rule: Validation rules
          Scenario: Validate input

        Rule: Processing rules
          Scenario: Process data

        Rule: Output rules
          Scenario: Generate output
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      package com.example.workflow;

      import dev.specbinder.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.Assertions;
      import org.junit.jupiter.api.ClassOrderer;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Nested;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Tag;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestClassOrder;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Workflow Processing
       */
      @DisplayName("workflow")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestClassOrder(ClassOrderer.OrderAnnotation.class)
      @FeatureFilePath("workflow.feature")
      public abstract class WorkflowTestsScenarios extends WorkflowTests {
          @Nested
          @Order(1)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: Validation rules")
          public class Rule_1 {
              @Test
              @Order(1)
              @Tag("new")
              @DisplayName("Scenario: Validate input")
              public void scenario_1() {
                  Assertions.fail("Scenario has no steps");
              }
          }

          @Nested
          @Order(2)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: Processing rules")
          public class Rule_2 {
              @Test
              @Order(1)
              @Tag("new")
              @DisplayName("Scenario: Process data")
              public void scenario_1() {
                  Assertions.fail("Scenario has no steps");
              }
          }

          @Nested
          @Order(3)
          @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
          @DisplayName("Rule: Output rules")
          public class Rule_3 {
              @Test
              @Order(1)
              @Tag("new")
              @DisplayName("Scenario: Generate output")
              public void scenario_1() {
                  Assertions.fail("Scenario has no steps");
              }
          }
      }
      """


