package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MenuItem;
import utils.FileUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"status\": \"error\", \"message\": \"Please log in to add items to cart.\"}");
            return;
        }

        String action = req.getParameter("action");
        String userId = (String) session.getAttribute("userId");

        // Retrieve or initialize the carts map from session
        @SuppressWarnings("unchecked")
        Map<String, List<Map<String, Object>>> allCarts = (Map<String, List<Map<String, Object>>>) session.getAttribute("allCarts");
        if (allCarts == null) {
            allCarts = new HashMap<>();
            session.setAttribute("allCarts", allCarts);
        }

        // Get the cart for the current user
        List<Map<String, Object>> cart = allCarts.computeIfAbsent(userId, k -> new ArrayList<>());

        resp.setContentType("application/json");
        try {
            if ("add".equals(action)) {
                String itemId = req.getParameter("itemId");
                String restaurantId = req.getParameter("restaurantId");
                int quantity = parseQuantity(req.getParameter("quantity"));

                if (itemId == null || restaurantId == null || quantity <= 0) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid item details.\"}");
                    return;
                }

                // Validate item against menu (optional but recommended)
                if (!isValidMenuItem(itemId, restaurantId)) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid item or restaurant.\"}");
                    return;
                }

                // Check if item already exists in cart
                boolean itemExists = false;
                for (Map<String, Object> cartItem : cart) {
                    if (cartItem.get("itemId").equals(itemId) && cartItem.get("restaurantId").equals(restaurantId)) {
                        int currentQuantity = (int) cartItem.get("quantity");
                        cartItem.put("quantity", currentQuantity + quantity);
                        itemExists = true;
                        break;
                    }
                }

                // If item doesn't exist, add new entry
                if (!itemExists) {
                    Map<String, Object> cartItem = new HashMap<>();
                    cartItem.put("itemId", itemId);
                    cartItem.put("restaurantId", restaurantId);
                    cartItem.put("quantity", quantity);
                    cart.add(cartItem);
                }

                allCarts.put(userId, cart);
                session.setAttribute("allCarts", allCarts);
                resp.getWriter().write("{\"status\": \"success\", \"message\": \"Item added to cart\", \"count\": " + getTotalQuantity(cart) + "}");
            } else if ("update".equals(action)) {
                String itemId = req.getParameter("itemId");
                String restaurantId = req.getParameter("restaurantId");
                int quantity = parseQuantity(req.getParameter("quantity"));

                if (itemId == null || restaurantId == null || quantity < 0) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid item details.\"}");
                    return;
                }

                for (Map<String, Object> cartItem : cart) {
                    if (cartItem.get("itemId").equals(itemId) && cartItem.get("restaurantId").equals(restaurantId)) {
                        if (quantity > 0) {
                            cartItem.put("quantity", quantity);
                        } else {
                            cart.remove(cartItem);
                            break;
                        }
                    }
                }
                allCarts.put(userId, cart);
                session.setAttribute("allCarts", allCarts);
                resp.getWriter().write("{\"status\": \"success\", \"count\": " + getTotalQuantity(cart) + "}");
            } else if ("remove".equals(action)) {
                String itemId = req.getParameter("itemId");
                String restaurantId = req.getParameter("restaurantId");

                if (itemId == null || restaurantId == null) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid item details.\"}");
                    return;
                }

                cart.removeIf(item -> item.get("itemId").equals(itemId) && item.get("restaurantId").equals(restaurantId));
                allCarts.put(userId, cart);
                session.setAttribute("allCarts", allCarts);
                resp.getWriter().write("{\"status\": \"success\", \"count\": " + getTotalQuantity(cart) + "}");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid action.\"}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\": \"error\", \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"count\": 0}");
            return;
        }

        String action = req.getParameter("action");
        String userId = (String) session.getAttribute("userId");
        @SuppressWarnings("unchecked")
        Map<String, List<Map<String, Object>>> allCarts = (Map<String, List<Map<String, Object>>>) session.getAttribute("allCarts");
        if (allCarts == null) {
            allCarts = new HashMap<>();
            session.setAttribute("allCarts", allCarts);
        }
        List<Map<String, Object>> cart = allCarts.getOrDefault(userId, new ArrayList<>());
        allCarts.put(userId, cart);
        session.setAttribute("allCarts", allCarts);

        resp.setContentType("application/json");
        try {
            if ("getCount".equals(action)) {
                int count = getTotalQuantity(cart);
                resp.getWriter().write("{\"count\": " + count + "}");
            } else if ("getCart".equals(action)) {
                // Return full cart contents (optional enhancement)
                resp.getWriter().write("{\"status\": \"success\", \"cart\": " + mapToJson(cart) + ", \"count\": " + getTotalQuantity(cart) + "}");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid action.\"}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\": \"error\", \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }

    // Helper method to parse quantity with error handling
    private int parseQuantity(String quantityStr) {
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            return 0;
        }
        try {
            int quantity = Integer.parseInt(quantityStr);
            return Math.max(0, quantity); // Ensure non-negative quantity
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    // Helper method to validate menu item (basic implementation)
    private boolean isValidMenuItem(String itemId, String restaurantId) {
        try {
            List<MenuItem> menuItems = new ArrayList<>();
            List<String> menuData = FileUtils.readFromFile(getServletContext(), "menu.txt");
            for (String line : menuData) {
                menuItems.add(MenuItem.fromString(line));
            }
            return menuItems.stream().anyMatch(item ->
                    item.getId().equals(itemId) && item.getRestaurantId().equals(restaurantId));
        } catch (IOException e) {
            System.err.println("Error validating menu item: " + e.getMessage());
            return false;
        }
    }

    // Helper method to convert cart to JSON (simple implementation)
    private String mapToJson(List<Map<String, Object>> cart) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < cart.size(); i++) {
            Map<String, Object> item = cart.get(i);
            json.append("{\"itemId\":\"").append(item.get("itemId"))
                    .append("\",\"restaurantId\":\"").append(item.get("restaurantId"))
                    .append("\",\"quantity\":").append(item.get("quantity"))
                    .append("}");
            if (i < cart.size() - 1) json.append(",");
        }
        json.append("]");
        return json.toString();
    }

    // Helper method to calculate total quantity
    private int getTotalQuantity(List<Map<String, Object>> cart) {
        return cart.stream().mapToInt(item -> (int) item.get("quantity")).sum();
    }
}