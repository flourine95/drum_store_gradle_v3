package com.drumstore.web.controllers.auth;

import com.drumstore.web.config.GoogleAuthConfig;
import com.drumstore.web.dto.UserDTO;
import com.drumstore.web.services.UserService;
import com.drumstore.web.utils.GsonUtils;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;

@WebServlet({"/login/google", "/login/oauth2/code/google"})
public class GoogleLoginController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            String authUrl = String.format("%s?client_id=%s&redirect_uri=%s&response_type=code&scope=%s",
                    GoogleAuthConfig.AUTH_ENDPOINT,
                    GoogleAuthConfig.CLIENT_ID,
                    GoogleAuthConfig.REDIRECT_URI,
                    GoogleAuthConfig.SCOPE);
            response.sendRedirect(authUrl);
            return;
        }

        try {
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    new GsonFactory(),
                    GoogleAuthConfig.CLIENT_ID,
                    GoogleAuthConfig.CLIENT_SECRET,
                    code,
                    GoogleAuthConfig.REDIRECT_URI
            ).execute();

            String accessToken = tokenResponse.getAccessToken();
            var url = URI.create(GoogleAuthConfig.USERINFO_ENDPOINT).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            JsonObject userInfo = GsonUtils.fromJson(
                    new InputStreamReader(conn.getInputStream())
            );

            String email = userInfo.get("email").getAsString();
            UserDTO user = userService.findUser("email", email);

            if (user == null) {
                user = new UserDTO();
                user.setEmail(email);
                user.setFullname(userInfo.get("name").getAsString());
                user.setAvatar(userInfo.get("picture").getAsString());
                user.setStatus(true);
                userService.store(user);
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=google_login_failed");
        }
    }
}