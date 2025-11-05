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
    
    /**
     * Helper method to create Document object from ResultSet
     */
    private Document createDocumentFromResultSet(ResultSet rs) throws SQLException {
        Document document = new Document();
        document.setId(rs.getInt("id"));
        document.setTitle(rs.getString("title"));
        document.setAuthor(rs.getString("author"));
        document.setCategory(rs.getString("category"));
        document.setYearPublic(rs.getInt("yearPublic"));
        document.setContent(rs.getString("content"));
        document.setDescription(rs.getString("description"));
        return document;
    }
    
    /**
     * Main search method with pagination support
     * @param page 1-based page number (use 0 for all results)
     * @param pageSize number of results per page (ignored if page = 0)
     * @param keyword search keyword (searches title, author, category)
     * @return List of matching documents
     */
    public List<Document> search(int page, int pageSize, String keyword) {
        List<Document> documents = new ArrayList<>();
        String base = "SELECT * FROM tblDocument";
        String where = "";
        String orderLimit = " ORDER BY id DESC";
        
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            where = " WHERE title LIKE ? OR author LIKE ? OR category LIKE ?";
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
                documents.add(createDocumentFromResultSet(rs));
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error searching documents: " + e.getMessage());
        }
        
        return documents;
    }
    
    /**
     * Get document by ID
     */
    public Document getDetailDocument(int id) {
        String sql = "SELECT * FROM tblDocument WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            Document document = null;
            if (rs.next()) {
                document = createDocumentFromResultSet(rs);
            }
            rs.close();
            ps.close();
            return document;
        } catch (SQLException e) {
            System.err.println("Error getting document detail: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Add new document
     */
    public boolean addNewDocument(Document document) {
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
  
    public List<Document> searchDocumentByName(String name, int page, int pageSize) {
        return search(page, pageSize, name);
    }
    
    public List<Document> searchDocumentByName(String name) {
        return search(0, 0, name);
    }
  
    public List<Document> searchAll() {
        return search(0, 0, null);
    }
}