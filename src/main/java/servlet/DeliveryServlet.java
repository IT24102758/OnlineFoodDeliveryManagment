package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Delivery;
import model.Order;
import model.Restaurant;
import utils.FileUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.stream.Collectors;


public class DeliveryServlet extends HttpServlet {
    private static final String DELIVERY_FILE = "deliveries.txt";
    private static final String ORDER_FILE = "orders.txt";
    private static final String USER_FILE = "users.txt";
    private static final String RESTAURANT_FILE = "restaurants.txt";
    private static final Logger LOGGER = Logger.getLogger(DeliveryServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to DeliveryServlet (GET): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "manage":
                if (!"admin".equals(role)) {
                    LOGGER.warning("Unauthorized access attempt to DeliveryServlet (GET): User is not an admin. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                // Load and process orders
                List<Order> allOrders = loadOrders();
                LOGGER.info("Loaded " + allOrders.size() + " orders from orders.txt");
                for (Order order : allOrders) {
                    LOGGER.info("Order ID: " + order.getOrderId() + ", Status: '" + order.getStatus() + "', User ID: " + order.getUserId());
                }

                List<Order> pendingOrders = allOrders.stream()
                        .filter(order -> {
                            String status = order.getStatus() != null ? order.getStatus().trim() : "";
                            boolean matches = "Out for Delivery".equalsIgnoreCase(status);
                            LOGGER.info("Filtering order " + order.getOrderId() + ": Status='" + status + "', Matches=" + matches);
                            return matches;
                        })
                        .collect(Collectors.toList());
                LOGGER.info("Found " + pendingOrders.size() + " orders with status 'Out for Delivery'");

                List<String> pendingOrderIds = pendingOrders.stream()
                        .map(Order::getOrderId)
                        .collect(Collectors.toList());
                LOGGER.info("Pending Order IDs: " + pendingOrderIds);

                // Load and process deliveries
                List<Delivery> deliveries = loadDeliveries();
                LOGGER.info("Loaded " + deliveries.size() + " deliveries from deliveries.txt");
                for (Delivery delivery : deliveries) {
                    LOGGER.info("Delivery ID: " + delivery.getDeliveryId() + ", Order ID: " + delivery.getOrderId() + ", Status: " + delivery.getStatus());
                }

                List<String> deliveryOrderIds = deliveries.stream()
                        .map(Delivery::getOrderId)
                        .collect(Collectors.toList());
                LOGGER.info("Delivery Order IDs: " + deliveryOrderIds);

                // Load drivers and restaurant names
                Map<String, String> drivers = loadDrivers();
                LOGGER.info("Loaded " + drivers.size() + " drivers from users.txt");
                Map<String, String> restaurantNames = loadRestaurantNames();
                LOGGER.info("Loaded " + restaurantNames.size() + " restaurants from restaurants.txt");

                // Set request attributes
                req.setAttribute("pendingOrders", pendingOrders);
                req.setAttribute("pendingOrderIds", pendingOrderIds);
                req.setAttribute("deliveries", deliveries);
                req.setAttribute("deliveryOrderIds", deliveryOrderIds);
                req.setAttribute("drivers", drivers);
                req.setAttribute("restaurantNames", restaurantNames);

                req.getRequestDispatcher("deliveryManagement.jsp").forward(req, resp);
                break;

            case "driverDashboard":
                if (!"driver".equals(role)) {
                    LOGGER.warning("Unauthorized access attempt to driverDashboard: User is not a driver. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                String driverId = (String) session.getAttribute("userId");
                LOGGER.info("Loading driver dashboard for driver ID: " + driverId);

                // Load deliveries assigned to this driver
                List<Delivery> allDeliveries = loadDeliveries();
                List<Delivery> assignedDeliveries = allDeliveries.stream()
                        .filter(delivery -> driverId.equals(delivery.getDriverId()))
                        .collect(Collectors.toList());
                LOGGER.info("Found " + assignedDeliveries.size() + " deliveries assigned to driver ID: " + driverId);

                // Load orders corresponding to these deliveries
                List<Order> driverOrders = new ArrayList<>();
                List<Order> orders = loadOrders();
                for (Delivery delivery : assignedDeliveries) {
                    orders.stream()
                            .filter(order -> order.getOrderId().equals(delivery.getOrderId()))
                            .findFirst()
                            .ifPresent(driverOrders::add);
                }
                LOGGER.info("Found " + driverOrders.size() + " orders for driver ID: " + driverId);

                // Load restaurant names for the orders
                Map<String, String> driverRestaurantNames = loadRestaurantNames();

                // Pass success or error messages from the redirect
                String successMessage = req.getParameter("success");
                String errorMessage = req.getParameter("error");
                if (successMessage != null && !successMessage.isEmpty()) {
                    req.setAttribute("success", successMessage);
                }
                if (errorMessage != null && !errorMessage.isEmpty()) {
                    req.setAttribute("error", errorMessage);
                }

                // Set request attributes
                req.setAttribute("assignedDeliveries", assignedDeliveries);
                req.setAttribute("driverOrders", driverOrders);
                req.setAttribute("restaurantNames", driverRestaurantNames);

                LOGGER.info("Forwarding to driverDashboard.jsp for driver ID: " + driverId);
                req.getRequestDispatcher("driverDashboard.jsp").forward(req, resp);
                break;

            default:
                LOGGER.info("Unknown action in DeliveryServlet for user with role " + role + ": " + action + ", redirecting to dashboard.jsp");
                resp.sendRedirect("dashboard.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to DeliveryServlet (POST): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            LOGGER.warning("Unauthorized access attempt to DeliveryServlet (POST): User is not an admin.");
            resp.sendRedirect("home.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                String orderId = req.getParameter("orderId");
                String driverId = req.getParameter("driverId");
                if (orderId == null || driverId == null || orderId.trim().isEmpty() || driverId.trim().isEmpty()) {
                    LOGGER.warning("Invalid delivery creation attempt: Missing orderId or driverId.");
                    resp.sendRedirect("delivery?action=manage&error=" + java.net.URLEncoder.encode("Missing order ID or driver ID.", "UTF-8"));
                    return;
                }

                List<Delivery> deliveries = loadDeliveries();
                Delivery existingDelivery = deliveries.stream()
                        .filter(d -> d.getOrderId().equals(orderId))
                        .findFirst()
                        .orElse(null);

                if (existingDelivery == null) {
                    LOGGER.warning("No delivery entry found for order: " + orderId);
                    resp.sendRedirect("delivery?action=manage&error=" + java.net.URLEncoder.encode("No delivery entry found for the specified order.", "UTF-8"));
                    return;
                }

                existingDelivery.setDriverId(driverId);
                existingDelivery.setStatus("Assigned");

                try {
                    FileUtils.rewriteFile(getServletContext(), DELIVERY_FILE, deliveries.stream().map(Delivery::toString).collect(Collectors.toList()));
                    LOGGER.info("Assigned driver " + driverId + " to delivery for order: " + orderId);
                    resp.sendRedirect("delivery?action=manage&success=" + java.net.URLEncoder.encode("Driver assigned successfully.", "UTF-8"));
                } catch (IOException e) {
                    LOGGER.severe("Error updating deliveries.txt: " + e.getMessage());
                    resp.sendRedirect("delivery?action=manage&error=" + java.net.URLEncoder.encode("Error assigning driver: " + e.getMessage(), "UTF-8"));
                }
                break;

            case "delete":
                String deliveryId = req.getParameter("deliveryId");
                if (deliveryId == null || deliveryId.trim().isEmpty()) {
                    LOGGER.warning("Invalid delivery deletion attempt: Missing deliveryId.");
                    resp.sendRedirect("delivery?action=manage&error=" + java.net.URLEncoder.encode("Missing delivery ID.", "UTF-8"));
                    return;
                }

                deliveries = loadDeliveries();
                boolean removed = deliveries.removeIf(d -> d.getDeliveryId().equals(deliveryId));
                if (removed) {
                    try {
                        FileUtils.rewriteFile(getServletContext(), DELIVERY_FILE, deliveries.stream().map(Delivery::toString).collect(Collectors.toList()));
                        LOGGER.info("Deleted delivery: " + deliveryId);
                        resp.sendRedirect("delivery?action=manage&success=" + java.net.URLEncoder.encode("Delivery deleted successfully.", "UTF-8"));
                    } catch (IOException e) {
                        LOGGER.severe("Error deleting delivery from deliveries.txt: " + e.getMessage());
                        resp.sendRedirect("delivery?action=manage&error=" + java.net.URLEncoder.encode("Error deleting delivery: " + e.getMessage(), "UTF-8"));
                    }
                } else {
                    LOGGER.warning("Delivery not found for deletion: " + deliveryId);
                    resp.sendRedirect("delivery?action=manage&error=" + java.net.URLEncoder.encode("Delivery not found.", "UTF-8"));
                }
                break;

            default:
                LOGGER.info("Unknown POST action in DeliveryServlet for user with role " + role + ": " + action + ", redirecting to dashboard.jsp");
                resp.sendRedirect("dashboard.jsp");
                break;
        }
    }

    private List<Order> loadOrders() {
        List<Order> orders = new ArrayList<>();
        try {
            List<String> orderData = FileUtils.readFromFile(getServletContext(), ORDER_FILE);
            LOGGER.info("Read " + orderData.size() + " lines from orders.txt");
            for (int i = 0; i < orderData.size(); i++) {
                String line = orderData.get(i);
                LOGGER.info("Processing order line " + (i + 1) + ": " + line);
                try {
                    Order order = Order.fromString(line);
                    orders.add(order);
                    LOGGER.info("Successfully parsed order: " + order.getOrderId());
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing order: " + line + " - " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading orders.txt: " + e.getMessage());
        }
        return orders;
    }

    private List<Delivery> loadDeliveries() {
        List<Delivery> deliveries = new ArrayList<>();
        try {
            List<String> deliveryData = FileUtils.readFromFile(getServletContext(), DELIVERY_FILE);
            LOGGER.info("Read " + deliveryData.size() + " lines from deliveries.txt");
            for (int i = 0; i < deliveryData.size(); i++) {
                String line = deliveryData.get(i);
                LOGGER.info("Processing delivery line " + (i + 1) + ": " + line);
                try {
                    Delivery delivery = Delivery.fromString(line);
                    deliveries.add(delivery);
                    LOGGER.info("Successfully parsed delivery: " + delivery.getDeliveryId());
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing delivery: " + line + " - " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading deliveries.txt: " + e.getMessage());
        }
        return deliveries;
    }

    private Map<String, String> loadDrivers() {
        Map<String, String> drivers = new HashMap<>();
        try {
            List<String> userData = FileUtils.readFromFile(getServletContext(), USER_FILE);
            for (String line : userData) {
                try {
                    String[] parts = line.split(",");
                    if (parts.length != 8) {
                        throw new IllegalArgumentException("Invalid user format: " + line);
                    }
                    String id = parts[0];
                    String name = parts[1];
                    String type = parts[6];
                    if ("driver".equals(type)) {
                        drivers.put(id, name);
                    }
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing user: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading users.txt: " + e.getMessage());
        }
        return drivers;
    }

    private Map<String, String> loadRestaurantNames() {
        Map<String, String> restaurantNames = new HashMap<>();
        try {
            List<String> restaurantData = FileUtils.readFromFile(getServletContext(), RESTAURANT_FILE);
            for (String line : restaurantData) {
                try {
                    Restaurant restaurant = Restaurant.fromString(line);
                    restaurantNames.put(restaurant.getId(), restaurant.getName());
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing restaurant: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading restaurants.txt: " + e.getMessage());
        }
        return restaurantNames;
    }
}