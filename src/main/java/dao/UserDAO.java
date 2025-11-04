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
    
    /**
     * Check login by filling the provided User object.
     * Returns true if credentials match; when true the User object will have id, name, role and other fields populated.
     */
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
        // Schema uses tblUser.id = tblStaff.id = tblLibrarian.id (each level shares the same id)
        // So to check if a given user is a librarian, look for a row in tblLibrarian with id = user.id
        String sql = "SELECT id as librarianId FROM tblLibrarian WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // In this schema design, staff id equals user id
                Staff staff = new Staff(user.getId(), user);
                return new Librarian(rs.getInt("librarianId"), staff);
            }
        }

        return null;
    }
}
