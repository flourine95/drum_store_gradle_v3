package com.drumstore.web.constants;

public class ProductConstants {
    public enum StockManagementType {
        SIMPLE(0),
        COLOR_ONLY(1),
        ADDON_ONLY(2),
        COLOR_AND_ADDON(3);

        private final int value;

        StockManagementType(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }

        public static StockManagementType fromValue(int value) {
            for (StockManagementType type : values()) {
                if (type.value == value) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Invalid StockManagementType value: " + value);
        }
    }

    public enum Status {
        INACTIVE(0),
        ACTIVE(1),
        DELETED(2);

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
            throw new IllegalArgumentException("Invalid Status value: " + value);
        }
    }
} 