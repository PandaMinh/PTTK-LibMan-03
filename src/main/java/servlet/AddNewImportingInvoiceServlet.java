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

@WebServlet("/addImportingInvoice")
public class AddNewImportingInvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ImportingInvoiceDAO importingInvoiceDAO;
    private DocumentDAO documentDAO;
    private SupplierDAO supplierDAO;
    
    public void init() {
        importingInvoiceDAO = new ImportingInvoiceDAO();
        documentDAO = new DocumentDAO();
        supplierDAO = new SupplierDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String documentName = request.getParameter("documentName");
        
        if (documentName != null && !documentName.trim().isEmpty()) {
            List<Document> documents = documentDAO.searchDocumentByName(documentName);
            request.setAttribute("documents", documents);
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/librarian/ImportingInvoiceView.jsp")
              .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
