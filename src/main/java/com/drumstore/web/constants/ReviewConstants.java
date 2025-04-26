package com.drumstore.web.constants;

public class ReviewConstants {
    public enum Status {
        PENDING(0),
        APPROVED(1),
        REJECTED(2);

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
            throw new IllegalArgumentException("Invalid Review Status value: " + value);
        }
    }
} 