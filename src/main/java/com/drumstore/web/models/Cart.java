package com.drumstore.web.models;

import com.drumstore.web.dto.CartItemDTO;
import com.drumstore.web.dto.VoucherDTO;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items;
    private VoucherDTO voucher;

    @Override
    public String toString() {
        return "Cart{" +
                "items=" + items +
                '}';
    }

    public VoucherDTO getVoucher() {
        return voucher;
    }

    public void setVoucher(VoucherDTO voucher) {
        this.voucher = voucher;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }

    public Cart() {
        this.items = new ArrayList<>();
    }

    public void addItem(CartItemDTO item, int quantity) {
        // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
        for (CartItem existingItem : items) {
            if (existingItem.getCartItem().getProductVariant().getId() == item.getProductVariant().getId()) {
                existingItem.setQuantity(existingItem.getQuantity() + quantity);
                return;
            }
        }
        items.add(new CartItem(items.size() + 1, quantity, item));
    }

    public void removeItem(int cartId) {
        items.removeIf(item -> item.getCartId() == cartId
        );
    }

    public double updateQuantity(int cartId, int quantity) {
        for (CartItem item : items) {
            if (item.getCartId() == cartId) {
                item.setQuantity(quantity);
                return item.getTotal();
            }
        }
        return 0;
    }



    public List<CartItem> getItems() {
        return items;
    }

    public double getTotal() {
        return items.stream()
                .mapToDouble(CartItem::getTotal)
                .sum() ;
    }
    public double getDiscountTotal(){
        if (voucher == null) {
            return 0;
        }
        return voucher.calculateDiscount(getTotal());
    }

    public int getItemCount() {
        return items.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    // cập nhật lại item khi người dùng chọn biến thể khác
    public CartItem changeVariant(int cartId ,CartItemDTO cartItemDTO) {
        for (CartItem item : items) {
            if (item.getCartId() == cartId) {
                item.changeCartItem(cartItemDTO);
                return item;
            }
        }
        return null;
    }


}