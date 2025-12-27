Feature: Shopping cart totals and shipping

  Scenario Outline: Subtotal updates when quantity changes
    Given my cart contains <name> with quantity <startQty> and unit price <price>
    When I change the quantity to <newQty>
    Then my cart subtotal is <expectedSubtotal>

    Examples:
      | name                | startQty | price | newQty | expectedSubtotal |
      | Wireless Headphones | 1        | 60.00 | 2      | 120.00           |
      | Coffee Beans 1kg    | 2        | 15.50 | 3      | 46.50            |