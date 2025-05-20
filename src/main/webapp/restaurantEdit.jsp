<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Restaurant" %>
<%@ page import="model.RestaurantType" %>
<html>
<head>
    <title>Edit Restaurant</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-r from-blue-100 to-purple-100 min-h-screen flex flex-col">
    <nav class="bg-blue-600 p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <a href="#" class="text-white text-2xl font-bold">Food Delivery</a>
            <div class="space-x-4">
                <%
                    String role = (String) session.getAttribute("role");
                    if ("admin".equals(role)) {
                %>
                <a href="dashboard.jsp" class="text-white hover:text-blue-200">Dashboard</a>
                <a href="userlist.jsp" class="text-white hover:text-blue-200">Users</a>
                <%
                    } else {
                %>
                <a href="home.jsp" class="text-white hover:text-blue-200">Home</a>
                <%
                    }
                %>
                <a href="restaurant?action=list" class="text-white hover:text-blue-200">Restaurants</a>
                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="max-w-md mx-auto bg-white p-8 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Edit Restaurant</h2>
            <% if (request.getAttribute("error") != null) { %>
                <p class="text-red-500 text-center mb-4"><%= request.getAttribute("error") %></p>
            <% } %>
            <%
                Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
                if (restaurant != null) {
            %>
            <form action="restaurant" method="post" class="space-y-4">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= restaurant.getId() %>">
                <div>
                    <label for="name" class="block text-sm font-medium text-gray-700">Restaurant Name</label>
                    <input type="text" id="name" name="name" value="<%= restaurant.getName() %>" required class="mt-1 block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label for="location" class="block text-sm font-medium text-gray-700">Location</label>
                    <input type="text" id="location" name="location" value="<%= restaurant.getLocation() %>" required class="mt-1 block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label for="cuisineType" class="block text-sm font-medium text-gray-700">Cuisine Type</label>
                    <select id="cuisineType" name="cuisineType" required class="mt-1 block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <%
                            for (RestaurantType type : RestaurantType.values()) {
                        %>
                        <option value="<%= type.name() %>" <%= restaurant.getCuisineType() == type ? "selected" : "" %>><%= type.name() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label for="contactInfo" class="block text-sm font-medium text-gray-700">Contact Info</label>
                    <input type="text" id="contactInfo" name="contactInfo" value="<%= restaurant.getContactInfo() %>" required class="mt-1 block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label for="operationHours" class="block text-sm font-medium text-gray-700">Operation Hours</label>
                    <input type="text" id="operationHours" name="operationHours" value="<%= restaurant.getOperationHours() %>" required class="mt-1 block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="text-center">
                    <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition">Save Changes</button>
                    <a href="restaurant?action=list" class="ml-4 text-blue-600 hover:underline">Cancel</a>
                </div>
            </form>
            <% } else { %>
            <p class="text-center text-red-600">Restaurant not found.</p>
            <% } %>
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>
</body>
</html>