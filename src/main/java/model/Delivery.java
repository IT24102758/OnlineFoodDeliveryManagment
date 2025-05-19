package model;

import java.util.logging.Logger;

public class Delivery {
    private static final Logger LOGGER = Logger.getLogger(Delivery.class.getName());

    private String deliveryId;
    private String orderId;
    private String driverId;
    private String status;
    private String location;
    private String timestamp;
    private String assignedAt; // Add this field if not already present

    public Delivery(String deliveryId, String orderId, String driverId, String status, String location, String timestamp) {
        this.deliveryId = deliveryId;
        this.orderId = orderId;
        this.driverId = driverId;
        this.status = status;
        this.location = location;
        this.timestamp = timestamp;
        this.assignedAt = timestamp; // Set assignedAt to timestamp for consistency
    }

    public String getDeliveryId() { return deliveryId; }
    public void setDeliveryId(String deliveryId) { this.deliveryId = deliveryId; }
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getDriverId() { return driverId; }
    public void setDriverId(String driverId) { this.driverId = driverId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getTimestamp() { return timestamp; }
    public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
    public String getAssignedAt() { return assignedAt; } // Add this getter
    public void setAssignedAt(String assignedAt) { this.assignedAt = assignedAt; } // Add this setter

    @Override
    public String toString() {
        return deliveryId + "," + orderId + "," + (driverId != null ? driverId : "") + "," + status + "," + location + "," + timestamp;
    }

    public static Delivery fromString(String line) {
        LOGGER.info("Parsing delivery line: " + line);
        String[] parts = line.split(",", 6);
        if (parts.length != 6) {
            throw new IllegalArgumentException("Invalid delivery format, expected 6 fields: " + line);
        }
        Delivery delivery = new Delivery(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
        LOGGER.info("Successfully parsed delivery: " + delivery.getDeliveryId());
        return delivery;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Delivery delivery = (Delivery) o;
        return deliveryId != null && deliveryId.equals(delivery.deliveryId);
    }

    @Override
    public int hashCode() {
        return deliveryId != null ? deliveryId.hashCode() : 0;
    }
}