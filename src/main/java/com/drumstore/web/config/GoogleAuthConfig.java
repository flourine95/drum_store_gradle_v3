package com.drumstore.web.config;


import com.drumstore.web.utils.ConfigUtils;

public class GoogleAuthConfig {
    public static final String CLIENT_ID = ConfigUtils.get("api.google.clientId");
    public static final String CLIENT_SECRET = ConfigUtils.get("api.google.clientSecret");
    public static final String REDIRECT_URI = ConfigUtils.get("api.google.redirectUri");
    public static final String AUTH_ENDPOINT = ConfigUtils.get("api.google.authEndpoint");
    public static final String TOKEN_ENDPOINT = ConfigUtils.get("api.google.tokenEndpoint");
    public static final String USERINFO_ENDPOINT = ConfigUtils.get("api.google.userinfoEndpoint");
    public static final String SCOPE = ConfigUtils.get("api.google.scope");
}
