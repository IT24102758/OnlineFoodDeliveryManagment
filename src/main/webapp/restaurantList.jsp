<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Restaurant" %>
<html>
<head>
    <title>Restaurant List</title>
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
                    } else if ("restaurant".equals(role)) {
                %>
                <a href="restaurantDashboard.jsp" class="text-white hover:text-blue-200">Dashboard</a>
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
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Restaurants</h2>
            <div class="mb-6 flex justify-between items-center">
                <div class="relative flex items-center space-x-2">
                    <div class="relative w-full max-w-md">
                        <input type="text" id="searchInput" placeholder="Search by name, cuisine, or location..."
                               value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>"
                               class="p-2 pl-10 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 w-full"
                               onkeyup="filterRestaurants()">
                        <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                    </div>
                </div>
                <% if ("admin".equals(role)) { %>
                <a href="restaurant?action=register" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition">Add Restaurant</a>
                <% } %>
            </div>
            <div id="restaurantGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <%
                    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
                    if (restaurants != null && !restaurants.isEmpty()) {
                        for (Restaurant restaurant : restaurants) {
                            boolean canEdit = "admin".equals(role);
                %>
                <div class="restaurant-card bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition"
                     data-name="<%= restaurant.getName().toLowerCase() %>"
                     data-cuisine="<%= restaurant.getCuisineType().toString().toLowerCase() %>"
                     data-location="<%= restaurant.getLocation().toLowerCase() %>">
                    <h3 class="text-lg font-semibold text-blue-600"><%= restaurant.getName() %></h3>
                    <p class="text-gray-600">Location: <%= restaurant.getLocation() %></p>
                    <p class="text-gray-600">Cuisine: <%= restaurant.getCuisineType() %></p>
                    <p class="text-gray-600">Contact: <%= restaurant.getContactInfo() %></p>
                    <p class="text-gray-600">Hours: <%= restaurant.getOperationHours() %></p>
                    <% if (canEdit) { %>
                    <div class="mt-4 flex space-x-2">
                        <a href="restaurant?action=edit&id=<%= restaurant.getId() %>" class="bg-yellow-500 text-white px-3 py-1 rounded-md hover:bg-yellow-600 transition">Edit</a>
                        <form action="restaurant" method="post" onsubmit="return confirm('Are you sure you want to delete this restaurant?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= restaurant.getId() %>">
                            <button type="submit" class="bg-red-500 text-white px-3 py-1 rounded-md hover:bg-red-600 transition">Delete</button>
                        </form>
                    </div>
                    <% } %>
                </div>
                <%
                        }
                    } else {
                %>
                <p id="noResults" class="text-center text-gray-600 col-span-3">No restaurants found.</p>
                <% } %>
            </div>
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>

    <script>
        function filterRestaurants() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            const restaurantCards = document.getElementsByClassName('restaurant-card');
            const noResultsMessage = document.getElementById('noResults');
            let hasVisibleCards = false;

            for (let i = 0; i < restaurantCards.length; i++) {
                const card = restaurantCards[i];
                const name = card.getAttribute('data-name');
                const cuisine = card.getAttribute('data-cuisine');
                const location = card.getAttribute('data-location');

                if (searchInput === '' ||
                    name.includes(searchInput) ||
                    cuisine.includes(searchInput) ||
                    location.includes(searchInput)) {
                    card.style.display = 'block';
                    hasVisibleCards = true;
                } else {
                    card.style.display = 'none';
                }
            }

            if (noResultsMessage) {
                noResultsMessage.style.display = hasVisibleCards ? 'none' : 'block';
            }
        }

        document.addEventListener('DOMContentLoaded', filterRestaurants);
    </script>
</body>
</html>