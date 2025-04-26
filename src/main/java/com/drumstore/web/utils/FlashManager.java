package com.drumstore.web.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;

public class FlashManager {
    private static final String FLASH_SESSION_KEY = "_FLASH_MESSAGES_";

    @SuppressWarnings("unchecked")
    public static void store(HttpServletRequest request, String key, String value) {
        HttpSession session = request.getSession();
        Map<String, String> flash = (Map<String, String>) session.getAttribute(FLASH_SESSION_KEY);
        if (flash == null) {
            flash = new HashMap<>();
        }
        flash.put(key, value);
        session.setAttribute(FLASH_SESSION_KEY, flash);
    }

    @SuppressWarnings("unchecked")
    public static String consume(HttpServletRequest request, String key) {
        HttpSession session = request.getSession();
        Map<String, String> flash = (Map<String, String>) session.getAttribute(FLASH_SESSION_KEY);
        if (flash != null) {
            String value = flash.get(key);
            flash.remove(key);
            if (flash.isEmpty()) {
                session.removeAttribute(FLASH_SESSION_KEY);
            } else {
                session.setAttribute(FLASH_SESSION_KEY, flash);
            }
            return value;
        }
        return null;
    }

    public static void exposeToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<String, String> flash = (Map<String, String>) session.getAttribute(FLASH_SESSION_KEY);
        if (flash != null) {
            for (Map.Entry<String, String> entry : flash.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }
            session.removeAttribute(FLASH_SESSION_KEY);
        }
    }
}
