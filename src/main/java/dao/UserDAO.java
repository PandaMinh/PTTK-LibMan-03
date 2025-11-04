package dao;

import model.Librarian;
import model.Staff;
import model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO extends DAO {
    
    public UserDAO() {
        super();
    }
    
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM tblUser WHERE username = ? AND password = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setName(rs.getString("name"));
                user.setTel(rs.getString("tel"));
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                user.setDateOfBirth(rs.getDate("dateOfBirth"));
                user.setRole(rs.getString("role"));
                
                if ("librarian".equals(user.getRole())) {
                    return getLibrarianByUserId(user);
                }
                
                return user;
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error checking login: " + e.getMessage());
        }
        
        return null;
    }
    
    private Librarian getLibrarianByUserId(User user) throws SQLException {
        String sql = "SELECT l.id as librarianId, s.id as staffId FROM tblLibrarian l " +
                    "JOIN tblStaff s ON l.staffId = s.id " +
                    "WHERE s.userId = ?";
                    
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                Staff staff = new Staff(rs.getInt("staffId"), user);
                return new Librarian(rs.getInt("librarianId"), staff);
            }
        }
        
        return null;
    }
}
