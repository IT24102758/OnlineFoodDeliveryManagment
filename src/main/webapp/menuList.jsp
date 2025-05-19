<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MenuItem" %>
<html>
<head>
    <title>Menu</title>
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
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Menu</h2>
            <%
                String role = (String) session.getAttribute("role");
                String restaurantId = (String) request.getAttribute("restaurantId");
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                <%= error %>
            </div>
            <%
                }
                if ("admin".equals(role)) {
            %>
            <div class="mb-4 flex space-x-4">
                <a href="menu?action=add&restaurantId=<%= restaurantId %>" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition">Add New Menu Item</a>
                <a href="menuManagement.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Back to Menu Management</a>
                <a href="cuisineSelection?action=cuisine" class="bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700 transition">Back to Cuisine Selection</a>
            </div>
            <%
                } else {
            %>
            <div class="mb-4">
                <a href="cuisineSelection?action=cuisine" class="bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700 transition">Back to Cuisine Selection</a>
            </div>
            <%
                }
            %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <%
                    List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
                    if (menuItems != null && !menuItems.isEmpty()) {
                        for (MenuItem menuItem : menuItems) {
                %>
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <img src="<%= request.getContextPath() + "/data/" + menuItem.getImageUrl() %>" alt="<%= menuItem.getDishName() %>" class="w-full h-48 object-cover rounded-md mb-4">
                    <h3 class="text-lg font-semibold text-blue-600"><%= menuItem.getDishName() %></h3>
                    <p class="text-gray-600"><%= menuItem.getDescription() %></p>
                    <p class="text-gray-600"><strong>Price:</strong> $<%= String.format("%.2f", menuItem.getPrice()) %></p>
                    <div class="mt-4 flex space-x-2">
                        <%
                            if ("admin".equals(role)) {
                        %>
                        <a href="menu?action=edit&id=<%= menuItem.getId() %>" class="bg-yellow-600 text-white px-4 py-2 rounded-md hover:bg-yellow-700 transition">Edit</a>
                        <form action="menu" method="post" onsubmit="return confirm('Are you sure you want to delete this menu item?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= menuItem.getId() %>">
                            <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
                            <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">Delete</button>
                        </form>
                        <%
                            } else {
                        %>
                        <a href="#" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Add to Cart</a>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <p class="text-center text-gray-600 col-span-3">No menu items available for this restaurant.</p>
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