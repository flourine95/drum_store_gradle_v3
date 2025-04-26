package com.drumstore.web.api;

import com.drumstore.web.models.District;
import com.drumstore.web.models.Province;
import com.drumstore.web.models.Ward;
import com.drumstore.web.services.LocationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/locations/*")
public class LocationApiController extends BaseApiController {
    private final LocationService locationService = new LocationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();

            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/locations - Lấy tất cả provinces
                handleGetProvinces(response);
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length < 2) {
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
                return;
            }

            switch (pathParts[1]) {
                case "provinces":
                    if (pathParts.length == 2) {
                        // GET /api/locations/provinces
                        handleGetProvinces(response);
                    } else if (pathParts.length == 3) {
                        // GET /api/locations/provinces/{id}
                        handleGetProvince(response, Integer.parseInt(pathParts[2]));
                    } else if (pathParts.length == 4 && "districts".equals(pathParts[3])) {
                        // GET /api/locations/provinces/{id}/districts
                        handleGetDistrictsByProvince(response, Integer.parseInt(pathParts[2]));
                    }
                    break;

                case "districts":
                    if (pathParts.length == 3) {
                        // GET /api/locations/districts/{id}
                        handleGetDistrict(response, Integer.parseInt(pathParts[2]));
                    } else if (pathParts.length == 4 && "wards".equals(pathParts[3])) {
                        // GET /api/locations/districts/{id}/wards
                        handleGetWardsByDistrict(response, Integer.parseInt(pathParts[2]));
                    }
                    break;

                case "wards":
                    if (pathParts.length == 3) {
                        // GET /api/locations/wards/{id}
                        handleGetWard(response, Integer.parseInt(pathParts[2]));
                    }
                    break;

                default:
                    sendError(response, HttpServletResponse.SC_NOT_FOUND, "Resource not found");
            }
        } catch (NumberFormatException e) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void handleGetProvinces(HttpServletResponse response) throws IOException {
        try {
            List<Province> provinces = locationService.getAllProvinces();
            sendResponse(response, provinces);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch provinces");
        }
    }

    private void handleGetProvince(HttpServletResponse response, int provinceId) throws IOException {
        try {
            Province province = locationService.getProvinceById(provinceId);
            if (province == null) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Province not found");
                return;
            }
            sendResponse(response, province);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch province");
        }
    }

    private void handleGetDistrictsByProvince(HttpServletResponse response, int provinceId) throws IOException {
        try {
            List<District> districts = locationService.getDistrictsByProvinceId(provinceId);
            sendResponse(response, districts);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch districts");
        }
    }

    private void handleGetDistrict(HttpServletResponse response, int districtId) throws IOException {
        try {
            District district = locationService.getDistrictById(districtId);
            if (district == null) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "District not found");
                return;
            }
            sendResponse(response, district);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch district");
        }
    }

    private void handleGetWardsByDistrict(HttpServletResponse response, int districtId) throws IOException {
        try {
            List<Ward> wards = locationService.getWardsByDistrictId(districtId);
            sendResponse(response, wards);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch wards");
        }
    }

    private void handleGetWard(HttpServletResponse response, int wardId) throws IOException {
        try {
            Ward ward = locationService.getWardById(wardId);
            if (ward == null) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Ward not found");
                return;
            }
            sendResponse(response, ward);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch ward");
        }
    }
} 