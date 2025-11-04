package model;

public class Supplier {
    private int id;
    private String name;
    private String tel;
    private String address;
    private String note;

    public Supplier() {
    }

    public Supplier(int id, String name, String tel, String address, String note) {
        this.id = id;
        this.name = name;
        this.tel = tel;
        this.address = address;
        this.note = note;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
