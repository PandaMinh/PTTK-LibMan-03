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
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchType = request.getParameter("type");
        
        if (searchType == null) {
            // Show search form
            request.getRequestDispatcher("/WEB-INF/jsp/reader/ReaderSearchDocuView.jsp")
                  .forward(request, response);
            return;
        }
        
        if (searchType.equals("detail")) {
            // Show document detail
            int documentId = Integer.parseInt(request.getParameter("id"));
            Document document = documentDAO.getDetailDocument(documentId);
            
            if (document != null) {
                request.setAttribute("document", document);
                request.getRequestDispatcher("/WEB-INF/jsp/reader/DetailDocumentView.jsp")
                      .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            // Search by name
            String title = request.getParameter("title");
            if (title != null && !title.trim().isEmpty()) {
                List<Document> documents = documentDAO.searchDocumentByName(title);
                request.setAttribute("documents", documents);
            }
            
            request.getRequestDispatcher("/WEB-INF/jsp/reader/ReaderSearchDocuView.jsp")
                  .forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
