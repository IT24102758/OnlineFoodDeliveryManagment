<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, model.Review" %>
<html>
<head>
    <title>Manage Reviews</title>
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
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Manage Reviews</h2>
            <%
                String successMessage = (String) request.getAttribute("success");
                String errorMessage = (String) request.getAttribute("error");
                if (successMessage != null && !successMessage.isEmpty()) {
            %>
                <p class="text-green-600 text-center mb-4"><%= successMessage %></p>
            <%
                }
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <p class="text-red-600 text-center mb-4"><%= errorMessage %></p>
            <%
                }
                List<Review> reviews = (List<Review>) request.getAttribute("reviews");
                Map<String, String> userNames = (Map<String, String>) request.getAttribute("userNames");
                Map<String, String> restaurantNames = (Map<String, String>) request.getAttribute("restaurantNames");
                if (reviews == null || reviews.isEmpty()) {
            %>
                <p class="text-gray-600 text-center">No reviews available.</p>
            <%
                } else {
            %>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-gray-50 rounded-lg shadow-md">
                        <thead>
                            <tr class="bg-blue-600 text-white">
                                <th class="py-3 px-4 text-left">Review ID</th>
                                <th class="py-3 px-4 text-left">Order ID</th>
                                <th class="py-3 px-4 text-left">User</th>
                                <th class="py-3 px-4 text-left">Restaurant</th>
                                <th class="py-3 px-4 text-left">Rating</th>
                                <th class="py-3 px-4 text-left">Comment</th>
                                <th class="py-3 px-4 text-left">Date</th>
                                <th class="py-3 px-4 text-left">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Review review : reviews) {
                            %>
                                <tr class="border-b hover:bg-gray-100">
                                    <td class="py-3 px-4"><%= review.getReviewId() %></td>
                                    <td class="py-3 px-4"><%= review.getOrderId() %></td>
                                    <td class="py-3 px-4"><%= userNames.getOrDefault(review.getUserId(), "Unknown User") %></td>
                                    <td class="py-3 px-4"><%= restaurantNames.getOrDefault(review.getRestaurantId(), "Unknown Restaurant") %></td>
                                    <td class="py-3 px-4"><%= String.format("%.1f", review.getRating()) %>/5</td>
                                    <td class="py-3 px-4"><%= review.getComment() != null && !review.getComment().isEmpty() ? review.getComment() : "No comment" %></td>
                                    <td class="py-3 px-4"><%= review.getTimestamp() %></td>
                                    <td class="py-3 px-4 space-x-2">

                                        <form action="review" method="post" class="inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                            <button type="submit" class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600"
                                                    onclick="return confirm('Are you sure you want to delete this review?');">Delete</button>
                                        </form>
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
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>
</body>
</html>