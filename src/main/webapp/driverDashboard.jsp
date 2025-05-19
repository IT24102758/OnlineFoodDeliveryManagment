<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, model.Delivery, model.Order" %>
<html>
<head>
    <title>Driver Dashboard</title>
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
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Driver Dashboard</h2>
            <h3 class="text-xl font-semibold text-blue-600 mb-4">Assigned Deliveries</h3>
            <%
                List<Delivery> assignedDeliveries = (List<Delivery>) request.getAttribute("assignedDeliveries");
                List<Order> driverOrders = (List<Order>) request.getAttribute("driverOrders");
                Map<String, String> restaurantNames = (Map<String, String>) request.getAttribute("restaurantNames");
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
                if (assignedDeliveries == null || assignedDeliveries.isEmpty()) {
            %>
                <p class="text-gray-600 text-center">No deliveries are currently assigned to you.</p>
            <%
                } else {
            %>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-gray-50 rounded-lg shadow-md">
                        <thead>
                            <tr class="bg-blue-600 text-white">
                                <th class="py-3 px-4 text-left">Delivery ID</th>
                                <th class="py-3 px-4 text-left">Order ID</th>
                                <th class="py-3 px-4 text-left">Restaurant</th>
                                <th class="py-3 px-4 text-left">Customer Details</th>
                                <th class="py-3 px-4 text-left">Status</th>
                                <th class="py-3 px-4 text-left">Assigned At</th>
                                <th class="py-3 px-4 text-left">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Delivery delivery : assignedDeliveries) {
                                    Order order = null;
                                    if (driverOrders != null) {
                                        for (Order driverOrder : driverOrders) {
                                            if (driverOrder.getOrderId().equals(delivery.getOrderId())) {
                                                order = driverOrder;
                                                break;
                                            }
                                        }
                                    }
                            %>
                                <tr class="border-b hover:bg-gray-100">
                                    <td class="py-3 px-4"><%= delivery.getDeliveryId() != null ? delivery.getDeliveryId() : "N/A" %></td>
                                    <td class="py-3 px-4"><%= delivery.getOrderId() != null ? delivery.getOrderId() : "N/A" %></td>
                                    <td class="py-3 px-4">
                                        <%
                                            if (order != null && order.getItems() != null && !order.getItems().isEmpty()) {
                                                String restaurantId = (String) order.getItems().get(0).get("restaurantId");
                                                out.print(restaurantNames != null ? restaurantNames.getOrDefault(restaurantId, restaurantId) : "Unknown Restaurant");
                                            } else {
                                                out.print("Unknown Restaurant");
                                            }
                                        %>
                                    </td>
                                    <td class="py-3 px-4">
                                        <%
                                            if (order != null) {
                                                out.println(order.getEmail() != null ? order.getEmail() : "N/A");
                                                out.println("<br>");
                                                out.println(order.getPhone() != null ? order.getPhone() : "N/A");
                                                out.println("<br>");
                                                String address = order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "";
                                                String district = order.getBillingDistrict() != null ? order.getBillingDistrict() : "";
                                                out.println(address + (address.isEmpty() || district.isEmpty() ? "" : ", ") + district);
                                            } else {
                                                out.print("Unknown Customer");
                                            }
                                        %>
                                    </td>
                                    <td class="py-3 px-4"><%= delivery.getStatus() != null ? delivery.getStatus() : "N/A" %></td>
                                    <td class="py-3 px-4"><%= delivery.getAssignedAt() != null ? delivery.getAssignedAt() : "N/A" %></td>
                                    <td class="py-3 px-4">
                                        <%
                                            if (order != null && !"Delivered".equals(order.getStatus())) {
                                                String deliveryAddress = order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "";
                                                String billingDistrict = order.getBillingDistrict() != null ? order.getBillingDistrict() : "";
                                                String fullAddress = deliveryAddress + (deliveryAddress.isEmpty() || billingDistrict.isEmpty() ? "" : ", ") + billingDistrict;
                                        %>
                                            <form action="order" method="post" class="inline">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                                <input type="hidden" name="status" value="Delivered">
                                                <input type="hidden" name="deliveryId" value="<%= delivery.getDeliveryId() %>">
                                                <input type="hidden" name="location" value="<%= fullAddress %>">
                                                <button type="submit" class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600" onclick="return confirm('Are you sure you want to mark this order as Delivered?');">Delivered</button>
                                            </form>
                                        <%
                                            } else if (order != null && "Delivered".equals(order.getStatus())) {
                                        %>
                                            <span class="bg-green-100 text-green-800 px-3 py-1 rounded">Delivered</span>
                                        <%
                                            } else {
                                                out.print("N/A");
                                            }
                                        %>
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