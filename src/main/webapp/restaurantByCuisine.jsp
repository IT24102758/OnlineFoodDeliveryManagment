<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Restaurant" %>
<html>
<head>
    <title>Restaurants by Cuisine - Pizza Cow</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- jQuery for AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <!-- Custom CSS for Additional Styling -->
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Pizza Cow orange gradient */
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: #4b5563; /* Gray-600 for contrast on white background */
        }
        .navbar-nav .nav-link {
            font-size: 1.1rem;
            padding: 0.5rem 1rem;
            color: #4b5563; /* Gray-600 for contrast on white background */
        }
        .navbar-nav .nav-link:hover {
            color: #f97316; /* Orange on hover */
        }
        .restaurant-card {
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        .modal .menu-item {
            margin-bottom: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 0.5rem;
        }
        footer {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Pizza Cow orange gradient */
            color: white;
            padding: 2rem 0;
            margin-top: auto;
        }
        footer a {
            color: #00d4ff; /* Cyan-300 for links */
            text-decoration: none;
        }
        footer a:hover {
            text-decoration: underline;
        }
        h1 {
            color: #4b5563; /* Gray-600 for headings */
            font-weight: bold;
        }
        .btn-custom {
            background-color: #eab308; /* Yellow-500 from splash screen */
            color: white;
            transition: transform 0.3s ease;
        }
        .btn-custom:hover {
            background-color: #d69e2e; /* Slightly darker yellow for hover */
            transform: scale(1.05); /* Matching hover-scale from home.jsp */
        }
    </style>
</head>
<body>
<!-- Header (Navbar) -->
<header>
    <nav class="navbar navbar-expand-lg" style="background-color: #ffffff;"> <!-- White background -->
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Pizza Cow</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Inside the navbar in restaurantByCuisine.jsp -->
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="home.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="user.jsp?action=read">Profile</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Support</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="cart.jsp">
                        <i class="fas fa-shopping-cart"></i> Cart <span id="cart-count" class="badge bg-light text-dark">0</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Logout</a>
                </li>
            </ul>

            <!-- Add this script at the bottom of restaurantByCuisine.jsp -->
            <script>
            // Fetch initial cart count on page load
            $(document).ready(function() {
                updateCartCount();
            });

            function updateCartCount() {
                $.ajax({
                    url: 'cart?action=getCount',
                    method: 'GET',
                    success: function(response) {
                        let cartCount = response.count || 0;
                        $('#cart-count').text(cartCount);
                    },
                    error: function(xhr, status, error) {
                        console.error('Error fetching cart count:', status, error);
                    }
                });
            }
            </script>
            </div>
        </div>
    </nav>
</header>

<!-- Main Content -->
<main class="container my-5">
    <%
        // Retrieve the selected cuisine from the request parameter
        String selectedCuisine = request.getParameter("cuisine");
        System.out.println("Received cuisine parameter: " + selectedCuisine);

        // Retrieve the filtered restaurant list from the request attribute
        List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
        System.out.println("Received restaurant list size: " + (restaurants != null ? restaurants.size() : "null"));

        if (selectedCuisine != null && !selectedCuisine.isEmpty()) {
    %>
    <h1 class="text-center mb-5" style="color: #4b5563; font-weight: bold;"><%= selectedCuisine %> Restaurants</h1>
    <div class="mb-4">
        <a href="cuisineSelection?action=cuisine" class="btn btn-custom"><i class="fas fa-arrow-left me-2"></i>Back to Cuisine Selection</a>
    </div>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <%
            if (restaurants != null && !restaurants.isEmpty()) {
                for (Restaurant restaurant : restaurants) {
                    System.out.println("Displaying restaurant: " + restaurant.getName() + ", Cuisine: " + restaurant.getCuisineType());
        %>
        <div class="col">
            <div class="restaurant-card card h-100">
                <div class="card-body">
                    <h5 class="card-title"><%= restaurant.getName() %></h5>
                    <p class="card-text">
                        <strong>Location:</strong> <%= restaurant.getLocation() %><br>
                        <strong>Cuisine:</strong> <%= restaurant.getCuisineType() %><br>
                        <strong>Contact:</strong> <%= restaurant.getContactInfo() %><br>
                        <strong>Hours:</strong> <%= restaurant.getOperationHours() %>
                    </p>
                    <!-- View Menu Button -->
                    <button type="button" class="btn btn-custom view-menu-btn" data-bs-toggle="modal" data-bs-target="#menuModal"
                            data-restaurant-id="<%= restaurant.getId() %>">
                        View Menu
                    </button>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <p class="text-center text-gray-600 col-span-3">No <%= selectedCuisine %> restaurants available.</p>
        <%
            }
        %>
    </div>
    <%
        } else {
    %>
    <p class="text-center text-gray-600">No cuisine selected. Please go back and select a cuisine.</p>
    <div class="text-center">
        <a href="cuisineSelection?action=cuisine" class="btn btn-custom">Back to Cuisine Selection</a>
    </div>
    <%
        }
    %>
</main>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-4 text-center text-md-start mb-3 mb-md-0">
                <h5 class="text-uppercase">Pizza Cow</h5>
                <p>Your one-stop platform for ordering food online.</p>
            </div>
            <div class="col-md-4 text-center mb-3 mb-md-0">
                <h5 class="text-uppercase">Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="home.jsp">Home</a></li>
                    <li><a href="user.jsp?action=read">Profile</a></li>
                    <li><a href="#">Support</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                </ul>
            </div>
            <div class="col-md-4 text-center text-md-end">
                <h5 class="text-uppercase">Contact Us</h5>
                <p>Email: <a href="mailto:support@pizzacow.com">support@pizzacow.com</a></p>
                <p>Phone: (123) 456-7890</p>
                <div class="mt-2">
                    <a href="#" class="me-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="me-2"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <p>© 2025 Pizza Cow Inc. All Rights Reserved.</p>
        </div>
    </div>
</footer>

<!-- Menu Modal -->
<div class="modal fade" id="menuModal" tabindex="-1" aria-labelledby="menuModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="menuModalLabel">Menu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="menuContent">
                <p>Loading menu...</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS (for Navbar Toggle and Modal) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<!-- JavaScript to Fetch and Display Menu -->
<script>
    $(document).ready(function() {
        $('.view-menu-btn').on('click', function() {
            var restaurantId = $(this).data('restaurant-id');
            $('#menuContent').html('<p>Loading menu...</p>');

            $.ajax({
                url: 'menu?action=list&restaurantId=' + restaurantId,
                method: 'GET',
                success: function(response) {
                    console.log('AJAX Success: Response received');
                    console.log('Response:', response);
                    if (response.trim() === "" || typeof response !== 'string') {
                        $('#menuContent').html('<p>No menu items available for this restaurant.</p>');
                    } else {
                        $('#menuContent').html(response);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error: ', status, error);
                    console.error('Response Text: ', xhr.responseText);
                    var errorMessage = 'Error loading menu: ' + status + ' - ' + error;
                    if (xhr.responseText) {
                        errorMessage += '<br>Server Response: ' + xhr.responseText;
                    }
                    $('#menuContent').html('<p>' + errorMessage + '</p>');
                }
            });
        });
    });
</script>