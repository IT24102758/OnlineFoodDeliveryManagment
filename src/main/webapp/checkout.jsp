<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DecimalFormat" %>
<html>
<head>
    <title>Checkout - Food Delivery</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- jQuery for AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <!-- Custom CSS -->
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
        .checkout-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .card-details, .contact-details {
            background-color: #fefcbf; /* Pastel yellow to match splash screen cards */
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }
        .btn-success {
            background-color: #eab308; /* Yellow-500 to match splash screen buttons */
            border: none;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s, transform 0.3s ease;
        }
        .btn-success:hover {
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
    <div class="checkout-container bg-white p-4 rounded shadow-lg">
        <h1 class="text-center mb-4" style="color: #2c3e50; font-weight: bold;">Checkout</h1>

        <%
            // Check if user is logged in
            if (session == null || session.getAttribute("userId") == null) {
        %>
        <div class="alert alert-warning" role="alert">
            Please <a href="login.jsp" class="alert-link">log in</a> to proceed with checkout.
        </div>
        <%
                return;
            }

            // Get total from request parameter with null check
            String totalStr = request.getParameter("total");
            double total = 0;
            if (totalStr == null || totalStr.trim().isEmpty()) {
                out.println("<div class='alert alert-danger'>No total amount provided. Please return to cart.</div>");
                %>
                <div class="text-center mt-3">
                    <a href="cart.jsp" class="btn btn-secondary">Back to Cart</a>
                </div>
                <%
                return;
            }
            try {
                total = Double.parseDouble(totalStr);
                if (total <= 0) {
                    out.println("<div class='alert alert-danger'>Invalid total amount. Please return to cart.</div>");
                    %>
                    <div class="text-center mt-3">
                        <a href="cart.jsp" class="btn btn-secondary">Back to Cart</a>
                    </div>
                    <%
                    return;
                }
            } catch (NumberFormatException e) {
                out.println("<div class='alert alert-danger'>Invalid total amount format. Please return to cart.</div>");
                %>
                <div class="text-center mt-3">
                    <a href="cart.jsp" class="btn btn-secondary">Back to Cart</a>
                </div>
                <%
                return;
            }

            // Check if user is premium (set in UserServlet during login)
            boolean isPremium = session.getAttribute("isPremium") != null && (boolean) session.getAttribute("isPremium");
            double discountPercentage = isPremium ? 15.0 : 5.0; // 15% for Premium, 5% for Regular
            double discount = (discountPercentage / 100) * total;
            double discountedTotal = total - discount;

            // Retrieve district from session or form (if submitted)
            String district = request.getParameter("district") != null ? request.getParameter("district") : (String) session.getAttribute("district");

            // Calculate delivery fee based on district
            double deliveryFee = 0.0;
            if (district != null && !district.isEmpty()) {
                deliveryFee = "Colombo".equalsIgnoreCase(district) ? 250.0 : 350.0;
            }

            // Calculate final total including delivery fee
            double finalTotal = discountedTotal + deliveryFee;

            DecimalFormat df = new DecimalFormat("#.##");

            // Get user details from session (if available)
            String deliveryAddress = (String) session.getAttribute("deliveryAddress");
            String phoneNumber = (String) session.getAttribute("phoneNumber");
            String email = (String) session.getAttribute("email");

            // Check for payment error message from PaymentServlet
            String paymentError = request.getParameter("error");
            if (paymentError != null) {
        %>
        <div class="alert alert-danger" role="alert">
            <%= paymentError %>
        </div>
        <%
            }
        %>

        <div class="mb-4">
            <h3 class="mb-2">Order Summary</h3>
            <p><strong>Customer Type:</strong> <%= isPremium ? "Premium" : "Regular" %></p>
            <p><strong>Original Total:</strong> $<%= df.format(total) %></p>
            <p><strong>Discount (<%= isPremium ? "15% Premium" : "5% Regular" %>):</strong> $<%= df.format(discount) %></p>
            <p><strong>Subtotal After Discount:</strong> $<%= df.format(discountedTotal) %></p>
            <p><strong>Delivery Fee:</strong> $<span id="deliveryFee"><%= df.format(deliveryFee) %></span></p>
            <p class="text-success"><strong>Final Total:</strong> $<span id="finalTotal"><%= df.format(finalTotal) %></span></p>
            <% if (!isPremium) { %>
                <p class="text-warning">Note: Upgrade to Premium for a 15% discount on all orders!</p>
            <% } %>
        </div>

        <form id="confirmPaymentForm" action="payment" method="post">
            <!-- Contact Details Section -->
            <div class="contact-details">
                <h3 class="mb-2">Contact Details</h3>
                <div class="mb-3">
                    <label for="phoneNumber" class="form-label">Phone Number</label>
                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="123-456-7890" value="<%= phoneNumber != null ? phoneNumber : "" %>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="example@domain.com" value="<%= email != null ? email : "" %>" required>
                </div>
                <div class="mb-3">
                    <label for="district" class="form-label">District</label>
                    <select class="form-control" id="district" name="district" onchange="updateDeliveryFee()" required>
                        <option value="" disabled <%= district == null ? "selected" : "" %>>Select your district</option>
                        <option value="Colombo" <%= "Colombo".equals(district) ? "selected" : "" %>>Colombo</option>
                        <option value="Gampaha" <%= "Gampaha".equals(district) ? "selected" : "" %>>Gampaha</option>
                        <option value="Kalutara" <%= "Kalutara".equals(district) ? "selected" : "" %>>Kalutara</option>
                        <option value="Kandy" <%= "Kandy".equals(district) ? "selected" : "" %>>Kandy</option>
                        <option value="Matale" <%= "Matale".equals(district) ? "selected" : "" %>>Matale</option>
                        <option value="Nuwara Eliya" <%= "Nuwara Eliya".equals(district) ? "selected" : "" %>>Nuwara Eliya</option>
                        <option value="Galle" <%= "Galle".equals(district) ? "selected" : "" %>>Galle</option>
                        <option value="Matara" <%= "Matara".equals(district) ? "selected" : "" %>>Matara</option>
                        <option value="Hambantota" <%= "Hambantota".equals(district) ? "selected" : "" %>>Hambantota</option>
                        <option value="Jaffna" <%= "Jaffna".equals(district) ? "selected" : "" %>>Jaffna</option>
                        <option value="Kilinochchi" <%= "Kilinochchi".equals(district) ? "selected" : "" %>>Kilinochchi</option>
                        <option value="Mannar" <%= "Mannar".equals(district) ? "selected" : "" %>>Mannar</option>
                        <option value="Vavuniya" <%= "Vavuniya".equals(district) ? "selected" : "" %>>Vavuniya</option>
                        <option value="Mullaitivu" <%= "Mullaitivu".equals(district) ? "selected" : "" %>>Mullaitivu</option>
                        <option value="Batticaloa" <%= "Batticaloa".equals(district) ? "selected" : "" %>>Batticaloa</option>
                        <option value="Ampara" <%= "Ampara".equals(district) ? "selected" : "" %>>Ampara</option>
                        <option value="Trincomalee" <%= "Trincomalee".equals(district) ? "selected" : "" %>>Trincomalee</option>
                        <option value="Kurunegala" <%= "Kurunegala".equals(district) ? "selected" : "" %>>Kurunegala</option>
                        <option value="Puttalam" <%= "Puttalam".equals(district) ? "selected" : "" %>>Puttalam</option>
                        <option value="Anuradhapura" <%= "Anuradhapura".equals(district) ? "selected" : "" %>>Anuradhapura</option>
                        <option value="Polonnaruwa" <%= "Polonnaruwa".equals(district) ? "selected" : "" %>>Polonnaruwa</option>
                        <option value="Badulla" <%= "Badulla".equals(district) ? "selected" : "" %>>Badulla</option>
                        <option value="Moneragala" <%= "Moneragala".equals(district) ? "selected" : "" %>>Moneragala</option>
                        <option value="Ratnapura" <%= "Ratnapura".equals(district) ? "selected" : "" %>>Ratnapura</option>
                        <option value="Kegalle" <%= "Kegalle".equals(district) ? "selected" : "" %>>Kegalle</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="deliveryAddress" class="form-label">Delivery Address</label>
                    <textarea class="form-control" id="deliveryAddress" name="deliveryAddress" rows="3" placeholder="Enter your delivery address" required><%= deliveryAddress != null ? deliveryAddress : "" %></textarea>
                </div>
            </div>

            <!-- Payment Details Section -->
            <div class="card-details mt-4">
                <h3 class="mb-2">Payment Details</h3>
                <div class="mb-3">
                    <label for="cardholderName" class="form-label">Cardholder Name</label>
                    <input type="text" class="form-control" id="cardholderName" name="cardholderName" placeholder="John Doe" required>
                </div>
                <div class="mb-3">
                    <label for="cardNumber" class="form-label">Card Number</label>
                    <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" required>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="expiryDate" class="form-label">Expiry Date</label>
                        <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YYYY" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="cvv" class="form-label">CVV</label>
                        <input type="text" class="form-control" id="cvv" name="cvv" placeholder="123" required>
                    </div>
                </div>
                <input type="hidden" name="discountedTotal" value="<%= discountedTotal %>">
                <button type="submit" class="btn btn-success mt-3">Confirm Payment</button>
            </div>
        </form>

        <div class="text-center mt-4">
            <a href="cart.jsp" class="btn btn-secondary">Back to Cart</a>
        </div>
    </div>
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

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    $(document).ready(function() {
        // Update cart count on page load
        updateCartCount();

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

        // Function to update delivery fee and final total
        window.updateDeliveryFee = function() {
            const district = $('#district').val();
            const discountedTotal = <%= discountedTotal %>;
            let deliveryFee = 0;

            if (district === "Colombo") {
                deliveryFee = 250.0;
            } else if (district !== "") {
                deliveryFee = 350.0;
            }

            const finalTotal = discountedTotal + deliveryFee;

            // Update the displayed values
            $('#deliveryFee').text(deliveryFee.toFixed(2));
            $('#finalTotal').text(finalTotal.toFixed(2));
        };

        // Initialize delivery fee on page load if district is pre-selected
        if ($('#district').val()) {
            updateDeliveryFee();
        }

        // Optional: Add confirmation before payment
        $('#confirmPaymentForm').on('submit', function(e) {
            if (!confirm('Are you sure you want to confirm the payment?')) {
                e.preventDefault();
            }
        });

        // Client-side validation for card number format (e.g., 1234 5678 9012 3456)
        $('#cardNumber').on('input', function() {
            let value = $(this).val().replace(/\D/g, ''); // Remove non-digits
            if (value.length > 16) value = value.substring(0, 16); // Limit to 16 digits
            let formatted = value.match(/.{1,4}/g)?.join(' ') || value; // Add space every 4 digits
            $(this).val(formatted);
        });

        // Client-side validation for expiry date (MM/YYYY)
        $('#expiryDate').on('input', function() {
            let value = $(this).val().replace(/\D/g, ''); // Remove non-digits
            if (value.length > 6) value = value.substring(0, 6); // Limit to 6 digits (MMYYYY)
            if (value.length > 2) {
                value = value.substring(0, 2) + '/' + value.substring(2); // Add slash after MM
            }
            $(this).val(value);
        });

        // Client-side validation for CVV (3 digits)
        $('#cvv').on('input', function() {
            let value = $(this).val().replace(/\D/g, ''); // Remove non-digits
            if (value.length > 3) value = value.substring(0, 3); // Limit to 3 digits
            $(this).val(value);
        });

        // Client-side validation for phone number (e.g., 123-456-7890)
        $('#phoneNumber').on('input', function() {
            let value = $(this).val().replace(/\D/g, ''); // Remove non-digits
            if (value.length > 10) value = value.substring(0, 10); // Limit to 10 digits
            let formatted = value;
            if (value.length > 3 && value.length <= 6) {
                formatted = value.substring(0, 3) + '-' + value.substring(3);
            } else if (value.length > 6) {
                formatted = value.substring(0, 3) + '-' + value.substring(3, 6) + '-' + value.substring(6);
            }
            $(this).val(formatted);
        });
    });
</script>
</body>
</html>