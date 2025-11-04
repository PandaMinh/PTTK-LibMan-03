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
    
    public Document getDetailDocument(int id) {
        Document document = null;
        String sql = "SELECT * FROM tblDocument WHERE id = ?";
        
        try {
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
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error getting document details: " + e.getMessage());
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
}
