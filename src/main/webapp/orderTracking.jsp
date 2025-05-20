<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order, utils.FileUtils, java.util.List, java.util.ArrayList, java.io.IOException" %>
<html>
<head>
    <title>Order Tracking - Food Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
        /* Card Styling */
        .card {
            background: #fefcbf; /* Pastel yellow to match splash screen cards */
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
        }
        .text-dark, .text-muted {
            color: #2c3e50 !important; /* Ensure contrast with pastel yellow background */
        }
        .btn-primary, .btn-secondary {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            border: none;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .btn-primary:hover, .btn-secondary:hover {
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
                    <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
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
                            <a class="nav-link" href="order?action=summary">Order Summary</a>
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

    <div class="container mt-5">
        <h2 class="text-center mb-4" style="color: #2c3e50; font-weight: bold;">Track Your Order</h2>
        <%
            String orderId = (String) request.getAttribute("orderId");
            if (orderId == null) {
        %>
        <div class="alert alert-warning">No order ID provided.</div>
        <%
                return;
            }

            List<Order> orders = new ArrayList<>();
            try {
                List<String> orderData = FileUtils.readFromFile(application, "orders.txt");
                for (String line : orderData) {
                    try {
                        orders.add(Order.fromString(line));
                    } catch (IllegalArgumentException e) {
                        System.err.println("Error parsing order: " + e.getMessage());
                    }
                }
            } catch (IOException e) {
                System.err.println("Error reading orders.txt: " + e.getMessage());
            }

            Order order = orders.stream().filter(o -> o.getOrderId().equals(orderId)).findFirst().orElse(null);
            if (order == null) {
        %>
        <div class="alert alert-danger">Order not found.</div>
        <%
                return;
            }
        %>
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Order #<%= order.getOrderId() %></h5>
                <p><strong>Subtotal:</strong> $<%= String.format("%.2f", order.getTotal()) %></p>
                <p><strong>Delivery Fee:</strong> $<%= String.format("%.2f", order.getDeliveryFee()) %></p>
                <p><strong>Final Total (with Delivery):</strong> $<%= String.format("%.2f", order.getFinalTotal()) %></p>
                <p><strong>Placed On:</strong> <%= order.getOrderDate() %></p>
                <p><strong>Status:</strong> <%= order.getStatus() %></p>
                <div class="progress mt-3">
                    <div class="progress-bar" role="progressbar" style="width: <%= getProgressPercentage(order.getStatus()) %>%;" aria-valuenow="<%= getProgressPercentage(order.getStatus()) %>" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <p class="mt-2">Status Progress: <%= getStatusDescription(order.getStatus()) %></p>
            </div>
        </div>
        <%
            if ("admin".equals(session.getAttribute("role"))) {
        %>
        <form action="order?action=update" method="post" class="mt-3">
            <input type="hidden" name="orderId" value="<%= orderId %>">
            <select name="status" class="form-select mb-3" required>
                <option value="Pending">Pending</option>
                <option value="Confirmed">Confirmed</option>
                <option value="Prepared">Prepared</option>
                <option value="Out for Delivery">Out for Delivery</option>
                <option value="Delivered">Delivered</option>
            </select>
            <button type="submit" class="btn btn-primary">Update Status</button>
        </form>
        <%
            }
        %>
        <a href="order?action=summary" class="btn btn-secondary mt-3">Back to Order Summary</a>
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
                <span class="block text-xl font-semibold">Pizza Cow</span>
                <p class="text-sm mt-2">© 2025 Food Delivery System. All Rights Reserved.</p>
            </div>
        </div>
    </footer>

    <%!
        private int getProgressPercentage(String status) {
            switch (status) {
                case "Pending": return 25;
                case "Confirmed": return 50;
                case "Prepared": return 75;
                case "Out for Delivery": return 90;
                case "Delivered": return 100;
                default: return 0;
            }
        }

        private String getStatusDescription(String status) {
            switch (status) {
                case "Pending": return "Your order has been received.";
                case "Confirmed": return "Your order has been confirmed.";
                case "Prepared": return "Your order is being prepared.";
                case "Out for Delivery": return "Your order is on its way!";
                case "Delivered": return "Your order has been delivered.";
                default: return "Unknown status.";
            }
        }
    %>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>