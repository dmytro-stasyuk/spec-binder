Feature: Checkout

  Order checkout process

  Scenario: Complete checkout with valid payment
    Given the user has items in the cart
    And the user is on the checkout page
    When the user enters shipping address "123 Main St, City, 12345"
    And the user enters payment details "4111111111111111"
    And the user confirms the order
    Then the order should be placed successfully
    And an order confirmation should be displayed
