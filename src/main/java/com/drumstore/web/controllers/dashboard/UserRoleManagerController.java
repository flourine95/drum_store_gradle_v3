package com.drumstore.web.controllers.dashboard;

import com.drumstore.web.dto.RoleDTO;
import com.drumstore.web.dto.UserDTO;
import com.drumstore.web.dto.UserRoleMatrixDTO;
import com.drumstore.web.repositories.RoleRepository;
import com.drumstore.web.repositories.UserRepository;
import com.drumstore.web.services.UserService;
import com.drumstore.web.utils.FlashManager;
import com.drumstore.web.utils.ForceLogoutCache;
import com.drumstore.web.utils.ParseHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/dashboard/user-roles/*")
public class UserRoleManagerController extends HttpServlet {
    private final UserService userService = new UserService();
    private final RoleRepository roleRepository = new RoleRepository();
    private final UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            index(request, response);
            return;
        }

        switch (action) {
            case "edit" -> edit(request, response);
            default -> index(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard/user-roles");
            return;
        }

        switch (action) {
            case "update" -> update(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/dashboard/user-roles");
        }
    }

    private void index(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FlashManager.exposeToRequest(request);
        
        // Get search parameters
        String search = request.getParameter("search");
        String roleFilter = request.getParameter("role");
        
        // Get all users and roles
        List<UserDTO> users = userService.getAllUsers();
        List<RoleDTO> roles = roleRepository.getAllRoles();

        // Apply search filter
        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase();
            users = users.stream()
                    .filter(user -> user.getEmail().toLowerCase().contains(searchLower) 
                            || (user.getFullname() != null && user.getFullname().toLowerCase().contains(searchLower)))
                    .collect(Collectors.toList());
        }

        // Apply role filter
        if (roleFilter != null && !roleFilter.isEmpty()) {
            try {
                int roleId = Integer.parseInt(roleFilter);
                users = users.stream()
                        .filter(user -> userService.getUserRoles(user.getId())
                                .stream()
                                .anyMatch(role -> role.getId() == roleId))
                        .collect(Collectors.toList());
            } catch (NumberFormatException ignored) {}
        }

        // Create matrix of users and their roles
        List<UserRoleMatrixDTO> matrixList = new ArrayList<>();
        for (UserDTO user : users) {
            UserRoleMatrixDTO matrix = new UserRoleMatrixDTO();
            matrix.setUserId(user.getId());
            matrix.setUserEmail(user.getEmail());
            matrix.setUserFullName(user.getFullname());

            Map<Integer, Boolean> roleMap = new HashMap<>();
            List<RoleDTO> userRoles = userService.getUserRoles(user.getId());

            for (RoleDTO role : roles) {
                boolean hasRole = userRoles.stream()
                        .anyMatch(ur -> ur.getId() == role.getId());
                roleMap.put(role.getId(), hasRole);
            }

            matrix.setRoleCheckboxMap(roleMap);
            matrixList.add(matrix);
        }

        request.setAttribute("matrixList", matrixList);
        request.setAttribute("roles", roles);
        request.setAttribute("search", search);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("title", "Quản lý vai trò người dùng");
        request.setAttribute("content", "user-roles/index.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("id");
        Integer userId = ParseHelper.tryParseInt(userIdStr);

        if (userId == null) {
            FlashManager.store(request, "error", "ID người dùng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/dashboard/user-roles");
            return;
        }

        UserDTO user = userService.findById(userId);
        if (user == null) {
            FlashManager.store(request, "error", "Người dùng không tồn tại");
            response.sendRedirect(request.getContextPath() + "/dashboard/user-roles");
            return;
        }

        List<RoleDTO> allRoles = roleRepository.getAllRoles();
        List<RoleDTO> userRoles = userService.getUserRoles(userId);

        request.setAttribute("user", user);
        request.setAttribute("allRoles", allRoles);
        request.setAttribute("userRoles", userRoles);
        request.setAttribute("title", "Chỉnh sửa vai trò người dùng");
        request.setAttribute("content", "user-roles/edit.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String[] roleIds = request.getParameterValues("roles[]");

        Integer userId = ParseHelper.tryParseInt(userIdStr);

        if (userId == null) {
            FlashManager.store(request, "error", "ID người dùng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/dashboard/user-roles");
            return;
        }

        UserDTO user = userService.findById(userId);
        if (user == null) {
            FlashManager.store(request, "error", "Người dùng không tồn tại");
            response.sendRedirect(request.getContextPath() + "/dashboard/user-roles");
            return;
        }

        try {
            // Get current user roles for comparison
            List<RoleDTO> currentRoles = userService.getUserRoles(userId);
            Set<Integer> currentRoleIds = currentRoles.stream()
                    .map(RoleDTO::getId)
                    .collect(Collectors.toSet());

            // Convert new role IDs to Set for comparison
            Set<Integer> newRoleIds = new HashSet<>();
            if (roleIds != null) {
                for (String roleId : roleIds) {
                    try {
                        newRoleIds.add(Integer.parseInt(roleId));
                    } catch (NumberFormatException ignored) {}
                }
            }

            // Remove roles that are no longer assigned
            for (Integer roleId : currentRoleIds) {
                if (!newRoleIds.contains(roleId)) {
                    userService.removeUserRole(userId, roleId);
                }
            }

            // Add new roles
            for (Integer roleId : newRoleIds) {
                if (!currentRoleIds.contains(roleId)) {
                    userService.addUserRole(userId, roleId);
                }
            }

            // Force logout if roles changed
            if (!currentRoleIds.equals(newRoleIds)) {
                ForceLogoutCache.markForLogout(userId);
            }

            FlashManager.store(request, "success", "Cập nhật vai trò người dùng thành công!");
        } catch (Exception e) {
            FlashManager.store(request, "error", "Có lỗi xảy ra khi cập nhật vai trò: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/dashboard/user-roles");
    }
}
