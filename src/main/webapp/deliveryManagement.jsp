<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, model.Order, model.Delivery, java.util.HashMap, java.util.ArrayList" %>
<%
    List<Order> pendingOrders = (List<Order>) request.getAttribute("pendingOrders");
    if (pendingOrders == null) {
        pendingOrders = new ArrayList<>();
    }

    List<Delivery> deliveries = (List<Delivery>) request.getAttribute("deliveries");
    if (deliveries == null) {
        deliveries = new ArrayList<>();
    }

    Map<String, String> drivers = (Map<String, String>) request.getAttribute("drivers");
    if (drivers == null) {
        drivers = new HashMap<>();
    }

    Map<String, String> restaurantNames = (Map<String, String>) request.getAttribute("restaurantNames");
    if (restaurantNames == null) {
        restaurantNames = new HashMap<>();
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<html>
<head>
    <title>Delivery Management - Food Delivery</title>
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
                <a href="delivery?action=manage" class="text-white hover:text-blue-200 font-bold">Manage Deliveries</a>
                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Delivery Management</h2>
            <% if (success != null && !success.isEmpty()) { %>
                <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6" role="alert">
                    <p><%= success %></p>
                </div>
            <% } %>
            <% if (error != null && !error.isEmpty()) { %>
                <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                    <p><%= error %></p>
                </div>
            <% } %>

            <!-- Assign Deliveries Section (Hidden if a delivery was just assigned) -->
            <% if (success == null || success.isEmpty()) { %>
                <div class="bg-gray-50 p-6 rounded-lg shadow-md mb-8">
                    <h3 class="text-lg font-semibold text-blue-600 mb-4">Assign Deliveries to Drivers</h3>
                    <% if (pendingOrders.isEmpty()) { %>
                        <p class="text-gray-600">No orders are currently ready for delivery.</p>
                    <% } else { %>
                        <div class="overflow-x-auto">
                            <table id="assignDeliveriesTable" class="min-w-full bg-gray-50 rounded-lg">
                                <thead>
                                    <tr class="bg-blue-600 text-white">
                                        <th class="py-3 px-4 text-left">Order ID</th>
                                        <th class="py-3 px-4 text-left">Customer ID</th>
                                        <th class="py-3 px-4 text-left">Restaurant</th>
                                        <th class="py-3 px-4 text-left">Delivery Address</th>
                                        <th class="py-3 px-4 text-left">Total</th>
                                        <th class="py-3 px-4 text-left">Status</th>
                                        <th class="py-3 px-4 text-left">Assign Driver</th>
                                        <th class="py-3 px-4 text-left">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Order order : pendingOrders) { %>
                                        <%
                                            String restaurantId = "N/A";
                                            List<Map<String, Object>> items = order.getItems();
                                            if (items != null && !items.isEmpty()) {
                                                Map<String, Object> firstItem = items.get(0);
                                                restaurantId = (String) firstItem.get("restaurantId");
                                                if (restaurantId == null) {
                                                    restaurantId = "N/A";
                                                }
                                            }

                                            // Find the corresponding delivery for this order to get its status
                                            Delivery delivery = deliveries.stream()
                                                .filter(d -> d.getOrderId().equals(order.getOrderId()))
                                                .findFirst()
                                                .orElse(null);
                                            String deliveryStatus = (delivery != null && delivery.getStatus() != null) ? delivery.getStatus() : "Pending Assignment";
                                        %>
                                        <tr class="border-b hover:bg-gray-100" data-delivery-status="<%= deliveryStatus %>">
                                            <td class="py-3 px-4"><%= order.getOrderId() != null ? order.getOrderId() : "N/A" %></td>
                                            <td class="py-3 px-4"><%= order.getUserId() != null ? order.getUserId() : "N/A" %></td>
                                            <td class="py-3 px-4"><%= restaurantNames.getOrDefault(restaurantId, restaurantId) %></td>
                                            <td class="py-3 px-4"><%= order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "N/A" %></td>
                                            <td class="py-3 px-4">$<%= String.format("%.2f", order.getFinalTotal()) %></td>
                                            <td class="py-3 px-4"><%= order.getStatus() != null ? order.getStatus() : "N/A" %></td>
                                            <td class="py-3 px-4">
                                                <form action="delivery?action=create" method="post" class="inline-block">
                                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                                    <select name="driverId" class="border rounded p-1" required>
                                                        <option value="">Select Driver</option>
                                                        <% for (Map.Entry<String, String> driver : drivers.entrySet()) { %>
                                                            <option value="<%= driver.getKey() %>"><%= driver.getValue() %></option>
                                                        <% } %>
                                                    </select>
                                                    <button type="submit" class="bg-blue-600 text-white px-2 py-1 rounded ml-2 hover:bg-blue-700">Assign</button>
                                                </form>
                                            </td>
                                            <td class="py-3 px-4">
                                                <a href="order?action=summary&orderId=<%= order.getOrderId() %>" class="bg-gray-600 text-white px-2 py-1 rounded hover:bg-gray-700">View Order</a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <!-- Track Deliveries Section -->
            <div class="bg-gray-50 p-6 rounded-lg shadow-md">
                <h3 class="text-lg font-semibold text-blue-600 mb-4">Track Deliveries</h3>
                <% if (deliveries.isEmpty()) { %>
                    <p class="text-gray-600">No deliveries have been assigned yet.</p>
                <% } else { %>
                    <div class="overflow-x-auto">
                        <table class="min-w-full bg-gray-50 rounded-lg">
                            <thead>
                                <tr class="bg-blue-600 text-white">
                                    <th class="py-3 px-4 text-left">Delivery ID</th>
                                    <th class="py-3 px-4 text-left">Order ID</th>
                                    <th class="py-3 px-4 text-left">Driver</th>
                                    <th class="py-3 px-4 text-left">Status</th>
                                    <th class="py-3 px-4 text-left">Location</th>
                                    <th class="py-3 px-4 text-left">Last Updated</th>
                                    <th class="py-3 px-4 text-left">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Delivery delivery : deliveries) { %>
                                    <tr class="border-b hover:bg-gray-100">
                                        <td class="py-3 px-4"><%= delivery.getDeliveryId() != null ? delivery.getDeliveryId() : "N/A" %></td>
                                        <td class="py-3 px-4"><%= delivery.getOrderId() != null ? delivery.getOrderId() : "N/A" %></td>
                                        <td class="py-3 px-4"><%= drivers.getOrDefault(delivery.getDriverId(), delivery.getDriverId() != null ? delivery.getDriverId() : "N/A") %></td>
                                        <td class="py-3 px-4"><%= delivery.getStatus() != null ? delivery.getStatus() : "N/A" %></td>
                                        <td class="py-3 px-4"><%= delivery.getLocation() != null ? delivery.getLocation() : "N/A" %></td>
                                        <td class="py-3 px-4"><%= delivery.getTimestamp() != null ? delivery.getTimestamp() : "N/A" %></td>
                                        <td class="py-3 px-4">
                                            <% if ("Delivered".equals(delivery.getStatus())) { %>
                                                <form action="delivery?action=delete" method="post" onsubmit="return confirm('Are you sure you want to delete this delivery?');" class="inline-block">
                                                    <input type="hidden" name="deliveryId" value="<%= delivery.getDeliveryId() %>">
                                                    <button type="submit" class="bg-red-600 text-white px-2 py-1 rounded hover:bg-red-700">Delete</button>
                                                </form>
                                            <% } else { %>
                                                <span class="text-gray-500">No actions available</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </main>
    <footer class="bg-gray-800 text-white text-center p-4 mt-8">
        <p>© 2025 Food Delivery System. All Rights Reserved.</p>
    </footer>

    <!-- JavaScript for Frontend Validation -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const table = document.getElementById('assignDeliveriesTable');
            if (table) {
                const rows = table.querySelectorAll('tbody tr');
                let hasVisibleRows = false;

                rows.forEach(row => {
                    const deliveryStatus = row.getAttribute('data-delivery-status');
                    if (deliveryStatus && deliveryStatus.toLowerCase() !== 'pending assignment') {
                        row.style.display = 'none'; // Hide rows where delivery status is not "Pending Assignment"
                    } else {
                        hasVisibleRows = true; // At least one row is visible
                    }
                });

                // If no rows are visible, show a message
                if (!hasVisibleRows) {
                    const tbody = table.querySelector('tbody');
                    const noOrdersMessage = document.createElement('tr');
                    noOrdersMessage.innerHTML = '<td colspan="8" class="py-3 px-4 text-gray-600 text-center">No orders are currently ready for delivery.</td>';
                    tbody.innerHTML = ''; // Clear existing rows
                    tbody.appendChild(noOrdersMessage);
                }
            }
        });
    </script>
</body>
</html>