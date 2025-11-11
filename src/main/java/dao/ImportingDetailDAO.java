package dao;

import model.ImportingDetail;
import model.ImportingInvoice;
import model.Document;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImportingDetailDAO extends DAO {
    
    public ImportingDetailDAO() {
        super();
    }
    
    // Constructor to use external connection (for transaction)
    public ImportingDetailDAO(Connection connection) {
        this.connection = connection;
    }
    
    public boolean addImportingDetail(ImportingDetail detail) throws SQLException {
        String sql = "INSERT INTO tblImportingDetail (invoiceId, documentId, price, quantity) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, detail.getImportingInvoice().getId());
            ps.setInt(2, detail.getDocument().getId());
            ps.setDouble(3, detail.getPrice());
            ps.setInt(4, detail.getQuantity());
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }
    
    public boolean addListNewImportingDetail(List<ImportingDetail> details) throws SQLException {
        String sql = "INSERT INTO tblImportingDetail (invoiceId, documentId, price, quantity) VALUES (?, ?, ?, ?)";
        
        System.out.println("DEBUG: addListNewImportingDetail called with " + details.size() + " details");
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            // Add all details in a batch
            for (ImportingDetail detail : details) {
                System.out.println("DEBUG: Adding detail - invoiceId=" + detail.getImportingInvoice().getId() 
                    + ", documentId=" + detail.getDocument().getId() 
                    + ", price=" + detail.getPrice() 
                    + ", quantity=" + detail.getQuantity());
                    
                ps.setInt(1, detail.getImportingInvoice().getId());
                ps.setInt(2, detail.getDocument().getId());
                ps.setDouble(3, detail.getPrice());
                ps.setInt(4, detail.getQuantity());
                ps.addBatch();
            }
            
            // Execute batch and verify results
            System.out.println("DEBUG: Executing batch insert...");
            int[] results = ps.executeBatch();
            System.out.println("DEBUG: Batch results length = " + results.length);
            
            for (int i = 0; i < results.length; i++) {
                System.out.println("DEBUG: Result[" + i + "] = " + results[i]);
                if (results[i] <= 0) {
                    System.out.println("DEBUG: Failed to insert detail at index " + i);
                    return false;
                }
            }
            
            System.out.println("DEBUG: All details inserted successfully");
            return true;
        }
    }
    
    public boolean updateImportingDetail(ImportingDetail detail) throws SQLException {
        String sql = "UPDATE tblImportingDetail SET price = ?, quantity = ? WHERE invoiceId = ? AND documentId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, detail.getPrice());
            ps.setInt(2, detail.getQuantity());
            ps.setInt(3, detail.getImportingInvoice().getId());
            ps.setInt(4, detail.getDocument().getId());
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }
    
    public boolean deleteImportingDetail(int invoiceId, int documentId) throws SQLException {
        String sql = "DELETE FROM tblImportingDetail WHERE invoiceId = ? AND documentId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, documentId);
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }
    
    public List<ImportingDetail> getImportingDetailsByInvoiceId(int invoiceId) throws SQLException {
        List<ImportingDetail> details = new ArrayList<>();
        String sql = "SELECT id.invoiceId, id.documentId, id.price, id.quantity, " +
                     "d.title, d.author, d.category, d.yearPublic, d.content, d.description " +
                     "FROM tblImportingDetail id " +
                     "LEFT JOIN tblDocument d ON id.documentId = d.id " +
                     "WHERE id.invoiceId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportingDetail detail = new ImportingDetail();
                    detail.setPrice(rs.getDouble("price"));
                    detail.setQuantity(rs.getInt("quantity"));
                    
                    // Create document object
                    Document document = new Document();
                    document.setId(rs.getInt("documentId"));
                    document.setTitle(rs.getString("title"));
                    document.setAuthor(rs.getString("author"));
                    document.setCategory(rs.getString("category"));
                    document.setYearPublic(rs.getInt("yearPublic"));
                    document.setContent(rs.getString("content"));
                    document.setDescription(rs.getString("description"));
                    detail.setDocument(document);
                    
                    // Create importing invoice object (simple version)
                    ImportingInvoice invoice = new ImportingInvoice();
                    invoice.setId(rs.getInt("invoiceId"));
                    detail.setImportingInvoice(invoice);
                    
                    details.add(detail);
                }
            }
        }
        
        return details;
    }
    
    public ImportingDetail getImportingDetail(int invoiceId, int documentId) throws SQLException {
        String sql = "SELECT id.invoiceId, id.documentId, id.price, id.quantity, " +
                     "d.title, d.author, d.category, d.yearPublic, d.content, d.description " +
                     "FROM tblImportingDetail id " +
                     "LEFT JOIN tblDocument d ON id.documentId = d.id " +
                     "WHERE id.invoiceId = ? AND id.documentId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, documentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ImportingDetail detail = new ImportingDetail();
                    detail.setPrice(rs.getDouble("price"));
                    detail.setQuantity(rs.getInt("quantity"));
                    
                    // Create document object
                    Document document = new Document();
                    document.setId(rs.getInt("documentId"));
                    document.setTitle(rs.getString("title"));
                    document.setAuthor(rs.getString("author"));
                    document.setCategory(rs.getString("category"));
                    document.setYearPublic(rs.getInt("yearPublic"));
                    document.setContent(rs.getString("content"));
                    document.setDescription(rs.getString("description"));
                    detail.setDocument(document);
                    
                    // Create importing invoice object (simple version)
                    ImportingInvoice invoice = new ImportingInvoice();
                    invoice.setId(rs.getInt("invoiceId"));
                    detail.setImportingInvoice(invoice);
                    
                    return detail;
                }
            }
        }
        
        return null;
    }
    
    public double getTotalAmountByInvoiceId(int invoiceId) throws SQLException {
        String sql = "SELECT SUM(price * quantity) as total FROM tblImportingDetail WHERE invoiceId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
        }
        
        return 0.0;
    }
}