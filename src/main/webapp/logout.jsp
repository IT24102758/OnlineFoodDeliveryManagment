<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logout</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta http-equiv="refresh" content="3;url=login.jsp">
    <style>
        .bg-orange-gradient {
            background: linear-gradient(90deg, #f97316, #fdba74);
        }
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container {
            margin-top: 5rem;
            margin-bottom: 5rem;
        }
        .card {
            background-color: #fefcbf; /* Pastel yellow to match splash screen cards */
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
        }
        .text-dark {
            color: #2c3e50 !important; /* Ensure contrast with pastel yellow background */
        }
        header {
            background: #ffffff; /* White background like splash screen */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: #eab308; /* Yellow-500 for brand text */
        }
        footer {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Match splash screen gradient */
            color: #ffffff; /* White text */
            padding: 2rem 0;
            margin-top: auto;
        }
        footer a {
            color: #eab308; /* Yellow-500 to match splash screen accents */
            text-decoration: none;
        }
        footer a:hover {
            text-decoration: underline;
            color: #d69e2e; /* Darker yellow for hover */
        }
        .logout-link {
            color: #eab308; /* Yellow-500 for link */
        }
        .logout-link:hover {
            color: #d69e2e; /* Darker yellow on hover */
        }
    </style>
</head>
<body class="bg-orange-gradient">
    <%
        // Invalidate the session to log the user out
        session.invalidate();
    %>

    <!-- Header -->
    <header>
        <nav class="p-4">
            <div class="container mx-auto flex justify-between items-center">
                <a href="home.jsp" class="navbar-brand">
                    <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                    <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
                </a>
            </div>
        </nav>
    </header>

    <main class="container mx-auto mt-8 flex-grow flex items-center justify-center">
        <div class="card text-center">
            <h2 class="text-2xl font-bold text-dark mb-4">You Have Been Logged Out</h2>
            <p class="text-gray-600 mb-4">Thank you for using our service. You will be redirected to the login page shortly.</p>
            <p class="text-gray-600">If you are not redirected, <a href="login.jsp" class="logout-link hover:underline">click here to login again</a>.</p>
        </div>
    </main>

    <footer>
        <div class="container mx-auto text-center">
            <div class="flex justify-center mb-4">
                <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                <span class="ml-2 text-xl font-semibold">Pizza Cow</span>
            </div>
            <p class="mt-4 text-sm">© 2025 Pizza Cow Inc. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</body>
</html>