package com.drumstore.web.constants;

import java.util.regex.Pattern;

public class ValidationPatterns {
    public static final Pattern PHONE = Pattern.compile("^[0-9]{10,15}$");
    public static final Pattern EMAIL = Pattern.compile("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    public static final Pattern PASSWORD = Pattern.compile("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$");
}


