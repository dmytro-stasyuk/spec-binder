Feature: ClassAnnotationFeatureFilePath
  As a developer navigating between generated tests and their source specifications
  I want the generated test class to be annotated with the path to its originating feature file
  So that I can quickly locate and edit the corresponding feature file when reviewing or debugging tests

  Rule: if the @Feature2JUnit annotation value is blank, the path is constructed from package and class name of the annotated class

    Scenario: explicit feature file path is specified
      Given the following base class:
      """
      package com.example.shop;

      @Feature2JUnit("features/shopping/cart.feature")
      public abstract class CartFeatureBase {
      }
      """
      And the following feature file:
      """
      Feature: Shopping Cart Management
        As a customer
        I want to manage items in my cart
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      package com.example.shop;

      import dev.spec2test.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: Shopping Cart Management
       *   As a customer
       *   I want to manage items in my cart
       */
      @DisplayName("cart")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("features/shopping/cart.feature")
      public abstract class CartFeatureBaseScenarios extends CartFeatureBase {
      }
      """

    Scenario: value is blank
      Given the following base class:
      """
      package com.example.payment;

      @Feature2JUnit
      public abstract class PaymentProcessing {
      }
      """
      And the following feature file:
      """
      Feature: Payment Processing
        As a payment system
        I want to process payments
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      package com.example.payment;

      import dev.spec2test.feature2junit.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;

      /**
       * Feature: Payment Processing
       *   As a payment system
       *   I want to process payments
       */
      @DisplayName("PaymentProcessing")
      @Generated("dev.spec2test.feature2junit.Feature2JUnitGenerator")
      @FeatureFilePath("com/example/payment/PaymentProcessing.feature")
      public abstract class PaymentProcessingScenarios extends PaymentProcessing {
      }
      """
