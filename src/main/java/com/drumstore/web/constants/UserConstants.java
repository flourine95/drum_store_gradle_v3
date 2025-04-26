package com.drumstore.web.constants;

public class UserConstants {
    public enum Role {
        CUSTOMER(0),
        ADMIN(1),
        STAFF(2);

        private final int value;

        Role(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }

        public static Role fromValue(int value) {
            for (Role role : values()) {
                if (role.value == value) {
                    return role;
                }
            }
            throw new IllegalArgumentException("Invalid User Role value: " + value);
        }
    }

    public enum Status {
        INACTIVE(0),
        ACTIVE(1),
        BANNED(2);

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
            throw new IllegalArgumentException("Invalid User Status value: " + value);
        }
    }
} 