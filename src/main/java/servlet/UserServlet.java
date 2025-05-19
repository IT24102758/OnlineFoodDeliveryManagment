package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.RegularCustomer;
import model.PremiumCustomer;
import model.Order;
import model.Restaurant;
import utils.FileUtils;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class UserServlet extends HttpServlet {
    private static final String FILE_NAME = "users.txt";
    private static final String ORDER_FILE = "orders.txt";
    private static final String RESTAURANT_FILE = "restaurants.txt";
    private static final Logger LOGGER = Logger.getLogger(UserServlet.class.getName());

//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String action = req.getParameter("action");
//        if ("create".equals(action)) {
//            String id = req.getParameter("id");
//            String name = req.getParameter("name");
//            String email = req.getParameter("email");
//            String password = req.getParameter("password");
//            String address = req.getParameter("address");
//            String phone = req.getParameter("phone");
//            String type = req.getParameter("type");
//
//            if (id == null || name == null || email == null || password == null || address == null || phone == null || type == null ||
//                    id.trim().isEmpty() || name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() ||
//                    address.trim().isEmpty() || phone.trim().isEmpty() || type.trim().isEmpty()) {
//                LOGGER.warning("User creation failed: Missing or empty fields.");
//                resp.sendRedirect("register.jsp?error=" + java.net.URLEncoder.encode("All fields are required.", "UTF-8"));
//                return;
//            }
//
//            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
//            for (String user : users) {
//                String[] parts = user.split(",");
//                if (parts[0].equals(id)) {
//                    LOGGER.warning("User creation failed: Duplicate ID=" + id);
//                    resp.sendRedirect("register.jsp?error=" + java.net.URLEncoder.encode("User ID already exists.", "UTF-8"));
//                    return;
//                }
//            }
//
//            User user;
//            if ("Premium".equals(type)) {
//                user = new PremiumCustomer(id, name, email, password, address, phone);
//            } else if ("Admin".equals(type)) {
//                user = new PremiumCustomer(id, name, email, password, address, phone);
//                user.setType("Admin");
//            } else if ("Restaurant".equals(type)) {
//                user = new RestaurantOwner(id, name, email, password, address, phone);
//            } else if ("driver".equals(type)) {
//                user = new RegularCustomer(id, name, email, password, address, phone);
//                user.setType("driver");
//            } else {
//                user = new RegularCustomer(id, name, email, password, address, phone);
//            }
//
//            LOGGER.info("Creating user: ID=" + id + ", Type=" + type);
//            FileUtils.writeToFile(getServletContext(), FILE_NAME, user.toString());
//            resp.sendRedirect("login.jsp?success=" + java.net.URLEncoder.encode("Registration successful. Please log in.", "UTF-8"));
//        } else if ("update".equals(action)) {
//            String id = req.getParameter("id");
//            String name = req.getParameter("name");
//            String email = req.getParameter("email");
//            String password = req.getParameter("password");
//            String address = req.getParameter("address");
//            String phone = req.getParameter("phone");
//            String type = req.getParameter("type");
//
//            if ("1".equals(id) && (type == null || type.trim().isEmpty())) {
//                type = "Admin";
//            }
//
//            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
//            List<String> updatedUsers = new ArrayList<>();
//            boolean updated = false;
//            for (String user : users) {
//                String[] parts = user.split(",");
//                if (parts[0].equals(id)) {
//                    User updatedUser;
//                    if ("Premium".equals(type)) {
//                        updatedUser = new PremiumCustomer(id, name, email, password, address, phone);
//                    } else if ("Restaurant".equals(type)) {
//                        updatedUser = new RestaurantOwner(id, name, email, password, address, phone);
//                    } else if ("Admin".equals(type)) {
//                        updatedUser = new PremiumCustomer(id, name, email, password, address, phone);
//                        updatedUser.setType("Admin");
//                    } else if ("driver".equals(type)) {
//                        updatedUser = new RegularCustomer(id, name, email, password, address, phone);
//                        updatedUser.setType("driver");
//                    } else {
//                        updatedUser = new RegularCustomer(id, name, email, password, address, phone);
//                    }
//                    updatedUsers.add(updatedUser.toString());
//                    updated = true;
//                    LOGGER.info("Updated user: ID=" + id + ", Type=" + type);
//                } else {
//                    updatedUsers.add(user);
//                }
//            }
//            if (updated) {
//                rewriteFile(updatedUsers);
//                resp.sendRedirect("userlist.jsp?success=" + java.net.URLEncoder.encode("User updated successfully.", "UTF-8"));
//            } else {
//                LOGGER.warning("User update failed: ID=" + id + " not found.");
//                resp.sendRedirect("userlist.jsp?error=" + java.net.URLEncoder.encode("User not found.", "UTF-8"));
//            }
//        } else if ("login".equals(action)) {
//            String email = req.getParameter("email");
//            String password = req.getParameter("password");
//            LOGGER.info("Login attempt: email=" + email + ", password=" + password);
//
//            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
//                LOGGER.warning("Invalid login attempt: email or password is empty");
//                resp.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("Email and password are required.", "UTF-8"));
//                return;
//            }
//
//            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
//            boolean authenticated = false;
//            String userId = null;
//            String role = "regular";
//
//            for (String user : users) {
//                LOGGER.fine("Checking user: " + user);
//                String[] parts = user.split(",");
//                if (parts.length == 8 && parts[2].equals(email.trim()) && parts[3].equals(password.trim())) {
//                    authenticated = true;
//                    userId = parts[0];
//                    String userType = parts[6].trim();
//                    LOGGER.info("User found: ID=" + userId + ", Type=" + userType);
//                    if ("Admin".equals(userType)) {
//                        role = "admin";
//                    } else if ("Restaurant".equals(userType)) {
//                        role = "restaurant";
//                    } else if ("driver".equals(userType)) {
//                        role = "driver";
//                    } else if ("Premium".equals(userType)) {
//                        role = "premium";
//                    } else {
//                        role = "regular";
//                    }
//                    LOGGER.info("Assigned role: " + role);
//                    break;
//                }
//            }
//
//            if (authenticated) {
//                HttpSession session = req.getSession();
//                session.setAttribute("userId", userId);
//                session.setAttribute("role", role);
//                LOGGER.info("Authenticated: userId=" + userId + ", role=" + role + ", redirecting...");
//                if ("admin".equals(role)) {
//                    // Load data for admin dashboard
//                    List<Order> orders = loadOrders();
//                    List<Order> pendingOrders = orders.stream()
//                            .filter(order -> "Out for Delivery".equals(order.getStatus()))
//                            .collect(Collectors.toList());
//                    List<String> drivers = loadDrivers();
//                    Map<String, String> restaurantNames = loadRestaurantNames();
//                    req.setAttribute("pendingOrders", pendingOrders);
//                    req.setAttribute("drivers", drivers);
//                    req.setAttribute("restaurantNames", restaurantNames);
//                    req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
//                } else if ("driver".equals(role)) {
//                    resp.sendRedirect("delivery?action=driverDashboard");
//                } else {
//                    resp.sendRedirect("home.jsp");
//                }
//            } else {
//                LOGGER.warning("Authentication failed for email=" + email);
//                resp.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("Invalid credentials", "UTF-8"));
//            }
//        }
//    }
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String action = req.getParameter("action");
    if ("create".equals(action)) {
        // Read existing users to determine the next ID
        List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
        int newId = 1; // Default ID if no users exist

        if (users != null && !users.isEmpty()) {
            // Find the highest ID
            int maxId = 0;
            for (String user : users) {
                String[] parts = user.split(",");
                if (parts.length > 0) {
                    try {
                        int currentId = Integer.parseInt(parts[0]);
                        if (currentId > maxId) {
                            maxId = currentId;
                        }
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid ID format in users.txt: " + parts[0]);
                        continue;
                    }
                }
            }
            newId = maxId + 1; // Increment the highest ID
        }

        // Get form parameters (excluding id, as it's auto-generated)
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");
        String type = req.getParameter("type");

        // Validate input (excluding id)
        if (name == null || email == null || password == null || address == null || phone == null || type == null ||
                name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() ||
                address.trim().isEmpty() || phone.trim().isEmpty() || type.trim().isEmpty()) {
            LOGGER.warning("User creation failed: Missing or empty fields.");
            resp.sendRedirect("register.jsp?error=" + java.net.URLEncoder.encode("All fields are required.", "UTF-8"));
            return;
        }

        // Check for duplicate email
        if (users != null) {
            for (String user : users) {
                String[] parts = user.split(",");
                if (parts.length >= 3 && parts[2].equals(email.trim())) {
                    LOGGER.warning("User creation failed: Duplicate email=" + email);
                    resp.sendRedirect("register.jsp?error=" + java.net.URLEncoder.encode("Email already exists.", "UTF-8"));
                    return;
                }
            }
        }

        // Create user with auto-generated ID
        User user;
        if ("Premium".equals(type)) {
            user = new PremiumCustomer(String.valueOf(newId), name, email, password, address, phone);
        } else if ("Admin".equals(type)) {
            user = new PremiumCustomer(String.valueOf(newId), name, email, password, address, phone);
            user.setType("Admin");

        } else if ("driver".equals(type)) {
            user = new RegularCustomer(String.valueOf(newId), name, email, password, address, phone);
            user.setType("driver");
        } else {
            user = new RegularCustomer(String.valueOf(newId), name, email, password, address, phone);
        }

        LOGGER.info("Creating user: ID=" + newId + ", Type=" + type);
        FileUtils.writeToFile(getServletContext(), FILE_NAME, user.toString());
        resp.sendRedirect("login.jsp?success=" + java.net.URLEncoder.encode("Registration successful. Please log in.", "UTF-8"));
    } else if ("update".equals(action)) {
        String id = req.getParameter("id");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");
        String type = req.getParameter("type");

        if ("1".equals(id) && (type == null || type.trim().isEmpty())) {
            type = "Admin";
        }

        List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
        List<String> updatedUsers = new ArrayList<>();
        boolean updated = false;
        for (String user : users) {
            String[] parts = user.split(",");
            if (parts[0].equals(id)) {
                User updatedUser;
                if ("Premium".equals(type)) {
                    updatedUser = new PremiumCustomer(id, name, email, password, address, phone);

                } else if ("Admin".equals(type)) {
                    updatedUser = new PremiumCustomer(id, name, email, password, address, phone);
                    updatedUser.setType("Admin");
                } else if ("driver".equals(type)) {
                    updatedUser = new RegularCustomer(id, name, email, password, address, phone);
                    updatedUser.setType("driver");
                } else {
                    updatedUser = new RegularCustomer(id, name, email, password, address, phone);
                }
                updatedUsers.add(updatedUser.toString());
                updated = true;
                LOGGER.info("Updated user: ID=" + id + ", Type=" + type);
            } else {
                updatedUsers.add(user);
            }
        }
        if (updated) {
            rewriteFile(updatedUsers);
            // Redirect back to user.jsp?action=read instead of userlist.jsp
            resp.sendRedirect("user.jsp?action=read&success=" + java.net.URLEncoder.encode("User updated successfully.", "UTF-8"));
        } else {
            LOGGER.warning("User update failed: ID=" + id + " not found.");
            resp.sendRedirect("user.jsp?action=read&error=" + java.net.URLEncoder.encode("User not found.", "UTF-8"));
        }
    } else if ("login".equals(action)) {
        // Existing login logic remains unchanged
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        LOGGER.info("Login attempt: email=" + email + ", password=" + password);

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            LOGGER.warning("Invalid login attempt: email or password is empty");
            resp.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("Email and password are required.", "UTF-8"));
            return;
        }

        List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
        boolean authenticated = false;
        String userId = null;
        String role = "regular";

        for (String user : users) {
            LOGGER.fine("Checking user: " + user);
            String[] parts = user.split(",");
            if (parts.length == 8 && parts[2].equals(email.trim()) && parts[3].equals(password.trim())) {
                authenticated = true;
                userId = parts[0];
                String userType = parts[6].trim();
                LOGGER.info("User found: ID=" + userId + ", Type=" + userType);
                if ("Admin".equals(userType)) {
                    role = "admin";
                } else if ("Restaurant".equals(userType)) {
                    role = "restaurant";
                } else if ("driver".equals(userType)) {
                    role = "driver";
                } else if ("Premium".equals(userType)) {
                    role = "premium";
                } else {
                    role = "regular";
                }
                LOGGER.info("Assigned role: " + role);
                break;
            }
        }

        if (authenticated) {
            HttpSession session = req.getSession();
            session.setAttribute("userId", userId);
            session.setAttribute("role", role);
            LOGGER.info("Authenticated: userId=" + userId + ", role=" + role + ", redirecting...");
            if ("admin".equals(role)) {
                List<Order> orders = loadOrders();
                List<Order> pendingOrders = orders.stream()
                        .filter(order -> "Out for Delivery".equals(order.getStatus()))
                        .collect(Collectors.toList());
                List<String> drivers = loadDrivers();
                Map<String, String> restaurantNames = loadRestaurantNames();
                req.setAttribute("pendingOrders", pendingOrders);
                req.setAttribute("drivers", drivers);
                req.setAttribute("restaurantNames", restaurantNames);
                req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
            } else if ("driver".equals(role)) {
                resp.sendRedirect("delivery?action=driverDashboard");
            } else {
                resp.sendRedirect("home.jsp");
            }
        } else {
            LOGGER.warning("Authentication failed for email=" + email);
            resp.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("Invalid credentials", "UTF-8"));
        }
    }
}



//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        HttpSession session = req.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            LOGGER.warning("Unauthorized access attempt to UserServlet (GET): User not logged in.");
//            resp.sendRedirect("login.jsp");
//            return;
//        }
//
//        String action = req.getParameter("action");
//        String role = (String) session.getAttribute("role");
//
//        if ("read".equals(action)) {
//            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
//            req.setAttribute("users", users);
//            req.getRequestDispatcher("user.jsp").forward(req, resp);
//        } else if ("edit".equals(action)) {
//            if (!"admin".equals(role)) {
//                resp.sendRedirect("customerEdit.jsp");
//                return;
//            }
//            String id = req.getParameter("id");
//            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
//            for (String user : users) {
//                String[] parts = user.split(",");
//                if (parts[0].equals(id)) {
//                    req.setAttribute("id", parts[0]);
//                    req.setAttribute("name", parts[1]);
//                    req.setAttribute("email", parts[2]);
//                    req.setAttribute("password", parts[3]);
//                    req.setAttribute("address", parts[4]);
//                    req.setAttribute("phone", parts[5]);
//                    if (!"1".equals(id)) {
//                        req.setAttribute("type", parts[6]);
//                    }
//                    break;
//                }
//            }
//            req.getRequestDispatcher("edit.jsp").forward(req, resp);
//        } else if ("delete".equals(action)) {
//            if (!"admin".equals(role)) {
//                LOGGER.warning("Unauthorized delete attempt by user with role: " + role);
//                resp.sendRedirect("home.jsp");
//                return;
//            }
//            String id = req.getParameter("id");
//            if (id == null || id.trim().isEmpty()) {
//                LOGGER.warning("Invalid delete attempt: Missing user ID.");
//                resp.sendRedirect("userlist.jsp?error=" + java.net.URLEncoder.encode("Invalid user ID.", "UTF-8"));
//                return;
//            }
//            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
//            List<String> updatedUsers = new ArrayList<>();
//            boolean deleted = false;
//            for (String user : users) {
//                String[] parts = user.split(",");
//                if (!parts[0].equals(id)) {
//                    updatedUsers.add(user);
//                } else {
//                    deleted = true;
//                }
//            }
//            if (deleted) {
//                rewriteFile(updatedUsers);
//                LOGGER.info("User deleted: ID=" + id);
//                resp.sendRedirect("userlist.jsp?success=" + java.net.URLEncoder.encode("User deleted successfully.", "UTF-8"));
//            } else {
//                LOGGER.warning("User delete failed: ID=" + id + " not found.");
//                resp.sendRedirect("userlist.jsp?error=" + java.net.URLEncoder.encode("User not found.", "UTF-8"));
//            }
//        }
//    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to UserServlet (GET): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String role = (String) session.getAttribute("role");

        if ("read".equals(action)) {
            // Fetch the specific user's details instead of the entire list
            String userId = (String) session.getAttribute("userId");
            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
            boolean userFound = false;
            for (String user : users) {
                String[] parts = user.split(",");
                if (parts.length >= 7 && parts[0].equals(userId)) {
                    req.setAttribute("id", parts[0]);
                    req.setAttribute("name", parts[1]);
                    req.setAttribute("email", parts[2]);
                    req.setAttribute("password", parts[3]);
                    req.setAttribute("address", parts[4]);
                    req.setAttribute("phone", parts[5]);
                    req.setAttribute("type", parts[6]);
                    req.setAttribute("discount", parts.length > 7 ? parts[7] : "0");
                    userFound = true;
                    break;
                }
            }
            if (!userFound) {
                LOGGER.warning("User not found for reading: ID=" + userId);
                resp.sendRedirect("user.jsp?action=read&error=" + java.net.URLEncoder.encode("User data not found.", "UTF-8"));
                return;
            }
            req.getRequestDispatcher("user.jsp").forward(req, resp);
        } else if ("edit".equals(action)) {
            // Allow users to edit their own profile, not just admins
            String id = req.getParameter("id");
            String sessionUserId = (String) session.getAttribute("userId");
            if (id == null || id.trim().isEmpty()) {
                LOGGER.warning("Invalid edit attempt: Missing or empty user ID.");
                resp.sendRedirect("user.jsp?action=read&error=" + java.net.URLEncoder.encode("Invalid user ID.", "UTF-8"));
                return;
            }
            if (!id.equals(sessionUserId) && !"admin".equals(role)) {
                LOGGER.warning("Unauthorized edit attempt: User ID=" + sessionUserId + " attempted to edit ID=" + id);
                resp.sendRedirect("user.jsp?action=read&error=" + java.net.URLEncoder.encode("You can only edit your own profile.", "UTF-8"));
                return;
            }

            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
            boolean userFound = false;
            for (String user : users) {
                String[] parts = user.split(",");
                if (parts.length >= 7 && parts[0].equals(id)) {
                    req.setAttribute("id", parts[0]);
                    req.setAttribute("name", parts[1]);
                    req.setAttribute("email", parts[2]);
                    req.setAttribute("password", parts[3]);
                    req.setAttribute("address", parts[4]);
                    req.setAttribute("phone", parts[5]);
                    req.setAttribute("type", parts[6]);
                    userFound = true;
                    LOGGER.info("User found for editing: ID=" + id);
                    break;
                }
            }

            if (!userFound) {
                LOGGER.warning("User not found for editing: ID=" + id);
                resp.sendRedirect("user.jsp?action=read&error=" + java.net.URLEncoder.encode("User not found.", "UTF-8"));
                return;
            }

            req.getRequestDispatcher("customerEdit.jsp").forward(req, resp);
        } else if ("delete".equals(action)) {
            if (!"admin".equals(role)) {
                LOGGER.warning("Unauthorized delete attempt by user with role: " + role);
                resp.sendRedirect("home.jsp");
                return;
            }
            String id = req.getParameter("id");
            if (id == null || id.trim().isEmpty()) {
                LOGGER.warning("Invalid delete attempt: Missing user ID.");
                resp.sendRedirect("userlist.jsp?error=" + java.net.URLEncoder.encode("Invalid user ID.", "UTF-8"));
                return;
            }
            List<String> users = FileUtils.readFromFile(getServletContext(), FILE_NAME);
            List<String> updatedUsers = new ArrayList<>();
            boolean deleted = false;
            for (String user : users) {
                String[] parts = user.split(",");
                if (!parts[0].equals(id)) {
                    updatedUsers.add(user);
                } else {
                    deleted = true;
                }
            }
            if (deleted) {
                rewriteFile(updatedUsers);
                LOGGER.info("User deleted: ID=" + id);
                resp.sendRedirect("userlist.jsp?success=" + java.net.URLEncoder.encode("User deleted successfully.", "UTF-8"));
            } else {
                LOGGER.warning("User delete failed: ID=" + id + " not found.");
                resp.sendRedirect("userlist.jsp?error=" + java.net.URLEncoder.encode("User not found.", "UTF-8"));
            }
        }
    }
    private void rewriteFile(List<String> data) throws IOException {
        String filePath = FileUtils.getFilePath(getServletContext(), FILE_NAME);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String line : data) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    private List<Order> loadOrders() {
        Set<Order> uniqueOrders = new HashSet<>();
        try {
            List<String> orderData = FileUtils.readFromFile(getServletContext(), ORDER_FILE);
            for (String line : orderData) {
                try {
                    uniqueOrders.add(Order.fromString(line));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing order: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading orders.txt: " + e.getMessage());
        }
        return new ArrayList<>(uniqueOrders);
    }

    private List<String> loadDrivers() {
        List<String> drivers = new ArrayList<>();
        try {
            List<String> userData = FileUtils.readFromFile(getServletContext(), FILE_NAME);
            for (String line : userData) {
                String[] parts = line.split(",");
                if (parts.length == 8 && "driver".equals(parts[6].trim())) {
                    drivers.add(parts[0]);
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading users.txt for drivers: " + e.getMessage());
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