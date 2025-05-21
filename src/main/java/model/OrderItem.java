package model;

public class OrderItem {
    private String itemId;
    private String restaurantId;
    private int quantity;

    public OrderItem(String itemId, String restaurantId, int quantity) {
        this.itemId = itemId;
        this.restaurantId = restaurantId;
        this.quantity = quantity;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return itemId + "," + restaurantId + "," + quantity;
    }

    public static OrderItem fromString(String line) {
        String[] parts = line.split(",");
        if (parts.length != 3) {
            throw new IllegalArgumentException("Invalid OrderItem format: " + line);
        }
        return new OrderItem(parts[0], parts[1], Integer.parseInt(parts[2]));
    }
}