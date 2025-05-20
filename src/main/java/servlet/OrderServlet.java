package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Delivery;
import model.MenuItem;
import model.Order;
import utils.FileUtils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;
import java.util.stream.Collectors;


public class OrderServlet extends HttpServlet {
    private static final String ORDER_FILE = "orders.txt";
    private static final String DELIVERY_FILE = "deliveries.txt";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final Logger LOGGER = Logger.getLogger(OrderServlet.class.getName());

    private static final List<String> VALID_DISTRICTS = Arrays.asList(
            "Colombo", "Gampaha", "Kalutara", "Kandy", "Matale", "Nuwara Eliya",
            "Galle", "Matara", "Hambantota", "Jaffna", "Kilinochchi", "Mannar",
            "Vavuniya", "Mullaitivu", "Batticaloa", "Ampara", "Trincomalee",
            "Kurunegala", "Puttalam", "Anuradhapura", "Polonnaruwa", "Badulla",
            "Moneragala", "Ratnapura", "Kegalle"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to OrderServlet (GET): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        switch (action != null ? action : "") {
            case "place":
                LOGGER.info("User " + userId + " accessed order placement page.");
                req.getRequestDispatcher("orderPlacement.jsp").forward(req, resp);
                break;

            case "track":
                String orderIdTrack = req.getParameter("orderId");
                LOGGER.info("User " + userId + " attempting to track order: " + orderIdTrack);
                if (orderIdTrack == null || orderIdTrack.trim().isEmpty()) {
                    LOGGER.warning("Invalid order tracking attempt by user " + userId + ": Missing orderId.");
                    resp.sendRedirect("order?action=summary");
                    return;
                }
                List<Order> ordersTrack = loadOrders();
                Order orderTrack = ordersTrack.stream()
                        .filter(o -> o.getOrderId().equals(orderIdTrack) && o.getUserId().equals(userId))
                        .findFirst()
                        .orElse(null);
                if (orderTrack == null) {
                    LOGGER.warning("Order tracking failed for user " + userId + ": Order " + orderIdTrack + " not found or does not belong to user.");
                    resp.sendRedirect("order?action=summary");
                    return;
                }
                List<Delivery> deliveries = loadDeliveries();
                Delivery delivery = deliveries.stream()
                        .filter(d -> d.getOrderId().equals(orderIdTrack))
                        .findFirst()
                        .orElse(null);
                req.setAttribute("orderId", orderIdTrack);
                req.setAttribute("delivery", delivery);
                LOGGER.info("Forwarding to orderTracking.jsp for order: " + orderIdTrack);
                req.getRequestDispatcher("orderTracking.jsp").forward(req, resp);
                break;

            case "history":
                LOGGER.info("User " + userId + " accessing order history.");
                List<Order> userOrders = loadOrders().stream()
                        .filter(o -> o.getUserId().equals(userId))
                        .collect(Collectors.toList());
                req.setAttribute("orders", userOrders);
                LOGGER.info("Loaded " + userOrders.size() + " orders for user " + userId + " in history action.");
                req.getRequestDispatcher("orderHistory.jsp").forward(req, resp);
                break;

            case "adminOrders":
                if (!"admin".equals(role)) {
                    LOGGER.warning("Unauthorized admin access attempt by user " + userId + " to view all orders.");
                    resp.sendRedirect("home.jsp");
                    return;
                }
                List<Order> allOrders = loadOrders();
                req.setAttribute("orders", allOrders);
                LOGGER.info("Loaded " + allOrders.size() + " orders for adminOrders action by admin " + userId);
                req.getRequestDispatcher("adminOrders.jsp").forward(req, resp);
                break;

            case "summary":
                String orderIdSummary = req.getParameter("orderId");
                List<Order> ordersSummary;

                if ("admin".equals(role) && orderIdSummary != null && !orderIdSummary.trim().isEmpty()) {
                    LOGGER.info("Admin " + userId + " accessing summary for specific order: " + orderIdSummary);
                    List<Order> allOrdersSummary = loadOrders();
                    LOGGER.info("Loaded " + allOrdersSummary.size() + " orders for summary action.");
                    if (allOrdersSummary.isEmpty()) {
                        LOGGER.warning("No orders found in orders.txt for summary action.");
                    } else {
                        String orderIds = allOrdersSummary.stream()
                                .map(Order::getOrderId)
                                .collect(Collectors.joining(", "));
                        LOGGER.info("Order IDs loaded: " + orderIds);
                    }

                    Order specificOrder = allOrdersSummary.stream()
                            .filter(o -> o.getOrderId().equals(orderIdSummary))
                            .findFirst()
                            .orElse(null);

                    if (specificOrder == null) {
                        LOGGER.warning("Order not found for summary by admin " + userId + ": " + orderIdSummary);
                        resp.sendRedirect("delivery?action=manage&error=" + java.net.URLEncoder.encode("Order not found.", "UTF-8"));
                        return;
                    }

                    ordersSummary = new ArrayList<>();
                    ordersSummary.add(specificOrder);
                    LOGGER.info("Order found: " + specificOrder.getOrderId() + ", added to orders list for admin summary.");
                } else {
                    LOGGER.info("User " + userId + " accessing their order summary.");
                    ordersSummary = loadOrders().stream()
                            .filter(o -> o.getUserId().equals(userId))
                            .collect(Collectors.toList());
                    LOGGER.info("Loaded " + ordersSummary.size() + " orders for user " + userId + " in summary action.");
                }

                req.setAttribute("orders", ordersSummary);
                LOGGER.info("Set orders attribute with list size: " + ordersSummary.size() + " for summary action.");
                req.getRequestDispatcher("orderSummary.jsp").forward(req, resp);
                break;

            default:
                LOGGER.info("Unknown action by user " + userId + ": " + action + ", redirecting to home.jsp.");
                resp.sendRedirect("home.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to OrderServlet (POST): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action") != null ? req.getParameter("action") : (String) req.getAttribute("action");
        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        LOGGER.info("Processing POST request for user " + userId + " with role: " + role + ", action: " + action);

        if ("create".equals(action)) {
            @SuppressWarnings("unchecked")
            Map<String, List<Map<String, Object>>> allCarts = (Map<String, List<Map<String, Object>>>) session.getAttribute("allCarts");
            if (allCarts == null) {
                LOGGER.warning("Order creation failed for user " + userId + ": Cart is not initialized.");
                req.setAttribute("error", "Cart is not initialized. Please add items to your cart.");
                req.getRequestDispatcher("cart.jsp").forward(req, resp);
                return;
            }

            List<Map<String, Object>> cart = allCarts.getOrDefault(userId, new ArrayList<>());
            if (cart.isEmpty()) {
                LOGGER.warning("Order creation failed for user " + userId + ": Cart is empty.");
                req.setAttribute("error", "Cart is empty. Please add items to your cart before placing an order.");
                req.getRequestDispatcher("cart.jsp").forward(req, resp);
                return;
            }

            String discountedTotalStr = req.getParameter("discountedTotal") != null ? req.getParameter("discountedTotal") : (String) req.getAttribute("discountedTotal");
            double total;
            try {
                if (discountedTotalStr == null || discountedTotalStr.trim().isEmpty()) {
                    throw new NumberFormatException("Discounted total is missing.");
                }
                total = Double.parseDouble(discountedTotalStr);
                if (total <= 0) {
                    throw new NumberFormatException("Discounted total must be greater than 0.");
                }
            } catch (NumberFormatException e) {
                total = calculateTotal(cart);
                LOGGER.warning("Invalid discounted total for user " + userId + ", recalculating: " + e.getMessage());
            }

            double deliveryCharge;
            try {
                String deliveryChargeStr = (String) req.getAttribute("deliveryCharge");
                if (deliveryChargeStr == null || deliveryChargeStr.trim().isEmpty()) {
                    throw new NumberFormatException("Delivery charge is missing.");
                }
                deliveryCharge = Double.parseDouble(deliveryChargeStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid delivery charge for user " + userId + ", setting to 0: " + e.getMessage());
                deliveryCharge = 0.0;
            }

            String finalTotalStr = req.getParameter("finalTotal") != null ? req.getParameter("finalTotal") : (String) req.getAttribute("finalTotal");
            double finalTotal;
            try {
                if (finalTotalStr == null || finalTotalStr.trim().isEmpty()) {
                    throw new NumberFormatException("Final total is missing.");
                }
                finalTotal = Double.parseDouble(finalTotalStr);
            } catch (NumberFormatException e) {
                finalTotal = total + deliveryCharge;
                LOGGER.warning("Invalid final total for user " + userId + ", recalculating: " + e.getMessage());
            }

            String deliveryAddress = req.getParameter("deliveryAddress") != null ? req.getParameter("deliveryAddress") : (String) req.getAttribute("deliveryAddress");
            String district = req.getParameter("district") != null ? req.getParameter("district") : (String) req.getAttribute("district");
            String phoneNumber = req.getParameter("phoneNumber") != null ? req.getParameter("phoneNumber") : (String) req.getAttribute("phoneNumber");
            String email = req.getParameter("email") != null ? req.getParameter("email") : (String) req.getAttribute("email");

            String paymentStatus = req.getParameter("paymentStatus") != null ? req.getParameter("paymentStatus") : (String) req.getAttribute("paymentStatus");
            String paymentMethod = req.getParameter("paymentMethod") != null ? req.getParameter("paymentMethod") : (String) req.getAttribute("paymentMethod");

            if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
                deliveryAddress = "Not provided";
            }
            if (district == null || district.trim().isEmpty()) {
                district = "Not provided";
            } else if (!VALID_DISTRICTS.contains(district)) {
                LOGGER.warning("Invalid district provided by user " + userId + ": " + district);
                district = "Not provided";
            }
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                phoneNumber = "Not provided";
            }
            if (email == null || email.trim().isEmpty()) {
                email = "Not provided";
            }

            if (paymentStatus == null || paymentStatus.trim().isEmpty()) {
                paymentStatus = "Unknown";
            }
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                paymentMethod = "Unknown";
            }

            session.setAttribute("deliveryAddress", deliveryAddress);
            session.setAttribute("district", district);
            session.setAttribute("phoneNumber", phoneNumber);
            session.setAttribute("email", email);

            String orderId = String.valueOf(System.currentTimeMillis());
            String timestamp = DATE_FORMAT.format(new Date());
            String status = "Pending";

            Order order = new Order(orderId, userId, cart, total, deliveryCharge, timestamp, status, deliveryAddress, district, phoneNumber, email, paymentStatus, paymentMethod);
            saveOrder(order);

            allCarts.put(userId, new ArrayList<>());
            session.setAttribute("allCarts", allCarts);

            LOGGER.info("Order created successfully for user " + userId + ": Order ID " + orderId);
            // Fixed typo in parameter name from "×tamp" to "timestamp"
            resp.sendRedirect("orderConfirmation.jsp?orderId=" + orderId + "&total=" + finalTotal + "&timestamp=" + java.net.URLEncoder.encode(timestamp, "UTF-8") + "&status=" + status);
        } else if ("update".equals(action)) {
            String orderId = req.getParameter("orderId");
            String status = req.getParameter("status");
            if (orderId == null || status == null || orderId.trim().isEmpty() || status.trim().isEmpty()) {
                LOGGER.warning("Invalid order status update attempt by user " + userId + ": Missing orderId or status.");
                if ("admin".equals(role)) {
                    resp.sendRedirect("order?action=track&orderId=" + orderId);
                } else {
                    resp.sendRedirect("delivery?action=driverDashboard&error=" + java.net.URLEncoder.encode("Missing order ID or status.", "UTF-8"));
                }
                return;
            }

            List<Order> orders = loadOrders();
            List<Delivery> deliveries = loadDeliveries();
            List<Delivery> originalDeliveries = new ArrayList<>(deliveries);

            boolean updated = false;
            Order targetOrder = null;
            for (Order order : orders) {
                if (order.getOrderId().equals(orderId)) {
                    targetOrder = order;
                    break;
                }
            }

            if (targetOrder == null) {
                LOGGER.warning("Order status update failed by user " + userId + ": Order ID " + orderId + " not found.");
                if ("admin".equals(role)) {
                    resp.sendRedirect("order?action=adminOrders&error=" + java.net.URLEncoder.encode("Order not found.", "UTF-8"));
                } else {
                    resp.sendRedirect("delivery?action=driverDashboard&error=" + java.net.URLEncoder.encode("Order not found.", "UTF-8"));
                }
                return;
            }

            // Authorization check
            if ("admin".equals(role)) {
                // Admins can update any order status
                String oldStatus = targetOrder.getStatus();
                targetOrder.setStatus(status);
                updated = true;

                if ("Out for Delivery".equals(status) && !"Out for Delivery".equals(oldStatus)) {
                    boolean deliveryExists = deliveries.stream().anyMatch(d -> d.getOrderId().equals(orderId));
                    if (!deliveryExists) {
                        String deliveryId = "DEL" + System.currentTimeMillis();
                        String driverId = "";
                        String deliveryStatus = "Pending Assignment";
                        String location = targetOrder.getDeliveryAddress() != null && !targetOrder.getDeliveryAddress().isEmpty() ? targetOrder.getDeliveryAddress() : "Not specified";
                        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                        Delivery delivery = new Delivery(deliveryId, orderId, driverId, deliveryStatus, location, timestamp);
                        deliveries.add(delivery);
                        LOGGER.info("Created new delivery entry: " + deliveryId + " for order: " + orderId + " with location: " + location);
                    } else {
                        LOGGER.info("Delivery entry already exists for order: " + orderId + ", skipping creation.");
                    }
                }
            } else if ("driver".equals(role) && "Delivered".equals(status)) {
                // Drivers can only update the status to "Delivered" for their assigned orders
                Delivery delivery = deliveries.stream()
                        .filter(d -> d.getOrderId().equals(orderId) && userId.equals(d.getDriverId()))
                        .findFirst()
                        .orElse(null);

                if (delivery == null) {
                    LOGGER.warning("Unauthorized order status update attempt by driver " + userId + ": Order " + orderId + " not assigned to this driver.");
                    resp.sendRedirect("delivery?action=driverDashboard&error=" + java.net.URLEncoder.encode("You are not authorized to update this order.", "UTF-8"));
                    return;
                }

                if (!"Out for Delivery".equals(targetOrder.getStatus())) {
                    LOGGER.warning("Order status update failed by driver " + userId + ": Order " + orderId + " is not in 'Out for Delivery' status.");
                    resp.sendRedirect("delivery?action=driverDashboard&error=" + java.net.URLEncoder.encode("Order must be in 'Out for Delivery' status to mark as Delivered.", "UTF-8"));
                    return;
                }

                targetOrder.setStatus(status);
                updated = true;

                // Update the delivery status to "Delivered" as well
                delivery.setStatus("Delivered");
            } else {
                LOGGER.warning("Unauthorized order status update attempt by user " + userId + " with role " + role);
                if ("admin".equals(role)) {
                    resp.sendRedirect("order?action=track&orderId=" + orderId);
                } else {
                    resp.sendRedirect("delivery?action=driverDashboard&error=" + java.net.URLEncoder.encode("Unauthorized access.", "UTF-8"));
                }
                return;
            }

            if (updated) {
                try {
                    FileUtils.rewriteFile(getServletContext(), ORDER_FILE, orders.stream().map(Order::toString).collect(Collectors.toList()));
                    FileUtils.rewriteFile(getServletContext(), DELIVERY_FILE, deliveries.stream().map(Delivery::toString).collect(Collectors.toList()));
                    LOGGER.info("Order status updated by user " + userId + " (role: " + role + "): Order ID " + orderId + ", New Status: " + status);
                    if ("admin".equals(role)) {
                        LOGGER.info("Redirecting admin to order?action=adminOrders");
                        resp.sendRedirect("order?action=adminOrders&success=" + java.net.URLEncoder.encode("Order status updated successfully.", "UTF-8"));
                    } else if ("driver".equals(role)) {
                        LOGGER.info("Redirecting driver to delivery?action=driverDashboard");
                        resp.sendRedirect("delivery?action=driverDashboard&success=" + java.net.URLEncoder.encode("Order marked as Delivered successfully.", "UTF-8"));
                    } else {
                        LOGGER.warning("Unexpected role for user " + userId + ": " + role + ", redirecting to home.jsp");
                        resp.sendRedirect("home.jsp");
                    }
                } catch (IOException e) {
                    try {
                        FileUtils.rewriteFile(getServletContext(), DELIVERY_FILE, originalDeliveries.stream().map(Delivery::toString).collect(Collectors.toList()));
                        LOGGER.severe("Error updating files, rolled back deliveries.txt: " + e.getMessage());
                    } catch (IOException rollbackEx) {
                        LOGGER.severe("Rollback failed for deliveries.txt: " + rollbackEx.getMessage());
                    }
                    LOGGER.severe("Error updating order status: " + e.getMessage());
                    if ("admin".equals(role)) {
                        LOGGER.info("Redirecting admin to order?action=adminOrders with error");
                        resp.sendRedirect("order?action=adminOrders&error=" + java.net.URLEncoder.encode("Error updating order status: " + e.getMessage(), "UTF-8"));
                    } else {
                        LOGGER.info("Redirecting driver to delivery?action=driverDashboard with error");
                        resp.sendRedirect("delivery?action=driverDashboard&error=" + java.net.URLEncoder.encode("Error updating order status: " + e.getMessage(), "UTF-8"));
                    }
                }
            } else {
                LOGGER.warning("Order status update failed by user " + userId + ": Order ID " + orderId + " not found.");
                if ("admin".equals(role)) {
                    LOGGER.info("Redirecting admin to order?action=adminOrders with error");
                    resp.sendRedirect("order?action=adminOrders&error=" + java.net.URLEncoder.encode("Order not found.", "UTF-8"));
                } else {
                    LOGGER.info("Redirecting driver to delivery?action=driverDashboard with error");
                    resp.sendRedirect("delivery?action=driverDashboard&error=" + java.net.URLEncoder.encode("Order not found.", "UTF-8"));
                }
            }
        } else if ("delete".equals(action)) {
            String orderId = req.getParameter("orderId");
            if (orderId == null || orderId.trim().isEmpty()) {
                LOGGER.warning("Invalid order deletion attempt by user " + userId + ": Missing orderId.");
                resp.sendRedirect("order?action=summary&error=" + java.net.URLEncoder.encode("Missing order ID.", "UTF-8"));
                return;
            }

            List<Order> orders = loadOrders();
            Order orderToDelete = orders.stream()
                    .filter(order -> order.getOrderId().equals(orderId))
                    .findFirst()
                    .orElse(null);

            if (orderToDelete == null) {
                LOGGER.warning("Order deletion failed for user " + userId + ": Order ID " + orderId + " not found.");
                resp.sendRedirect("order?action=summary&error=" + java.net.URLEncoder.encode("Order not found.", "UTF-8"));
                return;
            }

            if (!orderToDelete.getUserId().equals(userId)) {
                LOGGER.warning("Unauthorized order deletion attempt by user " + userId + " for Order ID " + orderId);
                resp.sendRedirect("order?action=summary&error=" + java.net.URLEncoder.encode("Unauthorized access.", "UTF-8"));
                return;
            }

            if (!"Pending".equals(orderToDelete.getStatus())) {
                LOGGER.warning("Order deletion failed for user " + userId + ": Order ID " + orderId + " is not in Pending status.");
                resp.sendRedirect("order?action=summary&error=" + java.net.URLEncoder.encode("Order must be in Pending status to delete.", "UTF-8"));
                return;
            }

            orders.removeIf(order -> order.getOrderId().equals(orderId));
            FileUtils.rewriteFile(getServletContext(), ORDER_FILE, orders.stream().map(Order::toString).collect(Collectors.toList()));
            LOGGER.info("Order deleted by user " + userId + ": Order ID " + orderId);
            resp.sendRedirect("order?action=summary&success=" + java.net.URLEncoder.encode("Order deleted successfully.", "UTF-8"));
        } else {
            LOGGER.info("Unknown POST action by user " + userId + ": " + action + ", redirecting to home.jsp.");
            resp.sendRedirect("home.jsp");
        }
    }

    private double calculateTotal(List<Map<String, Object>> cart) {
        List<MenuItem> allMenuItems = new ArrayList<>();
        try {
            List<String> menuData = FileUtils.readFromFile(getServletContext(), "menu.txt");
            for (String line : menuData) {
                try {
                    allMenuItems.add(MenuItem.fromString(line));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing menu item: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading menu.txt: " + e.getMessage());
        }

        double total = 0;
        for (Map<String, Object> cartItem : cart) {
            String itemId = (String) cartItem.get("itemId");
            String restaurantId = (String) cartItem.get("restaurantId");
            int quantity = (int) cartItem.get("quantity");

            MenuItem menuItem = allMenuItems.stream()
                    .filter(item -> item.getId().equals(itemId) && item.getRestaurantId().equals(restaurantId))
                    .findFirst()
                    .orElse(null);
            if (menuItem != null) {
                total += menuItem.getPrice() * quantity;
            } else {
                LOGGER.warning("Menu item not found for itemId: " + itemId + ", restaurantId: " + restaurantId);
            }
        }
        return total;
    }

    private void saveOrder(Order order) {
        List<Order> orders = loadOrders();
        orders.add(order);
        try {
            FileUtils.rewriteFile(getServletContext(), ORDER_FILE, orders.stream().map(Order::toString).collect(Collectors.toList()));
        } catch (IOException e) {
            LOGGER.severe("Error saving order: " + e.getMessage());
            throw new RuntimeException("Failed to save order: " + e.getMessage());
        }
    }

    private List<Order> loadOrders() {
        Set<Order> uniqueOrders = new HashSet<>();
        try {
            List<String> orderData = FileUtils.readFromFile(getServletContext(), ORDER_FILE);
            LOGGER.info("Read " + orderData.size() + " lines from orders.txt");
            for (int i = 0; i < orderData.size(); i++) {
                String line = orderData.get(i);
                LOGGER.info("Processing order line " + (i + 1) + ": " + line);
                try {
                    Order order = Order.fromString(line);
                    uniqueOrders.add(order);
                    LOGGER.info("Successfully parsed order: " + order.getOrderId());
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing order: " + line + " - " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading orders.txt: " + e.getMessage());
        }
        return new ArrayList<>(uniqueOrders);
    }

    private List<Delivery> loadDeliveries() {
        Set<Delivery> uniqueDeliveries = new HashSet<>();
        try {
            List<String> deliveryData = FileUtils.readFromFile(getServletContext(), DELIVERY_FILE);
            LOGGER.info("Read " + deliveryData.size() + " lines from deliveries.txt");
            for (String line : deliveryData) {
                try {
                    uniqueDeliveries.add(Delivery.fromString(line));
                    LOGGER.info("Successfully parsed delivery: " + line);
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing delivery: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading deliveries.txt: " + e.getMessage());
        }
        return new ArrayList<>(uniqueDeliveries);
    }
}