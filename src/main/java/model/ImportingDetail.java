package model;

public class ImportingDetail {
    private int id;
    private ImportingInvoice importingInvoice;
    private Document document;
    private double price;
    private int quantity;

    public ImportingDetail() {
    }

    public ImportingDetail(int id, ImportingInvoice importingInvoice, Document document, double price, int quantity) {
        this.id = id;
        this.importingInvoice = importingInvoice;
        this.document = document;
        this.price = price;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public ImportingInvoice getImportingInvoice() {
        return importingInvoice;
    }

    public void setImportingInvoice(ImportingInvoice importingInvoice) {
        this.importingInvoice = importingInvoice;
    }

    public Document getDocument() {
        return document;
    }

    public void setDocument(Document document) {
        this.document = document;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
