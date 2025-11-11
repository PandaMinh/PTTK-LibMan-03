package dao;

import model.ImportingDetail;
import model.ImportingInvoice;
import model.Supplier;
import model.Librarian;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ImportingInvoiceDAO extends DAO {
    
    private ImportingDetailDAO importingDetailDAO;
    
    public ImportingInvoiceDAO() {
        super();
        // Khởi tạo importingDetailDAO với cùng connection để đảm bảo transaction
        this.importingDetailDAO = new ImportingDetailDAO(this.connection);
    }
    
    public boolean addNewImportingInvoice(ImportingInvoice invoice, List<ImportingDetail> details) {
        String sql = "INSERT INTO tblImportingInvoice (importDate, supplierId, librarianId, typePay, bank) VALUES (?, ?, ?, ?, ?)";
        
        System.out.println("DEBUG: addNewImportingInvoice called with " + details.size() + " details");
        
        try {
            // Start transaction
            connection.setAutoCommit(false);
            System.out.println("DEBUG: Transaction started");
            
            // Insert invoice
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, new java.sql.Date(invoice.getImportDate().getTime()));
            ps.setInt(2, invoice.getSupplier().getId());
            ps.setInt(3, invoice.getLibrarian().getId());
            ps.setString(4, invoice.getTypePay());
            ps.setString(5, invoice.getBank());
            
            System.out.println("DEBUG: About to insert invoice...");
            int result = ps.executeUpdate();
            System.out.println("DEBUG: Invoice insert result = " + result);
            
            if (result > 0) {
                // Get generated invoice ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int invoiceId = generatedKeys.getInt(1);
                    invoice.setId(invoiceId);
                    System.out.println("DEBUG: Generated invoice ID = " + invoiceId);
                    
                    // Set invoice reference in details and add them
                    for (ImportingDetail detail : details) {
                        detail.setImportingInvoice(invoice);
                    }
                    
                    System.out.println("DEBUG: About to insert details...");
                    boolean detailsSuccess = importingDetailDAO.addListNewImportingDetail(details);
                    System.out.println("DEBUG: Details insert result = " + detailsSuccess);
                    
                    if (detailsSuccess) {
                        connection.commit();
                        System.out.println("DEBUG: Transaction committed successfully");
                        ps.close();
                        return true;
                    }
                }
            }
            
            System.out.println("DEBUG: Rolling back transaction");
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
    
    public List<ImportingInvoice> getAllImportingInvoices() throws SQLException {
        List<ImportingInvoice> invoices = new ArrayList<>();
        String sql = "SELECT ii.id, ii.importDate, ii.supplierId, ii.librarianId, ii.typePay, ii.bank, " +
                     "s.name as supplierName, s.tel as supplierTel, s.address as supplierAddress " +
                     "FROM tblImportingInvoice ii " +
                     "LEFT JOIN tblSupplier s ON ii.supplierId = s.id " +
                     "ORDER BY ii.importDate DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ImportingInvoice invoice = new ImportingInvoice();
                invoice.setId(rs.getInt("id"));
                invoice.setImportDate(rs.getDate("importDate"));
                invoice.setTypePay(rs.getString("typePay"));
                invoice.setBank(rs.getString("bank"));
                
                // Create supplier object
                Supplier supplier = new Supplier();
                supplier.setId(rs.getInt("supplierId"));
                supplier.setName(rs.getString("supplierName"));
                supplier.setTel(rs.getString("supplierTel"));
                supplier.setAddress(rs.getString("supplierAddress"));
                invoice.setSupplier(supplier);
                
                // Create librarian object (simple version)
                Librarian librarian = new Librarian();
                librarian.setId(rs.getInt("librarianId"));
                invoice.setLibrarian(librarian);
                
                invoices.add(invoice);
            }
        }
        
        return invoices;
    }
}
