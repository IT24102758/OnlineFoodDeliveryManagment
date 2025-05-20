package model;

import model.RestaurantType;

public class Restaurant {
    private String id;
    private String name;
    private String location;
    private RestaurantType cuisineType;
    private String contactInfo;
    private String operationHours;

    public Restaurant(String id, String name, String location, RestaurantType cuisineType, String contactInfo, String operationHours) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.cuisineType = cuisineType;
        this.contactInfo = contactInfo;
        this.operationHours = operationHours;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public RestaurantType getCuisineType() { return cuisineType; }
    public void setCuisineType(RestaurantType cuisineType) { this.cuisineType = cuisineType; }
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    public String getOperationHours() { return operationHours; }
    public void setOperationHours(String operationHours) { this.operationHours = operationHours; }

    @Override
    public String toString() {
        return id + "," + name + "," + location + "," + cuisineType + "," + contactInfo + "," + operationHours;
    }

    public static Restaurant fromString(String data) {
        String[] parts = data.split(",");
        return new Restaurant(parts[0], parts[1], parts[2], RestaurantType.valueOf(parts[3]), parts[4], parts[5]);
    }
}