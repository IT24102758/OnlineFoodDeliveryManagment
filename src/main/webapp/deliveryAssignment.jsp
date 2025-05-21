<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, model.Order, java.util.HashMap" %>
<html>
<head>
    <title>Delivery Assignment - Food Delivery</title>
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
                <a href="delivery?action=assign" class="text-white hover:text-blue-200 font-bold">Assign Deliveries</a>
                <a href="delivery?action=manage" class="text-white hover:text-blue-200">Manage Deliveries</a>
                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Assign Deliveries</h2>
            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null && !success.isEmpty()) {
            %>
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6" role="alert">
                <p><%= success %></p>
            </div>
            <%
                }
                if (error != null && !error.isEmpty()) {
            %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                <p><%= error %></p>
            </div>
            <%
                }
            %>
            <div class="overflow-x-auto">
                <table class="min-w-full bg-gray-50 rounded-lg">
                    <thead>
                        <tr class="bg-blue-600 text-white">
                            <th class="py-3 px-4 text-left">Order ID</th>
                            <th class="py-3 px-4 text-left">Customer ID</th>
                            <th class="py-3 px-4 text-left">Delivery Address</th>
                            <th class="py-3 px-4 text-left">Assign Driver</th>
                            <th class="py-3 px-4 text-left">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Order> orders = (List<Order>) request.getAttribute("orders");
                        Map<String, String> drivers = (Map<String, String>) request.getAttribute("drivers");
                        if (drivers == null) {
                            drivers = new HashMap<>();
                        }
                        if (orders != null && !orders.isEmpty()) {
                            for (Order order : orders) {
                    %>
                    <tr class="border-b hover:bg-gray-100">
                        <td class="py-3 px-4"><%= order.getOrderId() != null ? order.getOrderId() : "N/A" %></td>
                        <td class="py-3 px-4"><%= order.getUserId() != null ? order.getUserId() : "N/A" %></td>
                        <td class="py-3 px-4"><%= order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "N/A" %></td>
                        <td class="py-3 px-4">
                            <form action="delivery?action=create" method="post" class="inline-block">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <select name="driverId" class="border rounded p-1" required>
                                    <option value="">Select Driver</option>
                                    <%
                                        for (Map.Entry<String, String> driver : drivers.entrySet()) {
                                    %>
                                    <option value="<%= driver.getKey() %>"><%= driver.getValue() %></option>
                                    <%
                                        }
                                    %>
                                </select>
                                <button type="submit" class="bg-blue-600 text-white px-2 py-1 rounded ml-2 hover:bg-blue-700">Assign</button>
                            </form>
                        </td>
                        <td class="py-3 px-4">
                            <a href="order?action=track&orderId=<%= order.getOrderId() %>" class="bg-gray-600 text-white px-2 py-1 rounded hover:bg-gray-700">View Order</a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="py-3 px-4 text-center text-gray-600">No orders ready for delivery.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>
</body>
</html>