Feature: Profile

  User profile management

  Scenario: Update user profile information
    Given the user is logged in
    When the user navigates to the profile page
    And the user updates their name to "John Smith"
    And the user updates their phone to "555-1234"
    And the user saves the changes
    Then the profile should be updated successfully
