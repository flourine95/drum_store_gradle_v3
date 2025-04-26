package com.drumstore.web.utils;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ForceLogoutCache {
    private static Set<Integer> forceLogoutUserIds = ConcurrentHashMap.newKeySet();

    public static void markForLogout(Integer userId) {
        forceLogoutUserIds.add(userId);
    }

    public static void removeFromLogout(Integer userId) {
        forceLogoutUserIds.remove(userId);
    }
    public static Set<Integer> all() {
        return forceLogoutUserIds;
    }
    public static boolean shouldLogout(Integer userId) {
        return forceLogoutUserIds.contains(userId);
    }
}
