<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, model.Review" %>
<html>
<head>
    <title>Restaurant Reviews</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-r from-blue-100 to-purple-100 min-h-screen flex flex-col">
    <nav class="bg-blue-600 p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <a href="home.jsp" class="text-white text-2xl font-bold">Food Delivery</a>
            <div class="space-x-4">
                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Restaurant Reviews</h2>
            <%
                List<Review> reviews = (List<Review>) request.getAttribute("reviews");
                Map<String, String> userNames = (Map<String, String>) request.getAttribute("userNames");
                if (reviews == null || reviews.isEmpty()) {
            %>
                <p class="text-gray-600 text-center">No reviews available for this restaurant.</p>
            <%
                } else {
            %>
                <div class="space-y-4">
                    <%
                        for (Review review : reviews) {
                    %>
                        <div class="border p-4 rounded-lg bg-gray-50">
                            <p class="text-sm text-gray-500">Reviewed by: <%= userNames.getOrDefault(review.getUserId(), "Unknown User") %></p>
                            <p class="text-sm text-gray-500">Date: <%= review.getTimestamp() %></p>
                            <p class="text-yellow-500">Rating: <%= String.format("%.1f", review.getRating()) %>/5</p>
                            <p class="mt-2"><%= review.getComment() != null && !review.getComment().isEmpty() ? review.getComment() : "No comment provided." %></p>
                        </div>
                    <%
                        }
                    %>
                </div>
            <%
                }
            %>
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>
</body>
</html>