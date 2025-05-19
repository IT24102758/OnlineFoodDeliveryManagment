<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit Customer Profile - Pizza Cow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .edit-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
        }
        .edit-card {
            background: #fefcbf; /* Pastel yellow */
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            animation: fadeIn 1s ease-in-out;
        }
        .edit-header {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: white;
            padding: 2rem;
            text-align: center;
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
        }
        .edit-header h2 {
            margin: 0;
            font-size: 1.8rem;
        }
        .edit-body {
            padding: 2rem;
        }
        .form-group {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .form-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #f97316;
            font-size: 1.2rem;
        }
        .form-control {
            padding-left: 40px;
            border-radius: 10px;
            border: 1px solid #ddd;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #2575fc;
            box-shadow: 0 0 8px rgba(37, 117, 252, 0.3);
        }
        .form-control[readonly] {
            background: #f8f9fa;
            cursor: not-allowed;
        }
        .form-select {
            padding-left: 40px;
            border-radius: 10px;
            border: 1px solid #ddd;
        }
        .form-select:focus {
            border-color: #2575fc;
            box-shadow: 0 0 8px rgba(37, 117, 252, 0.3);
        }
        .btn-save {
            background-color: #4a5568; /* Dark gray */
            color: #ffffff; /* White */
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 500;
            transition: transform 0.2s ease;
        }
        .btn-save:hover {
            transform: scale(1.1);
        }
        .btn-save:active {
            animation: clickScale 0.1s ease;
        }
        .btn-back {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: #ffffff; /* White */
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 500;
            transition: transform 0.2s ease;
        }
        .btn-back:hover {
            transform: scale(1.1);
        }
        .btn-back:active {
            animation: clickScale 0.1s ease;
        }
        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
            color: #4b5563; /* gray-600 */
        }
        footer {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: white;
            padding: 2rem 0;
            margin-top: auto;
        }
        footer a {
            color: #00d4ff; /* cyan-300 */
            text-decoration: none;
        }
        footer a:hover {
            text-decoration: underline;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        @keyframes clickScale {
            0% { transform: scale(1); }
            50% { transform: scale(0.95); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
<!-- Header -->
<header class="bg-white p-4 flex justify-between items-center shadow-md">
    <div class="flex items-center">
        <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
        <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
    </div>
    <nav class="space-x-4">
        <a href="home.jsp" class="text-gray-600 hover:text-yellow-500">Home</a>
        <a href="user.jsp?action=read" class="text-gray-600 hover:text-yellow-500 font-semibold">Profile</a>
        <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500">Support</a>
        <a href="orderHistory.jsp" class="text-gray-600 hover:text-yellow-500">Order History</a>
        <a href="logout.jsp" class="bg-white text-gray-600 border border-gray-300 px-4 py-2 rounded hover:bg-gray-100">Logout</a>
    </nav>
</header>

<!-- Main Content -->
<main class="container my-5">
    <div class="edit-container">
        <div class="edit-card">
            <div class="edit-header">
                <h2>Edit Customer Profile</h2>
            </div>
            <div class="edit-body">
                <%-- Display Success or Error Messages --%>
                <%
                    String successMessage = request.getParameter("success");
                    String errorMessage = request.getParameter("error");
                    if (successMessage != null && !successMessage.isEmpty()) {
                %>
                    <div class="alert alert-success" role="alert">
                        <%= successMessage %>
                    </div>
                <%
                    }
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                    <div class="alert alert-danger" role="alert">
                        <%= errorMessage %>
                    </div>
                <%
                    }
                %>

                <form action="user" method="post">
                    <input type="hidden" name="action" value="update">
                    <div class="form-group">
                        <i class="fas fa-id-badge"></i>
                        <input type="text" name="id" class="form-control" value="<%= request.getAttribute("id") != null ? request.getAttribute("id") : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="name" class="form-control" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" placeholder="Name" required>
                    </div>
                    <div class="form-group">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" class="form-control" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" placeholder="Email" required>
                    </div>
                    <div class="form-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" class="form-control" value="<%= request.getAttribute("password") != null ? request.getAttribute("password") : "" %>" placeholder="Password" required>
                    </div>
                    <div class="form-group">
                        <i class="fas fa-map-marker-alt"></i>
                        <input type="text" name="address" class="form-control" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>" placeholder="Address" required>
                    </div>
                    <div class="form-group">
                        <i class="fas fa-phone"></i>
                        <input type="text" name="phone" class="form-control" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" placeholder="Phone Number" required>
                    </div>
                    <%
                        String userId = (String) request.getAttribute("id");
                        String currentType = (String) request.getAttribute("type");
                        if (!"1".equals(userId)) {
                    %>
                    <div class="form-group">
                        <i class="fas fa-user-tag"></i>
                        <select name="type" class="form-select" required>
                            <option value="Regular" <%= "Regular".equals(currentType) ? "selected" : "" %>>Regular Customer</option>
                            <option value="Premium" <%= "Premium".equals(currentType) ? "selected" : "" %>>Premium Customer</option>
                            <option value="Admin" <%= "Admin".equals(currentType) ? "selected" : "" %>>Admin</option>
                            <option value="Restaurant" <%= "Restaurant".equals(currentType) ? "selected" : "" %>>Restaurant Owner</option>
                            <option value="driver" <%= "driver".equals(currentType) ? "selected" : "" %>>Driver</option>
                        </select>
                    </div>
                    <% } else { %>
                    <input type="hidden" name="type" value="Admin">
                    <% } %>
                    <div class="text-center">
                        <button type="submit" class="btn-save">Save Changes</button>
                        <a href="user.jsp?action=read" class="btn-back ms-3">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-orange-gradient p-6 text-white text-center">
    <div class="flex justify-center mb-4">
        <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
        <span class="ml-2 text-xl font-semibold">Pizza Cow</span>
    </div>
    <div class="mb-4">
        <h5 class="text-lg font-semibold">Quick Links</h5>
        <ul class="list-none space-y-2 mt-2">
            <li><a href="home.jsp" class="text-cyan-300 hover:underline">Home</a></li>
            <li><a href="user.jsp?action=read" class="text-cyan-300 hover:underline">Profile</a></li>
            <li><a href="supportRequest.jsp" class="text-cyan-300 hover:underline">Support</a></li>
            <li><a href="logout.jsp" class="text-cyan-300 hover:underline">Logout</a></li>
        </ul>
    </div>
    <div class="flex justify-center space-x-4">
        <a href="#" class="text-cyan-300 hover:text-cyan-200"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="text-cyan-300 hover:text-cyan-200"><i class="fab fa-twitter"></i></a>
        <a href="#" class="text-cyan-300 hover:text-cyan-200"><i class="fab fa-instagram"></i></a>
    </div>
    <p class="mt-4 text-sm">© 2025 Pizza Cow Inc. All Rights Reserved.</p>
</footer>
</body>
</html>