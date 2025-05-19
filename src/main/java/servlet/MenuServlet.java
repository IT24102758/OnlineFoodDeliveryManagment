package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.MenuItem;
import utils.FileUtils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB max file size
public class MenuServlet extends HttpServlet {
    private static final String FILE_NAME = "menu.txt";
    private static final String IMAGE_DIR = "images";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("MenuServlet: No active session, redirecting to login.jsp");
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        String role = (String) session.getAttribute("role");
        System.out.println("MenuServlet: GET request with action=" + action + ", role=" + role);

        switch (action) {
            case "add":
                if (!"admin".equals(role)) {
                    System.out.println("MenuServlet: Non-admin user attempted to access add, role=" + role);
                    resp.sendRedirect("home.jsp");
                    return;
                }
                String restaurantId = req.getParameter("restaurantId");
                if (restaurantId == null || restaurantId.trim().isEmpty()) {
                    req.setAttribute("error", "Restaurant ID is required.");
                    req.getRequestDispatcher("menuAdd.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("restaurantId", restaurantId);
                req.getRequestDispatcher("menuAdd.jsp").forward(req, resp);
                break;

            case "edit":
                if (!"admin".equals(role)) {
                    System.out.println("MenuServlet: Non-admin user attempted to access edit, role=" + role);
                    resp.sendRedirect("menu?action=list");
                    return;
                }
                String id = req.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                    req.setAttribute("error", "Menu item ID is required for editing.");
                    req.getRequestDispatcher("menuList.jsp").forward(req, resp);
                    return;
                }
                List<String> menuItems = FileUtils.readFromFile(getServletContext(), FILE_NAME);
                for (String menuData : menuItems) {
                    try {
                        MenuItem menuItem = MenuItem.fromString(menuData);
                        if (menuItem.getId().equals(id)) {
                            req.setAttribute("menuItem", menuItem);
                            break;
                        }
                    } catch (IllegalArgumentException e) {
                        System.err.println("Error parsing menu item for edit, ID=" + id + ": " + e.getMessage());
                    }
                }
                if (req.getAttribute("menuItem") == null) {
                    req.setAttribute("error", "Menu item not found for ID: " + id);
                }
                req.getRequestDispatcher("menuEdit.jsp").forward(req, resp);
                break;

            case "list":
            default:
                String listRestaurantId = req.getParameter("restaurantId");
                if (listRestaurantId == null || listRestaurantId.trim().isEmpty()) {
                    System.out.println("MenuServlet: Missing restaurantId for list action");
                    req.setAttribute("error", "Restaurant ID is required to view the menu.");
                    req.getRequestDispatcher("restaurantByCuisine.jsp").forward(req, resp);
                    return;
                }
                List<MenuItem> menuItemList = new ArrayList<>();
                try {
                    List<String> allMenuItems = FileUtils.readFromFile(getServletContext(), FILE_NAME);
                    System.out.println("MenuServlet: Successfully read menu.txt, total lines=" + allMenuItems.size());
                    for (String menuData : allMenuItems) {
                        try {
                            MenuItem menuItem = MenuItem.fromString(menuData);
                            if (menuItem.getRestaurantId().equals(listRestaurantId)) {
                                menuItemList.add(menuItem);
                                System.out.println("Found menu item: " + menuItem.getDishName() + " for restaurantId=" + listRestaurantId);
                            }
                        } catch (IllegalArgumentException e) {
                            System.err.println("Error parsing menu item for list, data=" + menuData + ": " + e.getMessage());
                        }
                    }
                    System.out.println("Total menu items found for restaurantId=" + listRestaurantId + ": " + menuItemList.size());
                } catch (IOException e) {
                    System.err.println("Error reading menu file: " + e.getMessage());
                    req.setAttribute("error", "Error loading menu items: " + e.getMessage());
                }
                req.setAttribute("menuItems", menuItemList);
                req.setAttribute("restaurantId", listRestaurantId);

                // Check if this is an AJAX request
                String requestedWith = req.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith)) {
                    System.out.println("MenuServlet: Handling AJAX request for menu list, restaurantId=" + listRestaurantId);
                    resp.setContentType("text/html; charset=UTF-8");
                    try {
                        System.out.println("MenuServlet: Attempting to forward to menuPartial.jsp");
                        req.getRequestDispatcher("/menuPartial.jsp").forward(req, resp); // Updated to match current location
                        System.out.println("MenuServlet: Successfully forwarded to menuPartial.jsp");
                    } catch (Exception e) {
                        System.err.println("Error forwarding to menuPartial.jsp: " + e.getMessage());
                        e.printStackTrace();
                        resp.setContentType("text/html; charset=UTF-8");
                        resp.getWriter().write("<p>Error rendering menu: " + e.getMessage() + "</p>");
                        resp.getWriter().flush();
                    }
                } else {
                    req.getRequestDispatcher("menuList.jsp").forward(req, resp);
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("MenuServlet: No active session, redirecting to login.jsp");
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String role = (String) session.getAttribute("role");
        System.out.println("MenuServlet: POST request with action=" + action + ", role=" + role);

        List<String> menuItems;
        try {
            menuItems = FileUtils.readFromFile(getServletContext(), FILE_NAME);
        } catch (IOException e) {
            System.err.println("Error reading menu file: " + e.getMessage());
            req.setAttribute("error", "Error accessing menu data: " + e.getMessage());
            req.getRequestDispatcher("menuList.jsp").forward(req, resp);
            return;
        }

        if ("create".equals(action)) {
            if (!"admin".equals(role)) {
                System.out.println("MenuServlet: Non-admin user attempted to create menu item, role=" + role);
                resp.sendRedirect("home.jsp");
                return;
            }
            String id = String.valueOf(System.currentTimeMillis());
            String restaurantId = req.getParameter("restaurantId");
            String dishName = req.getParameter("dishName");
            String description = req.getParameter("description");
            String priceStr = req.getParameter("price");

            Part filePart = req.getPart("image");
            String imagePath = null;
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    imagePath = FileUtils.saveImageFile(getServletContext(), IMAGE_DIR, filePart);
                } catch (IOException e) {
                    System.err.println("Error saving image file: " + e.getMessage());
                    req.setAttribute("error", "Error uploading image: " + e.getMessage());
                    req.setAttribute("restaurantId", restaurantId);
                    req.getRequestDispatcher("menuAdd.jsp").forward(req, resp);
                    return;
                }
            } else {
                req.setAttribute("error", "Image file is required.");
                req.setAttribute("restaurantId", restaurantId);
                req.getRequestDispatcher("menuAdd.jsp").forward(req, resp);
                return;
            }

            if (restaurantId == null || restaurantId.trim().isEmpty() || dishName == null || dishName.trim().isEmpty() ||
                    description == null || description.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() ||
                    imagePath == null) {
                req.setAttribute("error", "All fields are required.");
                req.setAttribute("restaurantId", restaurantId);
                req.getRequestDispatcher("menuAdd.jsp").forward(req, resp);
                return;
            }

            try {
                double price = Double.parseDouble(priceStr);
                MenuItem menuItem = new MenuItem(id, restaurantId, dishName, description, price, imagePath);
                FileUtils.writeToFile(getServletContext(), FILE_NAME, menuItem.toString());
                System.out.println("Created menu item with ID: " + id);
                redirectToMenuList(req, resp, restaurantId);
            } catch (NumberFormatException e) {
                System.err.println("Invalid price format: " + priceStr);
                req.setAttribute("error", "Invalid price format: " + priceStr);
                req.setAttribute("restaurantId", restaurantId);
                req.getRequestDispatcher("menuAdd.jsp").forward(req, resp);
            } catch (IOException e) {
                System.err.println("Error writing menu item to file: " + e.getMessage());
                req.setAttribute("error", "Error creating menu item: " + e.getMessage());
                req.setAttribute("restaurantId", restaurantId);
                req.getRequestDispatcher("menuAdd.jsp").forward(req, resp);
            }

        } else if ("update".equals(action)) {
            if (!"admin".equals(role)) {
                System.out.println("MenuServlet: Non-admin user attempted to update menu item, role=" + role);
                resp.sendRedirect("menu?action=list");
                return;
            }
            String id = req.getParameter("id");
            String restaurantId = req.getParameter("restaurantId");
            String dishName = req.getParameter("dishName");
            String description = req.getParameter("description");
            String priceStr = req.getParameter("price");

            Part filePart = req.getPart("image");
            String imagePath = null;
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    imagePath = FileUtils.saveImageFile(getServletContext(), IMAGE_DIR, filePart);
                } catch (IOException e) {
                    System.err.println("Error saving image file: " + e.getMessage());
                    req.setAttribute("error", "Error uploading image: " + e.getMessage());
                    req.getRequestDispatcher("menuEdit.jsp").forward(req, resp);
                    return;
                }
            }

            if (id == null || id.trim().isEmpty() || restaurantId == null || restaurantId.trim().isEmpty() ||
                    dishName == null || dishName.trim().isEmpty() || description == null || description.trim().isEmpty() ||
                    priceStr == null || priceStr.trim().isEmpty()) {
                req.setAttribute("error", "All fields are required.");
                req.getRequestDispatcher("menuEdit.jsp").forward(req, resp);
                return;
            }

            try {
                double price = Double.parseDouble(priceStr);
                List<String> updatedMenuItems = new ArrayList<>();
                boolean found = false;
                for (String menuData : menuItems) {
                    try {
                        MenuItem menuItem = MenuItem.fromString(menuData);
                        if (menuItem.getId().equals(id)) {
                            found = true;
                            String oldImagePath = menuItem.getImageUrl();
                            menuItem = new MenuItem(id, restaurantId, dishName, description, price, imagePath != null ? imagePath : oldImagePath);
                        }
                        updatedMenuItems.add(menuItem.toString());
                    } catch (IllegalArgumentException e) {
                        System.err.println("Error parsing menu item for update, ID=" + id + ": " + e.getMessage());
                    }
                }
                if (found) {
                    FileUtils.rewriteFile(getServletContext(), FILE_NAME, updatedMenuItems);
                    System.out.println("Updated menu item with ID: " + id);
                    redirectToMenuList(req, resp, restaurantId);
                } else {
                    System.err.println("Menu item not found for update, ID: " + id);
                    req.setAttribute("error", "Menu item not found for update.");
                    req.getRequestDispatcher("menuEdit.jsp").forward(req, resp);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid price format: " + priceStr);
                req.setAttribute("error", "Invalid price format: " + priceStr);
                req.getRequestDispatcher("menuEdit.jsp").forward(req, resp);
            } catch (IOException e) {
                System.err.println("Error updating menu file: " + e.getMessage());
                req.setAttribute("error", "Error updating menu item: " + e.getMessage());
                req.getRequestDispatcher("menuEdit.jsp").forward(req, resp);
            }

        } else if ("delete".equals(action)) {
            if (!"admin".equals(role)) {
                System.out.println("Delete failed: User role is not admin, role=" + role);
                req.setAttribute("error", "Only admins can delete menu items.");
                req.getRequestDispatcher("menuList.jsp").forward(req, resp);
                return;
            }
            String id = req.getParameter("id");
            String restaurantId = req.getParameter("restaurantId");
            if (id == null || id.trim().isEmpty() || restaurantId == null || restaurantId.trim().isEmpty()) {
                System.err.println("Delete failed: Missing id or restaurantId, id=" + id + ", restaurantId=" + restaurantId);
                req.setAttribute("error", "Invalid delete request: Missing ID or restaurant ID.");
                req.getRequestDispatcher("menuList.jsp").forward(req, resp);
                return;
            }
            System.out.println("Deleting menu item with ID: " + id);
            List<String> updatedMenuItems = new ArrayList<>();
            boolean found = false;
            for (String menuData : menuItems) {
                try {
                    MenuItem menuItem = MenuItem.fromString(menuData);
                    if (!menuItem.getId().equals(id)) {
                        updatedMenuItems.add(menuData);
                    } else {
                        found = true;
                        String imagePath = menuItem.getImageUrl();
                        if (imagePath != null && !imagePath.trim().isEmpty()) {
                            String realPath = getServletContext().getRealPath("/data/" + imagePath);
                            if (realPath != null) {
                                File imageFile = new File(realPath);
                                if (imageFile.exists()) {
                                    boolean deleted = imageFile.delete();
                                    System.out.println("Image file deletion " + (deleted ? "succeeded" : "failed") + ": " + imagePath);
                                } else {
                                    System.out.println("Image file not found on disk: " + realPath);
                                }
                            } else {
                                System.err.println("Real path is null for image: " + imagePath);
                            }
                        } else {
                            System.out.println("No image path to delete for menu item ID: " + id);
                        }
                    }
                } catch (IllegalArgumentException e) {
                    System.err.println("Error parsing menu item during delete: " + e.getMessage());
                }
            }
            if (found) {
                try {
                    FileUtils.rewriteFile(getServletContext(), FILE_NAME, updatedMenuItems);
                    System.out.println("Menu item deleted successfully, ID: " + id);
                    redirectToMenuList(req, resp, restaurantId);
                } catch (IOException e) {
                    System.err.println("Error rewriting menu file: " + e.getMessage());
                    req.setAttribute("error", "Error deleting menu item: " + e.getMessage());
                    req.getRequestDispatcher("menuList.jsp").forward(req, resp);
                }
            } else {
                System.err.println("Menu item not found for deletion, ID: " + id);
                req.setAttribute("error", "Menu item not found for deletion.");
                req.getRequestDispatcher("menuList.jsp").forward(req, resp);
            }
        }
    }

    // Helper method to redirect to the menu list page after create/update/delete
    private void redirectToMenuList(HttpServletRequest req, HttpServletResponse resp, String restaurantId) throws ServletException, IOException {
        List<MenuItem> updatedMenuItemList = new ArrayList<>();
        try {
            List<String> allMenuItems = FileUtils.readFromFile(getServletContext(), FILE_NAME);
            for (String menuData : allMenuItems) {
                try {
                    MenuItem item = MenuItem.fromString(menuData);
                    if (item.getRestaurantId().equals(restaurantId)) {
                        updatedMenuItemList.add(item);
                    }
                } catch (IllegalArgumentException e) {
                    System.err.println("Error parsing menu item after operation: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading menu file after operation: " + e.getMessage());
            req.setAttribute("error", "Error loading menu items: " + e.getMessage());
        }
        req.setAttribute("menuItems", updatedMenuItemList);
        req.setAttribute("restaurantId", restaurantId);
        req.getRequestDispatcher("menuList.jsp").forward(req, resp);
    }
}
