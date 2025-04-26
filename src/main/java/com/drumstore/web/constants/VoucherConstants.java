package com.drumstore.web.constants;

public class VoucherConstants {
    public enum Status {
        INACTIVE(0),
        ACTIVE(1),
        EXPIRED(2);

        private final int value;

        Status(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }

        public static Status fromValue(int value) {
            for (Status status : values()) {
                if (status.value == value) {
                    return status;
                }
            }
            throw new IllegalArgumentException("Invalid Voucher Status value: " + value);
        }
    }

    public enum DiscountType {
        FIXED(1),      // Giảm giá trực tiếp một số tiền cố định
        PERCENTAGE(2); // Giảm giá theo phần trăm

        private final int value;

        DiscountType(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }

        public static DiscountType fromValue(int value) {
            for (DiscountType type : values()) {
                if (type.value == value) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Invalid Voucher Discount Type value: " + value);
        }
    }
} 