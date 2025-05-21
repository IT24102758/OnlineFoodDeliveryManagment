<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.FileUtils" %>
<html>
<head>
    <title>User Profile - Food Bridge Network</title>
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
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        .profile-card {
            background: #fefcbf; /* Pastel yellow */
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            animation: fadeIn 1s ease-in-out;
        }
        .profile-header {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: white;
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
        }
        .profile-header h2 {
            margin-bottom: 0.5rem;
            font-size: 2rem;
        }
        .profile-header .user-type {
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.3rem 1rem;
            border-radius: 20px;
            display: inline-block;
        }
        .avatar-container {
            position: relative;
            margin-top: -70px;
            text-align: center;
        }
        .avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 5px solid white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }
        .avatar:hover {
            transform: scale(1.05);
        }
        .profile-body {
            padding: 2rem;
        }
        .info-section {
            margin-bottom: 2rem;
        }
        .info-section h5 {
            color: #4b5563; /* gray-600 */
            font-weight: bold;
            margin-bottom: 1rem;
            border-bottom: 2px solid #f97316;
            display: inline-block;
            padding-bottom: 0.3rem;
        }
        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }
        .info-item i {
            font-size: 1.2rem;
            color: #f97316;
            margin-right: 1rem;
        }
        .info-item span {
            font-size: 1.1rem;
            color: #4b5563; /* gray-600 */
        }
        .discount-section {
            background: #fed7aa; /* Pastel orange */
            padding: 1rem;
            border-radius: 10px;
        }
        .discount-section h5 {
            margin-bottom: 1rem;
        }
        .progress {
            height: 1.5rem;
            border-radius: 10px;
            background-color: #e5e7eb; /* gray-200 */
        }
        .progress-bar {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: white;
            line-height: 1.5rem;
            text-align: center;
        }
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        .action-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background-color: #4a5568; /* Dark gray */
            color: #ffffff; /* White */
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 500;
            transition: transform 0.2s ease;
            text-decoration: none;
        }
        .action-btn:hover {
            transform: scale(1.1);
        }
        .action-btn:active {
            animation: clickScale 0.1s ease;
        }
        .action-btn i {
            font-size: 1.2rem;
        }
        .back-btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: white;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 500;
            transition: transform 0.2s ease;
            text-decoration: none;
        }
        .back-btn:hover {
            transform: scale(1.1);
        }
        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
            color: #4b5563; /* gray-600 */
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
        <span class="ml-2 text-xl font-semibold text-yellow-500">Food Bridge Network</span>
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
    <%
        String successMessage = request.getParameter("success");
        String errorMessage = request.getParameter("error");
        if (successMessage != null && !successMessage.isEmpty()) {
    %>
        <div class="alert alert-success alert-dismissible text-center fade show" role="alert">
            <%= successMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <%
        }
        if (errorMessage != null && !errorMessage.isEmpty()) {
    %>
        <div class="alert alert-danger alert-dismissible text-center fade show" role="alert">
            <%= errorMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <%
        }
    %>

    <%
        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        if (userId == null) {
    %>
        <div class="alert alert-danger text-center" role="alert">
            You are not logged in. Please <a href="login.jsp" class="alert-link text-cyan-300 hover:underline">log in</a> to view your profile.
        </div>
    <%
        } else {
            String name = (String) request.getAttribute("name");
            String email = (String) request.getAttribute("email");
            String address = (String) request.getAttribute("address");
            String phone = (String) request.getAttribute("phone");
            String type = (String) request.getAttribute("type");
            String discount = (String) request.getAttribute("discount");

            if (name == null) {
                List<String> users = FileUtils.readFromFile(application, "users.txt");
                if (users != null) {
                    for (String user : users) {
                        String[] tokens = user.split(",");
                        if (tokens.length >= 7 && tokens[0].equals(userId)) {
                            name = tokens[1];
                            email = tokens[2];
                            address = tokens[4];
                            phone = tokens[5];
                            type = tokens[6];
                            discount = tokens.length > 7 ? tokens[7] : "0";
                            break;
                        }
                    }
                }
            }

            if (name == null) {
    %>
                <div class="alert alert-warning text-center" role="alert">
                    User data not found. Please contact support.
                </div>
    <%
            } else {
                String avatarUrl = "https://api.dicebear.com/9.x/avataaars/svg?seed=" + userId;
    %>
                <div class="profile-container">
                    <div class="profile-card">
                        <div class="profile-header">
                            <h2><%= name %></h2>
                            <span class="user-type"><%= type %> User</span>
                        </div>
                        <div class="avatar-container">
                            <img src="<%= avatarUrl %>" alt="User Avatar" class="avatar">
                        </div>
                        <div class="profile-body">
                            <div class="info-section">
                                <h5>Personal Information</h5>
                                <div class="info-item">
                                    <i class="fas fa-envelope"></i>
                                    <span><strong>Email:</strong> <%= email %></span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span><strong>Address:</strong> <%= address %></span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-phone"></i>
                                    <span><strong>Phone:</strong> <%= phone %></span>
                                </div>
                            </div>
                            <div class="info-section discount-section">
                                <h5>Benefits</h5>
                                <div class="info-item">
                                    <i class="fas fa-tags"></i>
                                    <span><strong>Discount:</strong> <%= discount %>%</span>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar" role="progressbar" style="width: <%= discount %>%;" aria-valuenow="<%= discount %>" aria-valuemin="0" aria-valuemax="100">
                                        <%= discount %>%
                                    </div>
                                </div>
                            </div>
                            <div class="action-buttons">
                                <a href="user?action=edit&id=<%= userId %>" class="action-btn">
                                    <i class="fas fa-user-edit"></i> Edit Profile
                                </a>
                                <a href="user?action=delete&id=<%= userId %>" class="action-btn" onclick="return confirm('Are you sure you want to delete your account? This action cannot be undone.');">
                                    <i class="fas fa-trash-alt"></i> Delete Account
                                </a>
                            </div>
                            <div class="text-center mt-4">
                                <a href="home.jsp" class="back-btn">Back to Home</a>
                            </div>
                        </div>
                    </div>
                </div>
    <%
            }
        }
    %>
</main>

<!-- Footer -->
<footer class="bg-orange-gradient p-6 text-white text-center">
    <div class="flex justify-center mb-4">
        <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
        <span class="ml-2 text-xl font-semibold">Food Bridge Network</span>
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
    <p class="mt-4 text-sm">© 2025 Food Bridge Network Inc. All Rights Reserved.</p>
</footer>
</body>
</html>