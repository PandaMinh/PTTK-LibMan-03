package model;

import java.util.Date;

public class Reader extends User {
    private String numberCard;
    private String issuedDate;
    private String expiryDate;
    private String description;

    public Reader() {
    }

    public Reader(int id, String username, String password, String name, String tel, 
                String address, String email, Date dateOfBirth, String role,
                String numberCard, String issuedDate, String expiryDate, String description) {
        super(id, username, password, name, tel, address, email, dateOfBirth, role);
        this.numberCard = numberCard;
        this.issuedDate = issuedDate;
        this.expiryDate = expiryDate;
        this.description = description;
    }

    public String getNumberCard() {
        return numberCard;
    }

    public void setNumberCard(String numberCard) {
        this.numberCard = numberCard;
    }

    public String getIssuedDate() {
        return issuedDate;
    }

    public void setIssuedDate(String issuedDate) {
        this.issuedDate = issuedDate;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
