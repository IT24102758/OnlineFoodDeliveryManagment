<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, model.Order, utils.FileUtils" %>
<html>
<head>
    <title>Admin - Manage Orders</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // JavaScript for toggling order details
        function toggleDetails(orderId) {
            const details = document.getElementById('details-' + orderId);
            details.classList.toggle('hidden');
        }

        // JavaScript for filtering orders
        function filterOrders() {
            const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
            const userFilter = document.getElementById('userFilter').value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr.order-row');

            rows.forEach(row => {
                const status = row.querySelector('.status').textContent.toLowerCase();
                const userId = row.querySelector('.userId').textContent.toLowerCase();

                const matchesStatus = statusFilter === 'all' || status === statusFilter;
                const matchesUser = userFilter === '' || userId.includes(userFilter);

                if (matchesStatus && matchesUser) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // JavaScript for sorting orders
        function sortOrders(by) {
            const tbody = document.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr.order-row'));

            rows.sort((a, b) => {
                let aValue, bValue;
                if (by === 'date') {
                    aValue = new Date(a.querySelector('.date').textContent);
                    bValue = new Date(b.querySelector('.date').textContent);
                } else if (by === 'total') {
                    aValue = parseFloat(a.querySelector('.total').textContent.replace('$', ''));
                    bValue = parseFloat(b.querySelector('.total').textContent.replace('$', ''));
                } else if (by === 'status') {
                    aValue = a.querySelector('.status').textContent.toLowerCase();
                    bValue = b.querySelector('.status').textContent.toLowerCase();
                }
                return aValue > bValue ? 1 : -1;
            });

            rows.forEach(row => {
                const detailsRow = row.nextElementSibling;
                tbody.appendChild(row);
                if (detailsRow && detailsRow.id.startsWith('details-')) {
                    tbody.appendChild(detailsRow);
                }
            });
        }
    </script>
</head>
<body class="bg-gradient-to-r from-blue-100 to-purple-100 min-h-screen flex flex-col">
    <nav class="bg-blue-600 p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <a href="adminDashboard.jsp" class="text-white text-2xl font-bold">Food Delivery</a>
            <div class="space-x-4">
                <a href="user?action=read" class="text-white hover:text-blue-200">Manage Users</a>
                <a href="restaurant?action=list" class="text-white hover:text-blue-200">Manage Restaurants</a>
                <a href="order?action=adminOrders" class="text-white hover:text-blue-200 font-bold">Manage Orders</a>
                <a href="logout.jsp" class="text-white hover:text-blue-200">Logout</a>
            </div>
        </div>
    </nav>
    <main class="container mx-auto mt-8 flex-grow">
        <div class="bg-white p-6 rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Manage Orders</h2>
            <%
                // Check if user is admin
                String role = (String) session.getAttribute("role");
                if (session == null || role == null || !"admin".equals(role)) {
                    response.sendRedirect("home.jsp?error=" + java.net.URLEncoder.encode("Access denied. Only admins can view this page.", "UTF-8"));
                    return;
                }

                // Load orders from request attribute (set by OrderServlet)
                List<Order> orders = (List<Order>) request.getAttribute("orders");
                if (orders == null || orders.isEmpty()) {
            %>
            <p class="text-center text-gray-600">No orders found.</p>
            <%
            } else {
            %>
            <!-- Filter and Sort Controls -->
            <div class="mb-6 flex flex-wrap justify-between items-center">
                <div class="flex space-x-4">
                    <div>
                        <label for="statusFilter" class="text-gray-700 font-medium">Filter by Status:</label>
                        <select id="statusFilter" onchange="filterOrders()" class="border rounded p-2">
                            <option value="all">All</option>
                            <option value="pending">Pending</option>
                            <option value="confirmed">Confirmed</option>
                            <option value="prepared">Prepared</option>
                            <option value="out for delivery">Out for Delivery</option>
                            <option value="delivered">Delivered</option>
                        </select>
                    </div>
                    <div>
                        <label for="userFilter" class="text-gray-700 font-medium">Filter by User ID:</label>
                        <input type="text" id="userFilter" onkeyup="filterOrders()" placeholder="Enter User ID" class="border rounded p-2">
                    </div>
                </div>
                <div class="flex space-x-4">
                    <button onclick="sortOrders('date')" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Sort by Date</button>
                    <button onclick="sortOrders('total')" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Sort by Total</button>
                    <button onclick="sortOrders('status')" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Sort by Status</button>
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full bg-gray-50 rounded-lg">
                    <thead>
                        <tr class="bg-blue-600 text-white">
                            <th class="py-3 px-4 text-left">Order ID</th>
                            <th class="py-3 px-4 text-left">Customer ID</th>
                            <th class="py-3 px-4 text-left">Subtotal</th>
                            <th class="py-3 px-4 text-left">Delivery Fee</th>
                            <th class="py-3 px-4 text-left">Final Total</th>
                            <th class="py-3 px-4 text-left">Date</th>
                            <th class="py-3 px-4 text-left">Status</th>
                            <th class="py-3 px-4 text-left">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Order order : orders) {
                    %>
                    <tr class="border-b hover:bg-gray-100 order-row">
                        <td class="py-3 px-4"><%= order.getOrderId() %></td>
                        <td class="py-3 px-4 font-medium text-blue-800 userId"><%= order.getUserId() %></td>
                        <td class="py-3 px-4">$<%= String.format("%.2f", order.getTotal()) %></td>
                        <td class="py-3 px-4">$<%= String.format("%.2f", order.getDeliveryFee()) %></td>
                        <td class="py-3 px-4 total">$<%= String.format("%.2f", order.getFinalTotal()) %></td>
                        <td class="py-3 px-4 date"><%= order.getOrderDate() %></td>
                        <td class="py-3 px-4 status <%= getStatusColor(order.getStatus()) %>"><%= order.getStatus() %></td>
                        <td class="py-3 px-4">
                            <form action="order?action=update" method="post" class="inline-block">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <select name="status" class="border rounded p-1">
                                    <option value="Pending" <%= "Pending".equals(order.getStatus()) ? "selected" : "" %> <%= isStatusTransitionValid(order.getStatus(), "Pending") ? "" : "disabled" %>>Pending</option>
                                    <option value="Confirmed" <%= "Confirmed".equals(order.getStatus()) ? "selected" : "" %> <%= isStatusTransitionValid(order.getStatus(), "Confirmed") ? "" : "disabled" %>>Confirmed</option>
                                    <option value="Prepared" <%= "Prepared".equals(order.getStatus()) ? "selected" : "" %> <%= isStatusTransitionValid(order.getStatus(), "Prepared") ? "" : "disabled" %>>Prepared</option>
                                    <option value="Out for Delivery" <%= "Out for Delivery".equals(order.getStatus()) ? "selected" : "" %> <%= isStatusTransitionValid(order.getStatus(), "Out for Delivery") ? "" : "disabled" %>>Out for Delivery</option>
                                    <option value="Delivered" <%= "Delivered".equals(order.getStatus()) ? "selected" : "" %> <%= isStatusTransitionValid(order.getStatus(), "Delivered") ? "" : "disabled" %>>Delivered</option>
                                </select>
                                <button type="submit" class="bg-green-600 text-white px-2 py-1 rounded ml-2 hover:bg-green-700">Update</button>
                            </form>
                            <a href="order?action=track&orderId=<%= order.getOrderId() %>" class="ml-2 bg-blue-600 text-white px-2 py-1 rounded hover:bg-blue-700">Track</a>
                            <button onclick="toggleDetails('<%= order.getOrderId() %>')" class="ml-2 bg-gray-600 text-white px-2 py-1 rounded hover:bg-gray-700">Details</button>
                        </td>
                    </tr>
                    <!-- Collapsible Order Details -->
                    <tr id="details-<%= order.getOrderId() %>" class="hidden">
                        <td colspan="8" class="p-4 bg-gray-200">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <h4 class="font-bold text-gray-700">Order Items:</h4>
                                    <ul class="list-disc pl-5">
                                        <%
                                            List<Map<String, Object>> items = order.getItems();
                                            if (items != null && !items.isEmpty()) {
                                                for (Map<String, Object> item : items) {
                                                    String itemId = (String) item.get("itemId");
                                                    String restaurantId = (String) item.get("restaurantId");
                                                    int quantity = (int) item.get("quantity");
                                        %>
                                        <li>Item ID: <%= itemId %>, Restaurant ID: <%= restaurantId %>, Quantity: <%= quantity %></li>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <li>No items found.</li>
                                        <%
                                            }
                                        %>
                                    </ul>
                                </div>
                                <div>
                                    <h4 class="font-bold text-gray-700">Contact Details:</h4>
                                    <p><strong>Delivery Address:</strong> <%= order.getDeliveryAddress() != null && !order.getDeliveryAddress().isEmpty() ? order.getDeliveryAddress() : "Not provided" %></p>
                                    <p><strong>District:</strong> <%= order.getBillingDistrict() != null && !order.getBillingDistrict().isEmpty() ? order.getBillingDistrict() : "Not provided" %></p>
                                    <p><strong>Phone Number:</strong> <%= order.getPhone() != null && !order.getPhone().isEmpty() ? order.getPhone() : "Not provided" %></p>
                                    <p><strong>Email:</strong> <%= order.getEmail() != null && !order.getEmail().isEmpty() ? order.getEmail() : "Not provided" %></p>
                                </div>
                                <div>
                                    <h4 class="font-bold text-gray-700">Payment Details:</h4>
                                    <p><strong>Payment Status:</strong> <%= order.getPaymentStatus() != null && !order.getPaymentStatus().isEmpty() ? order.getPaymentStatus() : "Not provided" %></p>
                                    <p><strong>Payment Method:</strong> <%= order.getPaymentMethod() != null && !order.getPaymentMethod().isEmpty() ? order.getPaymentMethod() : "Not provided" %></p>
                                </div>
                            </div>
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
    <%!
        private String getStatusColor(String status) {
            switch (status != null ? status.toLowerCase() : "") {
                case "pending": return "text-yellow-600";
                case "confirmed": return "text-blue-600";
                case "prepared": return "text-orange-600";
                case "out for delivery": return "text-purple-600";
                case "delivered": return "text-green-600";
                default: return "text-gray-600";
            }
        }

        private boolean isStatusTransitionValid(String currentStatus, String newStatus) {
            if (currentStatus == null || newStatus == null) return false;
            switch (currentStatus) {
                case "Pending":
                    return newStatus.equals("Confirmed");
                case "Confirmed":
                    return newStatus.equals("Prepared");
                case "Prepared":
                    return newStatus.equals("Out for Delivery");
                case "Out for Delivery":
                    return newStatus.equals("Delivered");
                case "Delivered":
                    return false; // No further transitions allowed
                default:
                    return false;
            }
        }
    %>
</body>
</html>