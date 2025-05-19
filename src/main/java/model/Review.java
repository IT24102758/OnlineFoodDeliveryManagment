package model;

import java.util.Objects;

public class Review {
    private String reviewId;
    private String orderId;
    private String userId;
    private String restaurantId;
    private double rating; // Rating out of 5
    private String comment;
    private String timestamp;

    // Constructor
    public Review(String reviewId, String orderId, String userId, String restaurantId, double rating, String comment, String timestamp) {
        this.reviewId = reviewId;
        this.orderId = orderId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.rating = rating;
        this.comment = comment;
        this.timestamp = timestamp;
    }

    // Getters and Setters
    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    // toString method for file storage
    @Override
    public String toString() {
        return String.format("%s,%s,%s,%s,%.1f,%s,%s",
                reviewId, orderId, userId, restaurantId, rating, comment, timestamp);
    }

    // fromString method to parse a review from a file line
    public static Review fromString(String line) {
        String[] parts = line.split(",", 7);
        if (parts.length != 7) {
            throw new IllegalArgumentException("Invalid review format: " + line);
        }
        String reviewId = parts[0];
        String orderId = parts[1];
        String userId = parts[2];
        String restaurantId = parts[3];
        double rating = Double.parseDouble(parts[4]);
        String comment = parts[5];
        String timestamp = parts[6];
        return new Review(reviewId, orderId, userId, restaurantId, rating, comment, timestamp);
    }

    // Equals and HashCode for HashSet usage
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Review review = (Review) o;
        return reviewId.equals(review.reviewId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(reviewId);
    }
}