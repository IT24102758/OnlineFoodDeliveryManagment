package model;

public class PremiumCustomer extends User {
    public PremiumCustomer(String id, String name, String email, String password, String address, String phone) {
        super(id, name, email, password, address, phone, "Premium");
    }


    @Override
    public double calculateDiscount(double amount) {
        return 15.0; // 15% discount for premium customers
    }
}