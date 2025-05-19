<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home - Pizza Cow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        .bg-orange-gradient {
            background: linear-gradient(90deg, #f97316, #fdba74);
        }
        .bg-image {
            background-image: url('<%=request.getContextPath()%>/assets/images/background1.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
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
        .card-circle {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .card-circle.profile {
            background-color: #fefcbf; /* Pastel yellow */
        }
        .card-circle.restaurants {
            background-color: #fed7aa; /* Pastel orange */
        }
        .card-circle.support {
            background-color: #fbcfe8; /* Pastel pink */
        }
        .card-circle i {
            font-size: 3rem;
            margin-bottom: 0.5rem;
            color: #4b5563; /* gray-600 */
        }
        .card-circle .card-title {
            font-size: 1.1rem;
            color: #4b5563; /* gray-600 */
        }
        .card-circle .card-text {
            font-size: 1rem;
            max-width: 120px;
            color: #4b5563; /* gray-600 */
        }
        .go-button {
            display: inline-block;
            padding: 4px 12px;
            background-color: #4a5568; /* Dark gray */
            color: #ffffff; /* White */
            border-radius: 9999px; /* Fully rounded */
            transition: transform 0.2s ease;
            text-decoration: none;
        }
        .go-button:hover {
            transform: scale(1.1);
        }
        .go-button:active {
            animation: clickScale 0.1s ease;
        }
        @keyframes clickScale {
            0% { transform: scale(1); }
            50% { transform: scale(0.95); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body class="min-h-screen flex flex-col text-gray-800">
    <!-- Header -->
    <header class="bg-white p-4 flex justify-between items-center shadow-md">
        <div class="flex items-center">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
        </div>
        <nav class="space-x-4">
            <a href="#" class="text-gray-600 hover:text-yellow-500">Home</a>
            <a href="user.jsp?action=read" class="text-gray-600 hover:text-yellow-500">Profile</a>
            <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500">Support</a>
            <a href="orderHistory.jsp" class="text-gray-600 hover:text-yellow-500">Order History</a>
            <a href="logout.jsp" class="bg-white text-gray-600 border border-gray-300 px-4 py-2 rounded hover:bg-gray-100">Logout</a>
        </nav>
    </header>

    <!-- Main Section -->
    <main class="flex-grow bg-image flex items-center justify-center py-16">
        <div class="text-center">
            <h1 class="text-3xl font-bold text-white mb-8">Welcome back to Pizza Cow!</h1>
            <div class="flex justify-center space-x-8">
                <!-- Profile Card -->
                <div class="card-circle profile fade-in hover-scale">
                    <i class="fas fa-user-circle"></i>
                    <h5 class="card-title">View your Profile</h5>
                    <p class="card-text">Manage your account details</p>
                    <a href="user.jsp?action=read" class="go-button mt-2">Go</a>
                </div>
                <!-- Browse Restaurants Card -->
                <div class="card-circle restaurants fade-in hover-scale">
                    <i class="fas fa-utensils"></i>
                    <h5 class="card-title">Browse Restaurants</h5>
                    <p class="card-text">Explore dining options</p>
                    <a href="cuisineSelection.jsp" class="go-button mt-2">Go</a>
                </div>
                <!-- Customer Support Card -->
                <div class="card-circle support fade-in hover-scale">
                    <i class="fas fa-headset"></i>
                    <h5 class="card-title">Customer Support</h5>
                    <p class="card-text">Get help anytime</p>
                    <a href="supportRequest.jsp" class="go-button mt-2">Go</a>
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
                <li><a href="#" class="text-cyan-300 hover:underline">Home</a></li>
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