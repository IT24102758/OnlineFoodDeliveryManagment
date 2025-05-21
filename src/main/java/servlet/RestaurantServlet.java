package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Restaurant;
import model.RestaurantType;
import utils.FileUtils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class RestaurantServlet extends HttpServlet {
    private static final String FILE_NAME = "restaurants.txt";

    private void rewriteFile(List<String> data) throws IOException {
        String filePath = FileUtils.getFilePath(getServletContext(), FILE_NAME);
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, false))) {
            for (String line : data) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        String role = (String) session.getAttribute("role");
        System.out.println("RestaurantServlet: GET request with action=" + action + ", role=" + role);

        switch (action) {
            case "register":
                if (!"admin".equals(role)) {
                    resp.sendRedirect("home.jsp");
                    return;
                }
                req.getRequestDispatcher("restaurantRegister.jsp").forward(req, resp);
                break;
            case "edit":
                String id = req.getParameter("id");
                if (!"admin".equals(role)) {
                    resp.sendRedirect("restaurant?action=list");
                    return;
                }
                List<String> restaurants = FileUtils.readFromFile(getServletContext(), FILE_NAME);
                for (String restaurantData : restaurants) {
                    try {
                        Restaurant restaurant = Restaurant.fromString(restaurantData);
                        if (restaurant.getId().equals(id)) {
                            req.setAttribute("restaurant", restaurant);
                            break;
                        }
                    } catch (IllegalArgumentException e) {
                        e.printStackTrace();
                    }
                }
                req.getRequestDispatcher("restaurantEdit.jsp").forward(req, resp);
                break;
            case "cuisine":
                List<Restaurant> restaurantList = new ArrayList<>();
                List<String> cuisineRestaurants = FileUtils.readFromFile(getServletContext(), FILE_NAME);
                if (cuisineRestaurants == null || cuisineRestaurants.isEmpty()) {
                    req.setAttribute("restaurants", restaurantList);
                    req.getRequestDispatcher("cuisineSelection.jsp").forward(req, resp);
                    return;
                }
                for (String restaurantData : cuisineRestaurants) {
                    try {
                        Restaurant restaurant = Restaurant.fromString(restaurantData);
                        restaurantList.add(restaurant);
                    } catch (IllegalArgumentException e) {
                        e.printStackTrace();
                    }
                }
                req.setAttribute("restaurants", restaurantList);
                req.getRequestDispatcher("cuisineSelection.jsp").forward(req, resp);
                break;
            case "byCuisine":
                String selectedCuisine = req.getParameter("cuisine");
                System.out.println("Filtering restaurants for cuisine: " + selectedCuisine);
                List<Restaurant> filteredRestaurants = new ArrayList<>();
                List<String> allRestaurants = FileUtils.readFromFile(getServletContext(), FILE_NAME);
                if (allRestaurants == null || allRestaurants.isEmpty()) {
                    System.out.println("No restaurants found in file.");
                    req.setAttribute("restaurants", filteredRestaurants);
                    req.getRequestDispatcher("restaurantByCuisine.jsp").forward(req, resp);
                    return;
                }
                if (selectedCuisine != null && !selectedCuisine.isEmpty()) {
                    for (String restaurantData : allRestaurants) {
                        try {
                            Restaurant restaurant = Restaurant.fromString(restaurantData);
                            System.out.println("Checking restaurant: " + restaurant.getName() + ", Cuisine: " + restaurant.getCuisineType());
                            if (restaurant.getCuisineType().toString().equalsIgnoreCase(selectedCuisine)) {
                                filteredRestaurants.add(restaurant);
                                System.out.println("Match found: " + restaurant.getName());
                            }
                        } catch (IllegalArgumentException e) {
                            e.printStackTrace();
                        }
                    }
                } else {
                    System.out.println("No cuisine parameter provided.");
                }
                System.out.println("Filtered restaurants: " + filteredRestaurants);
                req.setAttribute("restaurants", filteredRestaurants);
                req.getRequestDispatcher("restaurantByCuisine.jsp").forward(req, resp);
                break;
            case "list":
            default:
                System.out.println("Loading all restaurants for list view.");
                List<Restaurant> restaurantListDefault = new ArrayList<>();
                List<String> restaurantss = FileUtils.readFromFile(getServletContext(), FILE_NAME);
                if (restaurantss == null || restaurantss.isEmpty()) {
                    req.setAttribute("restaurants", restaurantListDefault);
                    req.getRequestDispatcher("restaurantList.jsp").forward(req, resp);
                    return;
                }
                String searchQuery = req.getParameter("search");
                boolean showAll = searchQuery == null || searchQuery.trim().isEmpty();
                for (String restaurantData : restaurantss) {
                    try {
                        Restaurant restaurant = Restaurant.fromString(restaurantData);
                        if (showAll ||
                                restaurant.getName().toLowerCase().contains(searchQuery.toLowerCase()) ||
                                restaurant.getCuisineType().toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
                                restaurant.getLocation().toLowerCase().contains(searchQuery.toLowerCase())) {
                            restaurantListDefault.add(restaurant);
                        }
                    } catch (IllegalArgumentException e) {
                        e.printStackTrace();
                    }
                }
                req.setAttribute("restaurants", restaurantListDefault);
                req.setAttribute("searchQuery", searchQuery);
                req.getRequestDispatcher("restaurantList.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String role = (String) session.getAttribute("role");
        String userId = (String) session.getAttribute("userId");
        System.out.println("RestaurantServlet: POST request with action=" + action + ", role=" + role);

        List<String> restaurants = FileUtils.readFromFile(getServletContext(), FILE_NAME);
        if (restaurants == null) {
            restaurants = new ArrayList<>();
        }

        if ("create".equals(action)) {
            if (!"admin".equals(role)) {
                resp.sendRedirect("home.jsp");
                return;
            }
            String id = String.valueOf(System.currentTimeMillis());
            String name = req.getParameter("name");
            String location = req.getParameter("location");
            String cuisineTypeStr = req.getParameter("cuisineType");
            String contactInfo = req.getParameter("contactInfo");
            String operationHours = req.getParameter("operationHours");

            if (name == null || name.trim().isEmpty() || location == null || location.trim().isEmpty() ||
                    cuisineTypeStr == null || cuisineTypeStr.trim().isEmpty() || contactInfo == null || contactInfo.trim().isEmpty() ||
                    operationHours == null || operationHours.trim().isEmpty()) {
                req.setAttribute("error", "All fields are required.");
                req.getRequestDispatcher("restaurantRegister.jsp").forward(req, resp);
                return;
            }

            try {
                RestaurantType cuisineType = RestaurantType.valueOf(cuisineTypeStr);
                Restaurant restaurant = new Restaurant(id, name, location, cuisineType, contactInfo, operationHours);
                FileUtils.writeToFile(getServletContext(), FILE_NAME, restaurant.toString());
                resp.sendRedirect("restaurant?action=list");
            } catch (IllegalArgumentException e) {
                req.setAttribute("error", "Invalid cuisine type: " + cuisineTypeStr);
                req.getRequestDispatcher("restaurantRegister.jsp").forward(req, resp);
            }
        } else if ("update".equals(action)) {
            String id = req.getParameter("id");
            if (!"admin".equals(role)) {
                resp.sendRedirect("restaurant?action=list");
                return;
            }
            String name = req.getParameter("name");
            String location = req.getParameter("location");
            String cuisineTypeStr = req.getParameter("cuisineType");
            String contactInfo = req.getParameter("contactInfo");
            String operationHours = req.getParameter("operationHours");

            if (name == null || name.trim().isEmpty() || location == null || location.trim().isEmpty() ||
                    cuisineTypeStr == null || cuisineTypeStr.trim().isEmpty() || contactInfo == null || contactInfo.trim().isEmpty() ||
                    operationHours == null || operationHours.trim().isEmpty()) {
                req.setAttribute("error", "All fields are required.");
                req.getRequestDispatcher("restaurantEdit.jsp").forward(req, resp);
                return;
            }

            try {
                RestaurantType cuisineType = RestaurantType.valueOf(cuisineTypeStr);
                List<String> updatedRestaurants = new ArrayList<>();
                for (String restaurantData : restaurants) {
                    Restaurant restaurant = Restaurant.fromString(restaurantData);
                    if (restaurant.getId().equals(id)) {
                        restaurant = new Restaurant(id, name, location, cuisineType, contactInfo, operationHours);
                    }
                    updatedRestaurants.add(restaurant.toString());
                }
                rewriteFile(updatedRestaurants);
                resp.sendRedirect("restaurant?action=list");
            } catch (IllegalArgumentException e) {
                req.setAttribute("error", "Invalid cuisine type: " + cuisineTypeStr);
                req.getRequestDispatcher("restaurantEdit.jsp").forward(req, resp);
            }
        } else if ("delete".equals(action)) {
            String id = req.getParameter("id");
            if (!"admin".equals(role)) {
                resp.sendRedirect("restaurant?action=list");
                return;
            }
            System.out.println("Deleting restaurant with ID: " + id);
            System.out.println("Restaurants before deletion: " + restaurants);
            List<String> updatedRestaurants = new ArrayList<>();
            for (String restaurantData : restaurants) {
                Restaurant restaurant = Restaurant.fromString(restaurantData);
                if (!restaurant.getId().equals(id)) {
                    updatedRestaurants.add(restaurantData);
                }
            }
            System.out.println("Restaurants after deletion: " + updatedRestaurants);
            rewriteFile(updatedRestaurants);
            resp.sendRedirect("restaurant?action=list");
        }
    }
}
