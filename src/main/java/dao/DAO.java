package dao;

import util.DBUtil;

import java.sql.Connection;
import java.sql.SQLException;

public class DAO {
    protected Connection connection;
    
    public DAO() {
        try {
            connection = DBUtil.getConnection();
        } catch (SQLException e) {
            System.err.println("Error establishing database connection: " + e.getMessage());
        }
    }
    
    protected void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}
