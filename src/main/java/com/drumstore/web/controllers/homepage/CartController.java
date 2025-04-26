package com.drumstore.web.controllers.homepage;

import com.drumstore.web.dto.CartItemDTO;
import com.drumstore.web.models.Cart;
import com.drumstore.web.models.CartItem;
import com.drumstore.web.services.PaymentService;
import com.drumstore.web.services.ProductService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.OptionalLong;

@WebServlet("/cart/*")
public class CartController extends HttpServlet {
    private ProductService productService;
    private Gson gson;
    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
        this.gson = new Gson();
        this.paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        // chỉ dùng khi sử dụng thanh toán
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        if (vnp_ResponseCode != null) {
            if (vnp_ResponseCode.equals("00")) {
                String transactionId = request.getParameter("vnp_TransactionNo");

                int orderId = Optional.ofNullable(request.getSession().getAttribute("orderId"))
                        .map(Object::toString)
                        .map(Integer::parseInt)
                        .orElse(0);
                if(orderId != 0){
                    // cập nhật lại payment của khách hàng
                    paymentService.updatePayment(orderId,transactionId);
                    request.setAttribute("vnp_TransactionStatus", true);
                    request.setAttribute("orderId", orderId);
                    request.setAttribute("transactionId",transactionId);
                }
            }

        }


        request.setAttribute("cart", cart);
        request.setAttribute("title", "Giỏ hàng");
        request.setAttribute("content", "cart.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            Map<String, Object> result = new HashMap<>();
            switch (action) {
                case "add" -> {
                    int productVariantId = Integer.parseInt(request.getParameter("variantId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    CartItemDTO product = productService.findProductForCartItem(productVariantId, productId);
                    if (product != null) {
                        cart.addItem(product, quantity);
                        result.put("success", true);
                        result.put("message", "Đã thêm vào giỏ hàng");
                        result.put("cartCount", cart.getItemCount());
                        result.put("total", cart.getTotal());
                    } else {
                        result.put("success", false);
                        result.put("message", "Không tìm thấy sản phẩm");
                    }
                }
                case "update" -> {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    double price = cart.updateQuantity(cartId, quantity);
                    result.put("success", true);
                    result.put("price", price);
                    result.put("cartCount", cart.getItemCount());
                    result.put("discount", cart.getDiscountTotal());
                    result.put("total", cart.getTotal());
                }

                case "change-variant" -> {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    int addonId = Integer.parseInt(request.getParameter("addonId"));
                    int colorId = Integer.parseInt(request.getParameter("colorId"));
                    CartItemDTO  cartItemDTO = productService.findProductWithVariantForCartItem(colorId, addonId, productId);
                    if(cartItemDTO != null){
                        CartItem cartItem  = cart.changeVariant(cartId,cartItemDTO);
                        result.put("success", true);
                        result.put("item", cartItem);
                        result.put("price", cartItem.getTotal());
                        result.put("discount", cart.getDiscountTotal());
                        result.put("total", cart.getTotal());
                        result.put("totalQuantity", cart.getItemCount());
                    }else {
                        result.put("success", false);
                        result.put("message", "Lỗi");
                    }

                }

                case "remove" -> {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    cart.removeItem(cartId);
                    result.put("success", true);
                    result.put("cartCount", cart.getItemCount());
                    result.put("discount", cart.getDiscountTotal());
                    result.put("total", cart.getTotal());
                }
                case null, default -> {
                    result.put("success", false);
                    result.put("message", "Invalid action");
                }
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            System.out.println(e.getMessage());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(error));
        }
    }
}

