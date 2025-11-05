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
    
    public List<Supplier> searchSupplierByName(String name) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM tblSupplier WHERE name LIKE ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setId(rs.getInt("id"));
                supplier.setName(rs.getString("name"));
                supplier.setTel(rs.getString("tel"));
                supplier.setAddress(rs.getString("address"));
                supplier.setNote(rs.getString("note"));
                suppliers.add(supplier);
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error searching suppliers: " + e.getMessage());
        }
        
        return suppliers;
    }
    
    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM tblSupplier ORDER BY name";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setId(rs.getInt("id"));
                supplier.setName(rs.getString("name"));
                supplier.setTel(rs.getString("tel"));
                supplier.setAddress(rs.getString("address"));
                supplier.setNote(rs.getString("note"));
                suppliers.add(supplier);
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error getting all suppliers: " + e.getMessage());
        }
        
        return suppliers;
    }
    
    public Supplier getSupplierById(int id) {
        Supplier supplier = null;
        String sql = "SELECT * FROM tblSupplier WHERE id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                supplier = new Supplier();
                supplier.setId(rs.getInt("id"));
                supplier.setName(rs.getString("name"));
                supplier.setTel(rs.getString("tel"));
                supplier.setAddress(rs.getString("address"));
                supplier.setNote(rs.getString("note"));
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
