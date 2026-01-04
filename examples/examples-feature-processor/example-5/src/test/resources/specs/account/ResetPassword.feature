Feature: ResetPassword

  Password reset functionality

  Scenario: User requests password reset
    Given the user is on the forgot password page
    When the user enters email "user@example.com"
    And the user clicks the reset password button
    Then a password reset email should be sent
    And the user should see a confirmation message
