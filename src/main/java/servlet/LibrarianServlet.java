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
        
        String action = request.getParameter("action");
        
        if ("viewInvoices".equals(action)) {
            // Get all importing invoices for this librarian
            try {
                List<ImportingInvoice> invoices = importingInvoiceDAO.getAllImportingInvoices();
                request.setAttribute("invoices", invoices);
                request.getRequestDispatcher("/WEB-INF/jsp/librarian/InvoiceListView.jsp")
                        .forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể tải danh sách phiếu nhập: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/jsp/librarian/LibrarianView.jsp")
                        .forward(request, response);
            }
        } else {
            // Forward to librarian view
            request.getRequestDispatcher("/WEB-INF/jsp/librarian/LibrarianView.jsp")
                    .forward(request, response);
        }
    }
    
    private void handleSearchSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        
        System.out.println("DEBUG: handleSearchSupplier called with action=" + action);
        
        if (action != null && action.equals("select")) {
            // Select supplier and redirect to invoice page with supplier ID
            String supplierIdStr = request.getParameter("id");
            System.out.println("DEBUG: select action with supplierId=" + supplierIdStr);
            
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
                try {
                    int supplierId = Integer.parseInt(supplierIdStr);
                    Supplier supplier = supplierDAO.getSupplierById(supplierId);
                    
                    System.out.println("DEBUG: Found supplier: " + (supplier != null ? supplier.getName() : "null"));
                    
                    if (supplier != null) {
                        // Redirect to ImportingInvoiceView with supplier ID
                        String redirectUrl = request.getContextPath() + "/addImportingInvoice?supplierId=" + supplierId;
                        System.out.println("DEBUG: Redirecting to: " + redirectUrl);
                        response.sendRedirect(redirectUrl);
                        return;
                    } else {
                        System.out.println("DEBUG: Supplier not found, returning 404");
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Supplier not found");
                        return;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG: Invalid supplier ID format");
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid supplier ID");
                    return;
                }
            } else {
                System.out.println("DEBUG: Missing supplier ID");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing supplier ID");
                return;
            }
        } else {
            // Search with pagination
            int page = 1;
            int pageSize = 10;
            try {
                String p = request.getParameter("page");
                String ps = request.getParameter("pageSize");
                if (p != null) page = Math.max(1, Integer.parseInt(p));
                if (ps != null) pageSize = Math.max(1, Integer.parseInt(ps));
            } catch (NumberFormatException ignore) {}

            List<Supplier> suppliers;
            List<Supplier> allResults;
            int totalItems = 0;
            
            if (name != null && !name.trim().isEmpty()) {
                // Lấy tất cả kết quả để tính tổng số
                allResults = supplierDAO.searchSupplierByName(name);
                totalItems = allResults.size();
                
                // Validate page number
                int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / pageSize) : 1;
                if (page > totalPages) {
                    response.sendRedirect(request.getContextPath() + "/searchSupplier?name=" + 
                        java.net.URLEncoder.encode(name, "UTF-8") + "&pageSize=" + pageSize);
                    return;
                }
                
                // Lấy kết quả cho trang hiện tại
                suppliers = supplierDAO.searchSupplierByName(name, page, pageSize);
            } else {
                // Lấy tất cả để tính tổng
                allResults = supplierDAO.getAllSuppliers();
                totalItems = allResults.size();
                
                // Validate page number
                int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / pageSize) : 1;
                if (page > totalPages) {
                    response.sendRedirect(request.getContextPath() + "/searchSupplier?pageSize=" + pageSize);
                    return;
                }
                
                // Lấy kết quả cho trang hiện tại
                suppliers = supplierDAO.search(page, pageSize, null);
            }

            // Tính toán pagination dựa trên kết quả thực tế
            int actualItemsCount = suppliers != null ? suppliers.size() : 0;
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / pageSize) : 1;
            
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("actualItemsCount", actualItemsCount);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            
            request.getRequestDispatcher("/WEB-INF/jsp/librarian/SearchSupplierView.jsp")
                  .forward(request, response);
        }
    }
    
    private void handleAddImportingInvoiceGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String action = request.getParameter("action");
            String supplierId = request.getParameter("supplierId");
            String documentName = request.getParameter("documentName");
            
            System.out.println("DEBUG: handleAddImportingInvoiceGet called with supplierId=" + supplierId + ", action=" + action + ", documentName=" + documentName);
            
            // Kiểm tra supplier ID - bắt buộc phải có
            if (supplierId == null || supplierId.trim().isEmpty()) {
                System.out.println("DEBUG: Missing supplierId, redirecting to searchSupplier");
                response.sendRedirect(request.getContextPath() + "/searchSupplier");
                return;
            }
            
            // Lấy thông tin supplier
            Supplier supplier = null;
            try {
                int id = Integer.parseInt(supplierId);
                System.out.println("DEBUG: Getting supplier with id=" + id);
                supplier = supplierDAO.getSupplierById(id);
                System.out.println("DEBUG: Supplier found: " + (supplier != null ? supplier.getName() : "null"));
            } catch (NumberFormatException e) {
                System.out.println("DEBUG: Invalid supplier ID format, redirecting");
                response.sendRedirect(request.getContextPath() + "/searchSupplier");
                return;
            }
            
            // Nếu không tìm thấy supplier thì redirect
            if (supplier == null) {
                System.out.println("DEBUG: Supplier not found, redirecting");
                response.sendRedirect(request.getContextPath() + "/searchSupplier");
                return;
            }
            
            // Nếu có action=searchDocumentAjax thì trả về JSON
            if ("searchDocumentAjax".equals(action) && documentName != null && !documentName.trim().isEmpty()) {
                try {
                    System.out.println("DEBUG: AJAX Searching documents with name=" + documentName);
                    List<Document> documents = documentDAO.searchDocumentByName(documentName);
                    System.out.println("DEBUG: Found " + (documents != null ? documents.size() : 0) + " documents for AJAX");
                    
                    // Return JSON response
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    
                    StringBuilder json = new StringBuilder();
                    json.append("[");
                    if (documents != null && !documents.isEmpty()) {
                        for (int i = 0; i < documents.size(); i++) {
                            Document doc = documents.get(i);
                            if (i > 0) json.append(",");
                            json.append("{");
                            json.append("\"id\":").append(doc.getId()).append(",");
                            json.append("\"title\":\"").append(escapeJson(doc.getTitle())).append("\",");
                            json.append("\"author\":\"").append(escapeJson(doc.getAuthor())).append("\",");
                            json.append("\"category\":\"").append(escapeJson(doc.getCategory())).append("\"");
                            json.append("}");
                        }
                    }
                    json.append("]");
                    
                    response.getWriter().write(json.toString());
                    return;
                    
                } catch (Exception e) {
                    System.out.println("DEBUG: Error in AJAX search: " + e.getMessage());
                    e.printStackTrace();
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("[]");
                    return;
                }
            }
            
            // Nếu có action=searchDocument và có từ khóa tìm kiếm (traditional form)
            System.out.println("DEBUG: Checking search conditions - action=" + action + ", documentName=" + documentName);
            if ("searchDocument".equals(action) && documentName != null && !documentName.trim().isEmpty()) {
                try {
                    System.out.println("DEBUG: Searching documents with name=" + documentName);
                    // Tìm kiếm tài liệu không phân trang
                    List<Document> documents = documentDAO.searchDocumentByName(documentName);
                    System.out.println("DEBUG: Found " + (documents != null ? documents.size() : 0) + " documents");
                    if (documents != null && !documents.isEmpty()) {
                        for (Document doc : documents) {
                            System.out.println("DEBUG: Document: " + doc.getTitle() + " (ID: " + doc.getId() + ")");
                        }
                    }
                    request.setAttribute("documents", documents);
                } catch (Exception e) {
                    System.out.println("DEBUG: Error searching documents: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("searchError", "Có lỗi xảy ra khi tìm kiếm tài liệu: " + e.getMessage());
                }
            } else {
                System.out.println("DEBUG: No search performed - conditions not met");
                if (!"searchDocument".equals(action)) {
                    System.out.println("DEBUG: Action is not 'searchDocument', it is: " + action);
                }
                if (documentName == null || documentName.trim().isEmpty()) {
                    System.out.println("DEBUG: Document name is null or empty: " + documentName);
                }
            }
            
            // Set supplier attribute
            request.setAttribute("supplier", supplier);
            
            System.out.println("DEBUG: Forwarding to ImportingInvoiceView.jsp");
            request.getRequestDispatcher("/WEB-INF/jsp/librarian/ImportingInvoiceView.jsp")
                  .forward(request, response);
                  
        } catch (Exception e) {
            System.out.println("DEBUG: Unexpected error in handleAddImportingInvoiceGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
    
    private void handleAddImportingInvoicePost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        if ("addDetail".equals(action) || "addDocument".equals(action) || "addItem".equals(action)) {
            // Add importing detail - handle all action names
            try {
                int documentId = Integer.parseInt(request.getParameter("documentId"));
                double price = Double.parseDouble(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                
                System.out.println("DEBUG addItem - documentId: " + documentId + ", quantity: " + quantity + ", price: " + price);
                
                Document document = documentDAO.getDetailDocument(documentId);
                if (document == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document not found");
                    return;
                }
                
                @SuppressWarnings("unchecked")
                List<ImportingDetail> details = (List<ImportingDetail>) session.getAttribute("importingDetails");
                if (details == null) {
                    details = new ArrayList<>();
                    session.setAttribute("importingDetails", details);
                }
                
                // CHECK FOR DUPLICATES - Remove any existing items with same documentId
                boolean foundExisting = details.removeIf(detail -> {
                    boolean isMatch = detail.getDocument().getId() == documentId;
                    if (isMatch) {
                        System.out.println("DEBUG: Removing existing item with documentId: " + documentId + " (qty: " + detail.getQuantity() + ")");
                    }
                    return isMatch;
                });
                
                if (foundExisting) {
                    System.out.println("DEBUG: Found and removed existing duplicate(s), now adding new item");
                } else {
                    System.out.println("DEBUG: No existing duplicates found, adding new item");
                }
                
                // Add new detail
                ImportingDetail detail = new ImportingDetail();
                detail.setDocument(document);
                detail.setPrice(price);
                detail.setQuantity(quantity);
                details.add(detail);
                
                System.out.println("DEBUG: Added new item. Total details: " + details.size());
                
                // Redirect back to importing invoice page with supplier ID
                response.sendRedirect(request.getContextPath() + "/addImportingInvoice?supplierId=" + supplierId);
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input parameters");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error adding document: " + e.getMessage());
                return;
            }
            
        } else if ("updateItem".equals(action)) {
            // Update existing importing detail
            try {
                int documentId = Integer.parseInt(request.getParameter("documentId"));
                double price = Double.parseDouble(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                
                System.out.println("DEBUG updateItem - documentId: " + documentId + ", quantity: " + quantity + ", price: " + price);
                
                @SuppressWarnings("unchecked")
                List<ImportingDetail> details = (List<ImportingDetail>) session.getAttribute("importingDetails");
                
                if (details != null) {
                    System.out.println("DEBUG: Found " + details.size() + " details in session");
                    boolean found = false;
                    // Find and update existing detail
                    for (ImportingDetail detail : details) {
                        System.out.println("DEBUG: Checking detail with documentId: " + detail.getDocument().getId());
                        if (detail.getDocument().getId() == documentId) {
                            System.out.println("DEBUG: FOUND MATCHING DETAIL! Updating price from " + detail.getPrice() + " to " + price + ", quantity from " + detail.getQuantity() + " to " + quantity);
                            detail.setPrice(price);
                            detail.setQuantity(quantity);
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        System.out.println("DEBUG: NO MATCHING DETAIL FOUND for documentId: " + documentId);
                    }
                } else {
                    System.out.println("DEBUG: No details found in session");
                }
                
                // Redirect back to importing invoice page
                response.sendRedirect(request.getContextPath() + "/addImportingInvoice?supplierId=" + supplierId);
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input parameters");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating document: " + e.getMessage());
                return;
            }
            
        } else if ("removeItem".equals(action)) {
            // Remove item from importing details list
            try {
                int documentId = Integer.parseInt(request.getParameter("documentId"));
                int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                
                @SuppressWarnings("unchecked")
                List<ImportingDetail> details = (List<ImportingDetail>) session.getAttribute("importingDetails");
                
                if (details != null) {
                    // Find and remove the detail with matching document ID
                    details.removeIf(detail -> detail.getDocument().getId() == documentId);
                }
                
                // Redirect back to importing invoice page
                response.sendRedirect(request.getContextPath() + "/addImportingInvoice?supplierId=" + supplierId);
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input parameters");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error removing document: " + e.getMessage());
                return;
            }
            
        } else if ("submit".equals(action) || "saveInvoice".equals(action)) {
            // Submit/Save importing invoice
            try {
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
                    invoice.setTypePay(typePay != null ? typePay : "Tiền mặt");
                    invoice.setBank(bank != null ? bank : "");
                    
                    if (importingInvoiceDAO.addNewImportingInvoice(invoice, details)) {
                        session.removeAttribute("importingDetails");
                        try {
                            String message = java.net.URLEncoder.encode("Lưu hóa đơn nhập thành công", "UTF-8");
                            response.sendRedirect(request.getContextPath() + "/librarian?success=true&message=" + message);
                        } catch (java.io.UnsupportedEncodingException e) {
                            // Fallback without message
                            response.sendRedirect(request.getContextPath() + "/librarian?success=true");
                        }
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/addImportingInvoice?supplierId=" + supplierId + "&error=save_failed");
                        return;
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/addImportingInvoice?supplierId=" + supplierId + "&error=no_items");
                    return;
                }
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid supplier ID");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error saving invoice: " + e.getMessage());
                return;
            }
        }
    }
    
    // Helper method to escape JSON strings
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}