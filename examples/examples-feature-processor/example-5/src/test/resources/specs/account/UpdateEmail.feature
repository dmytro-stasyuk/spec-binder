Feature: UpdateEmail

  Email address update functionality

  Scenario: User updates their email address
    Given the user is logged in
    When the user navigates to account settings
    And the user enters new email "newemail@example.com"
    And the user enters password "current123"
    And the user confirms the email change
    Then the email should be updated successfully
    And a verification email should be sent to "newemail@example.com"
