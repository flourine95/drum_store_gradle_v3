package com.drumstore.web.constants;

public class PermissionConstants {
    public static final String VIEW = "view";
    public static final String CREATE = "create";
    public static final String EDIT = "edit";
    public static final String DELETE = "delete";

    public static String of(String module, String action) {
        return module + "." + action;
    }
}
