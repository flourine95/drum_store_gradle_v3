package com.drumstore.web.constants;

public class PaymentConstants {
    public enum Method {
        COD(0),
        BANK_TRANSFER(1),
        E_WALLET(2);

        private final int value;

        Method(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }

        public static Method fromValue(int value) {
            for (Method method : values()) {
                if (method.value == value) {
                    return method;
                }
            }
            throw new IllegalArgumentException("Invalid Payment Method value: " + value);
        }
    }

    public enum Status {
        PENDING(0),
        COMPLETED(1),
        FAILED(2),
        REFUNDED(3);

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
            throw new IllegalArgumentException("Invalid Payment Status value: " + value);
        }
    }
} 