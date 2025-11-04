package dao;

import model.ImportingDetail;
import model.ImportingInvoice;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class ImportingInvoiceDAO extends DAO {
    
    public ImportingInvoiceDAO() {
        super();
    }
    
    public boolean addNewImportingInvoice(ImportingInvoice invoice, List<ImportingDetail> details) {
        String sql = "INSERT INTO tblImportingInvoice (importDate, supplierId, librarianId, typePay, bank) VALUES (?, ?, ?, ?, ?)";
        
        try {
            // Start transaction
            connection.setAutoCommit(false);
            
            // Insert invoice
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, new java.sql.Date(invoice.getImportDate().getTime()));
            ps.setInt(2, invoice.getSupplier().getId());
            ps.setInt(3, invoice.getLibrarian().getId());
            ps.setString(4, invoice.getTypePay());
            ps.setString(5, invoice.getBank());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // Get generated invoice ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int invoiceId = generatedKeys.getInt(1);
                    invoice.setId(invoiceId);
                    
                    // Set invoice reference in details and add them
                    for (ImportingDetail detail : details) {
                        detail.setImportingInvoice(invoice);
                    }
                    addListNewImportingDetail(details);
                    
                    connection.commit();
                    ps.close();
                    return true;
                }
            }
            
            connection.rollback();
            ps.close();
            return false;
            
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            System.err.println("Error adding importing invoice: " + e.getMessage());
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error resetting auto-commit: " + e.getMessage());
            }
        }
    }
    
    private boolean addListNewImportingDetail(List<ImportingDetail> details) throws SQLException {
        String sql = "INSERT INTO tblImportingDetail (importingInvoiceId, documentId, price, quantity) VALUES (?, ?, ?, ?)";
        
        boolean autoCommit = connection.getAutoCommit();
        try {
            // Start transaction if not already in one
            if (autoCommit) {
                connection.setAutoCommit(false);
            }

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                // Add all details in a batch
                for (ImportingDetail detail : details) {
                    ps.setInt(1, detail.getImportingInvoice().getId());
                    ps.setInt(2, detail.getDocument().getId());
                    ps.setDouble(3, detail.getPrice());
                    ps.setInt(4, detail.getQuantity());
                    ps.addBatch();
                }
                
                // Execute batch and verify results
                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result <= 0) {
                        if (autoCommit) {
                            connection.rollback();
                        }
                        return false;
                    }
                }
                
                // Commit only if we started the transaction
                if (autoCommit) {
                    connection.commit();
                }
                return true;
            } catch (SQLException e) {
                // Rollback only if we started the transaction
                if (autoCommit) {
                    connection.rollback();
                }
                throw e; // Re-throw to be handled by caller
            }
        } finally {
            // Restore previous auto-commit state if we changed it
            if (autoCommit) {
                connection.setAutoCommit(true);
            }
        }
    }
}
