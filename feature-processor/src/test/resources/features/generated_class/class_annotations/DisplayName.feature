Feature: DisplayName
  As a developer running and reviewing test results
  I want test reports to display meaningful names based on the feature file name
  So that I can quickly identify which feature is being tested without inspecting technical class names

  Rule: @DisplayName annotation uses the name of the feature file (not the feature title inside the file)

    Scenario: file file is in the root directory
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("ShoppingCart.feature")
      public abstract class FeatureTestBase extends  {

      }
      """
      And the following feature file:
      """
      Feature: managing shopping cart
        As a customer
        I want to manage my shopping cart
        So that I can purchase items
      """

      When the generator is run

      Then the content of the generated class should be:
      """
      import com.example.FeatureTestBase;
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: managing shopping cart
       *   As a customer
       *   I want to manage my shopping cart
       *   So that I can purchase items
       */
      @DisplayName("ShoppingCart")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("ShoppingCart.feature")
      public abstract class FeatureTestBaseScenarios extends FeatureTestBase {
      }
      """

    Scenario: feature file is in a subdirectory
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("features/ShoppingCart.feature")
      public abstract class FeatureTestBase extends  {

      }
      """
      And a feature file under path "features/ShoppingCart.feature" with the following content:
      """
      Feature: Online Shopping Cart
        As a customer
        I want to manage my shopping cart
        So that I can purchase items
      """

      When the generator is run

      Then the content of the generated class should be:
      """
      package features;

      import com.example.FeatureTestBase;
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: Online Shopping Cart
       *   As a customer
       *   I want to manage my shopping cart
       *   So that I can purchase items
       */
      @DisplayName("ShoppingCart")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("features/ShoppingCart.feature")
      public abstract class FeatureTestBaseScenarios extends FeatureTestBase {
      }
      """

  Rule: feature description (text after "Feature:" keyword) does not affect the @DisplayName value

    Scenario: DisplayName is file name even when feature has different description
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("specs/payment.feature")
      public abstract class FeatureTestBase {

      }
      """
      And a feature file under path "specs/payment.feature" with the following content:
      """
      Feature: Processing Credit Card Payments and Refunds
        As a payment processor
        I want to handle various payment scenarios
        So that customers can complete transactions successfully
      """

      When the generator is run

      Then the content of the generated class should be:
      """
      package specs;

      import com.example.FeatureTestBase;
      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: Processing Credit Card Payments and Refunds
       *   As a payment processor
       *   I want to handle various payment scenarios
       *   So that customers can complete transactions successfully
       */
      @DisplayName("payment")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("specs/payment.feature")
      public abstract class FeatureTestBaseScenarios extends FeatureTestBase {
      }
      """


