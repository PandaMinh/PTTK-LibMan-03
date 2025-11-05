package dao;

import model.Librarian;
import model.Reader;
import model.Staff;
import model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO extends DAO {
    
    public UserDAO() {
        super();
    }
    
    public boolean checkLogin(User u) throws SQLException {
        if (connection == null) {
            throw new SQLException("No database connection");
        }

        String sql = "SELECT * FROM tblUser WHERE username = ? AND password = ?";

        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, u.getUsername());
        ps.setString(2, u.getPassword());
        ResultSet rs = ps.executeQuery();

        try {
            if (rs.next()) {
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setName(rs.getString("name"));
                u.setTel(rs.getString("tel"));
                u.setAddress(rs.getString("address"));
                u.setEmail(rs.getString("email"));
                u.setDateOfBirth(rs.getDate("dateOfBirth"));
                String role = rs.getString("role");
                u.setRole(role == null ? null : role.toUpperCase());

                return true;
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignore) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignore) {}
        }

        return false;
    }
    
    public Librarian getLibrarianByUserId(User user) throws SQLException {
        String sql = "SELECT * FROM tblLibrarian WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff(user.getId(), user);
                    Librarian librarian = new Librarian(rs.getInt("id"), staff);
                    return librarian;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting librarian by user ID " + user.getId() + ": " + e.getMessage());
            throw e;
        }

        return null;
    }

    public Reader getReaderByUserId(User user) throws SQLException {
        String sql = "SELECT * FROM tblReader WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reader reader = new Reader();
                    reader.setId(user.getId());
                    reader.setUsername(user.getUsername());
                    reader.setPassword(user.getPassword());
                    reader.setName(user.getName());
                    reader.setTel(user.getTel());
                    reader.setAddress(user.getAddress());
                    reader.setEmail(user.getEmail());
                    reader.setDateOfBirth(user.getDateOfBirth());
                    reader.setRole("READER");
                    
                    // Set reader-specific fields
                    reader.setNumberCard(rs.getString("numberCard"));
                    reader.setIssuedDate(rs.getDate("issuedDate"));
                    reader.setExpiryDate(rs.getDate("expiryDate"));
                    reader.setDescription(rs.getString("description"));
                    
                    return reader;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting reader by user ID " + user.getId() + ": " + e.getMessage());
            throw e;
        }

        return null;
    }
}
