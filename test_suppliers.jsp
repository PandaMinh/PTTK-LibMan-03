<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.SupplierDAO, model.Supplier, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Suppliers</title>
</head>
<body>
    <h2>Test SupplierDAO</h2>
    
    <%
        try {
            SupplierDAO supplierDAO = new SupplierDAO();
            
            // Test getAllSuppliers
            List<Supplier> allSuppliers = supplierDAO.getAllSuppliers();
            out.println("<h3>All Suppliers (" + allSuppliers.size() + "):</h3>");
            
            if (allSuppliers.isEmpty()) {
                out.println("<p style='color: red;'>No suppliers found in database!</p>");
            } else {
                out.println("<table border='1'>");
                out.println("<tr><th>ID</th><th>Name</th><th>Tel</th><th>Address</th></tr>");
                for (Supplier s : allSuppliers) {
                    out.println("<tr>");
                    out.println("<td>" + s.getId() + "</td>");
                    out.println("<td>" + s.getName() + "</td>");
                    out.println("<td>" + s.getTel() + "</td>");
                    out.println("<td>" + s.getAddress() + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
    
    <br><br>
    <a href="<%= request.getContextPath() %>/searchSupplier">Back to Search Supplier</a>
</body>
</html>