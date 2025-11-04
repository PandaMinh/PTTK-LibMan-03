package dao;

import model.Document;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO extends DAO {
    
    public DocumentDAO() {
        super();
    }
    
    public List<Document> searchDocumentByName(String name) {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM tblDocument WHERE title LIKE ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Document document = new Document();
                document.setId(rs.getInt("id"));
                document.setTitle(rs.getString("title"));
                document.setAuthor(rs.getString("author"));
                document.setCategory(rs.getString("category"));
                document.setYearPublic(rs.getInt("yearPublic"));
                document.setContent(rs.getString("content"));
                document.setDescription(rs.getString("description"));
                documents.add(document);
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error searching documents: " + e.getMessage());
        }
        
        return documents;
    }

    /**
     * Paginated search by name (keeps original method name but with pagination).
     * Returns results for the given page (1-based) and pageSize.
     */
    public List<Document> searchDocumentByName(String name, int page, int pageSize) {
        return search(page, pageSize, name);
    }
    
    /**
     * Test method to check if we can connect to database and fetch any document
     */
    public boolean testConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = util.DBUtil.getConnection();
            }
            PreparedStatement ps = connection.prepareStatement("SELECT COUNT(*) FROM tblDocument");
            ResultSet rs = ps.executeQuery();
            boolean hasData = rs.next() && rs.getInt(1) > 0;
            rs.close();
            ps.close();
            System.out.println("Database connection test: " + (hasData ? "SUCCESS - found documents" : "SUCCESS - no documents"));
            return true;
        } catch (SQLException e) {
            System.err.println("Database connection test FAILED: " + e.getMessage());
            return false;
        }
    }
    
    public Document getDetailDocument(int id) {
        Document document = null;
        String sql = "SELECT * FROM tblDocument WHERE id = ?";
        
        try {
            if (connection == null || connection.isClosed()) {
                System.err.println("Database connection is null or closed, attempting to reconnect...");
                connection = util.DBUtil.getConnection();
            }
            
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                document = new Document();
                document.setId(rs.getInt("id"));
                document.setTitle(rs.getString("title"));
                document.setAuthor(rs.getString("author"));
                document.setCategory(rs.getString("category"));
                document.setYearPublic(rs.getInt("yearPublic"));
                document.setContent(rs.getString("content"));
                document.setDescription(rs.getString("description"));
                System.out.println("Successfully loaded document: " + document.getTitle()); // debug
            } else {
                System.out.println("No document found with ID: " + id); // debug
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error getting document details for ID " + id + ": " + e.getMessage());
            e.printStackTrace(); // full stack trace for debugging
        }
        
        return document;
    }
    
    public boolean addDocument(Document document) {
        String sql = "INSERT INTO tblDocument (title, author, category, yearPublic, content, description) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, document.getTitle());
            ps.setString(2, document.getAuthor());
            ps.setString(3, document.getCategory());
            ps.setInt(4, document.getYearPublic());
            ps.setString(5, document.getContent());
            ps.setString(6, document.getDescription());
            
            int result = ps.executeUpdate();
            ps.close();
            
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error adding document: " + e.getMessage());
            return false;
        }
    }

    /**
     * Search documents with pagination. If keyword is null or empty, returns all paged.
     */
    public List<Document> search(int page, int pageSize, String keyword) {
        List<Document> documents = new ArrayList<>();
        String base = "SELECT * FROM tblDocument";
        String where = "";
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            where = " WHERE title LIKE ? OR author LIKE ? OR category LIKE ?";
        }
        String orderLimit = " ORDER BY id DESC LIMIT ? OFFSET ?";

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
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Document document = new Document();
                document.setId(rs.getInt("id"));
                document.setTitle(rs.getString("title"));
                document.setAuthor(rs.getString("author"));
                document.setCategory(rs.getString("category"));
                document.setYearPublic(rs.getInt("yearPublic"));
                document.setContent(rs.getString("content"));
                document.setDescription(rs.getString("description"));
                documents.add(document);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error searching documents (paged): " + e.getMessage());
        }

        return documents;
    }

    /**
     * Return total number of documents matching optional keyword.
     */
    public int getTotal(String keyword) {
        String sql = "SELECT COUNT(*) AS cnt FROM tblDocument";
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql += " WHERE title LIKE ? OR author LIKE ? OR category LIKE ?";
        }
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (hasKeyword) {
                String q = "%" + keyword + "%";
                ps.setString(1, q);
                ps.setString(2, q);
                ps.setString(3, q);
            }
            ResultSet rs = ps.executeQuery();
            int total = 0;
            if (rs.next()) {
                total = rs.getInt("cnt");
            }
            rs.close();
            ps.close();
            return total;
        } catch (SQLException e) {
            System.err.println("Error getting total documents: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Return all documents (no pagination). Use sparingly.
     */
    public List<Document> searchAll() {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM tblDocument ORDER BY id DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Document document = new Document();
                document.setId(rs.getInt("id"));
                document.setTitle(rs.getString("title"));
                document.setAuthor(rs.getString("author"));
                document.setCategory(rs.getString("category"));
                document.setYearPublic(rs.getInt("yearPublic"));
                document.setContent(rs.getString("content"));
                document.setDescription(rs.getString("description"));
                documents.add(document);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error fetching all documents: " + e.getMessage());
        }
        return documents;
    }
}
