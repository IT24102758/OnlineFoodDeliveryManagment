package model;

public abstract class User {
    private String id;
    private String name;
    private String email;
    private String password;
    private String address;
    private String phone;
    private String type;

    // Constructor
    public User(String id, String name, String email, String password, String address, String phone, String type) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.address = address;
        this.phone = phone;
        this.type = type;
    }


    // Getters and Setters (Encapsulation)
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    // Polymorphic method for discount calculation
    public abstract double calculateDiscount(double amount);

    @Override
    public String toString() {
        return id + "," + name + "," + email + "," + password + "," + address + "," + phone + "," + type + "," + calculateDiscount(100.0);
    }

}