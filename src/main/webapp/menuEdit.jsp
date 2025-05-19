<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MenuItem" %>
<html>
<head>
    <title>Edit Menu Item</title>
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
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Edit Menu Item</h2>
            <%
                String error = (String) request.getAttribute("error");
                MenuItem menuItem = (MenuItem) request.getAttribute("menuItem");
                if (error != null) {
            %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                <%= error %>
            </div>
            <%
                }
                if (menuItem != null) {
            %>
            <form action="menu" method="post" enctype="multipart/form-data" class="space-y-4">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= menuItem.getId() %>">
                <input type="hidden" name="restaurantId" value="<%= menuItem.getRestaurantId() %>">
                <div>
                    <label for="dishName" class="block text-sm font-medium text-gray-700">Dish Name</label>
                    <input type="text" id="dishName" name="dishName" value="<%= menuItem.getDishName() %>" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required>
                </div>
                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea id="description" name="description" rows="3" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required><%= menuItem.getDescription() %></textarea>
                </div>
                <div>
                    <label for="price" class="block text-sm font-medium text-gray-700">Price</label>
                    <input type="number" step="0.01" id="price" name="price" value="<%= menuItem.getPrice() %>" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" required>
                </div>
                <div>
                    <label for="image" class="block text-sm font-medium text-gray-700">Image (Leave empty to keep current image)</label>
                    <input type="file" id="image" name="image" accept="image/*" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500">
                    <p class="text-gray-500 mt-1">Current Image: <a href="<%= request.getContextPath() + "/data/" + menuItem.getImageUrl() %>" target="_blank"><%= menuItem.getImageUrl() %></a></p>
                </div>
                <div class="flex space-x-4">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Update Menu Item</button>
                    <a href="menu?action=list&restaurantId=<%= menuItem.getRestaurantId() %>" class="bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700 transition">Cancel</a>
                </div>
            </form>
            <%
                } else {
            %>
            <p class="text-center text-gray-600">Menu item not found.</p>
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