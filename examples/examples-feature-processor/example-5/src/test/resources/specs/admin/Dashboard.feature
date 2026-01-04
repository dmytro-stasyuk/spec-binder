Feature: Dashboard

  Admin dashboard functionality

  Scenario: View admin dashboard statistics
    Given the admin is logged in
    When the admin navigates to the dashboard
    Then the dashboard should display total users
    And the dashboard should display total orders
    And the dashboard should display revenue statistics
