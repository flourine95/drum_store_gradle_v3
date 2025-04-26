package com.drumstore.web.controllers.dashboard;

import com.drumstore.web.dto.RoleDTO;
import com.drumstore.web.repositories.RoleRepository;
import com.drumstore.web.utils.FlashManager;
import com.drumstore.web.utils.ForceLogoutCache;
import com.drumstore.web.utils.ParseHelper;
import com.drumstore.web.validators.RoleValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard/roles/*")
public class RoleManagerController extends HttpServlet {
    private final RoleRepository roleRepository = new RoleRepository();
    private final RoleValidator roleValidator = new RoleValidator();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            index(request, response);
            return;
        }

        switch (action) {
            case "create" -> create(request, response);
            case "edit" -> edit(request, response);
            default -> index(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
            return;
        }

        switch (action) {
            case "store" -> store(request, response);
            case "update" -> update(request, response);
            case "delete" -> delete(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/dashboard/roles");
        }
    }

    private void index(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FlashManager.exposeToRequest(request);
        List<RoleDTO> roles = roleRepository.getAllRoles();
        request.setAttribute("title", "Quản lý vai trò");
        request.setAttribute("content", "roles/index.jsp");
        request.setAttribute("roles", roles);
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Tạo vai trò mới");
        request.setAttribute("content", "roles/create.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Integer id = ParseHelper.tryParseInt(idStr);

        if (id == null) {
            FlashManager.store(request, "error", "ID vai trò không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
            return;
        }

        RoleDTO role = roleRepository.getRoleById(id);
        if (role == null) {
            FlashManager.store(request, "error", "Vai trò không tồn tại.");
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
            return;
        }

        request.setAttribute("role", role);
        request.setAttribute("title", "Chỉnh sửa vai trò");
        request.setAttribute("content", "roles/edit.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void store(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Map<String, String> errors;
        Map<String, String> oldInput = new HashMap<>();

        oldInput.put("name", name);
        oldInput.put("description", description);

        RoleDTO roleRequest = RoleDTO.builder()
                .name(name != null ? name.trim() : null)
                .description(description)
                .build();
        errors = roleValidator.validate(roleRequest);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("oldInput", oldInput);
            request.setAttribute("title", "Tạo vai trò mới");
            request.setAttribute("content", "roles/create.jsp");
            request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
            return;
        }

        boolean result = roleRepository.createRole(roleRequest);

        if (result) {
            FlashManager.store(request, "success", "Vai trò đã được tạo thành công!");
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
        } else {
            FlashManager.store(request, "error", "Không thể tạo vai trò.");
            request.setAttribute("errors", Map.of("general", "Có lỗi xảy ra. Vui lòng thử lại."));
            request.setAttribute("oldInput", oldInput);
            request.setAttribute("title", "Tạo vai trò mới");
            request.setAttribute("content", "roles/create.jsp");
            request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
        }
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Map<String, String> errors;
        Map<String, String> oldInput = new HashMap<>();

        oldInput.put("id", idStr);
        oldInput.put("name", name);
        oldInput.put("description", description);

        RoleDTO roleRequest = RoleDTO.builder()
                .id(ParseHelper.tryParseInt(idStr))
                .name(name != null ? name.trim() : null)
                .description(description)
                .build();

        errors = roleValidator.validate(roleRequest, true);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("oldInput", oldInput);
            request.setAttribute("title", "Cập nhật vai trò");
            request.setAttribute("content", "roles/edit.jsp");
            request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
            return;
        }

        boolean result = roleRepository.updateRole(roleRequest);

        if (result) {
            List<Integer> affectedUsers = roleRepository.getUserIdsByRoleId(roleRequest.getId());
            for (Integer userId : affectedUsers) {
                ForceLogoutCache.markForLogout(userId);
            }

            FlashManager.store(request, "success", "Cập nhật vai trò thành công!");
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
        } else {
            FlashManager.store(request, "error", "Cập nhật vai trò thất bại.");
            request.setAttribute("errors", Map.of("general", "Có lỗi xảy ra. Vui lòng thử lại."));
            request.setAttribute("oldInput", oldInput);
            request.setAttribute("title", "Cập nhật vai trò");
            request.setAttribute("content", "roles/edit.jsp");
            request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        Integer id = ParseHelper.tryParseInt(idStr);

        if (id == null) {
            FlashManager.store(request, "error", "ID vai trò không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
            return;
        }

        List<Integer> affectedUsers = roleRepository.getUserIdsByRoleId(id);
        boolean result = roleRepository.deleteRole(id);

        if (result) {
            for (Integer userId : affectedUsers) {
                ForceLogoutCache.markForLogout(userId);
            }

            FlashManager.store(request, "success", "Xóa vai trò thành công!");
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
        } else {
            FlashManager.store(request, "error", "Không thể xóa vai trò.");
            response.sendRedirect(request.getContextPath() + "/dashboard/roles");
        }
    }
}

