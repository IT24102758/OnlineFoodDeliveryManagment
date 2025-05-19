package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.Restaurant;
import model.Review;
import utils.FileUtils;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class ReviewServlet extends HttpServlet {
    private static final String REVIEW_FILE = "reviews.txt";
    private static final String ORDER_FILE = "orders.txt";
    private static final String RESTAURANT_FILE = "restaurants.txt";
    private static final String USER_FILE = "users.txt";
    private static final Logger LOGGER = Logger.getLogger(ReviewServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to ReviewServlet (GET): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String action = req.getParameter("action");

        if (action == null) {
            action = "";
        }

        switch (action) {
            case "submit":
                LOGGER.info("Processing review submission for userId: " + userId + ", role: " + role);
                if ("admin".equals(role) || "driver".equals(role)) { // Disallow admin and driver
                    LOGGER.warning("Unauthorized access attempt to submit review: User is an admin or driver. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                String orderId = req.getParameter("orderId");
                if (orderId == null || orderId.trim().isEmpty()) {
                    LOGGER.warning("Invalid review submission attempt by user " + userId + ": Missing orderId.");
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Missing order ID.", "UTF-8"));
                    return;
                }
                LOGGER.info("Order ID: " + orderId);
                List<Order> orders = loadOrders();
                LOGGER.info("Total orders loaded: " + orders.size());
                Order order = orders.stream()
                        .filter(o -> o.getOrderId().equals(orderId) && o.getUserId().equals(userId))
                        .findFirst()
                        .orElse(null);
                if (order == null) {
                    LOGGER.warning("Order not found for review submission by user " + userId + ": Order ID " + orderId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Order not found or does not belong to you.", "UTF-8"));
                    return;
                }
                LOGGER.info("Order found: " + order.toString());
                if (!"Delivered".equals(order.getStatus())) {
                    LOGGER.warning("Order not delivered for review submission by user " + userId + ": Order ID " + orderId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Order must be delivered to submit a review.", "UTF-8"));
                    return;
                }
                List<Review> reviews = loadReviews();
                LOGGER.info("Total reviews loaded: " + reviews.size());
                boolean hasReviewed = reviews.stream()
                        .anyMatch(r -> r.getOrderId().equals(orderId) && r.getUserId().equals(userId));
                if (hasReviewed) {
                    LOGGER.warning("User " + userId + " has already reviewed order: " + orderId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("You have already reviewed this order.", "UTF-8"));
                    return;
                }
                String restaurantId = order.getItems() != null && !order.getItems().isEmpty()
                        ? (String) order.getItems().get(0).get("restaurantId")
                        : null;
                if (restaurantId == null) {
                    LOGGER.warning("Restaurant ID not found for order: " + orderId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Restaurant information not found for this order.", "UTF-8"));
                    return;
                }
                LOGGER.info("Restaurant ID: " + restaurantId);
                req.setAttribute("orderId", orderId);
                req.setAttribute("restaurantId", restaurantId);
                LOGGER.info("Forwarding to submitReview.jsp for orderId: " + orderId);
                req.getRequestDispatcher("submitReview.jsp").forward(req, resp);
                break;

            case "view":
                String viewRestaurantId = req.getParameter("restaurantId");
                if (viewRestaurantId == null || viewRestaurantId.trim().isEmpty()) {
                    LOGGER.warning("Invalid review view attempt: Missing restaurantId.");
                    resp.sendRedirect("home.jsp?error=" + java.net.URLEncoder.encode("Missing restaurant ID.", "UTF-8"));
                    return;
                }
                List<Review> restaurantReviews = loadReviews().stream()
                        .filter(r -> r.getRestaurantId().equals(viewRestaurantId))
                        .collect(Collectors.toList());
                Map<String, String> userNames = loadUserNames();
                req.setAttribute("reviews", restaurantReviews);
                req.setAttribute("userNames", userNames);
                req.setAttribute("restaurantId", viewRestaurantId);
                req.getRequestDispatcher("viewReviews.jsp").forward(req, resp);
                break;

            case "edit":
                if ("admin".equals(role) || "driver".equals(role)) { // Disallow admin and driver
                    LOGGER.warning("Unauthorized access attempt to edit review: User role not allowed. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                String reviewId = req.getParameter("reviewId");
                if (reviewId == null || reviewId.trim().isEmpty()) {
                    LOGGER.warning("Invalid review edit attempt by user " + userId + ": Missing reviewId.");
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Missing review ID.", "UTF-8"));
                    return;
                }
                List<Review> allReviews = loadReviews();
                Review reviewToEdit = allReviews.stream()
                        .filter(r -> r.getReviewId().equals(reviewId))
                        .findFirst()
                        .orElse(null);
                if (reviewToEdit == null) {
                    LOGGER.warning("Review not found for editing by user " + userId + ": Review ID " + reviewId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Review not found.", "UTF-8"));
                    return;
                }
                if (!reviewToEdit.getUserId().equals(userId)) {
                    LOGGER.warning("Unauthorized review edit attempt by user " + userId + ": Review ID " + reviewId + " does not belong to user.");
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("You are not authorized to edit this review.", "UTF-8"));
                    return;
                }
                req.setAttribute("review", reviewToEdit);
                req.getRequestDispatcher("editReview.jsp").forward(req, resp);
                break;

            case "manage":
                if (!"admin".equals(role)) {
                    LOGGER.warning("Unauthorized access attempt to manage reviews: User is not an admin. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                List<Review> allReviewsForAdmin = loadReviews();
                Map<String, String> userNamesForAdmin = loadUserNames();
                Map<String, String> restaurantNames = loadRestaurantNames();
                req.setAttribute("reviews", allReviewsForAdmin);
                req.setAttribute("userNames", userNamesForAdmin);
                req.setAttribute("restaurantNames", restaurantNames);
                req.getRequestDispatcher("manageReviews.jsp").forward(req, resp);
                break;

            default:
                LOGGER.info("Unknown action in ReviewServlet for user " + userId + ": " + action + ", redirecting to home.jsp");
                resp.sendRedirect("home.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access attempt to ReviewServlet (POST): User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String action = req.getParameter("action");

        if (action == null) {
            action = "";
        }

        switch (action) {
            case "submit":
                LOGGER.info("Processing review submission (POST) for userId: " + userId + ", role: " + role);
                if ("admin".equals(role) || "driver".equals(role)) { // Disallow admin and driver
                    LOGGER.warning("Unauthorized review submission attempt: User is an admin or driver. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                String orderId = req.getParameter("orderId");
                String restaurantId = req.getParameter("restaurantId");
                String ratingStr = req.getParameter("rating");
                String comment = req.getParameter("comment");

                if (orderId == null || restaurantId == null || ratingStr == null || orderId.trim().isEmpty() || restaurantId.trim().isEmpty() || ratingStr.trim().isEmpty()) {
                    LOGGER.warning("Invalid review submission attempt by user " + userId + ": Missing required fields.");
                    req.setAttribute("error", "All fields are required.");
                    req.setAttribute("orderId", orderId);
                    req.setAttribute("restaurantId", restaurantId);
                    req.getRequestDispatcher("submitReview.jsp").forward(req, resp);
                    return;
                }

                double rating;
                try {
                    rating = Double.parseDouble(ratingStr);
                    if (rating < 1 || rating > 5) {
                        throw new NumberFormatException("Rating must be between 1 and 5.");
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid rating provided by user " + userId + ": " + ratingStr);
                    req.setAttribute("error", "Rating must be a number between 1 and 5.");
                    req.setAttribute("orderId", orderId);
                    req.setAttribute("restaurantId", restaurantId);
                    req.getRequestDispatcher("submitReview.jsp").forward(req, resp);
                    return;
                }

                List<Order> orders = loadOrders();
                Order order = orders.stream()
                        .filter(o -> o.getOrderId().equals(orderId) && o.getUserId().equals(userId))
                        .findFirst()
                        .orElse(null);
                if (order == null) {
                    LOGGER.warning("Order not found for review submission by user " + userId + ": Order ID " + orderId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Order not found or does not belong to you.", "UTF-8"));
                    return;
                }

                List<Review> reviews = loadReviews();
                String reviewId = "REV" + System.currentTimeMillis();
                String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                Review newReview = new Review(reviewId, orderId, userId, restaurantId, rating, comment != null ? comment : "", timestamp);
                reviews.add(newReview);

                try {
                    FileUtils.rewriteFile(getServletContext(), REVIEW_FILE, reviews.stream().map(Review::toString).collect(Collectors.toList()));
                    LOGGER.info("Review submitted by user " + userId + ": Review ID " + reviewId);
                    resp.sendRedirect("order?action=history&success=" + java.net.URLEncoder.encode("Review submitted successfully.", "UTF-8"));
                } catch (IOException e) {
                    LOGGER.severe("Error saving review: " + e.getMessage());
                    req.setAttribute("error", "Error submitting review: " + e.getMessage());
                    req.setAttribute("orderId", orderId);
                    req.setAttribute("restaurantId", restaurantId);
                    req.getRequestDispatcher("submitReview.jsp").forward(req, resp);
                }
                break;

            case "update":
                if ("admin".equals(role) || "driver".equals(role)) { // Disallow admin and driver
                    LOGGER.warning("Unauthorized review update attempt: User role not allowed. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                reviewId = req.getParameter("reviewId");
                ratingStr = req.getParameter("rating");
                comment = req.getParameter("comment");

                if (reviewId == null || ratingStr == null || reviewId.trim().isEmpty() || ratingStr.trim().isEmpty()) {
                    LOGGER.warning("Invalid review update attempt by user " + userId + ": Missing required fields.");
                    resp.sendRedirect("review?action=edit&reviewId=" + (reviewId != null ? reviewId : "") + "&error=" + java.net.URLEncoder.encode("All fields are required.", "UTF-8"));
                    return;
                }

                try {
                    rating = Double.parseDouble(ratingStr);
                    if (rating < 1 || rating > 5) {
                        throw new NumberFormatException("Rating must be between 1 and 5.");
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid rating provided by user " + userId + ": " + ratingStr);
                    resp.sendRedirect("review?action=edit&reviewId=" + reviewId + "&error=" + java.net.URLEncoder.encode("Rating must be a number between 1 and 5.", "UTF-8"));
                    return;
                }

                reviews = loadReviews();
                Review reviewToUpdate = reviews.stream()
                        .filter(r -> r.getReviewId().equals(reviewId))
                        .findFirst()
                        .orElse(null);

                if (reviewToUpdate == null) {
                    LOGGER.warning("Review not found for update by user " + userId + ": Review ID " + reviewId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Review not found.", "UTF-8"));
                    return;
                }

                if (!reviewToUpdate.getUserId().equals(userId)) {
                    LOGGER.warning("Unauthorized review update attempt by user " + userId + ": Review ID " + reviewId + " does not belong to user.");
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("You are not authorized to update this review.", "UTF-8"));
                    return;
                }

                reviewToUpdate.setRating(rating);
                reviewToUpdate.setComment(comment != null ? comment : "");
                reviewToUpdate.setTimestamp(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

                try {
                    FileUtils.rewriteFile(getServletContext(), REVIEW_FILE, reviews.stream().map(Review::toString).collect(Collectors.toList()));
                    LOGGER.info("Review updated by user " + userId + ": Review ID " + reviewId);
                    resp.sendRedirect("order?action=history&success=" + java.net.URLEncoder.encode("Review updated successfully.", "UTF-8"));
                } catch (IOException e) {
                    LOGGER.severe("Error updating review: " + e.getMessage());
                    resp.sendRedirect("review?action=edit&reviewId=" + reviewId + "&error=" + java.net.URLEncoder.encode("Error updating review: " + e.getMessage(), "UTF-8"));
                }
                break;

            case "delete":
                if ("admin".equals(role) || "driver".equals(role)) { // Disallow admin and driver
                    LOGGER.warning("Unauthorized review deletion attempt: User role not allowed. Role: " + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                reviewId = req.getParameter("reviewId");
                if (reviewId == null || reviewId.trim().isEmpty()) {
                    LOGGER.warning("Invalid review deletion attempt by user " + userId + ": Missing reviewId.");
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Missing review ID.", "UTF-8"));
                    return;
                }

                reviews = loadReviews();
                Review reviewToDelete = reviews.stream()
                        .filter(r -> r.getReviewId().equals(reviewId))
                        .findFirst()
                        .orElse(null);

                if (reviewToDelete == null) {
                    LOGGER.warning("Review not found for deletion by user " + userId + ": Review ID " + reviewId);
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Review not found.", "UTF-8"));
                    return;
                }

                if (!reviewToDelete.getUserId().equals(userId)) {
                    LOGGER.warning("Unauthorized review deletion attempt by user " + userId + ": Review ID " + reviewId + " does not belong to user.");
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("You are not authorized to delete this review.", "UTF-8"));
                    return;
                }

                reviews.removeIf(r -> r.getReviewId().equals(reviewId));
                try {
                    FileUtils.rewriteFile(getServletContext(), REVIEW_FILE, reviews.stream().map(Review::toString).collect(Collectors.toList()));
                    LOGGER.info("Review deleted by user " + userId + ": Review ID " + reviewId);
                    resp.sendRedirect("order?action=history&success=" + java.net.URLEncoder.encode("Review deleted successfully.", "UTF-8"));
                } catch (IOException e) {
                    LOGGER.severe("Error deleting review: " + e.getMessage());
                    resp.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Error deleting review: " + e.getMessage(), "UTF-8"));
                }
                break;

            default:
                LOGGER.info("Unknown POST action in ReviewServlet for user " + userId + ": " + action + ", redirecting to home.jsp");
                resp.sendRedirect("home.jsp");
                break;
        }
    }

    private List<Review> loadReviews() {
        List<Review> reviews = new ArrayList<>();
        try {
            List<String> reviewData = FileUtils.readFromFile(getServletContext(), REVIEW_FILE);
            for (String line : reviewData) {
                try {
                    reviews.add(Review.fromString(line));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing review: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading reviews.txt: " + e.getMessage());
        }
        return reviews;
    }

    private List<Order> loadOrders() {
        List<Order> orders = new ArrayList<>();
        try {
            List<String> orderData = FileUtils.readFromFile(getServletContext(), ORDER_FILE);
            for (String line : orderData) {
                try {
                    orders.add(Order.fromString(line));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing order: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading orders.txt: " + e.getMessage());
        }
        return orders;
    }

    private Map<String, String> loadUserNames() {
        Map<String, String> userNames = new HashMap<>();
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
                    userNames.put(id, name);
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Error parsing user: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error reading users.txt: " + e.getMessage());
        }
        return userNames;
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