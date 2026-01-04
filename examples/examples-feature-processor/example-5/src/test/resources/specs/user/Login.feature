Feature: Login

  User authentication and login functionality

  Scenario: Successful login with valid credentials
    Given the user is on the login page
    When the user enters username "john@example.com"
    And the user enters password "secret123"
    And the user clicks the login button
    Then the user should be redirected to the dashboard
