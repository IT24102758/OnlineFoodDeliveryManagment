package model;

public class MenuItem {
    private String id; // Unique ID for the menu item
    private String restaurantId; // ID of the associated restaurant
    private String dishName; // Name of the dish
    private String description; // Description of the dish
    private double price; // Price of the dish
    private String imageUrl; // URL or path to the dish image

    // Constructor
    public MenuItem(String id, String restaurantId, String dishName, String description, double price, String imageUrl) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.dishName = dishName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getDishName() {
        return dishName;
    }

    public void setDishName(String dishName) {
        this.dishName = dishName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // Convert MenuItem to string format for file storage
    @Override
    public String toString() {
        return id + "," + restaurantId + "," + dishName + "," + description + "," + price + "," + imageUrl;
    }

    // Create MenuItem from string (for reading from file)
    public static MenuItem fromString(String data) {
        String[] parts = data.split(",", 6);
        if (parts.length != 6) {
            throw new IllegalArgumentException("Invalid menu item data: " + data);
        }
        return new MenuItem(
                parts[0], // id
                parts[1], // restaurantId
                parts[2], // dishName
                parts[3], // description
                Double.parseDouble(parts[4]), // price
                parts[5] // imageUrl
        );
    }
}