package com.drumstore.web.utils;

public class ParseHelper {
    public static Integer tryParseInt(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value.trim()) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static Long tryParseLong(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Long.parseLong(value.trim()) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static Double tryParseDouble(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Double.parseDouble(value.trim()) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static Boolean tryParseBoolean(String value) {
        if (value == null) return null;
        value = value.trim().toLowerCase();
        if ("true".equals(value) || "1".equals(value)) return true;
        if ("false".equals(value) || "0".equals(value)) return false;
        return null;
    }
}
