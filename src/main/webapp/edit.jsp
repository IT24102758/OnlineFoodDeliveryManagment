<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
<div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
    <h1 class="text-2xl font-bold mb-6 text-center">Edit User</h1>
    <form action="user" method="post" class="space-y-4">
        <input type="hidden" name="action" value="update">
        <div>
            <label class="block text-gray-700">ID</label>
            <input type="text" name="id" class="w-full p-2 border rounded" value="<%= request.getAttribute("id") %>" readonly>
        </div>
        <div>
            <label class="block text-gray-700">Name</label>
            <input type="text" name="name" class="w-full p-2 border rounded" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required>
        </div>
        <div>
            <label class="block text-gray-700">Email</label>
            <input type="email" name="email" class="w-full p-2 border rounded" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
        </div>
        <div>
            <label class="block text-gray-700">Password</label>
            <input type="password" name="password" class="w-full p-2 border rounded" value="<%= request.getAttribute("password") != null ? request.getAttribute("password") : "" %>" required>
        </div>
        <div>
            <label class="block text-gray-700">Address</label>
            <input type="text" name="address" class="w-full p-2 border rounded" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>" required>
        </div>
        <div>
            <label class="block text-gray-700">Phone Number</label>
            <input type="text" name="phone" class="w-full p-2 border rounded" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required>
        </div>
        <%
            String userId = (String) request.getAttribute("id");
            if (!"1".equals(userId)) {
        %>
        <div>
            <label class="block text-gray-700">User Type</label>
            <select name="type" class="w-full p-2 border rounded" required>
                <option value="Regular" <%= "Regular".equals(request.getAttribute("type")) ? "selected" : "" %>>Regular Customer</option>
                <option value="Premium" <%= "Premium".equals(request.getAttribute("type")) ? "selected" : "" %>>Premium Customer</option>
            </select>
        </div>
        <% } %>
        <button type="submit" class="w-full bg-green-500 text-white py-2 rounded hover:bg-green-700">Save Changes</button>
    </form>
    <p class="mt-4 text-center">
        <a href="userlist.jsp" class="text-blue-500 hover:underline">Back to User List</a>
    </p>
</div>
</body>
</html>