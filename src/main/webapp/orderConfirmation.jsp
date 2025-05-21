<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order, model.MenuItem, utils.FileUtils, java.util.List, java.util.ArrayList, java.util.Map, java.util.stream.Collectors" %>
<html>
<head>
    <title>Order Confirmation - Food Delivery</title>
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
        /* Main Section Styling */
        .confirmation-container {
            background: #fefcbf; /* Pastel yellow to match splash screen cards */
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
        }
        .text-dark, .text-muted {
            color: #2c3e50 !important; /* Ensure contrast with pastel yellow background */
        }
        .btn-primary, .btn-success {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            border: none;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .btn-primary:hover, .btn-success:hover {
            background-color: #d69e2e; /* Darker yellow for hover */
            transform: scale(1.05); /* Match splash screen hover effect */
        }
        .btn-secondary {
            background-color: #6c757d; /* Keep secondary button as is for contrast */
            border: none;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            transform: scale(1.05);
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
                            <a class="nav-link" href="#">Support</a>
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

    <%
        // Retrieve query parameters
        String orderId = request.getParameter("orderId");
        String total = request.getParameter("total");
        String timestamp = request.getParameter("timestamp");
        String status = request.getParameter("status");

        // Validate query parameters
        if (orderId == null || total == null || timestamp == null || status == null) {
            response.sendRedirect("home.jsp");
            return;
        }

        // Load the order details from orders.txt
        Order order = null;
        List<Order> orders = new ArrayList<>();
        try {
            List<String> orderData = FileUtils.readFromFile(application, "orders.txt");
            for (String line : orderData) {
                try {
                    Order tempOrder = Order.fromString(line);
                    if (tempOrder.getOrderId().equals(orderId)) {
                        order = tempOrder;
                    }
                    orders.add(tempOrder);
                } catch (IllegalArgumentException e) {
                    System.err.println("Error parsing order: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.err.println("Error reading orders.txt: " + e.getMessage());
        }

        // If order not found, redirect to home
        if (order == null) {
            response.sendRedirect("home.jsp");
            return;
        }

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

        // Get user details from the Order object and session
        String userId = (String) session.getAttribute("userId");
        String deliveryAddress = order.getDeliveryAddress();
        String district = order.getBillingDistrict(); // Use billingDistrict from Order instead of session
        String phoneNumber = order.getPhone(); // Fixed: Use getPhone() instead of getPhoneNumber()
        String email = order.getEmail();
        String paymentStatus = order.getPaymentStatus();
        String paymentMethod = order.getPaymentMethod();
    %>

    <div class="container my-5">
        <div class="confirmation-container rounded p-4 max-w-2xl mx-auto">
            <!-- Header -->
            <div class="text-center mb-4">
                <i class="fas fa-check-circle text-success" style="font-size: 3rem;"></i>
                <h1 class="h3 font-weight-bold text-dark mt-2">Order Confirmed!</h1>
                <p class="text-muted">Thank you for your order. Here are the details:</p>
            </div>

            <!-- Order Details -->
            <div class="border-top border-bottom py-3 mb-4">
                <h2 class="h5 font-weight-bold text-dark mb-3">Order Summary</h2>
                <div class="row">
                    <div class="col-md-6">
                        <p class="text-muted"><strong>Order ID:</strong> <%= orderId %></p>
                        <p class="text-muted"><strong>Order Date:</strong> <%= timestamp %></p>
                        <p class="text-muted"><strong>Status:</strong> <span class="text-success"><%= status %></span></p>
                        <p class="text-muted"><strong>Payment Status:</strong> <%= paymentStatus != null ? paymentStatus : "Not provided" %></p>
                        <p class="text-muted"><strong>Payment Method:</strong> <%= paymentMethod != null ? paymentMethod : "Not provided" %></p>
                    </div>
                    <div class="col-md-6">
                        <p class="text-muted"><strong>Total Amount:</strong> $<%= String.format("%.2f", Double.parseDouble(total)) %></p>
                        <p class="text-muted"><strong>Delivery Address:</strong> <%= deliveryAddress != null && !deliveryAddress.isEmpty() ? deliveryAddress : "Not provided" %></p>
                        <p class="text-muted"><strong>District:</strong> <%= district != null && !district.isEmpty() ? district : "Not provided" %></p>
                        <p class="text-muted"><strong>Phone Number:</strong> <%= phoneNumber != null && !phoneNumber.isEmpty() ? phoneNumber : "Not provided" %></p>
                        <p class="text-muted"><strong>Email:</strong> <%= email != null && !email.isEmpty() ? email : "Not provided" %></p>
                    </div>
                </div>
            </div>

            <!-- Ordered Items -->
            <div class="mb-4">
                <h2 class="h5 font-weight-bold text-dark mb-3">Items Ordered</h2>
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
            <div class="d-flex flex-column flex-md-row justify-content-between gap-2">
                <a href="order?action=track&orderId=<%= orderId %>" class="btn btn-primary w-100 w-md-auto">Track Order</a>
                <a href="order?action=summary" class="btn btn-success w-100 w-md-auto">View Order Summary</a>
                <a href="home.jsp" class="btn btn-secondary w-100 w-md-auto">Back to Home</a>
            </div>
        </div>
    </div>

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
                <p class="text-sm mt-2">© 2025 Food Delivery System. All Rights Reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>