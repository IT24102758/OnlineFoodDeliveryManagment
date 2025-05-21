<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Submit Support Request - Food Bridge Network</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container {
            margin-top: 5rem;
            margin-bottom: 5rem;
        }
        .card {
            background: #fefcbf; /* Pastel yellow */
            padding: 2rem;
            max-width: 500px;
            margin: 0 auto;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #4b5563; /* gray-600 */
            font-weight: bold;
        }
        .form-label {
            color: #f97316;
            font-weight: 500;
        }
        .form-control {
            border-radius: 10px;
            border: 1px solid #ddd;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #2575fc;
            box-shadow: 0 0 8px rgba(37, 117, 252, 0.3);
        }
        textarea.form-control {
            resize: none;
        }
        .btn-submit {
            background-color: #4a5568; /* Dark gray */
            color: #ffffff; /* White */
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 500;
            transition: transform 0.2s ease;
        }
        .btn-submit:hover {
            transform: scale(1.1);
        }
        .btn-submit:active {
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
        <a href="user.jsp?action=read" class="text-gray-600 hover:text-yellow-500">Profile</a>
        <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500 font-semibold">Support</a>
        <a href="orderHistory.jsp" class="text-gray-600 hover:text-yellow-500">Order History</a>
        <a href="logout.jsp" class="bg-white text-gray-600 border border-gray-300 px-4 py-2 rounded hover:bg-gray-100">Logout</a>
    </nav>
</header>

<!-- Main Content -->
<main class="container">
    <h1 class="text-center mb-5">Submit a Support Request</h1>
    <%
        String successMessage = request.getParameter("success");
        String errorMessage = request.getParameter("error");
        if (successMessage != null && !successMessage.isEmpty()) {
    %>
        <div class="alert alert-success text-center">
            <%= successMessage %>
        </div>
    <%
        }
        if (errorMessage != null && !errorMessage.isEmpty()) {
    %>
        <div class="alert alert-danger text-center">
            <%= errorMessage %>
        </div>
    <%
        }
    %>
    <div class="card">
        <form action="support" method="post">
            <input type="hidden" name="action" value="submit">
            <div class="mb-3">
                <label for="subject" class="form-label">Subject</label>
                <input type="text" class="form-control" id="subject" name="subject" required>
            </div>
            <div class="mb-3">
                <label for="message" class="form-label">Message</label>
                <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
            </div>
            <div class="text-center">
                <button type="submit" class="btn-submit">Submit Request</button>
            </div>
        </form>
    </div>
    <div class="text-center mt-4">
        <a href="home.jsp" class="btn-back">Back to Home</a>
    </div>
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