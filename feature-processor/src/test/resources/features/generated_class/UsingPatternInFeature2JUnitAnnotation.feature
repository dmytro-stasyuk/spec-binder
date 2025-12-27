Feature: UsingPatternInFeature2JUnitAnnotation
  As a developer organizing feature files in a hierarchical directory structure
  I want to use glob patterns in the @Feature2JUnit annotation to match multiple feature files
  So that I can generate test classes for all matching feature files without annotating a separate class for each one

  Rule: When annotation value contains glob pattern characters (*, **), all matching feature files generate separate test classes
  - generated class name in this case is derived from the feature file name
  - all pattern-matched classes share same package and base class

    Scenario: Pattern matching single feature file in same directory
      Given the following base class:
      """
      package com.example.features;

      @Feature2JUnit("*.feature")
      public abstract class UserFeatures {
      }
      """
      And a feature file under path "UserLogin.feature" with the following content:
      """
      Feature: User Login
        Scenario: Successful login
          Given user exists
      """
      When the generator is run
      Then the content of the generated class should be:
      """
      package com.example.features;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: User Login
       */
      @DisplayName("UserLogin")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("UserLogin.feature")
      public abstract class UserLoginScenarios extends UserFeatures {
          public abstract void givenUserExists();

          @Test
          @Order(1)
          @DisplayName("Scenario: Successful login")
          public void scenario_1() {
              /*
               * Given user exists
               */
              givenUserExists();
          }
      }
      """

    Scenario: Pattern matching multiple feature files in same directory
      Given the following base class:
      """
      package com.example.features;

      @Feature2JUnit("*.feature")
      public abstract class UserFeatures {
      }
      """
      And a feature file under path "UserLogin.feature" with the following content:
      """
      Feature: User Login
        Scenario: Login test
          Given user exists
      """
      And a feature file under path "UserRegistration.feature" with the following content:
      """
      Feature: User Registration
        Scenario: Registration test
          Given user registers
      """
      When the generator is run
      Then 2 test classes should be generated
      And a class named "UserLoginScenarios" should be generated with content:
      """
      package com.example.features;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: User Login
       */
      @DisplayName("UserLogin")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("UserLogin.feature")
      public abstract class UserLoginScenarios extends UserFeatures {
          public abstract void givenUserExists();

          @Test
          @Order(1)
          @DisplayName("Scenario: Login test")
          public void scenario_1() {
              /*
               * Given user exists
               */
              givenUserExists();
          }
      }
      """
      And a class named "UserRegistrationScenarios" should be generated with content:
      """
      package com.example.features;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: User Registration
       */
      @DisplayName("UserRegistration")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("UserRegistration.feature")
      public abstract class UserRegistrationScenarios extends UserFeatures {
          public abstract void givenUserRegisters();

          @Test
          @Order(1)
          @DisplayName("Scenario: Registration test")
          public void scenario_1() {
              /*
               * Given user registers
               */
              givenUserRegisters();
          }
      }
      """

    Scenario: Pattern matching files in subdirectories using double asterisk
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("features/**/*.feature")
      public abstract class AllFeatures {
      }
      """
      And a feature file under path "features/user/Login.feature" with the following content:
      """
      Feature: User Login
        Scenario: Login
          Given user logs in
      """
      And a feature file under path "features/user/Registration.feature" with the following content:
      """
      Feature: User Registration
        Scenario: Register
          Given user registers
      """
      And a feature file under path "features/admin/Dashboard.feature" with the following content:
      """
      Feature: Admin Dashboard
        Scenario: View dashboard
          Given admin views dashboard
      """
      When the generator is run
      Then 3 test classes should be generated
      And a class named "LoginScenarios" should be generated with content:
      """
      package com.example;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: User Login
       */
      @DisplayName("Login")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("features/user/Login.feature")
      public abstract class LoginScenarios extends AllFeatures {
          public abstract void givenUserLogsIn();

          @Test
          @Order(1)
          @DisplayName("Scenario: Login")
          public void scenario_1() {
              /*
               * Given user logs in
               */
              givenUserLogsIn();
          }
      }
      """
      And a class named "RegistrationScenarios" should be generated with content:
      """
      package com.example;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: User Registration
       */
      @DisplayName("Registration")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("features/user/Registration.feature")
      public abstract class RegistrationScenarios extends AllFeatures {
          public abstract void givenUserRegisters();

          @Test
          @Order(1)
          @DisplayName("Scenario: Register")
          public void scenario_1() {
              /*
               * Given user registers
               */
              givenUserRegisters();
          }
      }
      """
      And a class named "DashboardScenarios" should be generated with content:
      """
      package com.example;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Admin Dashboard
       */
      @DisplayName("Dashboard")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("features/admin/Dashboard.feature")
      public abstract class DashboardScenarios extends AllFeatures {
          public abstract void givenAdminViewsDashboard();

          @Test
          @Order(1)
          @DisplayName("Scenario: View dashboard")
          public void scenario_1() {
              /*
               * Given admin views dashboard
               */
              givenAdminViewsDashboard();
          }
      }
      """

    Scenario: Pattern with specific subdirectory prefix
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("features/user/**")
      public abstract class UserFeatures {
      }
      """
      And a feature file under path "features/user/Login.feature" with the following content:
      """
      Feature: User Login
        Scenario: Login
          Given user logs in
      """
      And a feature file under path "features/user/auth/TwoFactor.feature" with the following content:
      """
      Feature: Two Factor Authentication
        Scenario: Enable 2FA
          Given user enables two factor authentication
      """
      And a feature file under path "features/admin/Dashboard.feature" with the following content:
      """
      Feature: Admin Dashboard
        Scenario: View dashboard
          Given admin views dashboard
      """
      When the generator is run
      Then 2 test classes should be generated
      And a class named "LoginScenarios" should be generated with content:
      """
      package com.example;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: User Login
       */
      @DisplayName("Login")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("features/user/Login.feature")
      public abstract class LoginScenarios extends UserFeatures {
          public abstract void givenUserLogsIn();

          @Test
          @Order(1)
          @DisplayName("Scenario: Login")
          public void scenario_1() {
              /*
               * Given user logs in
               */
              givenUserLogsIn();
          }
      }
      """
      And a class named "TwoFactorScenarios" should be generated with content:
      """
      package com.example;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Two Factor Authentication
       */
      @DisplayName("TwoFactor")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("features/user/auth/TwoFactor.feature")
      public abstract class TwoFactorScenarios extends UserFeatures {
          public abstract void givenUserEnablesTwoFactorAuthentication();

          @Test
          @Order(1)
          @DisplayName("Scenario: Enable 2FA")
          public void scenario_1() {
              /*
               * Given user enables two factor authentication
               */
              givenUserEnablesTwoFactorAuthentication();
          }
      }
      """

  Rule: Pattern matching respects generator options from the annotated class

    Scenario: Custom suffix applied to all generated classes from pattern
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("features/*.feature")
      @Feature2JUnitOptions(generatedClassSuffix = "TestCases")
      public abstract class Features {
      }
      """
      And a feature file under path "features/Login.feature" with the following content:
      """
      Feature: Login
        Scenario: Test login
          Given user logs in
      """
      And a feature file under path "features/Logout.feature" with the following content:
      """
      Feature: Logout
        Scenario: Test logout
          Given user logs out
      """
      When the generator is run
      Then 2 test classes should be generated
      And a class named "LoginTestCases" should be generated with content:
      """
      package com.example;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Login
       */
      @DisplayName("Login")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("features/Login.feature")
      public abstract class LoginTestCases extends Features {
          public abstract void givenUserLogsIn();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test login")
          public void scenario_1() {
              /*
               * Given user logs in
               */
              givenUserLogsIn();
          }
      }
      """
      And a class named "LogoutTestCases" should be generated with content:
      """
      package com.example;

      import dev.specbinder.annotations.output.FeatureFilePath;
      import javax.annotation.processing.Generated;
      import org.junit.jupiter.api.DisplayName;
      import org.junit.jupiter.api.MethodOrderer;
      import org.junit.jupiter.api.Order;
      import org.junit.jupiter.api.Test;
      import org.junit.jupiter.api.TestMethodOrder;

      /**
       * Feature: Logout
       */
      @DisplayName("Logout")
      @Generated("dev.specbinder.feature2junit.Feature2JUnitGenerator")
      @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
      @FeatureFilePath("features/Logout.feature")
      public abstract class LogoutTestCases extends Features {
          public abstract void givenUserLogsOut();

          @Test
          @Order(1)
          @DisplayName("Scenario: Test logout")
          public void scenario_1() {
              /*
               * Given user logs out
               */
              givenUserLogsOut();
          }
      }
      """

  Rule: Pattern matching behavior with edge cases

    Scenario: No files match the pattern
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("nonexistent/**/*.feature")
      public abstract class Features {
      }
      """
      And a feature file under path "features/UserLogin.feature" with the following content:
      """
      Feature: User Login
        Scenario: Successful login
          Given user exists
      """
      When the generator is run
      Then the generator should report an error:
      """
      No feature files found matching pattern 'nonexistent/**/*.feature'
      """

  Rule: Pattern matching with file name conflicts

    Scenario: Multiple feature files with same name in different directories
      Given the following base class:
      """
      package com.example;

      @Feature2JUnit("features/**/*.feature")
      public abstract class Features {
      }
      """
      And a feature file under path "features/user/Login.feature" with the following content:
      """
      Feature: User Login
        Scenario: User login test
      """
      And a feature file under path "features/admin/Login.feature" with the following content:
      """
      Feature: Admin Login
        Scenario: Admin login test
      """
      When the generator is run
      Then the generator should report an error:
      """
      Duplicate generated class name 'LoginScenarios' from feature file pattern 'features/**/*.feature'.
      """

    Rule: FeatureFilePath annotation contains the matched path

#    Scenario: FeatureFilePath reflects actual matched file path
#      Given the following base class:
#      """
#      package com.example;
#
#      @Feature2JUnit("features/**/*.feature")
#      public abstract class Features {
#      }
#      """
#      And the following feature file:
#      """
#      features/user/auth/Login.feature:
#        Feature: Login
#          Scenario: Test
#      """
#      When the generator is run
#      Then the generated class should have annotation:
#      """
#      @FeatureFilePath("features/user/auth/Login.feature")
#      """
