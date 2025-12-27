Feature: ClassAnnotationGenerated
  As a developer maintaining a codebase with generated code
  I want generated test classes to be clearly marked with @Generated annotation
  So that my development tools can automatically exclude them from code coverage, static analysis, and formatting rules

  Rule: @Generated annotation value is always "dev.specbinder.feature2junit.Feature2JUnitGenerator".

    Scenario: generated class has @Generated annotation with processor name
      Given the following base class:
      """
      package com.example.inventory;

      @Feature2JUnit("stock.feature")
      public abstract class StockManagement {
      }
      """
      And the following feature file:
      """
      Feature: Stock Management
        As a warehouse manager
        I want to track inventory
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      package com.example.inventory;

      import dev.specbinder.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: Stock Management
       *   As a warehouse manager
       *   I want to track inventory
       */
      @DisplayName("stock")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("stock.feature")
      public abstract class StockManagementScenarios extends StockManagement {
      }
      """

