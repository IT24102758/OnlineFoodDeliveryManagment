<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order, model.Review, utils.FileUtils, java.util.List, java.util.ArrayList, java.io.IOException" %>
<html>
<head>
    <title>Order History - Food Bridge Network</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container {
            margin-top: 5rem;
            margin-bottom: 5rem;
        }

        h2 {
            color: #4b5563; /* gray-600 */
            font-weight: bold;
        }

        .table {
            background: #fefcbf; /* Pastel yellow */
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
            margin: 0 auto; /* Center the table */
            width: 90%; /* Ensure it doesn't stretch too wide */
        }

        .table th,
        .table td {
            vertical-align: middle;
            color: #4b5563; /* gray-600 */
            padding: 1rem; /* Increased padding for better spacing */
            text-align: center; /* Center-aligned text */
            border-bottom: 1px solid #e5e7eb; /* Line to separate rows */
        }

        .table th {
            background-color: #f97316;
            color: white;
            font-weight: 600; /* Bold header text */
        }

        .table-hover tbody tr {
            transition: background-color 0.2s ease;
        }

        .table-hover tbody tr:hover {
            background-color: #e9ecef;
            transform: scale(1.01); /* Slight scale on hover */
        }

        .btn-action {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            color: #ffffff; /* White */
            border: none;
            padding: 0.5rem;
            border-radius: 50px;
            font-weight: 500;
            transition: background-color 0.3s, transform 0.2s ease;
            margin-right: 5px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 2rem; /* Smaller width for icon buttons */
            height: 2rem; /* Uniform height */
        }

        .btn-action:hover {
            background-color: #d69e2e; /* Darker yellow for hover */
            transform: scale(1.05); /* Match splash screen hover effect */
        }

        .btn-action:active {
            animation: clickScale 0.1s ease;
        }

        .btn-back {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: #ffffff; /* White */
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 500;
            transition: transform 0.2s ease;
        }

        .btn-back:hover {
            transform: scale(1.05); /* Match splash screen hover effect */
        }

        .btn-back:active {
            animation: clickScale 0.1s ease;
        }

        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
            color: #4b5563; /* gray-600 */
        }

        footer {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: #ffffff; /* White text */
            padding: 2rem 0;
            margin-top: auto;
        }

        footer a {
            color: #eab308; /* Yellow-500 to match splash screen accents */
            text-decoration: none;
        }

        footer a:hover {
            text-decoration: underline;
            color: #d69e2e; /* Darker yellow for hover */
        }

        @keyframes clickScale {
            0% { transform: scale(1); }
            50% { transform: scale(0.95); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <%
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Order> allOrders = new ArrayList<>();
        try {
            List<String> orderData = FileUtils.readFromFile(application, "orders.txt");
            for (String line : orderData) {
                try {
                    Order order = Order.fromString(line);
                    allOrders.add(order);
                } catch (IllegalArgumentException e) {
                    System.err.println("Error parsing order: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading orders.txt: " + e.getMessage());
        }

        List<Order> userOrders = new ArrayList<>();
        for (Order order : allOrders) {
            if (order.getUserId().equals(userId)) {
                userOrders.add(order);
            }
        }

        List<Review> reviews = new ArrayList<>();
        try {
            List<String> reviewData = FileUtils.readFromFile(application, "reviews.txt");
            for (String line : reviewData) {
                try {
                    Review review = Review.fromString(line);
                    reviews.add(review);
                } catch (IllegalArgumentException e) {
                    System.err.println("Error parsing review: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading reviews.txt: " + e.getMessage());
        }
    %>

    <!-- Header -->
    <header class="bg-white p-4 flex justify-between items-center shadow-md">
        <div class="flex items-center">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold text-yellow-500">Food Bridge Network</span>
        </div>
        <nav class="space-x-4">
            <a href="home.jsp" class="text-gray-600 hover:text-yellow-500">Home</a>
            <a href="user.jsp?action=read" class="text-gray-600 hover:text-yellow-500">Profile</a>
            <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500">Support</a>
            <a href="orderHistory.jsp" class="text-gray-600 hover:text-yellow-500 font-semibold">Order History</a>
            <a href="logout.jsp" class="bg-white text-gray-600 border border-gray-300 px-4 py-2 rounded hover:bg-gray-100">Logout</a>
        </nav>
    </header>

    <div class="container">
        <h2 class="text-center mb-4">Your Order History</h2>

        <%
            String successMessage = request.getParameter("success");
            String errorMessage = request.getParameter("error");
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
            <div class="alert alert-success text-center">
                <%= successMessage %>
            </div>
        <%
            }
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
            <div class="alert alert-danger text-center">
                <%= errorMessage %>
            </div>
        <%
            }

            if (userOrders.isEmpty()) {
        %>
        <div class="alert alert-info text-center">
            You have no previous orders.
        </div>
        <%
            } else {
        %>
        <div class="table-responsive">
            <table class="table table-hover table-bordered">
                <thead>
                    <tr>
                        <th class="py-3 px-6">Order ID</th>
                        <th class="py-3 px-6">Order Date</th>
                        <th class="py-3 px-6">Status</th>
                        <th class="py-3 px-6">Total Amount</th>
                        <th class="py-3 px-6">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Order order : userOrders) {
                            boolean hasReviewed = false;
                            Review userReview = null;
                            for (Review review : reviews) {
                                if (review.getOrderId().equals(order.getOrderId()) && review.getUserId().equals(userId)) {
                                    hasReviewed = true;
                                    userReview = review;
                                    break;
                                }
                            }
                    %>
                    <tr>
                        <td class="py-3 px-6"><%= order.getOrderId() %></td>
                        <td class="py-3 px-6"><%= order.getOrderDate() %></td>
                        <td class="py-3 px-6">
                            <span class="<%= order.getStatus().equals("Delivered") ? "text-green-600" : "text-yellow-600" %>">
                                <%= order.getStatus() %>
                            </span>
                        </td>
                        <td class="py-3 px-6">$<%= String.format("%.2f", order.getTotal() + order.getDeliveryFee()) %></td>
                        <td class="py-3 px-6">
                            <a href="order?action=track&orderId=<%= order.getOrderId() %>" class="btn-action">
                                <i class="fas fa-truck"></i>
                            </a>
                            <%
                                if ("Delivered".equals(order.getStatus())) {
                                    if (!hasReviewed) {
                            %>
                                <a href="review?action=submit&orderId=<%= order.getOrderId() %>" class="btn-action">
                                    <i class="fas fa-star"></i>
                                </a>
                            <%
                                    } else {
                            %>
                                <a href="viewUserReview.jsp?reviewId=<%= userReview.getReviewId() %>" class="btn-action">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="review?action=edit&reviewId=<%= userReview.getReviewId() %>" class="btn-action">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="review" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="reviewId" value="<%= userReview.getReviewId() %>">
                                    <button type="submit" class="btn-action" onclick="return confirm('Are you sure you want to delete this review?');">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            <%
                                    }
                                }
                            %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <%
            }
        %>
        <div class="text-center mt-4">
            <a href="home.jsp" class="btn-back">Back to Home</a>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="flex justify-center mb-4">
                <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                <span class="ml-2 text-xl font-semibold">Food Bridge Network</span>
            </div>
            <div class="mb-4 text-center">
                <h5 class="text-lg font-semibold">Quick Links</h5>
                <ul class="list-none space-y-2 mt-2">
                    <li><a href="home.jsp" class="text-yellow-500 hover:text-yellow-300">Home</a></li>
                    <li><a href="user.jsp?action=read" class="text-yellow-500 hover:text-yellow-300">Profile</a></li>
                    <li><a href="supportRequest.jsp" class="text-yellow-500 hover:text-yellow-300">Support</a></li>
                    <li><a href="logout.jsp" class="text-yellow-500 hover:text-yellow-300">Logout</a></li>
                </ul>
            </div>
            <div class="flex justify-center space-x-4">
                <a href="#" class="text-yellow-500 hover:text-yellow-300"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="text-yellow-500 hover:text-yellow-300"><i class="fab fa-twitter"></i></a>
                <a href="#" class="text-yellow-500 hover:text-yellow-300"><i class="fab fa-instagram"></i></a>
            </div>
            <p class="mt-4 text-sm">© 2025 Food Bridge Network Inc. All Rights Reserved.</p>
        </div>
    </footer>
</body>
</html>