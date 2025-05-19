<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.FileUtils" %>
<html>
<head>
    <title>Admin User List</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="bg-gray-100">
<div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4 text-center">Admin User List</h1>

    <!-- Debugging Role -->
    <%
        String role = (String) session.getAttribute("role");
    %>
    <p class="text-center mb-4">Logged in as: <%= role != null ? role : "Not set" %></p>

    <!-- Debugging User List -->
    <%
        List<String> users = FileUtils.readFromFile(application, "users.txt");
        if (users == null) {
    %>
        <p class="text-center text-red-500 mb-4">Error: Users list is null. Check file reading.</p>
    <% } else if (users.isEmpty()) { %>
        <p class="text-center text-red-500 mb-4">No users found in the file.</p>
    <% } else { %>
        <p class="text-center text-green-500 mb-4">Total users: <%= users.size()-1 %></p>
    <% } %>

    <!-- User List Table -->
    <div class="bg-white p-6 rounded-lg shadow-md">
        <table class="w-full border-collapse">
            <thead>
            <tr class="bg-gray-200">
                <th class="p-2 border">ID</th>
                <th class="p-2 border">Name</th>
                <th class="p-2 border">Email</th>
                <th class="p-2 border">Password</th>
                <th class="p-2 border">Address</th>
                <th class="p-2 border">Phone</th>
                <th class="p-2 border">Type</th>
                <th class="p-2 border">Discount</th>
                <th class="p-2 border">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                users = FileUtils.readFromFile(application, "users.txt"); // Re-read to ensure fresh data
                if (users == null || users.isEmpty()) {
            %>
                <tr>
                    <td colspan="9" class="p-2 border text-center">No users found.</td>
                </tr>
            <%
                } else {
                    for (String user : users) {
                        String[] tokens = user.split(",");
                        // Skip malformed entries
                        if (tokens.length < 7) {
            %>
                            <tr>
                                <td colspan="9" class="p-2 border text-center text-red-500">Malformed entry: <%= user %></td>
                            </tr>
            <%
                            continue;
                        }
                        String userId = tokens[0];
                        // Skip the admin user (ID "1")
                        if ("1".equals(userId)) {
                            continue;
                        }
                        String discount = tokens.length > 7 ? tokens[7] : "N/A";
            %>
                        <tr>
                            <td class="p-2 border"><%= tokens[0] %></td>
                            <td class="p-2 border"><%= tokens[1] %></td>
                            <td class="p-2 border"><%= tokens[2] %></td>
                            <td class="p-2 border"><%= tokens[3] %></td>
                            <td class="p-2 border"><%= tokens[4] %></td>
                            <td class="p-2 border"><%= tokens[5] %></td>
                            <td class="p-2 border"><%= tokens[6] %></td>
                            <td class="p-2 border"><%= discount %></td>
                            <td class="p-2 border">
                                <% if ("admin".equals(role)) { %>
                                    <div class="flex justify-center space-x-4">
                                        <!-- Edit Icon -->
                                        <a href="user?action=edit&id=<%= userId %>" class="text-blue-600 hover:text-blue-800 transition-colors duration-200" title="Edit User">
                                            <i class="fas fa-edit text-xl"></i>
                                        </a>
                                        <!-- Delete Icon -->
                                        <a href="user?action=delete&id=<%= userId %>" class="text-red-600 hover:text-red-800 transition-colors duration-200" title="Delete User" onclick="return confirm('Are you sure you want to delete this user?');">
                                            <i class="fas fa-trash text-xl"></i>
                                        </a>
                                    </div>
                                <% } else { %>
                                    <span class="text-gray-500 text-sm">Not Authorized</span>
                                <% } %>
                            </td>
                        </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>