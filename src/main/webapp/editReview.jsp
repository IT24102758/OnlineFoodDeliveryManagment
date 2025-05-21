<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Review" %>
<html>
<head>
    <title>Edit Review</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Match splash screen gradient */
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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

        .nav-link {
            font-size: 1.1rem;
            padding: 0.5rem 1rem;
            color: #4b5563; /* Gray-600 like splash screen */
        }

        .nav-link:hover {
            color: #eab308; /* Yellow-500 on hover */
        }

        .review-container {
            background: #fefcbf; /* Pastel yellow to match splash screen cards */
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
        }

        .text-dark {
            color: #2c3e50 !important; /* Ensure contrast with pastel yellow background */
        }

        .btn-primary {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            color: #ffffff;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
            width: 100%;
        }

        .btn-primary:hover {
            background-color: #d69e2e; /* Darker yellow for hover */
            transform: scale(1.05); /* Match splash screen hover effect */
        }

        .input-field {
            border: 1px solid #d1d5db; /* Gray-300 border */
            border-radius: 0.25rem;
            padding: 0.5rem;
            width: 100%;
            transition: border-color 0.3s ease;
        }

        .input-field:focus {
            outline: none;
            border-color: #eab308; /* Yellow-500 on focus */
            box-shadow: 0 0 0 2px rgba(234, 179, 8, 0.2); /* Focus ring */
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
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <nav class="p-4">
            <div class="container mx-auto flex justify-between items-center">
                <a href="home.jsp" class="navbar-brand">
                    <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                    <span class="ml-2 text-xl font-semibold text-yellow-500">Food Bridge Network</span>
                </a>
                <div class="space-x-4">
                    <a href="logout.jsp" class="nav-link">Logout</a>
                </div>
            </div>
        </nav>
    </header>

    <main class="container mx-auto mt-8 flex-grow">
        <div class="review-container p-6 max-w-md mx-auto">
            <h2 class="text-2xl font-bold text-center text-dark mb-6">Edit Review</h2>
            <%
                String errorMessage = (String) request.getAttribute("error");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <p class="text-red-600 text-center mb-4"><%= errorMessage %></p>
            <%
                }
                Review review = (Review) request.getAttribute("review");
                if (review != null) {
            %>
                <form action="review" method="post" class="space-y-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                    <div>
                        <label for="rating" class="block text-gray-700 font-semibold">Rating (1-5):</label>
                        <input type="number" id="rating" name="rating" min="1" max="5" step="0.1" required
                               value="<%= review.getRating() %>"
                               class="input-field">
                    </div>
                    <div>
                        <label for="comment" class="block text-gray-700 font-semibold">Comment:</label>
                        <textarea id="comment" name="comment" rows="4"
                                  class="input-field"><%= review.getComment() != null ? review.getComment() : "" %></textarea>
                    </div>
                    <button type="submit" class="btn-primary">
                        Update Review
                    </button>
                </form>
            <%
                }
            %>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <div class="container mx-auto text-center">
            <div class="flex justify-center mb-4">
                <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                <span class="ml-2 text-xl font-semibold">Food Bridge Network</span>
            </div>
            <div class="mb-4">
                <h5 class="text-lg font-semibold">Quick Links</h5>
                <ul class="list-none space-y-2 mt-2">
                    <li><a href="home.jsp" class="text-yellow-500 hover:text-yellow-300">Home</a></li>
                    <li><a href="user.jsp?action=read" class="text-yellow-500 hover:text-yellow-300">Profile</a></li>
                    <li><a href="supportRequest.jsp" class="text-yellow-500 hover:text-yellow-300">Support</a></li>
                    <li><a href="logout.jsp" class="text-yellow-500 hover:text-yellow-300">Logout</a></li>
                </ul>
            </div>
            <div class="flex justify-center space-x-4">
                <a href="#" class="text-yellow-500 hover:text-yellow-300"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="text-yellow-500 hover:text-yellow-300"><i class="fab fa-twitter"></i></a>
                <a href="#" class="text-yellow-500 hover:text-yellow-300"><i class="fab fa-instagram"></i></a>
            </div>
            <p class="mt-4 text-sm">© 2025 Food Bridge Network Inc. All Rights Reserved.</p>
        </div>
    </footer>
</body>
</html>