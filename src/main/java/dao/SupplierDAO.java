package dao;

import model.Supplier;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DAO {
    
    public SupplierDAO() {
        super();
    }
    
    /**
     * Helper method to create Supplier object from ResultSet
     */
    private Supplier createSupplierFromResultSet(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setId(rs.getInt("id"));
        supplier.setName(rs.getString("name"));
        supplier.setTel(rs.getString("tel"));
        supplier.setAddress(rs.getString("address"));
        supplier.setNote(rs.getString("note"));
        return supplier;
    }
    
    /**
     * Main search method with pagination support
     * @param page 1-based page number (use 0 for all results)
     * @param pageSize number of results per page (ignored if page = 0)
     * @param keyword search keyword (searches name, tel, address)
     * @return List of matching suppliers
     */
    public List<Supplier> search(int page, int pageSize, String keyword) {
        List<Supplier> suppliers = new ArrayList<>();
        String base = "SELECT * FROM tblSupplier";
        String where = "";
        String orderLimit = " ORDER BY name";
        
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            where = " WHERE name LIKE ? OR tel LIKE ? OR address LIKE ?";
        }
        
        if (page > 0) {
            orderLimit += " LIMIT ? OFFSET ?";
        }
        
        String sql = base + where + orderLimit;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int idx = 1;
            
            if (hasKeyword) {
                String q = "%" + keyword + "%";
                ps.setString(idx++, q);
                ps.setString(idx++, q);
                ps.setString(idx++, q);
            }
            
            if (page > 0) {
                int offset = (page - 1) * pageSize;
                ps.setInt(idx++, pageSize);
                ps.setInt(idx, offset);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                suppliers.add(createSupplierFromResultSet(rs));
            }
            rs.close();
            ps.close();
            
        } catch (SQLException e) {
            System.err.println("Error searching suppliers: " + e.getMessage());
        }
        
        return suppliers;
    }
    
    public List<Supplier> searchSupplierByName(String name, int page, int pageSize) {
        return search(page, pageSize, name);
    }
    
    public List<Supplier> searchSupplierByName(String name) {
        return search(0, 0, name);
    }
    
    public List<Supplier> getAllSuppliers() {
        return search(0, 0, null);
    }
    
    public Supplier getSupplierById(int id) {
        Supplier supplier = null;
        String sql = "SELECT * FROM tblSupplier WHERE id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                supplier = createSupplierFromResultSet(rs);
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error getting supplier: " + e.getMessage());
        }
        
        return supplier;
    }
    
    public boolean addSupplier(Supplier supplier) {
        String sql = "INSERT INTO tblSupplier (name, tel, address, note) VALUES (?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getTel());
            ps.setString(3, supplier.getAddress());
            ps.setString(4, supplier.getNote());
            
            int result = ps.executeUpdate();
            ps.close();
            
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error adding supplier: " + e.getMessage());
            return false;
        }
    }
}
