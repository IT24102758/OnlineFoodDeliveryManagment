<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Delivery" %>
<html>
<head>
    <title>Track Delivery - Food Delivery</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-r from-blue-100 to-purple-100 min-h-screen flex flex-col">
    <nav class="bg-blue-600 p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <a href="home.jsp" class="text-white text-2xl font-bold">Food Delivery</a>
            <div class="space-x-4">
                <a href="home.jsp" class="text-white hover:text-blue-200">Home</a>
                <a href="order?action=history" class="text-white hover:text-blue-200">Order History</a>
                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Track Your Delivery</h2>
            <%
                Delivery delivery = (Delivery) request.getAttribute("delivery");
                if (delivery != null) {
            %>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <p><strong>Delivery ID:</strong> <%= delivery.getDeliveryId() %></p>
                    <p><strong>Order ID:</strong> <%= delivery.getOrderId() %></p>
                    <p><strong>Driver ID:</strong> <%= delivery.getDriverId() %></p>
                </div>
                <div>
                    <p><strong>Status:</strong> <span class="text-green-600"><%= delivery.getStatus() %></span></p>
                    <p><strong>Location:</strong> <%= delivery.getLocation() %></p>
                    <p><strong>Last Updated:</strong> <%= delivery.getTimestamp() %></p>
                </div>
            </div>
            <%
                } else {
            %>
            <p class="text-center text-gray-600">Delivery information not available.</p>
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