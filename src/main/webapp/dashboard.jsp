<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-r from-blue-100 to-purple-100 min-h-screen flex flex-col">
    <nav class="bg-blue-600 p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <a href="dashboard.jsp" class="text-white text-2xl font-bold">Food Delivery</a>
            <div class="space-x-4">
                <a href="user?action=read" class="text-white hover:text-blue-200">Manage Users</a>
                <a href="restaurant?action=list" class="text-white hover:text-blue-200">Manage Restaurants</a>
                <a href="order?action=adminOrders" class="text-white hover:text-blue-200">Manage Orders</a>
                <a href="delivery?action=manage" class="text-white hover:text-blue-200">Manage Deliveries</a>
                <a href="review?action=manage" class="text-white hover:text-blue-200">Manage Reviews</a>

                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Admin Dashboard</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-lg font-semibold text-blue-600">User Management</h3>
                    <p class="text-gray-600">Manage customer profiles and accounts.</p>
                    <div class="mt-4">
                        <a href="userlist.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Go to Users</a>
                    </div>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-lg font-semibold text-blue-600">Restaurant Management</h3>
                    <p class="text-gray-600">Manage restaurant profiles and listings.</p>
                    <div class="mt-4">
                        <a href="restaurant?action=list" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Go to Restaurants</a>
                    </div>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-lg font-semibold text-blue-600">Menu Management</h3>
                    <p class="text-gray-600">Manage menus for restaurants.</p>
                    <div class="mt-4">
                        <a href="menuManagement.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Go to Menus</a>
                    </div>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-lg font-semibold text-blue-600">Order Management</h3>
                    <p class="text-gray-600">View and manage customer orders.</p>
                    <div class="mt-4">
                        <a href="order?action=adminOrders" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Go to Orders</a>
                    </div>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-lg font-semibold text-blue-600">Delivery Management</h3>
                    <p class="text-gray-600">Assign and track deliveries.</p>
                    <div class="mt-4">
                        <a href="delivery?action=manage" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Go to Deliveries</a>
                    </div>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-lg font-semibold text-blue-600">Review Management</h3>
                    <p class="text-gray-600">View and moderate customer reviews.</p>
                    <div class="mt-4">
                        <a href="review?action=manage" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Go to Reviews</a>
                    </div>
                </div>

            </div>
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>
</body>
</html>