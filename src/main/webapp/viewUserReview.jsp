<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Review, utils.FileUtils, java.util.List, java.util.ArrayList, java.io.IOException" %>
<html>
<head>
    <title>View Review - Pizza Cow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .bg-orange-gradient {
            background: linear-gradient(90deg, #f97316, #fdba74);
        }
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container {
            margin-top: 5rem;
            margin-bottom: 5rem;
        }
        .card {
            background-color: #fefcbf; /* Pastel yellow to match splash screen cards */
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
        }
        .text-dark {
            color: #2c3e50 !important; /* Ensure contrast with pastel yellow background */
        }
        header {
            background: #ffffff; /* White background like splash screen */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: #eab308; /* Yellow-500 for brand text */
        }
        .nav-link {
            font-size: 1.1rem;
            padding: 0.5rem 1rem;
            color: #4b5563; /* Gray-600 like splash screen */
        }
        .nav-link:hover {
            color: #eab308; /* Yellow-500 on hover */
        }
        .btn-back {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            color: #ffffff;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .btn-back:hover {
            background-color: #d69e2e; /* Darker yellow for hover */
            transform: scale(1.05); /* Match splash screen hover effect */
        }
        footer {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Match splash screen gradient */
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
    </style>
</head>
<body class="bg-orange-gradient">
    <%
        // Check if the user is logged in
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the reviewId from the request
        String reviewId = request.getParameter("reviewId");
        Review review = null;
        if (reviewId != null && !reviewId.trim().isEmpty()) {
            try {
                List<String> reviewData = FileUtils.readFromFile(application, "reviews.txt");
                for (String line : reviewData) {
                    try {
                        Review r = Review.fromString(line);
                        if (r.getReviewId().equals(reviewId) && r.getUserId().equals(userId)) {
                            review = r;
                            break;
                        }
                    } catch (IllegalArgumentException e) {
                        System.err.println("Error parsing review: " + e.getMessage());
                    }
                }
            } catch (IOException e) {
                System.err.println("Error reading reviews.txt: " + e.getMessage());
            }
        }

        if (review == null) {
            response.sendRedirect("order?action=history&error=" + java.net.URLEncoder.encode("Review not found or you do not have permission to view it.", "UTF-8"));
            return;
        }
    %>

    <!-- Header -->
    <header>
        <nav class="p-4">
            <div class="container mx-auto flex justify-between items-center">
                <a href="home.jsp" class="navbar-brand">
                    <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                    <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
                </a>
                <div class="space-x-4">
                    <a href="logout.jsp" class="nav-link">Logout</a>
                </div>
            </div>
        </nav>
    </header>

    <div class="container">
        <h2 class="text-center mb-4 text-dark">Your Review</h2>
        <div class="card mx-auto" style="max-width: 500px;">
            <h5 class="text-dark font-bold">Order ID: <%= review.getOrderId() %></h5>
            <div class="mt-3">
                <p class="text-dark"><strong>Rating:</strong> <%= review.getRating() %> / 5</p>
                <p class="text-dark"><strong>Comment:</strong> <%= review.getComment() != null && !review.getComment().isEmpty() ? review.getComment() : "No comment provided." %></p>
                <p class="text-dark"><strong>Submitted On:</strong> <%= review.getTimestamp() %></p>
            </div>
            <div class="text-center mt-4">
                <a href="order?action=history" class="btn-back">Back to Order History</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container mx-auto text-center">
            <div class="flex justify-center mb-4">
                <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                <span class="ml-2 text-xl font-semibold">Pizza Cow</span>
            </div>
            <div class="mb-4">
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
            <p class="mt-4 text-sm">© 2025 Pizza Cow Inc. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</body>
</html>