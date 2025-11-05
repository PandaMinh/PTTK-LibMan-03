package servlet;

import dao.DocumentDAO;
import dao.ImportingInvoiceDAO;
import dao.SupplierDAO;
import model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet({"/librarian", "/searchSupplier", "/addImportingInvoice"})
public class LibrarianServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplierDAO supplierDAO;
    private DocumentDAO documentDAO;
    private ImportingInvoiceDAO importingInvoiceDAO;
    
    @Override
    public void init() {
        supplierDAO = new SupplierDAO();
        documentDAO = new DocumentDAO();
        importingInvoiceDAO = new ImportingInvoiceDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        switch (servletPath) {
            case "/librarian":
                handleLibrarianDashboard(request, response);
                break;
            case "/searchSupplier":
                handleSearchSupplier(request, response);
                break;
            case "/addImportingInvoice":
                handleAddImportingInvoiceGet(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        switch (servletPath) {
            case "/librarian":
                handleLibrarianDashboard(request, response);
                break;
            case "/searchSupplier":
                handleSearchSupplier(request, response);
                break;
            case "/addImportingInvoice":
                handleAddImportingInvoicePost(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleLibrarianDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Forward to librarian view
        request.getRequestDispatcher("/WEB-INF/jsp/librarian/LibrarianView.jsp")
                .forward(request, response);
    }
    
    private void handleSearchSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        
        if (action != null && action.equals("select")) {
            // Select supplier and move to invoice page
            int supplierId = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            
            if (supplier != null) {
                request.setAttribute("supplier", supplier);
                request.getRequestDispatcher("/WEB-INF/jsp/librarian/ImportingInvoiceView.jsp")
                      .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            // Search by name or show all
            if (name != null && !name.trim().isEmpty()) {
                List<Supplier> suppliers = supplierDAO.searchSupplierByName(name);
                request.setAttribute("suppliers", suppliers);
            } else if (name != null) {
                // Show all suppliers when name parameter exists but is empty
                List<Supplier> suppliers = supplierDAO.getAllSuppliers();
                request.setAttribute("suppliers", suppliers);
            }
            
            request.getRequestDispatcher("/WEB-INF/jsp/librarian/SearchSupplierView.jsp")
                  .forward(request, response);
        }
    }
    
    private void handleAddImportingInvoiceGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String documentName = request.getParameter("documentName");
        
        if (documentName != null && !documentName.trim().isEmpty()) {
            List<Document> documents = documentDAO.searchDocumentByName(documentName);
            request.setAttribute("documents", documents);
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/librarian/ImportingInvoiceView.jsp")
              .forward(request, response);
    }
    
    private void handleAddImportingInvoicePost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        if ("addDetail".equals(action)) {
            // Add importing detail
            int documentId = Integer.parseInt(request.getParameter("documentId"));
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Document document = documentDAO.getDetailDocument(documentId);
            ImportingDetail detail = new ImportingDetail();
            detail.setDocument(document);
            detail.setPrice(price);
            detail.setQuantity(quantity);
            
            @SuppressWarnings("unchecked")
            List<ImportingDetail> details = (List<ImportingDetail>) session.getAttribute("importingDetails");
            if (details == null) {
                details = new ArrayList<>();
                session.setAttribute("importingDetails", details);
            }
            details.add(detail);
            
            response.sendRedirect(request.getContextPath() + "/addImportingInvoice");
            
        } else if ("submit".equals(action)) {
            // Submit importing invoice
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String typePay = request.getParameter("typePay");
            String bank = request.getParameter("bank");
            
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            Librarian librarian = (Librarian) session.getAttribute("user");
            
            @SuppressWarnings("unchecked")
            List<ImportingDetail> details = (List<ImportingDetail>) session.getAttribute("importingDetails");
            
            if (details != null && !details.isEmpty()) {
                ImportingInvoice invoice = new ImportingInvoice();
                invoice.setImportDate(new Date());
                invoice.setSupplier(supplier);
                invoice.setLibrarian(librarian);
                invoice.setTypePay(typePay);
                invoice.setBank(bank);
                
                if (importingInvoiceDAO.addNewImportingInvoice(invoice, details)) {
                    session.removeAttribute("importingDetails");
                    response.sendRedirect(request.getContextPath() + "/librarian?success=true");
                    return;
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/addImportingInvoice?error=true");
        }
    }
}