package model;

import java.util.Date;

public class ImportingInvoice {
    private int id;
    private Date importDate;
    private Supplier supplier;
    private Librarian librarian;
    private String typePay;
    private String bank;

    public ImportingInvoice() {
    }

    public ImportingInvoice(int id, Date importDate, Supplier supplier, Librarian librarian, String typePay, String bank) {
        this.id = id;
        this.importDate = importDate;
        this.supplier = supplier;
        this.librarian = librarian;
        this.typePay = typePay;
        this.bank = bank;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public Librarian getLibrarian() {
        return librarian;
    }

    public void setLibrarian(Librarian librarian) {
        this.librarian = librarian;
    }

    public String getTypePay() {
        return typePay;
    }

    public void setTypePay(String typePay) {
        this.typePay = typePay;
    }

    public String getBank() {
        return bank;
    }

    public void setBank(String bank) {
        this.bank = bank;
    }
}