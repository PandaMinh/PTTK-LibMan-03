package servlet;

import dao.DocumentDAO;
import model.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/reader", "/searchDocument"})
public class ReaderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DocumentDAO documentDAO;
    
    @Override
    public void init() {
        documentDAO = new DocumentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        // Route to appropriate handler
        if ("/searchDocument".equals(servletPath)) {
            handleSearchDocument(request, response);
        } else {
            handleReaderDashboard(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Handle main reader dashboard (/reader)
     */
    private void handleReaderDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Session validation
        Object userObj = request.getSession().getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Role validation
        String role = getUserRole(userObj);
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        role = role.toLowerCase();
        if ("reader".equals(role) || "librarian".equals(role)) {
            request.getRequestDispatcher("/WEB-INF/jsp/reader/ReaderView.jsp").forward(request, response);
            return;
        }

        // Redirect other roles
        if ("manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/manager");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/");
    }
    
    /**
     * Handle document search (/searchDocument)
     */
    private void handleSearchDocument(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String searchType = request.getParameter("type");
        String title = request.getParameter("title");

        // Detail view
        if ("detail".equals(searchType)) {
            handleDocumentDetail(request, response);
            return;
        }

        // Search / list view with pagination
        int page = 1;
        int pageSize = 10;
        try {
            String p = request.getParameter("page");
            String ps = request.getParameter("pageSize");
            if (p != null) page = Math.max(1, Integer.parseInt(p));
            if (ps != null) pageSize = Math.max(1, Integer.parseInt(ps));
        } catch (NumberFormatException ignore) {}

        List<Document> documents = null;
        int totalItems = 0;
        
        if (title != null && !title.trim().isEmpty()) {
            // Lấy tất cả kết quả để tính tổng số
            List<Document> allResults = documentDAO.searchDocumentByName(title);
            totalItems = allResults.size();
            
            // Validate page number
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / pageSize) : 1;
            if (page > totalPages) {
                response.sendRedirect(request.getContextPath() + "/searchDocument?title=" + 
                    java.net.URLEncoder.encode(title, "UTF-8") + "&pageSize=" + pageSize);
                return;
            }
            
            // Lấy kết quả cho trang hiện tại
            documents = documentDAO.searchDocumentByName(title, page, pageSize);
        } 
        // Comment để không load all documents khi vào trang lần đầu
        /*
        else {
            // Lấy tất cả để tính tổng
            List<Document> allResults = documentDAO.searchAll();
            totalItems = allResults.size();
            
            // Validate page number
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / pageSize) : 1;
            if (page > totalPages) {
                response.sendRedirect(request.getContextPath() + "/searchDocument?pageSize=" + pageSize);
                return;
            }
            
            // Lấy kết quả cho trang hiện tại
            documents = documentDAO.search(page, pageSize, null);
        }
        */

        // Set attributes
        if (documents != null) {
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / pageSize) : 1;
            request.setAttribute("documents", documents);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/reader/ReaderSearchDocuView.jsp")
                .forward(request, response);
    }
    
    /**
     * Handle document detail view
     */
    private void handleDocumentDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String idStr = request.getParameter("id");
        try {
            int documentId = Integer.parseInt(idStr);
            Document document = documentDAO.getDetailDocument(documentId);
            
            if (document != null) {
                request.setAttribute("document", document);
                request.getRequestDispatcher("/WEB-INF/jsp/reader/DetailDocumentView.jsp")
                        .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * Extract user role from user object using reflection
     */
    private String getUserRole(Object userObj) {
        try {
            java.lang.reflect.Method m = userObj.getClass().getMethod("getRole");
            Object r = m.invoke(userObj);
            return r != null ? r.toString() : null;
        } catch (Exception ex) {
            return null;
        }
    }
}
