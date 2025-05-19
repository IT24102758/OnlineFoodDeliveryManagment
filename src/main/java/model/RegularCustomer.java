package model;

public class RegularCustomer extends User {
    public RegularCustomer(String id, String name, String email, String password, String address, String phone) {
        super(id, name, email, password, address, phone, "Regular");
    }

    @Override
    public double calculateDiscount(double amount) {
        return 5.0; // 5% discount for regular customers
    }
}