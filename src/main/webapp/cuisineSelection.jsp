<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.RestaurantType" %>
<html>
<head>
    <title>Cuisine Selection - Pizza Cow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .cuisine-container {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            margin: 0 auto;
            max-width: 900px;
            width: 90%;
        }
        h1 {
            color: #4b5563; /* gray-600 */
            font-weight: bold;
            margin-bottom: 2rem;
            text-align: center;
        }
        .cuisine-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }
        @media (max-width: 768px) {
            .cuisine-row {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 576px) {
            .cuisine-row {
                grid-template-columns: 1fr;
            }
        }
        .cuisine-card {
            background: #fefcbf; /* Pastel yellow */
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.3s ease;
            cursor: pointer;
            height: 200px;
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .cuisine-card:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        .cuisine-card img {
            width: 100%;
            height: 150px;
            object-fit: contain; /* Changed from cover to contain */
            max-width: 100%; /* Ensure image doesn't overflow */
        }
        .cuisine-card .card-text {
            position: absolute;
            bottom: 5px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.5);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 5px;
            font-weight: bold;
            font-size: 0.9rem;
        }
        .btn-back {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: #ffffff; /* White */
            border: none;
            padding: 0.5rem 1.5rem; /* Reduced padding */
            border-radius: 50px;
            font-weight: 400; /* Reduced boldness */
            transition: transform 0.2s ease;
            display: inline-block;
            margin: 0 auto;
        }
        .btn-back:hover {
            transform: scale(1.1);
        }
        .btn-back:active {
            animation: clickScale 0.1s ease;
        }
        footer {
            background: linear-gradient(90deg, #f97316, #fdba74);
            color: white;
            padding: 2rem 0;
            margin-top: auto;
            width: 100%;
        }
        header {
            background: white;
            padding: 1rem 2rem;
            width: 100%;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
<header class="w-full">
    <div class="container mx-auto flex justify-between items-center">
        <div class="flex items-center">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
        </div>
        <nav class="space-x-4">
            <a href="home.jsp" class="text-gray-600 hover:text-yellow-500">Home</a>
            <a href="user.jsp?action=read" class="text-gray-600 hover:text-yellow-500">Profile</a>
            <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500">Support</a>
            <a href="orderHistory.jsp" class="text-gray-600 hover:text-yellow-500">Order History</a>
            <a href="logout.jsp" class="bg-white text-gray-600 border border-gray-300 px-4 py-2 rounded hover:bg-gray-100">Logout</a>
        </nav>
    </div>
</header>

<!-- Main Content -->
<main class="container my-5">
    <div class="cuisine-container">
        <h1 class="text-center">Explore by cuisine</h1>
        <div class="cuisine-row">
            <%
                RestaurantType[] cuisineTypes = RestaurantType.values();
                String basePath = request.getContextPath() + "/assets/images/";
                String[] imageNames = {
                    "italian.jpg",  // Italian
                    "chinese.jpg",  // Chinese
                    "indian.jpg",   // Indian
                    "mexican.jpg",  // Mexican
                    "american.jpg", // American
                    "other.jpg"     // Other
                };
                for (int i = 0; i < cuisineTypes.length; i++) {
                    RestaurantType cuisine = cuisineTypes[i];
                    String imageUrl = basePath + imageNames[i];
            %>
            <a href="restaurantByCuisine?action=byCuisine&cuisine=<%= cuisine.toString() %>" class="text-decoration-none">
                <div class="cuisine-card">
                    <img src="<%= imageUrl %>" alt="<%= cuisine.toString() %> Cuisine">
                    <div class="card-text"><%= cuisine.toString() %></div>
                </div>
            </a>
            <%
                }
            %>
        </div>
        <div class="text-center"> <!-- Added text-center class to center the button -->
            <a href="home.jsp" class="btn-back">Back to Home</a>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="w-full">
    <div class="container mx-auto text-center">
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
            <a href="#" class="text-cyan-200"><i class="fab fa-twitter"></i></a>
            <a href="#" class="text-cyan-300 hover:text-cyan-200"><i class="fab fa-instagram"></i></a>
        </div>
        <p class="mt-4 text-sm">© 2025 Pizza Cow Inc. All Rights Reserved.</p>
    </div>
</footer>
</body>
</html>