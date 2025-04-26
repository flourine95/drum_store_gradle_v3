package com.drumstore.web.controllers.dashboard;

import com.drumstore.web.dto.PermissionDTO;
import com.drumstore.web.dto.PermissionMatrixDTO;
import com.drumstore.web.dto.RoleDTO;
import com.drumstore.web.dto.RolePermissionDTO;
import com.drumstore.web.repositories.PermissionRepository;
import com.drumstore.web.repositories.RolePermissionRepository;
import com.drumstore.web.repositories.RoleRepository;
import com.drumstore.web.utils.ForceLogoutCache;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

@WebServlet("/dashboard/role-permissions/*")
public class RolePermissonManagerController extends HttpServlet {
    private final RoleRepository roleRepository = new RoleRepository();
    private final PermissionRepository permissionRepository = new PermissionRepository();
    private final RolePermissionRepository rolePermissionRepository = new RolePermissionRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<RoleDTO> roles = roleRepository.getAllRoles();
        List<PermissionDTO> permissions = permissionRepository.getAllPermissions();
        List<RolePermissionDTO> rolePermissions = rolePermissionRepository.getAllRolePermissions();

        List<PermissionMatrixDTO> matrixList = new ArrayList<>();

        for (PermissionDTO permission : permissions) {
            PermissionMatrixDTO dto = new PermissionMatrixDTO();
            dto.setPermissionId(permission.getId());
            dto.setPermissionName(permission.getName());
            dto.setPermissionDescription(permission.getDescription());

            Map<Integer, Boolean> roleMap = new HashMap<>();

            for (RoleDTO role : roles) {
                boolean hasPermission = rolePermissions.stream()
                        .anyMatch(rp -> rp.getRoleId() == role.getId() && rp.getPermissionId() == permission.getId());
                roleMap.put(role.getId(), hasPermission);
            }

            dto.setRoleCheckboxMap(roleMap);
            matrixList.add(dto);
        }
        request.setAttribute("matrixList", matrixList);
        request.setAttribute("roles", roles);
        request.setAttribute("permissions", permissions);
        request.setAttribute("title", "Quản lý quyền của vai trò");
        request.setAttribute("content", "role-permissions/index.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String[]> parameterMap = request.getParameterMap();
        Set<Integer> affectedPermissionIds = new HashSet<>();
        Set<Integer> affectedRoleIds = new HashSet<>();

        Map<Integer, Set<Integer>> oldRolePermissions = new HashMap<>();
        for (RoleDTO role : roleRepository.getAllRoles()) {
            Set<Integer> permissions = new HashSet<>();
            for (RolePermissionDTO rp : rolePermissionRepository.getAllRolePermissions()) {
                if (rp.getRoleId() == role.getId()) {
                    permissions.add(rp.getPermissionId());
                }
            }
            oldRolePermissions.put(role.getId(), permissions);
        }

        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String paramName = entry.getKey();
            String[] paramValues = entry.getValue();

            if (paramName.startsWith("permissions")) {
                String permissionIdStr = paramName.replaceAll("permissions\\[(\\d+)]\\[]", "$1");
                int permissionId = Integer.parseInt(permissionIdStr);

                for (String roleIdStr : paramValues) {
                    int roleId = Integer.parseInt(roleIdStr);
                    boolean hasPermission = rolePermissionRepository.hasRolePermission(roleId, permissionId);
                    if (!hasPermission) {
                        rolePermissionRepository.saveRolePermission(roleId, permissionId);
                        affectedRoleIds.add(roleId);
                        affectedPermissionIds.add(permissionId);
                    }
                }
            }
        }

        for (RoleDTO role : roleRepository.getAllRoles()) {
            for (PermissionDTO permission : permissionRepository.getAllPermissions()) {
                String key = "permissions[" + permission.getId() + "][]";
                String[] selectedRoleIds = parameterMap.get(key);

                if (selectedRoleIds == null || !containsRole(selectedRoleIds, String.valueOf(role.getId()))) {
                    if (oldRolePermissions.get(role.getId()).contains(permission.getId())) {
                        rolePermissionRepository.deleteRolePermission(role.getId(), permission.getId());
                        affectedRoleIds.add(role.getId());
                        affectedPermissionIds.add(permission.getId());
                    }
                }
            }
        }

        Set<Integer> usersToLogout = new HashSet<>();

        for (Integer roleId : affectedRoleIds) {
            usersToLogout.addAll(roleRepository.getUserIdsByRoleId(roleId));
        }

        for (Integer permissionId : affectedPermissionIds) {
            usersToLogout.addAll(permissionRepository.getUserIdsByPermissionId(permissionId));
        }

        for (Integer userId : usersToLogout) {
            ForceLogoutCache.markForLogout(userId);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard/role-permissions");
    }

    private boolean containsRole(String[] roleIds, String roleId) {
        for (String id : roleIds) {
            if (id.equals(roleId)) {
                return true;
            }
        }
        return false;
    }
}
