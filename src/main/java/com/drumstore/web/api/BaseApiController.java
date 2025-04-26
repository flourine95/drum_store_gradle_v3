package com.drumstore.web.api;

import com.drumstore.web.utils.GsonUtils;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public abstract class BaseApiController extends HttpServlet {
    
    protected void sendResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(GsonUtils.toJson(data));
    }

    protected void sendError(HttpServletResponse response, int status, String message) throws IOException {
        Map<String, Object> error = new HashMap<>();
        error.put("error", message);
        response.setStatus(status);
        sendResponse(response, error);
    }

    protected <T> T parseRequestBody(HttpServletRequest request, Class<T> type) throws IOException {
        return GsonUtils.fromJson(request.getReader(), type);
    }

    protected Map<String, String> getQueryParams(HttpServletRequest request) {
        Map<String, String> params = new HashMap<>();
        request.getParameterMap().forEach((key, values) -> {
            if (values != null && values.length > 0) {
                params.put(key, values[0]);
            }
        });
        return params;
    }

    protected int getRequiredIntParam(HttpServletRequest request, String paramName) throws IOException {
        String value = request.getParameter(paramName);
        if (value == null || value.isEmpty()) {
            throw new IllegalArgumentException(paramName + " is required");
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid " + paramName + " format");
        }
    }

    protected String getRequiredParam(HttpServletRequest request, String paramName) throws IOException {
        String value = request.getParameter(paramName);
        if (value == null || value.isEmpty()) {
            throw new IllegalArgumentException(paramName + " is required");
        }
        return value;
    }
} 