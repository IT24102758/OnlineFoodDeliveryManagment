<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - Food Delivery System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Custom CSS for Background and Animations -->
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        body {
            background: url('<%=request.getContextPath()%>/assets/images/background.jpeg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: white;
            position: relative;
        }
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, rgba(249, 115, 22, 0.7), rgba(253, 186, 116, 0.7));
            z-index: -1;
        }
        .fade-in {
            animation: fadeIn 1.5s ease-in-out;
        }
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .hover-scale {
            transition: transform 0.3s ease;
        }
        .hover-scale:hover {
            transform: scale(1.05);
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            animation: fadeIn 1.5s ease-in-out;
            border-radius: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            padding: 2rem;
        }
        .login-card:hover {
            transform: translateY(-5px);
        }
        .input-group {
            position: relative;
        }
        .input-group .icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #fbbf24; /* yellow-500 */
        }
        .input-group input {
            padding-left: 2.5rem;
            transition: border-color 0.3s ease;
        }
        .input-group input:focus {
            border-color: #f97316; /* orange-600 */
            outline: none;
        }
        .btn-loading {
            background: #fbbf24; /* yellow-500 */
            color: white;
            opacity: 0.7;
            cursor: not-allowed;
        }
        .register-text {
            color: #1f2937; /* gray-800 */
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white p-4 flex justify-between items-center shadow-md">
        <div class="flex items-center">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold text-yellow-500">Food Bridge Network</span>
        </div>
        <nav class="space-x-4">
            <a href="index.jsp" class="text-gray-600 hover:text-yellow-500">Home</a>
            <a href="aboutus.jsp" class="text-gray-600 hover:text-yellow-500">About</a>
            <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500">Contact</a>
            <a href="login.jsp" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600 font-bold">Login</a>
        </nav>
    </header>

    <!-- Main Section -->
    <main class="container mx-auto mt-12 flex-grow flex items-center justify-center">
        <div class="max-w-md w-full mx-auto bg-white p-8 rounded-lg login-card">
            <div class="text-center mb-6">
                <h2 class="text-3xl font-bold text-yellow-500 fade-in">Welcome to Food Bridge Network</h2>
                <p class="text-gray-600 mt-2">Login to enjoy delicious meals at your doorstep</p>
            </div>
            <% if (request.getParameter("error") != null) { %>
                <p class="text-red-500 text-center mb-4"><%= request.getParameter("error") %></p>
            <% } %>
            <form action="user" method="post" class="space-y-6" id="loginForm">
                <input type="hidden" name="action" value="login">
                <div class="input-group">
                    <input type="email" id="email" name="email" required class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:border-orange-600" placeholder="Enter your email">
                    <span class="icon"><i class="fas fa-envelope"></i></span>
                </div>
            <div class="input-group">

                    <input type="password" name="password" class="w-full p-2 border rounded" placeholder="Enter your password" required>
                    <span class="icon"><i class="fas fa-lock"></i></span>

                    </div>
                <div class="text-center">
                    <button type="submit" class="bg-yellow-500 text-white px-6 py-2 rounded-md hover:bg-yellow-600 transition hover-scale" id="loginButton">Login</button>
                </div>
            </form>
            <p class="text-center mt-4 register-text">Don't have an account? <a href="register.jsp" class="text-yellow-500 hover:underline">Register</a></p>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-orange-gradient p-4 text-white text-center mt-auto">
        <div class="flex justify-center mb-2">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold">Food Bridge Network</span>
        </div>
        <p class="text-sm">© 2025 Food Bridge Network Inc. All Rights Reserved</p>
    </footer>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const button = document.getElementById('loginButton');
            button.disabled = true;
            button.classList.add('btn-loading');
            setTimeout(() => {
                button.disabled = false;
                button.classList.remove('btn-loading');
            }, 2000); // Simulate 2-second loading
        });
    </script>
</body>
</html>