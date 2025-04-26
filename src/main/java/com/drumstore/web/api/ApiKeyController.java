package com.drumstore.web.api;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.drumstore.web.utils.ConfigUtils;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.*;

@WebServlet("/api/keys")
public class ApiKeyController extends BaseApiController {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String service = request.getParameter("service");

        switch (service) {
            case "ckeditor" -> sendResponse(response, ConfigUtils.get("api.ckeditor.licenseKey"));
            case "ckbox" -> handleCKBoxToken(request, response);
            case "ckbox-dev" -> sendResponse(response, ConfigUtils.get("api.ckbox.tokenUrl"));
            default -> sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid or restricted service");
        }
    }

    private void handleCKBoxToken(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("userId") != null ? request.getParameter("userId") : "test-user";
        String role = request.getParameter("role") != null ? request.getParameter("role") : "superadmin";

        String token = createCSToken(userId, role);

        response.setContentType("text/plain");
        response.getWriter().write(token);
    }

    private String createCSToken(String userId, String role) {
        String secretKey = ConfigUtils.get("api.ckbox.secretKey");
        String environmentId = ConfigUtils.get("api.ckbox.environmentId");
        List<String> workspaces = Arrays.asList(ConfigUtils.get("api.ckbox.workspaces").split(","));

        Map<String, Object> authClaim = new HashMap<>() {{
            put("ckbox", new HashMap<>() {{
                put("role", role);
                put("workspaces", workspaces);
            }});
        }};

        return JWT.create()
                .withAudience(environmentId)
                .withIssuedAt(Instant.now())
                .withSubject(userId)
                .withClaim("auth", authClaim)
                .sign(Algorithm.HMAC256(secretKey.getBytes(StandardCharsets.US_ASCII)));
    }
}
