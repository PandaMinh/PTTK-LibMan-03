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

@WebServlet("/searchDocument")
public class SearchDocumentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DocumentDAO documentDAO;
    
    public void init() {
        documentDAO = new DocumentDAO();
        // Test database connection
        if (!documentDAO.testConnection()) {
            System.err.println("WARNING: Database connection test failed in SearchDocumentServlet.init()");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchType = request.getParameter("type");
        String title = request.getParameter("title");

        // Detail view
        if ("detail".equals(searchType)) {
            String idStr = request.getParameter("id");
            System.out.println("Detail request for document ID: " + idStr); // debug
            try {
                int documentId = Integer.parseInt(idStr);
                Document document = documentDAO.getDetailDocument(documentId);
                System.out.println("Document found: " + (document != null ? document.getTitle() : "null")); // debug
                if (document != null) {
                    request.setAttribute("document", document);
                    request.getRequestDispatcher("/WEB-INF/jsp/reader/DetailDocumentView.jsp")
                            .forward(request, response);
                    return;
                } else {
                    System.err.println("Document not found for ID: " + documentId); // debug
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            } catch (NumberFormatException ex) {
                System.err.println("Invalid document ID format: " + idStr); // debug
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
        }

        // Search / list view (supports pagination)
        int page = 1;
        int pageSize = 10;
        try {
            String p = request.getParameter("page");
            String ps = request.getParameter("pageSize");
            if (p != null) page = Math.max(1, Integer.parseInt(p));
            if (ps != null) pageSize = Math.max(1, Integer.parseInt(ps));
        } catch (NumberFormatException ignore) {}

        List<Document> documents;
        int totalItems = 0;
        if (title != null && !title.trim().isEmpty()) {
            totalItems = documentDAO.getTotal(title);
            // Use legacy-named method with pagination for compatibility
            documents = documentDAO.searchDocumentByName(title, page, pageSize);
        } else {
            totalItems = documentDAO.getTotal(null);
            documents = documentDAO.search(page, pageSize, null);
        }

        request.setAttribute("documents", documents);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/WEB-INF/jsp/reader/ReaderSearchDocuView.jsp")
                .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
