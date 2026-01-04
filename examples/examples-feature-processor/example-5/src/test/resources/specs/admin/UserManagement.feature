Feature: UserManagement

  Admin user management functionality

  Scenario: Admin deactivates a user account
    Given the admin is on the user management page
    When the admin searches for user "baduser@example.com"
    And the admin clicks the deactivate button
    And the admin confirms the deactivation
    Then the user account should be deactivated
    And the user should no longer be able to log in
