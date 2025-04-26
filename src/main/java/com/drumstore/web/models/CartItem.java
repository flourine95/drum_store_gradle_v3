package com.drumstore.web.models;

import com.drumstore.web.dto.CartItemDTO;

public class CartItem {
    private int cartId;
    private CartItemDTO cartItem;
    private int quantity;

    public CartItem(int cartId, int quantity, CartItemDTO cartItem) {
        this.cartId = cartId;
        this.quantity = quantity;
        this.cartItem = cartItem;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public CartItemDTO getCartItem() {
        return cartItem;
    }

    public void setCartItem(CartItemDTO cartItem) {
        this.cartItem = cartItem;
    }

    public double getTotal() {
        return cartItem.getLowestSalePrice()*quantity;
    }

    public void changeCartItem(CartItemDTO cartItem) {
        this.cartItem = cartItem;
        this.quantity = 1;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "cartId=" + cartId +
                ", cartItem=" + cartItem +
                ", quantity=" + quantity +
                '}';
    }
}