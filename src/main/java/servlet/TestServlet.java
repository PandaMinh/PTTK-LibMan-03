package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test")
public class TestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String supplierId = request.getParameter("supplierId");
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Test Servlet</title></head>");
        out.println("<body>");
        out.println("<h1>Test Servlet Works!</h1>");
        out.println("<p>Supplier ID: " + supplierId + "</p>");
        out.println("<p>Context Path: " + request.getContextPath() + "</p>");
        out.println("<p>Servlet Path: " + request.getServletPath() + "</p>");
        out.println("<p>Request URI: " + request.getRequestURI() + "</p>");
        out.println("</body>");
        out.println("</html>");
    }
}