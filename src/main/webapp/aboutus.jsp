<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About Us - Pizza Cow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .bg-orange-gradient {
            background: linear-gradient(90deg, #f97316, #fdba74);
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
        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white p-4 flex justify-between items-center shadow-md">
        <div class="flex items-center">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
        </div>
        <nav class="space-x-4">


            <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500">Contact</a>
            <a href="login.jsp" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600">Start Ordering</a>
        </nav>
    </header>

    <!-- Main Section -->
    <main class="flex-grow bg-orange-gradient">
        <div class="container mx-auto py-16 px-4">
            <div class="text-center text-white mb-12 fade-in">
                <h1 class="text-4xl font-bold mb-4">About Pizza Cow</h1>
                <p class="text-lg max-w-2xl mx-auto">At Pizza Cow, we’re passionate about bringing delicious food from your favorite local restaurants right to your door. Founded in 2023, our mission is to make every craving count with fast, reliable, and delightful delivery.</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
                <div class="bg-white p-6 rounded-lg card fade-in">
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">Our Vision</h2>
                    <p class="text-gray-600">We believe food is more than just a meal—it’s an experience. That’s why we partner with over 20 restaurants to offer a diverse menu that satisfies every taste, from pizza to salads and everything in between.</p>
                    <img src="<%=request.getContextPath()%>/assets/images/pizza.jpg" alt="Pizza" class="w-32 h-32 object-cover mt-4 mx-auto hover-scale">
                </div>
                <div class="bg-white p-6 rounded-lg card fade-in">
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">Our Team</h2>
                    <p class="text-gray-600">Our dedicated team of food enthusiasts and delivery experts works around the clock to ensure your order arrives hot and fresh. We’re a community-driven company, proud to serve neighborhoods with love and care.</p>
                    <img src="<%=request.getContextPath()%>/assets/images/food-delivery-bag.jpg" alt="Delivery Bag" class="w-32 h-32 object-cover mt-4 mx-auto hover-scale">
                </div>
            </div>
            <div class="text-center mt-12 fade-in">
                <h2 class="text-3xl font-bold text-white mb-4">Ready to Satisfy Your Cravings?</h2>
                <a href="login.jsp" class="bg-yellow-500 text-white px-6 py-3 rounded hover:bg-yellow-600 text-lg hover-scale inline-block">Order Now</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-orange-gradient p-4 text-white text-center">
        <div class="flex justify-center mb-2">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold">Pizza Cow</span>
        </div>
        <p class="text-sm">© 2025 Pizza Cow Inc. All Rights Reserved</p>
    </footer>
</body>
</html>