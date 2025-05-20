package model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class Order {
    private static final Logger LOGGER = Logger.getLogger(Order.class.getName());

    private String orderId;
    private String userId;
    private List<Map<String, Object>> items;
    private double total;
    private double deliveryFee;
    private String orderDate;
    private String status;
    private String deliveryAddress;
    private String billingDistrict;
    private String phone;
    private String email;
    private String paymentStatus;
    private String paymentMethod;

    public Order(String orderId, String userId, List<Map<String, Object>> items, double total, double deliveryFee,
                 String orderDate, String status, String deliveryAddress, String billingDistrict,
                 String phone, String email, String paymentStatus, String paymentMethod) {
        this.orderId = orderId;
        this.userId = userId;
        this.items = items;
        this.total = total;
        this.deliveryFee = deliveryFee;
        this.orderDate = orderDate;
        this.status = status;
        this.deliveryAddress = deliveryAddress;
        this.billingDistrict = billingDistrict;
        this.phone = phone;
        this.email = email;
        this.paymentStatus = paymentStatus;
        this.paymentMethod = paymentMethod;
    }

    // Getters
    public String getOrderId() { return orderId; }
    public String getUserId() { return userId; }
    public List<Map<String, Object>> getItems() { return items; }
    public double getTotal() { return total; }
    public double getDeliveryFee() { return deliveryFee; }
    public double getFinalTotal() { return total + deliveryFee; }
    public String getOrderDate() { return orderDate; }
    public String getStatus() { return status; }
    public String getDeliveryAddress() { return deliveryAddress; }
    public String getBillingDistrict() { return billingDistrict; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
    public String getPaymentStatus() { return paymentStatus; }
    public String getPaymentMethod() { return paymentMethod; }

    // Setters
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public void setUserId(String userId) { this.userId = userId; }
    public void setItems(List<Map<String, Object>> items) { this.items = items; }
    public void setTotal(double total) { this.total = total; }
    public void setDeliveryFee(double deliveryFee) { this.deliveryFee = deliveryFee; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }
    public void setStatus(String status) { this.status = status; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
    public void setBillingDistrict(String billingDistrict) { this.billingDistrict = billingDistrict; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setEmail(String email) { this.email = email; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public static Order fromString(String line) {
        LOGGER.info("Parsing order line: " + line);
        String[] parts = line.split("\\|", -1); // Use -1 to include empty trailing fields
        if (parts.length != 13) { // Expect 13 fields (without notes)
            throw new IllegalArgumentException("Invalid order format, expected 13 fields: " + line);
        }

        String orderId = parts[0];
        String userId = parts[1];

        // Parse items
        List<Map<String, Object>> items = new ArrayList<>();
        String itemsStr = parts[2].substring(1, parts[2].length() - 1); // Remove [ and ]
        if (!itemsStr.isEmpty()) {
            String[] itemPairs = itemsStr.split(",");
            for (String pair : itemPairs) {
                String[] itemDetails = pair.split(":");
                if (itemDetails.length >= 3) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("restaurantId", itemDetails[0].trim());
                    item.put("itemId", itemDetails[1].trim());
                    item.put("quantity", Integer.parseInt(itemDetails[2].trim()));
                    items.add(item);
                } else {
                    LOGGER.warning("Invalid item format in order: " + pair);
                }
            }
        }

        double total = Double.parseDouble(parts[3]);
        double deliveryFee = Double.parseDouble(parts[4]);
        String orderDate = parts[5];
        String status = parts[6];
        String deliveryAddress = parts[7];
        String billingDistrict = parts[8];
        String phone = parts[9];
        String email = parts[10];
        String paymentStatus = parts[11];
        String paymentMethod = parts[12];

        Order order = new Order(orderId, userId, items, total, deliveryFee, orderDate, status, deliveryAddress,
                billingDistrict, phone, email, paymentStatus, paymentMethod);
        LOGGER.info("Successfully parsed order: " + order.getOrderId());
        return order;
    }

    @Override
    public String toString() {
        StringBuilder itemsStr = new StringBuilder("[");
        for (int i = 0; i < items.size(); i++) {
            Map<String, Object> item = items.get(i);
            itemsStr.append(item.get("restaurantId")).append(":").append(item.get("itemId")).append(":").append(item.get("quantity"));
            if (i < items.size() - 1) {
                itemsStr.append(",");
            }
        }
        itemsStr.append("]");
        return String.join("|", orderId, userId, itemsStr.toString(), String.valueOf(total), String.valueOf(deliveryFee),
                orderDate, status, deliveryAddress, billingDistrict, phone, email, paymentStatus, paymentMethod);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Order order = (Order) o;
        return orderId != null && orderId.equals(order.orderId);
    }

    @Override
    public int hashCode() {
        return orderId != null ? orderId.hashCode() : 0;
    }
}