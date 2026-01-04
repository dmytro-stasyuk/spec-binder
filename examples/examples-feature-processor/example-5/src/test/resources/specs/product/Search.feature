Feature: Search

  Product search functionality

  Scenario: Search for products by keyword
    Given the user is on the home page
    When the user enters "laptop" in the search box
    And the user clicks the search button
    Then the search results should display products matching "laptop"
    And the results should be sorted by relevance
