package org.mycompany.app;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class CartItem {

    private final String name;

    private final int qty;

    private final double price;

}
