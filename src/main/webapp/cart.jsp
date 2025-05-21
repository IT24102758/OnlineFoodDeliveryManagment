<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.IOException" %>
<%@ page import="model.MenuItem" %>
<%@ page import="utils.FileUtils" %>
<html>
<head>
    <title>Cart - Food Delivery</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- jQuery for AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <!-- Custom CSS for Additional Styling -->
    <style>
        body {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Match splash screen gradient */
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        /* Header Styling to Match Splash Screen */
        header {
            background: #ffffff; /* White background like splash screen */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: #eab308; /* Yellow-500 for brand text */
        }
        .navbar-nav .nav-link {
            font-size: 1.1rem;
            padding: 0.5rem 1rem;
            color: #4b5563; /* Gray-600 like splash screen */
        }
        .navbar-nav .nav-link:hover {
            color: #eab308; /* Yellow-500 on hover */
        }
        /* Cart Table Styling */
        .cart-table {
            background: #fefcbf; /* Pastel yellow to match splash screen cards */
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
        }
        .cart-table th, .cart-table td {
            vertical-align: middle;
            color: #2c3e50; /* Dark gray for contrast */
        }
        .quantity-selector {
            display: flex;
            align-items: center;
        }
        .quantity-selector button {
            width: 30px;
            height: 30px;
            padding: 0;
            font-size: 1rem;
            border: 1px solid #ced4da;
            background-color: #e9ecef;
            border-radius: 0.25rem;
        }
        .quantity-selector input {
            width: 50px;
            text-align: center;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            margin: 0 0.5rem;
        }
        .remove-btn {
            background-color: #dc3545;
            border: none;
            padding: 0.25rem 0.5rem;
            font-size: 0.9rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s;
        }
        .remove-btn:hover {
            background-color: #c82333;
        }
        .checkout-btn, .btn-primary {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            border: none;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .checkout-btn:hover, .btn-primary:hover {
            background-color: #d69e2e; /* Darker yellow for hover */
            transform: scale(1.05); /* Match splash screen hover effect */
        }
        .btn-secondary {
            background-color: #6c757d; /* Keep secondary button as is for contrast */
            border: none;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            transform: scale(1.05);
        }
        /* Footer Styling to Match Splash Screen */
        footer {
            background: linear-gradient(90deg, #f97316, #fdba74); /* Match splash screen gradient */
            padding: 2rem 0;
            margin-top: auto;
            color: #ffffff; /* White text */
        }
        footer a {
            color: #ffffff; /* White links to match splash screen text */
            text-decoration: none;
        }
        footer a:hover {
            text-decoration: underline;
            color: #eab308; /* Yellow-500 on hover for consistency */
        }
    </style>
</head>
<body>
<!-- Header (Navbar) -->
<header>
    <nav class="navbar navbar-expand-lg navbar-light" style="background: #ffffff;">
        <div class="container-fluid">
            <a class="navbar-brand" href="home.jsp">
                <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
                <span class="ml-2 text-xl font-semibold text-yellow-500">Food Bridge Network</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
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
                            <i class="fas fa-shopping-cart"></i> Cart <span id="cart-count" class="badge bg-secondary">0</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>

<!-- Main Content -->
<main class="container my-5">
    <h1 class="text-center mb-4" style="color: #2c3e50; font-weight: bold;">Your Cart</h1>
    <%
        // Use the implicit session object instead of redeclaring
        if (session == null || session.getAttribute("userId") == null) {
    %>
    <div class="alert alert-warning" role="alert">
        Please <a href="login.jsp" class="alert-link">log in</a> to view your cart.
    </div>
    <%
        return;
    }

    String userId = (String) session.getAttribute("userId");
    @SuppressWarnings("unchecked")
    Map<String, List<Map<String, Object>>> allCarts = (Map<String, List<Map<String, Object>>>) session.getAttribute("allCarts");
    List<Map<String, Object>> cart = allCarts != null ? allCarts.getOrDefault(userId, new ArrayList<>()) : new ArrayList<>();

    List<MenuItem> allMenuItems = new ArrayList<>();
    try {
        List<String> menuData = FileUtils.readFromFile(getServletContext(), "menu.txt");
        for (String line : menuData) {
            try {
                allMenuItems.add(MenuItem.fromString(line));
            } catch (IllegalArgumentException e) {
                System.err.println("Error parsing menu item: " + e.getMessage());
            }
        }
    } catch (IOException e) {
        System.err.println("Error reading menu.txt: " + e.getMessage());
    }

    if (cart.isEmpty()) {
    %>
    <p class="text-center" style="color: #2c3e50;">Your cart is empty.</p>
    <div class="text-center">
        <a href="restaurantByCuisine.jsp?cuisine=ITALIAN" class="btn btn-primary">Continue Shopping</a>
    </div>
    <%
    } else {
        double total = 0;
    %>
    <table class="table cart-table">
        <thead>
            <tr>
                <th>Item</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Subtotal</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, Object> cartItem : cart) {
                String itemId = (String) cartItem.get("itemId");
                String restaurantId = (String) cartItem.get("restaurantId");
                int quantity = (int) cartItem.get("quantity");

                MenuItem menuItem = allMenuItems.stream()
                        .filter(item -> item.getId().equals(itemId) && item.getRestaurantId().equals(restaurantId))
                        .findFirst()
                        .orElse(null);

                if (menuItem != null) {
                    double price = menuItem.getPrice();
                    double subtotal = price * quantity;
                    total += subtotal;
        %>
        <tr id="cart-item-<%= itemId %>">
            <td><%= menuItem.getDishName() != null ? menuItem.getDishName() : "Unknown Dish" %></td>
            <td>
                <div class="quantity-selector">
                    <button type="button" class="btn btn-sm decrease-quantity" data-item-id="<%= itemId %>" data-restaurant-id="<%= restaurantId %>">-</button>
                    <input type="number" class="quantity-input" value="<%= quantity %>" min="1" max="99" readonly>
                    <button type="button" class="btn btn-sm increase-quantity" data-item-id="<%= itemId %>" data-restaurant-id="<%= restaurantId %>">+</button>
                </div>
            </td>
            <td>$<%= String.format("%.2f", price) %></td>
            <td>$<%= String.format("%.2f", subtotal) %></td>
            <td>
                <button type="button" class="btn btn-danger remove-btn" data-item-id="<%= itemId %>" data-restaurant-id="<%= restaurantId %>">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3" class="text-end fw-bold">Total</td>
                <td>$<%= String.format("%.2f", total) %></td>
                <td></td>
            </tr>
        </tfoot>
    </table>
    <div class="text-end mt-3">
        <%
            // Ensure total is valid before creating the checkout link
            if (total <= 0) {
        %>
        <div class="alert alert-warning" role="alert">
            Unable to proceed with an invalid total. Please review your cart.
        </div>
        <%
            } else {
        %>
        <a href="checkout.jsp?total=<%= String.format("%.2f", total) %>" class="btn btn-primary checkout-btn">Proceed to Checkout</a>
        <a href="restaurantByCuisine.jsp?cuisine=ITALIAN" class="btn btn-secondary ms-2">Continue Shopping</a>
        <%
            }
        %>
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
                <h5 class="text-uppercase">Food Delivery</h5>
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
                <p>Email: <a href="mailto:support@fooddelivery.com">support@fooddelivery.com</a></p>
                <p>Phone: (123) 456-7890</p>
                <div class="mt-2">
                    <a href="#" class="me-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="me-2"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold mx-auto">PC</div>
            <span class="block text-xl font-semibold">Food Bridge Network</span>
            <p class="text-sm mt-2">© 2025 Food Delivery System. All Rights Reserved.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS (for Navbar Toggle) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    $(document).ready(function() {
        // Update cart count on page load
        updateCartCount();

        // Quantity selector functionality
        $('.increase-quantity').on('click', function() {
            let $input = $(this).siblings('.quantity-input');
            let currentValue = parseInt($input.val()) || 1;
            if (currentValue < 99) {
                $input.val(currentValue + 1);
                updateQuantity($(this).data('item-id'), $(this).data('restaurant-id'), currentValue + 1);
            }
        });

        $('.decrease-quantity').on('click', function() {
            let $input = $(this).siblings('.quantity-input');
            let currentValue = parseInt($input.val()) || 1;
            if (currentValue > 1) {
                $input.val(currentValue - 1);
                updateQuantity($(this).data('item-id'), $(this).data('restaurant-id'), currentValue - 1);
            }
        });

        // Remove item functionality
        $('.remove-btn').on('click', function() {
            let itemId = $(this).data('item-id');
            let restaurantId = $(this).data('restaurant-id');
            if (confirm('Are you sure you want to remove this item?')) {
                removeItem(itemId, restaurantId);
            }
        });

        // Update quantity via AJAX
        function updateQuantity(itemId, restaurantId, quantity) {
            $.ajax({
                url: 'cart?action=update',
                method: 'POST',
                data: {
                    itemId: itemId,
                    restaurantId: restaurantId,
                    quantity: quantity
                },
                success: function(response) {
                    console.log('Update Quantity Success:', response);
                    let count = response.count || 0;
                    $('#cart-count').text(count);
                    location.reload(); // Refresh page to update totals
                },
                error: function(xhr, status, error) {
                    console.error('Update Quantity Error:', status, error);
                    alert('Error updating quantity: ' + xhr.responseText);
                }
            });
        }

        // Remove item via AJAX
        function removeItem(itemId, restaurantId) {
            $.ajax({
                url: 'cart?action=remove',
                method: 'POST',
                data: {
                    itemId: itemId,
                    restaurantId: restaurantId
                },
                success: function(response) {
                    console.log('Remove Item Success:', response);
                    let count = response.count || 0;
                    $('#cart-count').text(count);
                    $('#cart-item-' + itemId).remove();
                    if (count === 0) {
                        location.reload(); // Refresh if cart is empty
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Remove Item Error:', status, error);
                    alert('Error removing item: ' + xhr.responseText);
                }
            });
        }

        // Update cart count
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
    });
</script>
</body>
</html>