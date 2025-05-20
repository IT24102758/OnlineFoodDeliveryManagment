<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Restaurant" %>
<%@ page import="utils.FileUtils" %>
<html>
<head>
    <title>Menu Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-r from-blue-100 to-purple-100 min-h-screen flex flex-col">
    <nav class="bg-blue-600 p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <a href="#" class="text-white text-2xl font-bold">Food Delivery</a>
            <div class="space-x-4">
                <a href="adminDashboard.jsp" class="text-white hover:text-blue-200">Dashboard</a>
                <a href="user?action=read" class="text-white hover:text-blue-200">Manage Users</a>
                <a href="restaurant?action=list" class="text-white hover:text-blue-200">Manage Restaurants</a>
                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Menu Management</h2>
            <div class="mb-4">
                <a href="dashboard.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Back to Dashboard</a>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <%
                    // Load restaurants from file
                    List<String> restaurantDataList = FileUtils.readFromFile(application, "restaurants.txt");
                    if (restaurantDataList != null && !restaurantDataList.isEmpty()) {
                        for (String restaurantData : restaurantDataList) {
                            try {
                                Restaurant restaurant = Restaurant.fromString(restaurantData);
                %>
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-lg font-semibold text-blue-600"><%= restaurant.getName() %></h3>
                    <p class="text-gray-600"><strong>Cuisine:</strong> <%= restaurant.getCuisineType() %></p>
                    <p class="text-gray-600"><strong>Location:</strong> <%= restaurant.getLocation() %></p>
                    <div class="mt-4 flex space-x-2">
                        <a href="menu?action=add&restaurantId=<%= restaurant.getId() %>" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition">Add Menu</a>
                        <a href="menu?action=list&restaurantId=<%= restaurant.getId() %>" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">View Menu</a>
                    </div>
                </div>
                <%
                            } catch (IllegalArgumentException e) {
                                e.printStackTrace();
                            }
                        }
                    } else {
                %>
                <p class="text-center text-gray-600 col-span-3">No restaurants available.</p>
                <%
                    }
                %>
            </div>
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>
</body>
</html>