Feature: Registration

  New user registration functionality

  Scenario: Register a new user account
    Given the user is on the registration page
    When the user enters email "newuser@example.com"
    And the user enters password "secure456"
    And the user enters name "Jane Doe"
    And the user submits the registration form
    Then a new account should be created
    And a confirmation email should be sent
