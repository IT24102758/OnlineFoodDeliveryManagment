package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.YearMonth;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;
import java.util.regex.Pattern;

public class PaymentServlet extends HttpServlet {
    // Logger for auditing payment attempts
    private static final Logger LOGGER = Logger.getLogger(PaymentServlet.class.getName());

    // Regex patterns for validation
    private static final Pattern CARD_NUMBER_PATTERN = Pattern.compile("^\\d{4}\\s\\d{4}\\s\\d{4}\\s\\d{4}$");
    private static final Pattern EXPIRY_DATE_PATTERN = Pattern.compile("^(0[1-9]|1[0-2])/\\d{4}$");
    private static final Pattern CVV_PATTERN = Pattern.compile("^\\d{3}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\d{3}-\\d{3}-\\d{4}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    // List of valid districts in Sri Lanka
    private static final List<String> VALID_DISTRICTS = Arrays.asList(
            "Colombo", "Gampaha", "Kalutara", "Kandy", "Matale", "Nuwara Eliya",
            "Galle", "Matara", "Hambantota", "Jaffna", "Kilinochchi", "Mannar",
            "Vavuniya", "Mullaitivu", "Batticaloa", "Ampara", "Trincomalee",
            "Kurunegala", "Puttalam", "Anuradhapura", "Polonnaruwa", "Badulla",
            "Moneragala", "Ratnapura", "Kegalle"
    );

    // Delivery charge constants
    private static final double DELIVERY_CHARGE_COLOMBO = 250.0;
    private static final double DELIVERY_CHARGE_OTHER = 350.0;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized payment attempt: User not logged in.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userId");

        // Retrieve payment details
        String cardholderName = req.getParameter("cardholderName");
        String cardNumber = req.getParameter("cardNumber");
        String expiryDate = req.getParameter("expiryDate");
        String cvv = req.getParameter("cvv");
        String discountedTotalStr = req.getParameter("discountedTotal");

        // Retrieve contact details
        String deliveryAddress = req.getParameter("deliveryAddress");
        String district = req.getParameter("district");
        String phoneNumber = req.getParameter("phoneNumber");
        String email = req.getParameter("email");

        // Basic validation: Check for null or empty fields
        StringBuilder errorMessage = new StringBuilder();
        if (cardholderName == null || cardholderName.trim().isEmpty()) {
            errorMessage.append("Cardholder name is required. ");
        }
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            errorMessage.append("Card number is required. ");
        }
        if (expiryDate == null || expiryDate.trim().isEmpty()) {
            errorMessage.append("Expiry date is required. ");
        }
        if (cvv == null || cvv.trim().isEmpty()) {
            errorMessage.append("CVV is required. ");
        }
        if (discountedTotalStr == null || discountedTotalStr.trim().isEmpty()) {
            errorMessage.append("Discounted total is required. ");
        }
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            errorMessage.append("Delivery address is required. ");
        }
        if (district == null || district.trim().isEmpty()) {
            errorMessage.append("District is required. ");
        }
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            errorMessage.append("Phone number is required. ");
        }
        if (email == null || email.trim().isEmpty()) {
            errorMessage.append("Email is required. ");
        }

        // If there are missing fields, redirect back to checkout
        if (errorMessage.length() > 0) {
            LOGGER.warning("Payment attempt failed for user " + userId + ": " + errorMessage.toString());
            resp.sendRedirect("checkout.jsp?error=" + java.net.URLEncoder.encode(errorMessage.toString(), "UTF-8") + "&total=" + (discountedTotalStr != null ? java.net.URLEncoder.encode(discountedTotalStr, "UTF-8") : "0"));
            return;
        }

        // Validate payment details format
        if (!CARD_NUMBER_PATTERN.matcher(cardNumber).matches()) {
            errorMessage.append("Invalid card number format (must be 1234 5678 9012 3456). ");
        }
        if (!EXPIRY_DATE_PATTERN.matcher(expiryDate).matches()) {
            errorMessage.append("Invalid expiry date format (must be MM/YYYY, e.g., 12/2025). ");
        } else {
            try {
                String[] expiryParts = expiryDate.split("/");
                int expiryMonth = Integer.parseInt(expiryParts[0]);
                int expiryYear = Integer.parseInt(expiryParts[1]);
                YearMonth expiry = YearMonth.of(expiryYear, expiryMonth);
                YearMonth current = YearMonth.now();
                if (expiry.isBefore(current)) {
                    errorMessage.append("Card has expired. ");
                }
            } catch (Exception e) {
                errorMessage.append("Invalid expiry date. ");
            }
        }
        if (!CVV_PATTERN.matcher(cvv).matches()) {
            errorMessage.append("Invalid CVV (must be 3 digits). ");
        }

        // Validate contact details format
        if (!VALID_DISTRICTS.contains(district)) {
            errorMessage.append("Invalid district selected. ");
        }
        if (!PHONE_PATTERN.matcher(phoneNumber).matches()) {
            errorMessage.append("Invalid phone number format (must be 123-456-7890). ");
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            errorMessage.append("Invalid email format (must be user@example.com). ");
        }

        // Validate discounted total
        double discountedTotal;
        try {
            discountedTotal = Double.parseDouble(discountedTotalStr);
            if (discountedTotal <= 0) {
                errorMessage.append("Discounted total must be greater than 0. ");
            }
        } catch (NumberFormatException e) {
            errorMessage.append("Invalid discounted total format. ");
            discountedTotal = 0;
        }

        // Calculate delivery charge based on district
        double deliveryCharge = "Colombo".equalsIgnoreCase(district) ? DELIVERY_CHARGE_COLOMBO : DELIVERY_CHARGE_OTHER;
        double finalTotal = discountedTotal + deliveryCharge; // Add delivery charge to the discounted total

        // If there are validation errors, redirect back to checkout
        if (errorMessage.length() > 0) {
            LOGGER.warning("Payment attempt failed for user " + userId + ": " + errorMessage.toString());
            resp.sendRedirect("checkout.jsp?error=" + java.net.URLEncoder.encode(errorMessage.toString(), "UTF-8") + "&total=" + java.net.URLEncoder.encode(discountedTotalStr, "UTF-8"));
            return;
        }

        // Simulate payment processing (replace with actual payment gateway integration)
        boolean paymentSuccess = simulatePayment(cardNumber, expiryDate, cvv, finalTotal); // Use final total including delivery charge
        String paymentStatus = paymentSuccess ? "Success" : "Failed";
        String paymentMethod = "Credit Card";

        // Log the payment attempt
        LOGGER.info("Payment attempt for user " + userId + ": Status=" + paymentStatus + ", Amount=" + finalTotal + ", Method=" + paymentMethod);

        if (paymentSuccess) {
            // Store contact details in session for display in orderConfirmation.jsp
            session.setAttribute("deliveryAddress", deliveryAddress);
            session.setAttribute("district", district);
            session.setAttribute("phoneNumber", phoneNumber);
            session.setAttribute("email", email);

            // Forward to OrderServlet to create the order
            req.setAttribute("action", "create");
            req.setAttribute("discountedTotal", String.valueOf(discountedTotal)); // Original discounted total (excluding delivery charge)
            req.setAttribute("deliveryCharge", String.valueOf(deliveryCharge)); // Pass delivery charge as String
            req.setAttribute("finalTotal", String.valueOf(finalTotal)); // Pass final total as String
            req.setAttribute("deliveryAddress", deliveryAddress);
            req.setAttribute("district", district);
            req.setAttribute("phoneNumber", phoneNumber);
            req.setAttribute("email", email);
            req.setAttribute("paymentStatus", paymentStatus);
            req.setAttribute("paymentMethod", paymentMethod);
            req.getRequestDispatcher("/order").forward(req, resp);
        } else {
            String failureReason = "Payment declined. Please check your card details or try a different payment method.";
            LOGGER.warning("Payment failed for user " + userId + ": " + failureReason);
            resp.sendRedirect("checkout.jsp?error=" + java.net.URLEncoder.encode(failureReason, "UTF-8") + "&total=" + java.net.URLEncoder.encode(discountedTotalStr, "UTF-8"));
        }
    }

    private boolean simulatePayment(String cardNumber, String expiryDate, String cvv, double amount) {
        if (cardNumber.endsWith("0000")) {
            return false;
        }
        if (cvv.equals("000")) {
            return false;
        }
        return true;
    }
}