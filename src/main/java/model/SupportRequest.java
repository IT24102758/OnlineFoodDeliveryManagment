package model;

// SupportRequest model class
public class SupportRequest { // Made the class public
    private String requestId;
    private String userId;
    private String subject;
    private String message;
    private String timestamp;

    public SupportRequest(String requestId, String userId, String subject, String message, String timestamp) {
        this.requestId = requestId;
        this.userId = userId;
        this.subject = subject;
        this.message = message;
        this.timestamp = timestamp;
    }

    public String getRequestId() {
        return requestId;
    }

    public String getUserId() {
        return userId;
    }

    public String getSubject() {
        return subject;
    }

    public String getMessage() {
        return message;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public static SupportRequest fromString(String line) {
        String[] parts = line.split(",", 5);
        if (parts.length != 5) {
            throw new IllegalArgumentException("Invalid support request format: " + line);
        }
        return new SupportRequest(parts[0], parts[1], parts[2], parts[3], parts[4]);
    }

    @Override
    public String toString() {
        return String.format("%s,%s,%s,%s,%s", requestId, userId, subject, message, timestamp);
    }
}