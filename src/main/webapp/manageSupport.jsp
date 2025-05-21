<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, model.SupportRequest" %>
<html>
<head>
    <title>Manage Support Requests - Food Bridge Network</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
        .container-main {
            background: #fefcbf; /* Pastel yellow to match splash screen cards */
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
            padding: 1.5rem;
        }
        .request-card {
            background: #ffffff; /* White for better contrast */
            border: 1px solid #e5e7eb; /* Light gray border */
            border-radius: 0.375rem;
            padding: 1rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .request-card:hover {
            transform: translateY(-5px); /* Slight lift on hover */
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); /* Enhanced shadow on hover */
        }
        .text-dark {
            color: #2c3e50 !important; /* Ensure contrast with pastel yellow background */
        }
        .btn-action-respond {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            color: #ffffff; /* White */
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: background-color 0.3s, transform 0.2s ease;
        }
        .btn-action-respond:hover {
            background-color: #d69e2e; /* Darker yellow for hover */
            transform: scale(1.05); /* Match splash screen hover effect */
        }
        .btn-action-resolve {
            background-color: #10b981; /* Green-600 for resolve action */
            color: #ffffff; /* White */
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: background-color 0.3s, transform 0.2s ease;
        }
        .btn-action-resolve:hover {
            background-color: #059669; /* Darker green for hover */
            transform: scale(1.05);
        }
        .btn-action-view {
            background-color: #3b82f6; /* Blue-600 for view action */
            color: #ffffff; /* White */
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: background-color 0.3s, transform 0.2s ease;
        }
        .btn-action-view:hover {
            background-color: #2563eb; /* Darker blue for hover */
            transform: scale(1.05);
        }
        .btn-back {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Gradient to match splash screen */
            color: #ffffff; /* White */
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: transform 0.2s ease;
        }
        .btn-back:hover {
            transform: scale(1.05); /* Match splash screen hover effect */
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
    <%
        // Check if the user is logged in and is an admin
        String userId = (String) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        if (userId == null || !"admin".equals(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get support requests and user names from request attributes
        @SuppressWarnings("unchecked")
        List<SupportRequest> supportRequests = (List<SupportRequest>) request.getAttribute("supportRequests");
        @SuppressWarnings("unchecked")
        Map<String, String> userNames = (Map<String, String>) request.getAttribute("userNames");

        if (supportRequests == null) {
            supportRequests = new ArrayList<>();
        }
    %>

    <!-- Header -->
    <header>
        <nav class="p-4">
            <div class="container mx-auto flex justify-between items-center">
                <a href="home.jsp" class="navbar-brand">
                    <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                    <span class="ml-2 text-xl font-semibold text-yellow-500">Food Bridge Network</span>
                </a>
                <div class="space-x-4">
                    <a href="adminDashboard.jsp" class="nav-link">Dashboard</a>
                    <a href="user?action=read" class="nav-link">Manage Users</a>
                    <a href="restaurant?action=list" class="nav-link">Manage Restaurants</a>
                    <a href="manageSupportRequest.jsp" class="nav-link font-semibold">Support Requests</a>
                    <a href="logout.jsp" class="nav-link">Logout</a>
                </div>
            </div>
        </nav>
    </header>

    <main class="container mx-auto mt-8 flex-grow">
        <div class="container-main">
            <h2 class="text-2xl font-bold text-center text-dark mb-6">Manage Support Requests</h2>
            <div class="mb-4">
                <a href="adminDashboard.jsp" class="btn-back">Back to Dashboard</a>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <%
                    if (supportRequests != null && !supportRequests.isEmpty()) {
                        for (SupportRequest request : supportRequests) {
                            String userName = userNames != null ? userNames.getOrDefault(request.getUserId(), "Unknown User") : "Unknown User";
                %>
                <div class="request-card">
                    <h3 class="text-lg font-semibold text-dark">Request ID: <%= request.getRequestId() %></h3>
                    <p class="text-gray-600"><strong>User ID:</strong> <%= request.getUserId() %> (<%= userName %>)</p>
                    <p class="text-gray-600"><strong>Subject:</strong> <%= request.getSubject() %></p>
                    <p class="text-gray-600"><strong>Description:</strong> <%= request.getDescription() %></p>
                    <p class="text-gray-600"><strong>Status:</strong>
                        <span class="<%= request.getStatus().equals("Resolved") ? "text-green-600" : "text-yellow-600" %>">
                            <%= request.getStatus() %>
                        </span>
                    </p>
                    <p class="text-gray-600"><strong>Submitted On:</strong> <%= request.getTimestamp() %></p>
                    <div class="mt-4 flex space-x-2">
                        <a href="supportRequest?action=view&requestId=<%= request.getRequestId() %>" class="btn-action-view">
                            <i class="fas fa-eye mr-1"></i> View Details
                        </a>
                        <%
                            if (!"Resolved".equals(request.getStatus())) {
                        %>
                        <a href="supportRequest?action=respond&requestId=<%= request.getRequestId() %>" class="btn-action-respond">
                            <i class="fas fa-reply mr-1"></i> Respond
                        </a>
                        <form action="supportRequest" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="resolve">
                            <input type="hidden" name="requestId" value="<%= request.getRequestId() %>">
                            <button type="submit" class="btn-action-resolve" onclick="return confirm('Are you sure you want to mark this request as resolved?');">
                                <i class="fas fa-check mr-1"></i> Resolve
                            </button>
                        </form>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <p class="text-center text-gray-600 col-span-3">No support requests available.</p>
                <%
                    }
                %>
            </div>
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
                    <li><a href="manageSupportRequest.jsp" class="text-yellow-500 hover:text-yellow-300">Support Requests</a></li>
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