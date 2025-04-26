package com.drumstore.web.constants;

public class OrderConstants {
    public enum Status {
        PENDING(0),
        CONFIRMED(1),
        SHIPPING(2),
        DELIVERED(3),
        CANCELLED(4);

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
            throw new IllegalArgumentException("Invalid Order Status value: " + value);
        }
    }
} 