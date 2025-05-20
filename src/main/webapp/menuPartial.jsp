<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MenuItem" %>
<!-- Ensure jQuery is available (already included in restaurantByCuisine.jsp) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
<style>
    .menu-item {
        margin-bottom: 1rem;
        padding: 1rem;
        background: #fefcbf; /* Pastel yellow to match splash screen cards */
        border-radius: 0.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .menu-details {
        flex-grow: 1;
    }
    .menu-item img {
        margin-left: 1rem;
    }
    .quantity-selector {
        display: flex;
        align-items: center;
        margin-right: 1rem;
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
        width: 40px;
        text-align: center;
        border: 1px solid #ced4da;
        border-radius: 0.25rem;
        margin: 0 0.5rem;
    }
    .add-to-cart-btn {
        background-color: #eab308; /* Yellow-500 to match splash screen buttons */
        border: none;
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
        border-radius: 0.25rem;
        transition: background-color 0.3s, transform 0.3s ease;
        color: white;
    }
    .add-to-cart-btn:hover {
        background-color: #d69e2e; /* Darker yellow for hover */
        transform: scale(1.05); /* Matching splash screen hover effect */
    }
    .alert-success {
        margin-top: 0.5rem;
        padding: 0.5rem;
        font-size: 0.9rem;
    }
</style>

<%
    List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
    String restaurantId = (String) request.getAttribute("restaurantId");
    String error = (String) request.getAttribute("error");
    System.out.println("menuPartial.jsp: Rendering for restaurantId=" + restaurantId + ", menuItems size=" + (menuItems != null ? menuItems.size() : "null"));
    if (error != null) {
%>
<div class="alert alert-danger" role="alert"><%= error %></div>
<%
    } else if (menuItems != null && !menuItems.isEmpty()) {
        for (MenuItem menuItem : menuItems) {
            System.out.println("menuPartial.jsp: Rendering menu item: " + menuItem.getDishName());
            // Ensure null safety for dishName, description, and imageUrl
            String dishName = (menuItem.getDishName() != null) ? menuItem.getDishName() : "Unknown Dish";
            String description = (menuItem.getDescription() != null) ? menuItem.getDescription() : "No description available";
            String imageUrl = (menuItem.getImageUrl() != null) ? menuItem.getImageUrl() : "images/default.jpg";
            System.out.println("Image URL for " + dishName + ": " + request.getContextPath() + "/data/" + imageUrl); // Debug image URL
%>
<div class="menu-item" id="menu-item-<%= menuItem.getId() %>">
    <div class="menu-details">
        <h6><%= dishName %></h6>
        <p><%= description %></p>
        <p><strong>Price:</strong> $<%= String.format("%.2f", menuItem.getPrice()) %></p>
    </div>
    <img src="<%= request.getContextPath() + "/data/" + imageUrl %>" alt="<%= dishName %>" class="img-fluid" style="max-height: 100px;" onerror="this.src='<%= request.getContextPath() + "/data/images/default.jpg" %>'; console.log('Image load failed for ' + this.src + ', using default: ' + '<%= request.getContextPath() + "/data/images/default.jpg" %>');">
    <div class="quantity-selector">
        <button type="button" class="btn btn-sm decrease-quantity">-</button>
        <input type="number" class="quantity-input" value="1" min="1" max="99" readonly>
        <button type="button" class="btn btn-sm increase-quantity">+</button>
    </div>
    <button type="button" class="btn btn-success add-to-cart-btn" data-item-id="<%= menuItem.getId() %>" data-restaurant-id="<%= restaurantId %>">
        Add to Cart
    </button>
</div>
<div class="feedback-message" style="display: none;"></div>
<%
        }
    } else {
%>
<p>No menu items available for this restaurant.</p>
<%
    }
%>

<script>
    $(document).ready(function() {
        // Initialize quantity for each menu item
        $('.menu-item').each(function() {
            let $input = $(this).find('.quantity-input');
            let initialValue = parseInt($input.val()) || 1;
            $input.val(initialValue);
        });

        // Quantity selector functionality
        $('.increase-quantity').on('click', function() {
            let $input = $(this).siblings('.quantity-input');
            let currentValue = parseInt($input.val()) || 1;
            if (currentValue < 99) {
                $input.val(currentValue + 1);
            }
        });

        $('.decrease-quantity').on('click', function() {
            let $input = $(this).siblings('.quantity-input');
            let currentValue = parseInt($input.val()) || 1;
            if (currentValue > 1) {
                $input.val(currentValue - 1);
            }
        });

        // Add to Cart functionality
        $('.add-to-cart-btn').on('click', function() {
            let button = $(this);
            let itemId = button.data('item-id');
            let restaurantId = button.data('restaurant-id');
            let $menuItem = button.closest('.menu-item');
            let $input = $menuItem.find('.quantity-input');
            let quantity = parseInt($input.val()) || 1; // Default to 1 if parsing fails
            let feedbackMessage = $menuItem.next('.feedback-message');

            console.log('Adding to cart: itemId=' + itemId + ', restaurantId=' + restaurantId + ', quantity=' + quantity);

            // AJAX request to add item to cart
            $.ajax({
                url: 'cart?action=add',
                method: 'POST',
                data: {
                    itemId: itemId,
                    restaurantId: restaurantId,
                    quantity: quantity
                },
                success: function(response) {
                    console.log('Add to Cart Success:', response);
                    feedbackMessage.html('<div class="alert alert-success" role="alert">Item added to cart!</div>');
                    feedbackMessage.show();
                    setTimeout(function() {
                        feedbackMessage.fadeOut();
                    }, 2000);
                    updateCartCount();
                },
                error: function(xhr, status, error) {
                    console.error('Add to Cart Error:', status, error);
                    feedbackMessage.html('<div class="alert alert-danger" role="alert">Error adding item to cart: ' + xhr.responseText + '</div>');
                    feedbackMessage.show();
                }
            });
        });

        // Optional: Function to update cart count in the UI
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
