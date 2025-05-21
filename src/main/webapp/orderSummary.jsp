<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order, model.MenuItem, utils.FileUtils, java.util.List, java.util.ArrayList, java.util.Map" %>
<html>
<head>
    <title>Order Summary - Food Delivery</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Custom CSS -->
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Match splash screen gradient */
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        /* Header Styling to Match Splash Screen */
        header {
            background: #ffffff; /* White background like splash screen */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: #eab308; /* Yellow-500 for brand text */
        }
        .navbar-nav .nav-link {
            font-size: 1.1rem;
            padding: 0.5rem 1rem;
            color: #4b5563; /* Gray-600 like splash screen */
        }
        .navbar-nav .nav-link:hover {
            color: #eab308; /* Yellow-500 on hover */
        }
        .order-card {
            background: #fefcbf; /* Pastel yellow to match splash screen cards */
            transition: transform 0.2s;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
        }
        .order-card:hover {
            transform: scale(1.02);
        }
        .text-dark, .text-muted {
            color: #2c3e50 !important; /* Ensure contrast with pastel yellow background */
        }
        .btn-primary, .btn-danger {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            border: none;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .btn-primary:hover, .btn-danger:hover {
            background-color: #d69e2e; /* Darker yellow for hover */
            transform: scale(1.05); /* Match splash screen hover effect */
        }
        /* Footer Styling to Match Splash Screen */
        footer {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Match splash screen gradient */
            padding: 2rem 0;
            margin-top: auto;
            color: #ffffff; /* White text */
        }
        footer a {
            color: #ffffff; /* White links to match splash screen text */
            text-decoration: none;
        }
        footer a:hover {
            text-decoration: underline;
            color: #eab308; /* Yellow-500 on hover for consistency */
        }
    </style>
</head>
<body>
<!-- Header (Navbar) -->
<header>
    <nav class="navbar navbar-expand-lg navbar-light" style="background: #ffffff;">
        <div class="container-fluid">
            <a class="navbar-brand" href="home.jsp">
                <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                <span class="ml-2 text-xl font-semibold text-yellow-500">Food Bridge Network</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="user.jsp?action=read">Profile</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="order?action=summary">Order Summary</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="cart.jsp">
                            <i class="fas fa-shopping-cart"></i> Cart <span id="cart-count" class="badge bg-secondary">0</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>

<!-- Main Content -->
<main class="container my-5">
    <h1 class="text-center mb-4" style="color: #2c3e50; font-weight: bold;">Your Order Summary</h1>

    <%
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the list of orders from the request
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        if (orders == null || orders.isEmpty()) {
    %>
        <div class="text-center text-muted">
            <p>You have no orders yet. Start ordering now!</p>
            <a href="home.jsp" class="btn btn-primary mt-3">Go to Home</a>
        </div>
    <%
        } else {
            // Load menu items to get item details (name, price)
            List<MenuItem> allMenuItems = new ArrayList<>();
            try {
                List<String> menuData = FileUtils.readFromFile(application, "menu.txt");
                for (String line : menuData) {
                    try {
                        allMenuItems.add(MenuItem.fromString(line));
                    } catch (IllegalArgumentException e) {
                        System.err.println("Error parsing menu item: " + e.getMessage());
                    }
                }
            } catch (Exception e) {
                System.err.println("Error reading menu.txt: " + e.getMessage());
            }

            // Display each order
            for (Order order : orders) {
    %>
        <div class="order-card rounded p-4 mb-4">
            <!-- Order Details -->
            <div class="border-bottom pb-3 mb-3">
                <h2 class="h4 font-weight-bold text-dark mb-2">Order #<%= order.getOrderId() %></h2>
                <div class="row">
                    <div class="col-md-6">
                        <p class="text-muted"><strong>Order Date:</strong> <%= order.getOrderDate() %></p>
                        <p class="text-muted"><strong>Status:</strong> <span class="text-success"><%= order.getStatus() %></span></p>
                        <p class="text-muted"><strong>Subtotal:</strong> $<%= String.format("%.2f", order.getTotal()) %></p>
                        <p class="text-muted"><strong>Delivery Charge:</strong> $<%= String.format("%.2f", order.getDeliveryFee()) %></p>
                        <p class="text-muted"><strong>Final Total:</strong> $<%= String.format("%.2f", order.getFinalTotal()) %></p>
                        <p class="text-muted"><strong>Payment Status:</strong> <%= order.getPaymentStatus() %></p>
                        <p class="text-muted"><strong>Payment Method:</strong> <%= order.getPaymentMethod() %></p>
                    </div>
                    <div class="col-md-6">
                        <p class="text-muted"><strong>Delivery Address:</strong> <%= order.getDeliveryAddress() != null && !order.getDeliveryAddress().isEmpty() ? order.getDeliveryAddress() : "Not provided" %></p>
                        <p class="text-muted"><strong>District:</strong> <%= order.getBillingDistrict() != null && !order.getBillingDistrict().isEmpty() ? order.getBillingDistrict() : "Not provided" %></p>
                        <p class="text-muted"><strong>Phone Number:</strong> <%= order.getPhone() != null && !order.getPhone().isEmpty() ? order.getPhone() : "Not provided" %></p>
                        <p class="text-muted"><strong>Email:</strong> <%= order.getEmail() != null && !order.getEmail().isEmpty() ? order.getEmail() : "Not provided" %></p>
                    </div>
                </div>
            </div>

            <!-- Ordered Items -->
            <div>
                <h3 class="h5 font-weight-bold text-dark mb-2">Items Ordered</h3>
                <div>
                    <%
                        List<Map<String, Object>> items = order.getItems();
                        if (items == null || items.isEmpty()) {
                    %>
                        <p class="text-muted">No items found in this order.</p>
                    <%
                        } else {
                            for (Map<String, Object> item : items) {
                                String itemId = (String) item.get("itemId");
                                String restaurantId = (String) item.get("restaurantId");
                                int quantity = (int) item.get("quantity");

                                // Find the menu item details
                                MenuItem menuItem = allMenuItems.stream()
                                    .filter(m -> m.getId().equals(itemId) && m.getRestaurantId().equals(restaurantId))
                                    .findFirst()
                                    .orElse(null);

                                if (menuItem != null) {
                                    double itemTotal = menuItem.getPrice() * quantity;
                    %>
                        <div class="d-flex justify-content-between border-bottom pb-2 mb-2">
                            <div>
                                <p class="text-dark font-weight-medium"><%= menuItem.getDishName() %></p>
                                <p class="text-muted small">Quantity: <%= quantity %></p>
                                <p class="text-muted small">Price: $<%= String.format("%.2f", menuItem.getPrice()) %> each</p>
                            </div>
                            <p class="text-dark font-weight-medium">$<%= String.format("%.2f", itemTotal) %></p>
                        </div>
                    <%
                                } else {
                    %>
                        <div class="text-muted small">Item (ID: <%= itemId %>) not found in menu.</div>
                    <%
                                }
                            }
                        }
                    %>
                </div>
            </div>

            <!-- Actions -->
            <div class="d-flex justify-content-end mt-3 gap-2">
                <a href="order?action=track&orderId=<%= order.getOrderId() %>" class="btn btn-primary btn-sm">
                    Track Order
                </a>
                <% if ("Pending".equals(order.getStatus())) { %>
                    <form action="order" method="post" class="d-inline">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to cancel this order?');">
                            Cancel Order
                        </button>
                    </form>
                <% } %>
            </div>
        </div>
    <%
            }
        }
    %>
</main>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-4 text-center text-md-start mb-3 mb-md-0">
                <h5 class="text-uppercase">Food Delivery</h5>
                <p>Your one-stop platform for ordering food online.</p>
            </div>
            <div class="col-md-4 text-center mb-3 mb-md-0">
                <h5 class="text-uppercase">Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="home.jsp">Home</a></li>
                    <li><a href="user.jsp?action=read">Profile</a></li>
                    <li><a href="#">Support</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                </ul>
            </div>
            <div class="col-md-4 text-center text-md-end">
                <h5 class="text-uppercase">Contact Us</h5>
                <p>Email: <a href="mailto:support@fooddelivery.com">support@fooddelivery.com</a></p>
                <p>Phone: (123) 456-7890</p>
                <div class="mt-2">
                    <a href="#" class="me-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="me-2"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold mx-auto">PC</div>
            <span class="block text-xl font-semibold">Food Bridge Network</span>
            <p class="text-sm mt-2">© 2025 Food Bridge Network. All Rights Reserved.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>