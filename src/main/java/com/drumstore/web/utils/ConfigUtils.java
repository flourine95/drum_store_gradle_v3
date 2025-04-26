package com.drumstore.web.utils;

import java.io.InputStream;
import java.util.Properties;

public class ConfigUtils {
    private static final String configFilePath = "config.properties";

    private static final Properties properties = new Properties();

    static {
        try (InputStream input = ConfigUtils.class.getClassLoader().getResourceAsStream(configFilePath)) {
            if (input != null) {
                properties.load(input);
            } else {
                throw new RuntimeException(configFilePath + " not found");
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to load properties", e);
        }
    }

    public static String get(String key) {
        return properties.getProperty(key);
    }

    public static Properties getAll() {
        return properties;
    }
}
