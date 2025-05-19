<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Registration</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        .bg-orange-gradient {
            background: linear-gradient(90deg, #f97316, #fdba74);
        }
        .fade-in {
            animation: fadeIn 1s ease-in-out;
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
        .input-group {
            position: relative;
        }
        .input-group .icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #f59e0b; /* yellow-500 */
        }
        .input-group input, .input-group select {
            padding-left: 2.5rem;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .input-group input:focus, .input-group select:focus {
            border-color: #f59e0b; /* yellow-500 */
            box-shadow: 0 0 8px rgba(245, 158, 11, 0.5); /* yellow-500 glow */
            outline: none;
        }
        .btn-loading {
            background: #f59e0b; /* yellow-500 */
            opacity: 0.7;
            cursor: not-allowed;
        }
    </style>
</head>
<body class="bg-orange-gradient flex items-center justify-center min-h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md fade-in">
        <h1 class="text-2xl font-bold mb-6 text-center text-gray-800">Register New User</h1>
        <form action="user" method="post" class="space-y-4" id="registerForm">
            <input type="hidden" name="action" value="create">
            <div class="input-group">
                <input type="text" name="name" class="w-full p-2 border rounded" placeholder="Enter your name" required>
                <span class="icon"><i class="fas fa-user"></i></span>
            </div>
            <div class="input-group">
                <input type="email" name="email" class="w-full p-2 border rounded" placeholder="Enter your email" required>
                <span class="icon"><i class="fas fa-envelope"></i></span>
            </div>
            <div class="input-group">
                <input type="password" name="password" class="w-full p-2 border rounded" placeholder="Enter your password" required>
                <span class="icon"><i class="fas fa-lock"></i></span>
            </div>
            <div class="input-group">
                <input type="text" name="address" class="w-full p-2 border rounded" placeholder="Enter your address" required>
                <span class="icon"><i class="fas fa-home"></i></span>
            </div>
            <div class="input-group">
                <input type="text" name="phone" class="w-full p-2 border rounded" placeholder="Enter your phone number" required>
                <span class="icon"><i class="fas fa-phone"></i></span>
            </div>
            <div class="input-group">
                <select name="type" class="w-full p-2 border rounded" required>
                    <option value="" disabled selected>Select user type</option>
                    <option value="Regular">Regular Customer</option>
                    <option value="Premium">Premium Customer</option>
                </select>
                <span class="icon"><i class="fas fa-user-tag"></i></span>
            </div>
            <button type="submit" class="w-full bg-yellow-500 text-white py-2 rounded hover:bg-yellow-600 hover-scale" id="registerButton">Register</button>
        </form>
        <p class="mt-4 text-center text-gray-600">
            Already have an account? <a href="login.jsp" class="text-yellow-500 hover:underline hover-scale">Login here</a>
        </p>
    </div>
    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const button = document.getElementById('registerButton');
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